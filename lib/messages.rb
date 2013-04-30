require "smart_colored/extend"

module Messages
  STATES_TO_PREFIXES = {
    :header => "  ",
    :item   => "    "
  }

  # print messages only by one thread at a time
  @log_lock = Mutex.new

  class << self
    def header(message)
      @log_lock.synchronize { puts message.bold }

      in_state(:header) { yield }
    end

    def item(message)
      @log_lock.synchronize { puts "  * #{message}..." }

      in_state(:item) { yield }
    end

    def info(message)
      log $stdout, message
    end

    def warning(message)
      log $stderr, "WARNING: #{message}".yellow
    end

    def error(message)
      log $stderr, "ERROR: #{message}".red
    end

    private

    def in_state(state)
      saved_state = @state
      @state = state
      yield
      @state = saved_state
    end

    def log(stream, message)
      prefix = STATES_TO_PREFIXES[@state] || ""

      @log_lock.synchronize { stream.puts "#{prefix}#{message}" }
    end

    def status(message, status)
      spaces = if message.size < MAX_MESSAGE_WIDTH
        " " * (MAX_MESSAGE_WIDTH - message.size)
      else
        " "
      end

      puts message + spaces + status
    end
  end
end
