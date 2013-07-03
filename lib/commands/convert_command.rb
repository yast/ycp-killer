# encoding: utf-8

require_relative "command"

module Commands
  class ConvertCommand < Command
    def apply(mod)
      check_missing_work(mod.ybc_deps + mod.ruby_deps)

      if File.exists?(mod.work_dir)
        ResetCommand.new.apply(mod)
      else
        CloneCommand.new.apply(mod)
      end

      RestructureCommand.new.apply(mod)
      PatchCommand.new.apply(mod)
      @counts = YbcCommand.new.apply(mod)
      # in case of error do not continue with submit
      return @counts if result_failed?

      @counts = RubyCommand.new.apply(mod)
      return @counts if result_failed?

      MakefileCommand.new.apply(mod)
      PackageCommand.new.apply(mod)

      TestCommand.new.apply(mod)

      @counts
    end

    private

    # can only be called once all $yast_modules have been initialized
    def check_missing_work(yast_modules)
      missing = yast_modules.reject do |m|
        File.exists?(m.work_dir)
      end
      if ! missing.empty?
        raise "These dependencies do not have a working directory; convert them first: #{missing.map(&:name).join(", ")}"
      end
    end

    def result_failed?
      if !@counts[:error_ybc].zero? ||
          !@counts[:error_y2r].zero? ||
          !@counts[:error_ruby].zero? ||
          !@counts[:error_other].zero?
        return true
      end
      return false
    end
  end
end
