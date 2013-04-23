require_relative "command"

module Commands
  class PatchCommand < Command
    def apply(mod)
      action "Patching" do
        patch_file = "#{PATCHES_DIR}/#{mod.name}.patch"
        next unless File.exists?(patch_file)

        Dir.chdir mod.work_dir do
          Cheetah.run "git", "apply", patch_file
        end
      end
    end
  end
end

