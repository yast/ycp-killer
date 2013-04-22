require_relative "command"

module Commands
  class RestructureCommand < Command
    def apply(mod)
      action "Restructuring" do
        puts "WARNING: No 'moves' section found in #{mod.name}.yml" if mod.moves.empty?
        Dir.chdir mod.work_dir do
          mod.moves.each do |move|
            FileUtils.mkdir_p move["to"]

            from_files = Dir.glob(move["from"])
            puts "WARNING: typo? no matches for: #{move["from"]}" if from_files.empty?
            from_files.each do |file|
              # We want the moves stored in git index. This way the "genpatch"
              # command creates patch against state after restructuring, not
              # before it.
              Cheetah.run "git", "mv", file, "#{move["to"]}/#{File.basename(file)}"
            end
          end
        end
      end
    end
  end
end

