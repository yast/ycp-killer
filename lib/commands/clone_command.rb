# encoding: utf-8

require_relative "command"

module Commands
  class CloneCommand < Command
    def initialize(options = {})
      @ref = options[:ref] || options[:branch] || options[:tag] || "master"
    end

    def apply(mod)
      action "Cloning" do
        FileUtils.rm_rf(mod.work_dir)

        Cheetah.run "git", "clone", "--no-checkout", "git@github.com:yast/yast-#{mod.name}.git", mod.work_dir

        Dir.chdir mod.work_dir do
          Cheetah.run "git", "checkout", @ref
        end
      end
    end
  end
end
