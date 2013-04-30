class Threading

  # number of threads to use
  @@threads_count = nil

  class << self

    # Run a task in parallel for processing list of items.
    # 
    # The passed block is used for processing each list item.
    #
    # The number of created threads for processing is autodetected
    # (equals to the number of CPUs in system) or can be set explicitly
    # by setting Threading.threads_count value.
    #
    # Example:
    #   Threading.in_parallel [ 1, 3, 4, 5] do | arg |
    #     sleep arg
    #     puts "Slept #{a} seconds"
    #   end
    #
    def in_parallel args
      tasks = split_array args, threads_count

      # the currently running threads
      running_threads = []

      tasks.each do |task|
        running_threads << Thread.new(task) do |args|
          args.each { |arg| yield arg }
        end      
      end

      # wait for all threads to finish
      running_threads.each { |t| t.join }
    end

    def threads_count= num
      @@threads_count = num
    end

    def threads_count
      @@threads_count ||= cpu_count
    end

    private

    # autodetect the number of CPUs in the system
    def cpu_count
      File.read("/proc/cpuinfo").split("\n").select { |s| s.start_with?("processor\t:") }.size
    end

    # split an array to (possibly) equal parts
    def split_array(arr, parts)
      ret = [];
      arr.each_slice((arr.size / parts.to_f).ceil) { |part| ret << part } unless arr.empty?
      ret
    end

  end

end
