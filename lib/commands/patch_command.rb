require_relative "command"

module Commands
  class PatchCommand < Command
    def apply(mod)
      action "Patching" do
        next unless File.exists?(mod.patch_file)

        Dir.chdir mod.work_dir do
          Cheetah.run "git", "apply", mod.patch_file
        end
      end
    end
  end
end

