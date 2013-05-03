# encoding: utf-8

require_relative "command"

module Commands
  class CloneCommand < Command
    def apply(mod)
      action "Cloning" do
        FileUtils.rm_rf(mod.work_dir)

        Cheetah.run "git", "clone", "git://github.com/yast/yast-#{mod.name}.git", mod.work_dir
      end
    end
  end
end
