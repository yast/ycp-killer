require_relative "command"
require_relative "../build_order"
require_relative "../messages"
require_relative "../threading"

module Commands
  class YbcCommand < Command
    def apply(mod)
      reset_counts(mod)

      action "Cleaning previous compilation results" do
        clean_previous_compilation(mod)
      end

      Dir.chdir mod.work_dir do
        ordered_modules = nil
        action "Ordering modules" do
          # list of full paths
          ordered_modules = BuildOrder.new(mod.exports).ordered_modules
        end

        Threading.in_parallel ordered_modules do |files|
          files.each do |file|
            file_action "Compiling", :y2r, mod, file do
              create_ybc mod, file
            end
          end
        end
      end

      @counts
    end

    private

    def clean_previous_compilation(mod)
      Dir["#{mod.work_dir}/**/*.ybc"].each do |file|
        FileUtils.rm file
      end
    end

    def create_ybc(mod, file)
      cmd = [@config["ycpc"], "--no-std-includes", "--no-std-modules"]
      mod.ybc_module_paths.each do |module_path|
        cmd << "--module-path" << module_path
      end
      mod.ybc_include_paths.each do |include_path|
        cmd << "--include-path" << include_path
      end
      cmd << "-c" << file

      Cheetah.run cmd
    end
  end
end
