require_relative "command"

module Commands
  class PullCommand < Command
    def apply(mod)
      action "Updating Git checkout" do
        Dir.chdir mod.work_dir do
          Cheetah.run "git", "pull"
        end
      end
    end
  end
end

