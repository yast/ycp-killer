require_relative "../messages"

module Commands
  class Command
    def initialize(config)
      @config = config
    end

    protected

    def action(message)
      Messages.start "  * #{message}..."

      begin
        yield
      rescue Exception => e
        Messages.finish "ERROR"
        raise
      end

      Messages.finish "OK"
    end

    def reset_counts(mod)
      @counts = {
        :ok          => 0,
        :excluded    => mod.excluded.size,
        :error_ybc   => 0,
        :error_y2r   => 0,
        :error_ruby  => 0,
        :error_other => 0
      }
    end

    def handle_exception(e, phase, mod, file)
      raise if e.is_a? Interrupt

      if ! e.is_a? Cheetah::ExecutionFailed
        phase = :other
      end
      Messages.finish "ERROR(#{phase})" if verbose
      @counts["error_#{phase}".to_sym] += 1
      log_error(mod, file, e)
    end

    def log_error(mod, file, e)
      File.open(ERROR_FILE, "a") do |f|
        header = "[#{mod.name}] #{file}"
        f.puts header
        f.puts "-" * header.size
        f.puts
        if e.is_a?(Cheetah::ExecutionFailed)
          f.puts e.stderr
        else
          f.puts e.message
          e.backtrace.each { |l| f.puts l }
        end
        f.puts
      end
    end
  end
end
