require_relative "build_order"
require_relative "messages"

class YastModule

  WORK_DIR   = "work"
  RESULT_DIR = "result"
  OBS_DIR = "build_service"
  OBS_PROJECT = "YaST:Head:ruby"

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

  def patch
    action "Patching" do
      patch_file = "#{PATCHES_DIR}/#{@name}.patch"
      next unless File.exists?(patch_file)

      Dir.chdir work_dir do
        Cheetah.run "git", "apply", patch_file
      end
    end
  end

  def compile_modules
    clean_previous_compilation
    reset_counts

    Dir.chdir work_dir do
      # list of full paths
      ordered_modules = BuildOrder.new(exports).ordered_modules

      ordered_modules.each do |file|
        begin
          Messages.start "  * Compiling #{file}..."
          create_ybc file
          Messages.finish "OK"
          @counts[:ok] += 1
        rescue Exception => e
          handle_exception(e, :ybc, file)
        end
      end
    end

    @counts
  end

  def convert_to_ruby
    prepare_result_dir
    reset_counts

    Dir.chdir work_dir do
      Dir["**/*.y{cp,h}"].each do |file|
        next if excluded.include?(file)

        Messages.start "  * Converting #{file}..."

        work_file = "#{work_dir}/#{file}"
        FileUtils.rm "#{result_dir}/#{file}"
        result_file = "#{result_dir}/#{file}".sub(/\.y(cp|h)$/, ".rb")

        begin
          # This makes private symbols in modules visible. Needed by some
          # testsuites.
          ENV["Y2ALLGLOBAL"] = "1"

          create_rb  work_file, result_file
        rescue Exception => e
          handle_exception(e, :y2r, work_file)
          next
        end

        begin
          check_rb result_file
        rescue Exception => e
          handle_exception(e, :ruby, work_file)
          next
        end

        Messages.finish "OK"
        @counts[:ok] += 1
      end
    end

    @counts
  end

  def exported_module_paths
    exports.map { |e| "#{work_dir}/#{e}/modules" }
  end

  def exported_include_paths
    exports.map { |e| "#{work_dir}/#{e}/include" }
  end

  def reset
    action "Resetting" do
      Dir.chdir work_dir do
        Cheetah.run "git", "reset", "--hard", "HEAD"

        output = Cheetah.run "git", "status", "--short", :stdout => :capture
        output.split("\n").each do |line|
          if line =~ /^\?\?\s+(.*)$/
            FileUtils.rm_rf $1
          else
            raise "Unknown git file status: #{line}"
          end
        end
      end
    end
  end

  def restructure
    action "Restructuring" do
      puts "WARNING: No 'moves' section found in #{name}.yml" if moves.empty?
      Dir.chdir work_dir do
        moves.each do |move|
          FileUtils.mkdir_p move["to"]

          from_files = Dir.glob(move["from"])
          puts "WARNING: typo? no matches for: #{move["from"]}" if from_files.empty?
          from_files.each do |file|
            # We want the moves stored in git index. This way the "genpatch"
            # command creates patch against state after restructuring, not
            # before it.
            Cheetah.run "git", "mv", file, "#{move["to"]}/#{File.basename(file)}"
          end
        end
      end
    end
  end

  def generate_makefiles
    action "Generating Makefiles" do
      exports.each do |export_dir|
        dir = "#{result_dir}/#{export_dir}"

        Dir["#{dir}/**/Makefile.am"].each do |file|
          FileUtils.rm file
        end

        File.open("#{dir}/Makefile.am", "w") do |file|
          dist_variables = []

          file.puts "# Sources for #{name}"
          Dir.chdir dir do
            sections = MAKEFILE_DESCRIPTION.map do |section|
              result = section.dup
              result[:files] = Dir[section[:glob]]

              result
            end

            sections.reject! { |section| section[:files].empty? }

            sections = sections.map { |section| split_section(section) }.reduce(&:+)

            sections.each do |section|
              file.write makefile_entry(section[:key_line] || section[:key], section[:values])

              dist_variables << section[:key]
            end

            dist_value = dist_variables.map { |v| "$(#{v})" }.join(" ")
            file.write "\nEXTRA_DIST = #{dist_value}\n\n"
            file.write 'include $(top_srcdir)/Makefile.am.common'
          end
        end
      end
    end
  end

  def package
    action "Packaging" do
      Dir.chdir result_dir do
        Cheetah.run "make", "-f", "Makefile.cvs" # TODO will not work for cmake based ones
        Cheetah.run "make"
        Cheetah.run "make", "package-local", "CHECK_SYNTAX=false"
      end

      package_name = File.read("#{result_dir}/RPMNAME").chomp

      FileUtils.mkdir_p obs_dir
      Dir.chdir obs_dir do
        package_obs_dir = "#{obs_dir}/#{OBS_PROJECT}/#{package_name}"

        create_obs_package_dir!(package_name) unless File.exists?(package_obs_dir)

        Dir["#{result_dir}/package/*"].each do |file|
          # for last three arguments keep defaults except last that we switch to
          # overwrite file in destrination
          FileUtils.copy_entry file, "#{package_obs_dir}/#{File.basename(file)}", false, false, true
        end
      end
    end
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

  # cwd must be obs_dir
  def create_obs_package_dir!(package_name)
    first = true
    begin
      Cheetah.run "osc", "co", OBS_PROJECT, package_name
    rescue Cheetah::ExecutionFailed
      # probably it is not created yet, so lets create it
      if first
        first = false
        create_package_in_obs package_name
        retry
      end

      raise
    end
  end

  def create_package_in_obs(package_name)
    ENV["EDITOR"] = "ed"
    # just add description via ed as meta pkg invoke editor
    ed_command = <<EOS
      # enable error reporting
      H
      # title is required
      # comma: all lines; s: substitute
      ,s/<title>/<title>YaST module converted to ruby/
      # write
      w
      # quit
      q
