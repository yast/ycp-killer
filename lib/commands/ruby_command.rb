require_relative "command"
require_relative "../messages"
require_relative "../threading"

module Commands
  class RubyCommand < Command
    def apply(mod)
      reset_counts(mod)

      action "Creating result directory" do
        prepare_result_dir(mod)
      end

      Dir.chdir mod.work_dir do
        Threading.in_parallel Dir["**/*.y{cp,h}"] do |files|
          files.each do |file|
            next if mod.excluded.include?(file)

            Messages.info "  * Converting #{file}..."

            work_file = "#{mod.work_dir}/#{file}"
            FileUtils.rm "#{mod.result_dir}/#{file}"
            result_file = "#{mod.result_dir}/#{file}".sub(/\.y(cp|h)$/, ".rb")

            file_action "Converting", :y2r, mod, file do
              # This makes private symbols in modules visible. Needed by some
              # testsuites.
              ENV["Y2ALLGLOBAL"] = "1"

              create_rb mod, work_file, result_file
            end

            file_action "Checking", :ruby, mod, file do
              check_rb result_file
            end
          end
        end
      end

      @counts
    end

    private

    def prepare_result_dir(mod)
      FileUtils.mkdir_p File.dirname(mod.result_dir)
      FileUtils.rm_rf mod.result_dir
      FileUtils.copy_entry(mod.work_dir, mod.result_dir)

      #clean all compiled ybc files created by ybc step
      Dir["#{mod.result_dir}/**/*.ybc"].each do |file|
        FileUtils.rm file
      end
    end

    def create_rb(mod, file, output_file)
      cmd = [@config["y2r"]]
      cmd << "--ycpc" << @config["ycpc"]

      mod.ruby_module_paths(file).each do |module_path|
        cmd << "--module-path" << module_path
      end

      mod.ruby_include_paths(file).each do |include_path|
        cmd << "--include-path" << include_path
      end

      cmd << file
      cmd << output_file

      Cheetah.run cmd
    end

    def check_rb(file)
      Cheetah.run "ruby", "-c", file
    end
  end
end
