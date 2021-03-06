# encoding: utf-8

require_relative "command"
require_relative "../yast_module"

module Commands
  class PackageCommand < Command
    def apply(mod)
      action "Packaging" do
        Dir.chdir mod.result_dir do
          # do not check for configured
          # rubygems in external ruby scripts called during packaging
          disable_bundler do
            Cheetah.run "make", "-f", "Makefile.cvs"
            Cheetah.run "make", "package-local", "CHECK_SYNTAX=false"
          end
        end

        FileUtils.mkdir_p mod.obs_base_dir
        Dir.chdir mod.obs_base_dir do
          create_obs_package_dir!(mod.package_name) unless File.exists?(mod.obs_dir)

          # remove all - get rid of obsoleted files before copying new ones
          FileUtils.rm Dir["#{mod.obs_dir}/*"]

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
      Cheetah.run "osc", "co", YastModule::OBS_PROJECT, pkg_name
    end
  end
end