EOS

    Cheetah.run "osc", "meta", "pkg", OBS_PROJECT, package_name, "-e", :stdin => StringIO.new(ed_command)
  end

  def makefile_entry(key, values)
    "\n#{key} = \\\n  " + values.join(" \\\n  ") + "\n"
  end

  MAKEFILE_DESCRIPTION = [
    {
      :glob     => 'modules/**/*\.{ycp,ybc,rb,py,pl,pm,sh}',
      :key      => 'module_DATA',
      :dir_var  => '@moduledir@'
    },
    {
      :glob     => 'clients/**/*\.{ycp,rb,py,pl,sh,pm}',
      :key      => 'client_DATA'
    },
    {
      :glob     => 'include/**/*\.{ycp,rb,py}',
      :key      => 'ynclude_DATA',
      :dir_var  => '@yncludedir@'
    },
    {
      :glob     => "scrconf/*\.scr",
      :key      => "scrconf_DATA"
    },
    {
      :glob     => "servers_non_y2/*",
      :key      => "agent_SCRIPTS"
    },
    {
      :glob     => "autoyast-rnc/*.rnc",
      :key      => "schemafiles_DATA",
      :key_line => "schemafilesdir = $(schemadir)/autoyast/rnc\nschemafiles_DATA"
    },
    {
      :glob     => "bin/*",
      :key      => "ybin_SCRIPTS"
    },
    {
      :glob     => "data/*",
      :key      => "ydata_DATA"
    },
    {
      :glob     => "desktop/*",
      :key      => "desktop_DATA"
    },
    {
      :glob     => "fillup/*",
      :key      => "fillup_DATA"
    }
  ]

  def split_section(section)
    # Group section by subdirectories it includes.
    # Note this means that we ignore the first directory in the path.
    #
    # Example:
    #
    #   [ "modules/Language.rb", "modules/YAPI/LANGUAGE/pl"]
    #
    # ends up as
    #
    #   {
    #     [] => ["modules/Language.rb"]
    #     ["YAPI"] => ["modules/YAPI/LANGUAGE/pl"]
    #   }
    groups = section[:files].group_by { |f| f.split('/')[1..-2] }

    i = 0
    groups.map do |subdir, values|
      # The key includes a name and its type separated by underscore,
      # e.g. ynclude_DATA or ybin_SCRIPT. We construct unique group name and key
      # from the name (not the type).
      key_parts = section[:key].split('_')
      key_type = key_parts.pop
      key_name = key_parts.join("_")

      key_name = key_name + i.to_s if i > 0

      res = {
        :values => values,
        :key    => "#{key_name}_#{key_type}"
      }

      # For the schemafiles section we already have special key_line, so we use
      # it. There should be no subdirs there, so it is not a problem.
      res[:key_line] = section[:key_line] if section[:key_line]

      # If it is not a subdir and the first element, then keep it as it was
      # (common case).
      if subdir.size > 0 || i > 0
        raise "Unexpected subdir #{subdir.join("/")} for key #{key_name}" unless section[:dir_var]

        res[:key_line] = "#{key_name}dir = #{section[:dir_var]}/#{subdir.join("/")}\n#{res[:key]}"
      end

      i += 1

      res
    end
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

  def handle_exception(e, phase, file)
    raise if e.is_a? Interrupt

    if ! e.is_a? Cheetah::ExecutionFailed
      phase = :other
    end
    Messages.finish "ERROR(#{phase})"
    @counts["error_#{phase}".to_sym] += 1
    log_error(file, e)
  end

  def clean_previous_compilation
    Dir["#{work_dir}/**/*.ybc"].each do |file|
      FileUtils.rm file
    end
  end

  def prepare_result_dir
    FileUtils.mkdir_p File.dirname(result_dir)
    FileUtils.rm_rf result_dir
    FileUtils.copy_entry(work_dir, result_dir)

    #clean all compiled ybc files created by ybc step
    Dir["#{result_dir}/**/*.ybc"].each do |file|
      FileUtils.rm file
    end
  end

  def create_ybc(file)
    cmd = [@config["ycpc"], "--no-std-includes", "--no-std-modules"]
    ybc_module_paths.each do |module_path|
      cmd << "--module-path" << module_path
    end
    ybc_include_paths.each do |include_path|
      cmd << "--include-path" << include_path
    end
    cmd << "-c" << file

    Cheetah.run cmd
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

  def create_rb(file, output_file)
    cmd = [@config["y2r"]]
    cmd << "--ycpc" << @config["ycpc"]

    ruby_module_paths(file).each do |module_path|
      cmd << "--module-path" << module_path
    end

    ruby_include_paths(file).each do |include_path|
      cmd << "--include-path" << include_path
    end

    cmd << file
    cmd << output_file

    Cheetah.run cmd
  end

  def check_rb(file)
    Cheetah.run "ruby", "-c", file
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
