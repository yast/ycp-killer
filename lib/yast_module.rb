require_relative "build_order"
require_relative "messages"

class YastModule

  WORK_DIR   = "work"
  RESULT_DIR = "result"
  OBS_DIR = "build_service"

  attr_reader :name,
    :work_dir,
    :result_dir,
    :obs_dir,
    :ybc_deps,
    :ruby_deps,
    :exports,
    :excluded,
    :moves

  def initialize(name, data, config)
    @name       = name
    @config     = config
    @work_dir   = "#{@config["yast_dir"]}/#{WORK_DIR}/#@name"
    @result_dir = "#{@config["yast_dir"]}/#{RESULT_DIR}/#@name"
    # Not suffixed with @name as it does not match (usuall yast2-#{name} )
    @obs_dir    = "#{@config["yast_dir"]}/#{OBS_DIR}"
    @ybc_deps   = data.delete("ybc_deps") || []
    @ruby_deps  = data.delete("ruby_deps") || []
    @exports    = data.delete("exports") || ["src"]
    @excluded   = data.delete("excluded") || []
    @moves      = data.delete("moves") || []

    if !data.empty?
      puts "WARNING: Unknown keys in #{name}.yml: #{data.keys.join(", ")}."
    end
  end

  def transitive_deps
    deps_of_deps = ybc_deps.map { |d| $yast_modules[d].transitive_deps }
    depth_first_deps = deps_of_deps.reduce([], :+) + ybc_deps
    # Note that they come out topologically sorted
    # because uniq takes the first object.
    depth_first_deps.uniq
  end

  # can only be called once all $yast_modules have been initialized
  def check_missing_work(yast_module_names)
    missing = yast_module_names.reject do |d|
      File.exists?($yast_modules[d].work_dir)
    end
    if ! missing.empty?
      raise "These dependencies do not have a working directory; convert them first: #{missing.join(", ")}"
    end
  end

  def convert
    check_missing_work(ybc_deps + ruby_deps)
    File.exists?(work_dir) ? update : clone
    restructure
    patch
    compile_modules
    # in case of error do not continue with submit
    return @counts if result_failed?

    convert_to_ruby
    return @counts if result_failed?

    generate_makefiles
    package

    @counts
  end

  def update
    reset
    pull
  end

  def pull
    Dir.chdir work_dir do
      Cheetah.run "git", "pull"
    end
  end

  def exported_module_paths
    exports.map { |e| "#{work_dir}/#{e}/modules" }
  end

  def exported_include_paths
    exports.map { |e| "#{work_dir}/#{e}/include" }
  end

  def ybc_module_paths
    # The lazy loading is needed because the dependencies may not be fully
    # initialized when "initialize" is called on this module.
    unless @ybc_module_paths
      @ybc_module_paths = [STUBS_DIR] + exported_module_paths
      transitive_deps.each do |dependency|
        @ybc_module_paths.concat $yast_modules[dependency].exported_module_paths
      end
    end

    @ybc_module_paths
  end

  def ybc_include_paths
    # The lazy loading is needed because the dependencies may not be fully
    # initialized when "initialize" is called on this module.
    unless @ybc_include_paths
      @ybc_include_paths = [STUBS_DIR] + exported_include_paths
      transitive_deps.each do |dependency|
        @ybc_include_paths.concat $yast_modules[dependency].exported_include_paths
      end
    end

    @ybc_include_paths
  end

  def ruby_module_paths file
    # Do not use transitive deps as there is risk to face circle, because
    # clients dependencies uses only modules and clients from dependency could
    # use modules from converted module
    ret = ruby_deps.reduce([]) do |acc, mod|
      acc + $yast_modules[mod].exported_module_paths
    end

    (ret + ybc_module_paths + [ File.dirname(file) ]).uniq
  end

  def ruby_include_paths file
    ret = ruby_deps.reduce([]) do |acc, mod|
      acc + $yast_modules[mod].exported_include_paths
    end

    (ret + ybc_include_paths + [ File.dirname(file) ]).uniq
  end

  private

  def result_failed?
    if !@counts[:error_ybc].zero? ||
        !@counts[:error_y2r].zero? ||
        !@counts[:error_ruby].zero? ||
        !@counts[:error_other].zero?
      return true
    end
    return false
  end

  def reset_counts
    @counts = {
      :ok          => 0,
      :excluded    => excluded.size,
      :error_ybc   => 0,
      :error_y2r   => 0,
      :error_ruby  => 0,
      :error_other => 0
    }
  end

  def handle_exception(e, phase, file)
    raise if e.is_a? Interrupt

    if ! e.is_a? Cheetah::ExecutionFailed
      phase = :other
    end
    Messages.finish "ERROR(#{phase})"
    @counts["error_#{phase}".to_sym] += 1
    log_error(file, e)
  end

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

  def log_error(file, e)
    File.open(ERROR_FILE, "a") do |f|
      f.puts file
      f.puts "-" * file.size
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
