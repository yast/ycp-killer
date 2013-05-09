YCP Killer
==========

YCP Killer is a tool that manages tasks related to translation of
[YCP](http://doc.opensuse.org/projects/YaST/SLES10/tdg/Book-YCPLanguage.html)
code in [YaST](http://en.opensuse.org/Portal:YaST) modules into Ruby. It will be
used to translate the whole YaST codebase into Ruby, which will allow us to get
rid of YCP completely.

To do the actual translation, YCP Killer uses
[Y2R](https://github.com/yast/y2r).

**YCP Killer is still work in progress.**

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

  2. **Update `ycpc`**

     Updated `ycpc` is needed because Y2R relies on some features that
     are not present in `ycpc` bundled with openSUSE 12.3.

     To install updated `ycpc`, install the `yast2-core` package from
     `YaST:Head:ruby`:

         $ sudo zypper ar -f http://download.opensuse.org/repositories/YaST:/Head:/ruby/openSUSE_12.3/ YaST:Head:ruby
         $ sudo zypper in -f -r YaST:Head:ruby yast2-core

  3. **Install basic Ruby environment**

         $ sudo zypper in ruby ruby-devel rubygem-bundler

  4. **Install YCP Killer's dependencies and clone its repository**

     Install Y2R's dependencies:

         $ sudo zypper in gcc-c++                   # Needed by Nokogiri
         $ sudo zypper in make                      # Needed by Nokogiri
         $ sudo zypper in libxml2-devel             # Needed by Nokogiri
         $ sudo zypper in libxslt-devel             # Needed by Nokogiri

     Install packages needed to convert YaST modules into Ruby in general:

         $ sudo zypper in yast2-ycp-ui-bindings     # Implements UI::*
         $ sudo zypper in yast2-pkg-bindings        # Implements Pkg::*
         $ sudo zypper in yast2-perl-bindings       # Makes Perl modules work

     Install packages needed to convert specific YaST modules:

         $ sudo zypper in cracklib-devel            # Needed by users
         $ sudo zypper in limal-perl                # Needed by bootloader
         $ sudo zypper in perl-Crypt-SmbHash        # Needed by samba-server
         $ sudo zypper in perl-Date-Calc            # Needed by ca-management
         $ sudo zypper in perl-Digest-SHA1          # Needed by ftp-server,
                                                    # phone-services,
                                                    # profile-manager and s390
         $ sudo zypper in perl-JSON                 # Needed by crowbar
         $ sudo zypper in perl-NetxAP               # Needed by mail
         $ sudo zypper in perl-X500-DN              # Needed by ldap-server
         $ sudo zypper in perl-camgm                # Needed by ca-management
         $ sudo zypper in sablotron                 # Needed by storage
         $ sudo zypper in suseRegister              # Needed by registration
         $ sudo zypper in yast2-ldap                # Needed by dns-server and
                                                    # dhcp-server (they need Perl
                                                    # modules which are not
                                                    # available otherwise as we
                                                    # don't translate ldap)
         $ sudo zypper in yast2-storage             # Needed by storage (it needs
                                                    # a C part, so let's use
                                                    # already built one)

     Install packages needed to build YaST modules in general:

         $ sudo zypper in yast2-devtools            # Needed to create package source
         $ sudo zypper in osc                       # Needed to create package source
         $ sudo zypper in libtool                   # Needed to create package source
         $ sudo zypper in expect                    # Needed by tests
         $ sudo zypper in dejagnu                   # Needed by tests

     Install packages needed to build specific YaST modules:

         $ sudo zypper in openslp-devel             # Needed by slp
         $ sudo zypper in swig                      # Needed by storage
         $ sudo zypper in dia                       # Needed by nfs-client
         $ sudo zypper in docbook-xsl-stylesheets   # Needed by dbus-server
         $ sudo zypper in dbus-1-devel              # Needed by dbus-server
         $ sudo zypper in polkit-devel              # Needed by dbus-server
         $ sudo zypper in yast2-core-devel          # Needed by installation
         $ sudo zypper in trang                     # Needed by installation
         $ sudo zypper in rubygem-racc              # Needed by drbd
         $ sudo zypper in libldap-cpp-devel         # Needed by ldap-server
         $ sudo zypper in boost-devel               # Needed by ldap-server
         $ sudo zypper in xorg-x11-libX11-devel     # Needed by printer
         $ sudo zypper in alsa-devel                # Needed by sound
         $ sudo zypper in libyui-devel              # Needed by ycp-ui-bindings
         $ sudo zypper in ImageMagick               # Needed by nis-server

     Clone YCP Killer's repository and install Gem dependencies:

         $ git clone git://github.com/yast/ycp-killer.git
         $ cd ycp-killer
         $ bundle install

  5. **Configure `osc`**

     Configure your `osc` credentials if you didn't use `osc` on the machine
     yet. Just run `osc`, it will ask for them and save them to `~/.oscrc`.

     You can skip this step if you don't plan to create translated package
     sources (using `yk package`).

  6. **Done!**

     You can now start killing YCP.

Overview
--------

YCP Killer is a command-line tool built around tasks that are applied on YaST
module source code. Some of these tasks are driven by *module metadata files*
which contain various information about all the translated modules (see [Module
Metadata](#module-metadata).

The usual YCP Killer usage workflow is:

  * Clone YaST module Git repository.
  * Restructure the YaST module source code to match the new structure (see [New
    YaST Module Structure](#new-yast-module-structure).
  * Apply patches to the restructured YaST module source code (typically to
    adapt Makefiles to Ruby translation and to work around Y2R deficiencies).
  * Compile YaST module's YCP modules (without this any code depending on them
    can't be translated by Y2R).
  * Convert the YaST module source code into Ruby.
  * Create a YaST module package source.
  * Build the package locally.
  * Submit a package into OBS.

All these tasks (and some more) can be executed by commands described in the
[Usage](#usage) section.

YCP Killer stores its data in `$XDG_DATA_HOME/ycp-killer` (usually
`~/.local/share/ycp-killer`). The directory structure looks like this:

    $XDG_DATA_HOME/ycp-killer
    └─ yast
       ├─ work
       │  ├─ add-on-creator
       │  ├─ ...
       │  └─ ycp-ui-bindings
       ├─ result
       │  ├─ add-on-creator
       │  ├─ ...
       │  └─ ycp-ui-bindings
       └─ build_service
          └─ YaST:Head:ruby
             ├─ autoyast2
             ├─ ...
             └─ yast2-ycp-ui-bindings

For each YaST module, YCP Killer creates three directories:

  * **Work directory** (`$XDG_DATA_HOME/ycp-killer/yast/work/<module-name>`)

    Contains clone of module Git repository. Restructuring, patching and module
    compilation all happen here.

  * **Result directory** (`$XDG_DATA_HOME/ycp-killer/yast/result/<module-name>`)

    Contains module source code after translation into Ruby.

  * **OBS directory** (`$XDG_DATA_HOME/ycp-killer/yast/build_service/YaST:Head:ruby/<module-package-name>`)

    Contains translated module package source, ready to be built locally or
    submitted to OBS. Techically, this directory is an OBS package checkout as
    created by `osc`.

Data in the `$XDG_DATA_HOME/ycp-killer` directory can easily grow into
gigabytes, so make sure you have enough free space.

Usage
-----

YCP Killer is a command line tool. It's entry point is the `yk` script, which
accepts subcommands (like `git` or `bundler`). Each subcommand can be applied to
a set of YaST modules passed as arguments. A special value `all` will apply a
command to all YaST modules.

```
$ ./yk help
Tasks:
  yk build <module>...        # Build package(s) for module(s) locally
  yk clone <module>...        # Clone module(s)
  yk convert <module>...      # Convert module(s)
  yk genpatch <module>...     # Store changes from work directory of module(s) into a patch
  yk help [TASK]              # Describe available tasks or one specific task
  yk makefile <module>...     # Generates Makefile.am for exported dirs of module(s)
  yk package <module>...      # Create packages in build service directory for module(s)
  yk patch <module>...        # Patch module(s)
  yk pull <module>...         # Update the module(s) work directory to the latest state (git pull)
  yk reset <module>...        # Revert module(s) work directory to clean state
  yk restructure <module>...  # Change module(s) work directory structure to fit the Y2DIR scheme
  yk ruby <module>...         # Convert module(s) to Ruby
  yk submit <module>...       # Submit source files to build service for module(s)
  yk ybc <module>...          # Compile module(s) to ybc

Options:
  [--debug]      # verbosely log what commands are run
  [--with-deps]  # also include module dependencies in operations
```

### Commands

The commands operate on two distinct directory trees: the *working* tree and
the *result* tree.

The module name can be omitted if it is the current working directory in the
*working* tree.

#### yk convert

Does everything at once: `clone`, `restructure`, `patch`, `compile`, `makefile`, `package`.

#### yk clone

Clones repositories of specified modules into subdirectories of a directory
specified by the `yast_dir` setting in `config.yml`.

**Removes the working tree for the module beforehand.**

```
$ ./yk clone testsuite
[1/1] Processing testsuite:
  * Cloning...
```

#### yk reset

Reverts the working directory to a clean state.
It is a local variant of `yk clone`
in that it **removes all modifications in the working tree**.
Use `yk genpatch` beforehand to save them.

The command also checks if the current Git checkout is up to date with the original YaST
repository and prints a warning it not (see `yk pull` command).

```
$ ./yk reset testsuite
[1/1] Processing testsuite:
  * Resetting...
```

#### yk pull

Pulls changes from the upstream YaST Git repository. If the changes cannot be
merged (e.g. because of changes done by restructuring or by patching)
you need to run `yk reset` and try it again.

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
[1/1] Processing testsuite:
  * Restructuring...
```

#### yk patch

Applies patches for specified modules from the `patches` directory to their
checkouts. If a module doesn't have a patch, this command does not do anything.

```
$ ./yk patch testsuite
[1/1] Processing testsuite:
  * Patching...
```

#### yk ruby

Compiles YCP files of specified modules to Ruby, placing the result in the
*result* tree.
The compilation is driven by
module descriptions stored in the `data` directory. It uses `ycpc` and `y2r`
(see `y2r` setting in `config.xml`).

The compilation of each file can pass or may fail with one of the following error:

  * **ERROR(ybc)** – the compilation failed when running `ycpc`
    on the module code
  * **ERROR(y2r)** – the compilation failed when running `y2r`
    on the module code
  * **ERROR(ruby)** – the compilation failed because it produced a result which
    was invalid Ruby (as determined by `ruby -c`)
  * **ERROR(other)** – the compilation failed for some other reason

If the compilation is successful, all YCP files defined in the module
description will be compiled by `ycp` and will have an eqivalent Ruby file
created in the **result** tree (e.g. compiling `Sysconfig.ycp` will produce
`Sysconfig.rb` file).

In case of `ERROR(y2r)` and `ERROR(ruby)`, details of the error are logged into
the `error.log` file in the YCP Killer directory.

```
$ ./yk ruby testsuite
[1/1] Processing testsuite:
  * Creating result directory...
  * Converting src/modules/Pkg.ycp...
  * Checking src/modules/Pkg.ycp...
  * Converting src/modules/Testsuite.ycp...
  * Checking src/modules/Testsuite.ycp...
  * Converting src/include/testsuite.ycp...
  * Checking src/include/testsuite.ycp...
  * Converting testsuite/test.ycp...
  * Checking testsuite/test.ycp...

-----

Total OK:           8
Total EXCLUDED:     0
Total ERROR(ybc):   0
Total ERROR(y2r):   0
Total ERROR(ruby):  0
Total ERROR(other): 0
```

#### yk genpatch

Stores changes from the working directory
into a patch in the `patches` directory.

**Any existing patch for the module is removed**.

```
$ ./yk genpatch testsuite
[1/1] Processing testsuite:
  * Generating patch...
```

#### yk makefile

Generates Makefile.am for exported directories of module(s)

#### yk package

Creates packages for module(s) in the build service directory, which is a
third tree alongside the *working* and *result* ones.

### Module Metadata

Modules have metadata files placed in `data/foo.yml`, in the [YAML][yaml]
format.

[yaml]: http://en.wikipedia.org/wiki/YAML

```
# A list of modules this one depends on to compile ycp code to ybc. Only direct
# dependencies need to be stated here (the indirect ones are computed
# automatically when needed).
# Default: []
ybc_deps:
  - yast2

# A list of modules this one additionally depends on to convert  ycp code to
# ruby. It needs to specify even indirect dependencies opposed to previous list.
# It is useful when client or testsuite depends on additional modules as
# ybc_deps are automatically merged.
# Default: []
ruby_deps:
  - testsuite

# A list of operations used by the `restructure` command
# to make the working tree better fit the Y2DIR scheme.
# Default: []
moves:
    # A glob in the original structure
    # (use quotes because of YAML syntax).
  - from: src/NfsServer.ycp
    # A directory path in the new structure.
    # Missing directories will be created.
    to: src/modules
  - from: "src/nfs[-_]server*.ycp"
    to: src/clients
    # The list is ordered, so we can glob the rest of the files:
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

New YaST Module Structure
-------------------------

The existing directory tree layout of nearly all YaST modules is rather random
and stupid. It is convenient to use the translation occasion to also move
files to a more logical and uniform scheme, to enable exporting the working
directory via `Y2DIR` and to unify Makefiles.

The following tree shows what gets installed where:

```
tictactoe-server
└── src
    ├── bin            ->  /usr/lib/YaST2/bin       (lib, even if lib64 exists)
    ├── servers_non_y2 ->  /usr/lib/YaST2/servers_non_y2
    ├── clients        ->  /usr/share/YaST2/clients
    ├── data           ->  /usr/share/YaST2/data
    ├── include        ->  /usr/share/YaST2/include
    ├── modules        ->  /usr/share/YaST2/modules
    ├── scrconf        ->  /usr/share/YaST2/scrconf
    ├── autoyast-rnc   ->  /usr/share/YaST2/schema/autoyast/rnc
    ├── control-rnc    ->  /usr/share/YaST2/schema/control/rnc
    ├── desktop        ->  /usr/share/applications/YaST2
    └── fillup         ->  /var/adm/fillup-templates
```

Other directories, like `doc` and `testsuite`, are not restructured now
and keep their existing Makefiles.
