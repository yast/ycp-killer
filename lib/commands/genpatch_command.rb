require_relative "command"

module Commands
  class GenpatchCommand < Command
    def apply(mod)
      action "Generating patch" do
        patch_file = "#{PATCHES_DIR}/#{mod.name}.patch"

        FileUtils.rm_rf patch_file

        Dir.chdir mod.work_dir do
          output = Cheetah.run "git", "diff", :stdout => :capture
          # git fails to apply empty file, so don't create it
          next if output.empty?

          File.open(patch_file, "w") do |f|
            f.write output
          end
        end
      end
    end
  end
end

