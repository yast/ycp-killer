require_relative "command"

module Commands
  class ResetCommand < Command
    def apply(mod)
      action "Resetting" do
        Dir.chdir mod.work_dir do
          Cheetah.run "git", "reset", "--hard", "HEAD"

          output = Cheetah.run "git", "status", "--short", :stdout => :capture
          output.split("\n").each do |line|
            if line =~ /^\?\?\s+(.*)$/
              FileUtils.rm_rf $1
            else
              raise "Unknown git file status: #{line}"
            end
          end
        end
      end
    end
  end
end

