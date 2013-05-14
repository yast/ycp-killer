# encoding: utf-8

require_relative "messages"

class YastModule

  WORK_DIR   = "work"
  RESULT_DIR = "result"
  OBS_DIR = "obs"
  OBS_PROJECT = "YaST:Head:ruby"

  attr_reader :name,
    :work_dir,
    :result_dir,
    :obs_base_dir,
    :exports,
    :excluded,
    :moves

  def initialize(name, data, data_dir)
    @name           = name
    @work_dir       = "#{data_dir}/#{WORK_DIR}/#@name"
    @result_dir     = "#{data_dir}/#{RESULT_DIR}/#@name"
    @obs_base_dir   = "#{data_dir}/#{OBS_DIR}"
    @ybc_dep_names  = data.delete("ybc_deps") || []
    @ruby_dep_names = data.delete("ruby_deps") || []
    @exports        = data.delete("exports") || ["src"]
    @excluded       = data.delete("excluded") || []
    @moves          = data.delete("moves") || []

    if !data.empty?
      Messages.warning "Unknown keys in #{name}.yml: #{data.keys.join(", ")}."
    end
  end

  def obs_dir
    @obs_dir ||= "#{@obs_base_dir}/#{OBS_PROJECT}/#{package_name}"
  end

  def package_name
    @package_name ||= File.read("#{result_dir}/RPMNAME").chomp
  end

  def ybc_deps
    @ybc_dep_names.map { |n| $yast_modules[n] }
  end

  def ruby_deps
    @ruby_dep_names.map { |n| $yast_modules[n] }
  end

  def transitive_deps
    deps_of_deps = ybc_deps.map(&:transitive_deps)
    depth_first_deps = deps_of_deps.reduce([], :+) + ybc_deps
    # Note that they come out topologically sorted
    # because uniq takes the first object.
    depth_first_deps.uniq
  end

  def patch_file
    "#{PATCHES_DIR}/#@name.patch"
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
        @ybc_module_paths.concat dependency.exported_module_paths
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
        @ybc_include_paths.concat dependency.exported_include_paths
      end
    end

    @ybc_include_paths
  end

  def ruby_module_paths file
    # Do not use transitive deps as there is risk to face circle, because
    # clients dependencies uses only modules and clients from dependency could
    # use modules from converted module
    ret = ruby_deps.reduce([]) do |acc, mod|
      acc + mod.exported_module_paths
    end

    (ret + ybc_module_paths + [ File.dirname(file) ]).uniq
  end

  def ruby_include_paths file
    ret = ruby_deps.reduce([]) do |acc, mod|
      acc + mod.exported_include_paths
    end

    (ret + ybc_include_paths + [ File.dirname(file) ]).uniq
  end
end
