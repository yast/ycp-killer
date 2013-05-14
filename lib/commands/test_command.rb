# encoding: utf-8

require_relative "command"
require_relative "../yast_module"

module Commands
  class TestCommand < Command
    def apply(mod)
      reset_counts(mod)
      file_action "Testing", :other, mod, "some files" do
        # Otherwise YaST will not find fast_gettext.gem
        disable_bundler do
          Dir.chdir mod.result_dir do
            # It's important to look for our .rb files in result_dir,
            # not for ybc files in work_dir.
            y2dirs = ([mod] + mod.transitive_deps).map(&:result_exports).flatten
            # --keep-going reveals failures in multiple testsuite dirs
            Cheetah.run "make", "--keep-going", "check", "Y2BASE_Y2DIR=#{y2dirs.join(':')}"
          end
        end
      end
      @counts
    end
  end
end
