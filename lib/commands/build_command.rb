# encoding: utf-8

require_relative "command"

module Commands
  class BuildCommand < Command
    def apply(mod)
      action "Building" do
        Dir.chdir mod.obs_dir do
          Cheetah.run "osc", "build", "openSUSE_12.3"
        end
      end
    end
  end
end
