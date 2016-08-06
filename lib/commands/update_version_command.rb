# encoding: utf-8

require_relative "command"
require_relative "../messages"

module Commands
  class UpdateVersionCommand < Command
    def apply(mod)
      new_version = "3.0.0"

      action "Updating version to #{new_version}" do
        Dir.chdir mod.result_dir do
          f = File.open "VERSION", "w"
          f.write new_version
          f.close
        end
      end
    end
  end
end
