YCP Killer
==========

YCP Killer is a tool that manages translation of
[YCP](http://doc.opensuse.org/projects/YaST/SLES10/tdg/Book-YCPLanguage.html)
code in [YaST](http://en.opensuse.org/Portal:YaST) into Ruby. Once complete, it
will be used to translate the whole YaST codebase into Ruby, which will allow us
to get rid of YCP completely.

Description
-----------

YCP Killer translates YaST code into Ruby module by module. The translation is
driven by files in the `data` directory, which describe which files in each
module need to be translated and also contain some other metadata. To perform
the actual translation, YCP Killer uses [Y2R](https://github.com/yast/y2r).

Before the actual translation, modules can be patched using patches in the
`patches` directory. This makes it possible e.g. to rewrite parts of module code
that contain constructs that Y2R can't handle.

**Note:** YCP Killer is work in progress and translation of many modules
currently fails with errors.

Installation
------------

YCP Killer is tested only on [openSUSE
12.3](http://en.opensuse.org/Portal:12.3). It probably won't work in other
openSUSE versions, other Linux distributions, or other operating systems.

The following steps will make YCP Killer run on a vanilla openSUSE 12.3 system.
They are somewhat complex, but we will hopefully simplify them over time as
things get gemified, packaged, etc.

  1. **Install Git**

         $ sudo zypper in git

  2. **Clone the yast-core repository and compile your own `ycpc`**

     Custom-compiled `ycpc` is needed because Y2R relies on some features that
     are not present in `ycpc` bundled with openSUSE 12.3. These fatures are
     implemented in the `y2r_fixes` branch.

         $ sudo zypper in make yast2-devtools libtool gcc-c++ bison \
           docbook-xsl-stylesheets expect dejagnu flex boost-devel doxygen
         $ git clone git://github.com/yast/yast-core.git -b y2r_fixes
         $ cd yast-core
         $ make -f Makefile.cvs
         $ make
         $ cd ..

  3. **Install basic Ruby environment**

         $ sudo zypper in ruby ruby-devel
         $ sudo gem install bundler

  4. **Clone the Y2R repository and install Y2R's dependencies**

         $ sudo zypper in libxml2-devel libxslt-devel   # Needed by Nokogiri
         $ git clone git://github.com/yast/y2r.git
         $ cd y2r
         $ bundle1.9 install
         $ cd ..

  5. **Create a directory for compiled YaST modules**

         $ mkdir yast

  6. **Clone the YCP Killer repository and install YCP Killer's dependencies**

         $ git clone git://github.com/yast/ycp-killer.git
         $ cd ycp-killer
         $ bundle1.9 install

  7. **Configure YCP Killer**

     Copy the `config.yml.example` file to `config.yml` and fill in the
     settings as described by comments in the file.

  8. **Done!**

     You can now start killing YCP.

Usage
-----

YCP Killer is a command line tool. It's entry point is the `yk` script, which
accepts subcommands (like `git` or `bundler`). Each subcommand can be applied to
a set of YaST modules passed as arguments. A special value `all` will apply a
command to all YaST modules.

```
$ ./yk help
Tasks:
  yk clone <module>...        # Clone module(s)
  yk compile <module>...      # Compile module(s)
  yk convert <module>...      # Convert module(s)
  yk genpatch <module>...     # Store changes from work directory of module(s) into a patch
  yk help [TASK]              # Describe available tasks or one specific task
  yk patch <module>...        # Patch module(s)
  yk reset <module>...        # Revert module(s) work directory to clean state
  yk restructure <module>...  # Change module(s) work directory structure to fit the Y2DIR scheme
```

### Commands

The commands operate on two distinct directory trees: the *working* tree and
the *result* tree.

#### yk convert

Does everything at once: `clone`, `restructure`, `patch`, `compile`.

#### yk clone

Clones repositories of specified modules into subdirectories of a directory
specified by the `yast_dir` setting in `config.yml`.

**Removes the working tree for the module beforehand.**

```
$ ./yk clone testsuite
[1/1] Cloning testsuite...                                            OK
```

#### yk restructure

Changes the working directory structure to fit the Y2DIR scheme.
See [`moves`](#module-metadata) in Module Metadata below.

Results of the operation are saved into git index.
This means you can use `git status` or `git diff --cached`
inside the work directory to see what moved where.
The main purpose however is
to ensure that `yk genpatch` diffs properly against the new structure.

```
$ ./yk restructure testsuite
[1/1] Restructuring testsuite...                                      OK
```

#### yk patch

Applies patches for specified modules from the `patches` directory to their
checkouts. If a module doesn't have a patch, this command does not do anything.

```
$ ./yk patch testsuite
[1/1] Patching testsuite...                                           OK
```

#### yk compile

Compiles YCP files of specified modules to Ruby, placing the result in the
*result* tree.
The compilation is driven by
module descriptions stored in the `data` directory. It uses `ycpc` and `y2r`
binaries specified by the `ycpc` and `y2r` setting in `config.xml`.

The compilation of each file may finish in one the following states:

  * **OK** – the compilation was successful
  * **ERROR(y2r)** – the compilation failed when running `ycpc` or `y2r` on the
    module code
  * **ERROR(ruby)** – the compilation failed because it produced a result which
    was invalid Ruby (as determined by `ruby -c`)
  * **ERROR(other)** – the compilation failed for some other reason

If the compilation is successful, all YCP files defined in the module
description will be compiled by `ycp` and will have an eqivalent Ruby file
created by their side (e.g. compiling `Sysconfig.ycp` will produce
`Sysconfig.ybc` and `Sysconfig.rb` in the same directory).

In case of `ERROR(y2r)` and `ERROR(ruby)`, details of the error are logged into
the `error.log` file in the YCP Killer directory.

```
$ ./yk compile testsuite
[1/1] Compiling testsuite...
  * devel/src/bench.ycp                                               ERROR(y2r)
  * devel/src/debug.ycp                                               ERROR(y2r)
  * devel/src/devel.ycp                                               ERROR(y2r)
  * devel/testsuite/tests/bench.ycp                                   ERROR(y2r)
  * devel/testsuite/tests/debug.ycp                                   ERROR(y2r)
  * src/Pkg.ycp                                                       OK
  * src/Testsuite.ycp                                                 OK
  * src/testsuite.ycp                                                 OK
  * testsuite/test.ycp                                                ERROR(y2r)

-----

Total OK:           3
Total EXCLUDED:     0
Total ERROR(y2r):   6
Total ERROR(ruby):  0
Total ERROR(other): 0
```

#### yk genpatch

FIXME

Store changes from the working directory of module(s) into a patch.

#### yk reset

FIXME

Revert the working directory to a clean state.

### Module Metadata

Modules have metadata files placed in `data/foo.yml`, in the [YAML][yaml]
format.

[yaml]: http://en.wikipedia.org/wiki/YAML

```
# A list of modules this one depends on to compile.
# Default: []
deps:
  - yast2

# A list of operations used by the `restructure` command
# to make the working tree better fit the Y2DIR scheme.
# Default: []
moves:
    # a glob in the original structure
    # (use quotes because of YAML syntax).
  - from: src/NfsServer.ycp
    # a directory path in the new structure.
    # Missing directories will be created.
    to: src/modules
  - from: "src/nfs[-_]server*.ycp"
    to: src/clients
  - from: "src/*.ycp"
    to: src/include/nfs_server

# A list of file paths (in the new structure, see 'moves')
# to exclude from compilation.
# A reason for the exclusion should be supplied in a comment.
# Default: []
excluded:
  # include stuff for testsuite
  - library/sequencer/testsuite/tests/Wizard.yh
  # agreed to exclude doc from automatic translation
  - library/sequencer/doc/examples/example1.ycp
  - library/sequencer/doc/examples/example2.ycp
  # include files that is not complete
  - library/packages/src/include/packages/common.ycp

# A list of paths (in the new structure, see 'moves')
# that users of this module should add to their `Y2DIR`.
# (Only mess^W complex modules like `yast2` should need this.
# Default: ["src"]
exports:
  - src
  - library/sequencer/src
  - library/packages/src
```
