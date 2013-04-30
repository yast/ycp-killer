require_relative "command"

module Commands
  class SubmitCommand < Command
    def apply(mod)
      action "Submitting" do
        Dir.chdir mod.obs_dir do
          Cheetah.run "osc", "addremove"
          Cheetah.run "osc", "commit", "-m", "Updated by YCP Killer"
        end
      end
    end
  end
end
