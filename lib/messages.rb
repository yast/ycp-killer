require "smart_colored/extend"

module Messages
  class << self
    def header(message)
      puts message.yellow.bold

      @prefix = "  "
    end

    def reset
      @prefix = ""
    end

    def item(message)
      puts "  * #{message}..."

      @prefix = "    "
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

    def log(stream, message)
      stream.puts "#@prefix#{message}"
    end
  end
end
