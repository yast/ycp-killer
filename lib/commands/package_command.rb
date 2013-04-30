require_relative "command"
require_relative "../yast_module"

module Commands
  class PackageCommand < Command
    def apply(mod)
      action "Packaging" do
        Dir.chdir mod.result_dir do
          Cheetah.run "make", "-f", "Makefile.cvs" # TODO will not work for cmake based ones
          Cheetah.run "make", "package-local", "CHECK_SYNTAX=false"
        end

        FileUtils.mkdir_p mod.obs_base_dir
        Dir.chdir mod.obs_base_dir do
          create_obs_package_dir!(mod.package_name) unless File.exists?(mod.obs_dir)

          Dir["#{mod.result_dir}/package/*"].each do |file|
            # for last three arguments keep defaults except last that we switch to
            # overwrite file in destrination
            FileUtils.copy_entry file, "#{mod.obs_dir}/#{File.basename(file)}", false, false, true
          end
        end
      end
    end

    private

    # cwd must be obs_dir
    def create_obs_package_dir!(pkg_name)
      first = true
      begin
        Cheetah.run "osc", "co", YastModule::OBS_PROJECT, pkg_name
      rescue Cheetah::ExecutionFailed
        # probably it is not created yet, so lets create it
        if first
          first = false
          create_package_in_obs pkg_name
          retry
        end

        raise
      end
    end

    def create_package_in_obs(pkg_name)
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

      Cheetah.run "osc", "meta", "pkg", YastModule::OBS_PROJECT, pkg_name, "-e", :stdin => StringIO.new(ed_command)
    end
  end
end
