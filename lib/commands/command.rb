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
  end
end
