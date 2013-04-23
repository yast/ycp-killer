require_relative "command"

module Commands
  class PackageCommand < Command
    OBS_PROJECT = "YaST:Head:ruby"

    def apply(mod)
      action "Packaging" do
        Dir.chdir mod.result_dir do
          Cheetah.run "make", "-f", "Makefile.cvs" # TODO will not work for cmake based ones
          Cheetah.run "make"
          Cheetah.run "make", "package-local", "CHECK_SYNTAX=false"
        end

        package_name = File.read("#{mod.result_dir}/RPMNAME").chomp

        FileUtils.mkdir_p mod.obs_dir
        Dir.chdir mod.obs_dir do
          package_obs_dir = "#{mod.obs_dir}/#{OBS_PROJECT}/#{package_name}"

          create_obs_package_dir!(package_name) unless File.exists?(package_obs_dir)

          Dir["#{mod.result_dir}/package/*"].each do |file|
            # for last three arguments keep defaults except last that we switch to
            # overwrite file in destrination
            FileUtils.copy_entry file, "#{package_obs_dir}/#{File.basename(file)}", false, false, true
          end
        end
      end
    end

    private

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
  end
end
