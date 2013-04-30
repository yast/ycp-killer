class Threading

  # number of threads to use
  @@threads = nil

  # the currently running threads
  @@running_threads = []

  class << self
    # Run a task in parallel
    # 
    # Split the parameter (a list) into parts and process each part
    # (sublist) in a block running in separate thread.
    #
    # By default autodetects the number of CPUs, see Threading.threads
    # to use a specific value instead of the autodetection.
    #
    # Example:
    #   Threading.in_parallel [ 1, 3, 4, 5] do | args |
    #     args.each do |a|
    #       sleep a
    #       puts "Slept #{a} seconds"
    #     end
    #   end
    #
    def in_parallel args
      tasks = split_array args, threads

      tasks.each do |task|
        @@running_threads << Thread.new(task) do |arg|
          yield arg
        end      
      end

      # wait for all threads to finish
      @@running_threads.each {|t| t.join}
      @@running_threads = []
    end

    def threads= num
      @@threads = num
    end

    def threads
      @@threads = cpu_count unless @@threads
      @@threads
    end


    private

    # autodetect the number of CPUs in the system
    def cpu_count
      File.read("/proc/cpuinfo").split("\n").select{|s| s.start_with?("processor\t:")}.size
    end

    # split an array to (possibly) equal parts
    def split_array(arr, parts)
      ret = [];
      arr.each_slice((arr.size / parts.to_f).ceil){ |part| ret << part} unless arr.empty?
      ret
    end

  end


end
