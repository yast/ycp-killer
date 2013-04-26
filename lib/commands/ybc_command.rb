require_relative "command"
require_relative "../build_order"
require_relative "../messages"

module Commands
  class YbcCommand < Command
    def apply(mod)
      clean_previous_compilation(mod)
      reset_counts(mod)

      Dir.chdir mod.work_dir do
        # list of full paths
        ordered_modules = BuildOrder.new(mod.exports).ordered_modules

        ordered_modules.each do |file|
          begin
            Messages.start "  * Compiling #{file}..."
            create_ybc mod, file
            Messages.finish "OK"
            @counts[:ok] += 1
          rescue Exception => e
            handle_exception(e, :ybc, mod, file)
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
