# encoding: utf-8

require_relative "command"

module Commands
  class MakefileCommand < Command
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
        :glob     => "data/**/*",
        :key      => "ydata_DATA",
        :dir_var  => '@ydatadir@'
      },
      {
        :glob     => "desktop/**/*",
        :key      => "desktop_DATA",
        :dir_var  => '@desktopdir@'
      },
      {
        :glob     => "fillup/*",
        :key      => "fillup_DATA"
      }
    ]

    def apply(mod)
      action "Generating Makefiles" do
        mod.exports.each do |export_dir|
          dir = "#{mod.result_dir}/#{export_dir}"

          Dir["#{dir}/**/Makefile.am"].each do |file|
            FileUtils.rm file
          end

          File.open("#{dir}/Makefile.am", "w") do |file|
            dist_variables = []

            file.puts "# Sources for #{mod.name}"
            Dir.chdir dir do
              sections = MAKEFILE_DESCRIPTION.map do |section|
                result = section.dup
                result[:files] = Dir[section[:glob]].reject{|f| File.directory?(f)}

                result
              end

              sections.reject! { |section| section[:files].empty? }

              sections = sections.map { |section| split_section(section) }.reduce([], :+)

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

    private

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

    def makefile_entry(key, values)
      "\n#{key} = \\\n  " + values.join(" \\\n  ") + "\n"
    end
  end
end
