module Messages
  MAX_MESSAGE_WIDTH = 70

  class << self
    def start(message)
      print message

      @last_message_size = message.size
    end

    def finish(status)
      spaces = if @last_message_size < MAX_MESSAGE_WIDTH
        " " * (MAX_MESSAGE_WIDTH - @last_message_size)
      else
        ""
      end

      puts spaces + status
    end

    def info(message)
      puts message
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
