# based on ycpmakedep script https://github.com/yast/yast-devtools/blob/master/devtools/bin/ycpmakedep
class BuildOrder

  class Source
    attr :name                    # name
    attr :full_path               # string
    attr :imports                 # list of names
    attr :includes                # list of names

    # Parse the file.
    # imports and includes still contain references outside this package,
    # but there are no duplicates
    def initialize(name, full_path)
      @name = name
      @full_path = full_path
      lines = ::File.readlines @full_path
      @imports =  direct_imports(lines).uniq
      @includes = direct_includes(lines).uniq
    rescue ArgumentError => e
      if e.to_s =~ /invalid byte sequence/
        raise e, e.message + "; offending file: #{@full_path}"
      end
      raise e
    end

    # Can be called once we know about all local modules and includes
    def filter_outside_references(is_local_module_proc, is_local_include_proc)
      imports.keep_if(&is_local_module_proc)
      includes.keep_if(&is_local_include_proc)
    end

  private
    # return ["Report", "Popup", "FIXME: Foo::Bar or Foo/Bar"]
    def direct_imports(lines)
      import_lines = lines.grep(/^\s*import[\s"\(]/)
      import_lines.map do |line|
        line.chomp!
        line.sub!(/^\s*import[^"]*"([^"]+)".*$/, '\\1')
        line.sub!(/\.ycp$/, "")
        line
      end
    end

    # return ["lan/dialogs", "lan/routines"]
    def direct_includes(lines)
      include_lines = lines.grep(/^\s*include[\s"\(]/)

      include_lines.map do |line|
        line.chomp!
        line.sub!(/^\s*include[^"]*"([^"]+)".*$/, '\\1')
        line.sub!(/\.y(cp|h)$/, "")
        line
      end
    end
  end

  # Distinguish them because we only compile modules,
  # and there are even cycles that are ok because they consist of
  # a module-include pair
  class Module < Source
  end

  class Include < Source
  end

  # @modules  Hash: name => Source
  # @includes Hash: name => Source
  def initialize(source_dirs)
    @modules  = find_modules source_dirs
    @includes = find_includes source_dirs
    filter_outside_references
  end

  def ordered_modules
    tsorted_modules = tsort_breaking_pair_cycles.select do |source|
      source.is_a? Module
    end

    tsorted_modules.map { |source| source.full_path }
  end

  private

  def find_modules(source_dirs)
    modules = {}

    source_dirs.each do |dir|
      Dir["#{dir}/modules/**/*.ycp"].each do |file|
        relative_path = file.sub(/#{Regexp.escape(dir)}\/modules\//, "")
        module_name = relative_path.sub(/\.ycp$/, "")

        modules[module_name] = Module.new(module_name, file)
      end
    end

    modules
  end

  def find_includes(source_dirs)
    includes = {}

    source_dirs.each do |dir|
      Dir["#{dir}/include/**/*.y{cp,h}"].each do |file|
        relative_path = file.sub(/#{Regexp.escape(dir)}\/include\//, "")
        include_name = relative_path.sub(/\.y(cp|h)$/, "")

        includes[include_name] = Include.new(include_name, file)
      end
    end

    includes
  end

  include TSort

  def each_source(&block)
    @modules.each_value(&block)
    @includes.each_value(&block)
  end
  alias :tsort_each_node :each_source

  def tsort_each_child(node, &block)
    node.imports.each  { |name| block.call(@modules[name])  }
    node.includes.each { |name| block.call(@includes[name]) }
  end

  # remove items from modules and includes that refer outside this package
  def filter_outside_references
    is_local_module  = lambda {|m| @modules.has_key?(m) }
    is_local_include = lambda {|i| @includes.has_key?(i) }
    each_source do |f|
      f.filter_outside_references(is_local_module, is_local_include)
    end
  end

  # There may be a dependency cycle which is harmless,
  # because we only care that the subgraph over *modules* is acyclical.
  # That is, cycles are only a problem if they contain
  # more than one include or more than one module.
  # Therefore, we will break cycles consisting of module-include pairs.
  def tsort_breaking_pair_cycles
    each_strongly_connected_component do |component|
      next if component.size == 1
      if component.all? {|source| source.is_a? Include}
        # YCP parser breaks include cycles
        component.last.includes.delete component.first.name
        next
      end
      modules = component.find_all {|source| source.is_a? Module}
      if modules.size > 1
        raise TSort::Cyclic.new("Cycle involving 2 modules: #{component.inspect}")
      end
      # Now we have a component of one module and some includes,
      # with possibly multiple cycles in it.
      # Discard all dependencies leading from the module.
      mod = modules.first
      mod.includes.each do |i|
        puts "Broke a cyclic dependency between #{mod.name} and #{i}."
      end
      mod.includes.clear
    end
    # all harmless cycles are broken; run for real
    tsort
  end
end
