# encoding: utf-8

require "bundler/setup"   # Needed to setup path to the "y2r" binary.

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

      save_env do
        # This makes private symbols in modules visible. Needed by some
        # testsuites.
        ENV["Y2ALLGLOBAL"] = "1"

        Dir.chdir mod.work_dir do
          Threading.in_parallel Dir["**/*.y{cp,h}"] do |file|
            next if mod.excluded.include?(file)

            converted_file = mod.include_wrappers[file] || file
            work_file = "#{mod.work_dir}/#{converted_file}"
            FileUtils.rm "#{mod.result_dir}/#{file}"
            result_file = "#{mod.result_dir}/#{file}".sub(/\.y(cp|h)$/, ".rb")

            options = {}

            is_in_include_dir = mod.exports.any? do |export|
              file.start_with?("#{export}/include")
            end
            is_yh = file.end_with?(".yh")

            options[:is_include] = is_in_include_dir || is_yh

            if options[:is_include]
              if mod.include_wrappers[file]
                # We assume that if an include file isn't in the include dir,
                # the wrapper file includes it just using its base name. This
                # seems to be true for all such include files we have.
                options[:extracted_file] = if is_in_include_dir
                  file.sub(/^.*\/include\//, "")
                else
                  File.basename(file)
                end
              end
            end

            options[:reported_file] = file

            options[:export_private] = mod.export_private.include?(file)

            file_action "Converting", :y2r, mod, file do
              create_rb mod, work_file, result_file, options
            end

            next unless File.exists?(result_file)

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

    def create_rb(mod, file, output_file, options)
      cmd = ["y2r"]

      mod.ruby_module_paths(file).each do |module_path|
        cmd << "--module-path" << module_path
      end

      mod.ruby_include_paths(file).each do |include_path|
        cmd << "--include-path" << include_path
      end

      cmd << "--as-include-file" if options[:is_include]
      cmd << "--extract-file" << options[:extracted_file] if options[:extracted_file]
      cmd << "--report-file" << options[:reported_file] if options[:reported_file]
      cmd << "--export-private" if options[:export_private]

      cmd << file
      cmd << output_file

      Cheetah.run cmd
    end

    def check_rb(file)
      Cheetah.run "ruby", "-c", file
    end
  end
end
