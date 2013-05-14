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
            # Note that y2dirs is only for the current module.
            # Other modules are taken from RPMs.
            y2dirs = mod.exports.map { |e| File.absolute_path(e) }
            # --keep-going reveals failures in multiple testsuite dirs
            Cheetah.run "make", "--keep-going", "check", "Y2BASE_Y2DIR=#{y2dirs.join(':')}"
          end
        end
      end
      @counts
    end
  end
end
