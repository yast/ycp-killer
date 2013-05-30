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

Contents
--------

  * [Installation](#installation)
  * [Overview](#overview)
  * [Usage](#usage)
    * [Commands](#commands)
      * [yk build](#yk-build)
      * [yk clone](#yk-clone)
      * [yk convert](#yk-convert)
      * [yk genpatch](#yk-genpatch)
      * [yk makefile](#yk-makefile)
      * [yk package](#yk-package)
      * [yk patch](#yk-patch)
      * [yk pull](#yk-pull)
      * [yk reset](#yk-reset)
      * [yk restructure](#yk-restructure)
      * [yk ruby](#yk-ruby)
      * [yk submit](#yk-submit)
      * [yk test](#yk-test)
  * [Module Metadata](#module-metadata)
  * [New YaST Module Structure](#new-yast-module-structure)

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

         $ sudo zypper in gcc-c++                        # Needed by Nokogiri
         $ sudo zypper in make                           # Needed by Nokogiri
         $ sudo zypper in libxml2-devel                  # Needed by Nokogiri
         $ sudo zypper in libxslt-devel                  # Needed by Nokogiri

     Install packages needed to convert YaST modules into Ruby in general:

         $ sudo zypper in yast2-ycp-ui-bindings          # Implements UI::*
         $ sudo zypper in yast2-pkg-bindings             # Implements Pkg::*
         $ sudo zypper in yast2-perl-bindings            # Makes Perl modules work

     Install packages needed to convert specific YaST modules:

         $ sudo zypper in cracklib-devel                 # Needed by users
         $ sudo zypper in limal-perl                     # Needed by bootloader
         $ sudo zypper in perl-Crypt-SmbHash             # Needed by samba-server
         $ sudo zypper in perl-Date-Calc                 # Needed by ca-management
         $ sudo zypper in perl-Digest-SHA1               # Needed by ftp-server,
                                                         # phone-services,
                                                         # profile-manager and s390
         $ sudo zypper in perl-JSON                      # Needed by crowbar
         $ sudo zypper in perl-NetxAP                    # Needed by mail
         $ sudo zypper in perl-X500-DN                   # Needed by ldap-server
         $ sudo zypper in perl-camgm                     # Needed by ca-management
         $ sudo zypper in sablotron                      # Needed by storage
         $ sudo zypper in suseRegister                   # Needed by registration
         $ sudo zypper in yast2-ldap                     # Needed by dns-server and
                                                         # dhcp-server (they need Perl
                                                         # modules which are not
                                                         # available otherwise as we
                                                         # don't translate ldap)
         $ sudo zypper in yast2-storage                  # Needed by storage (it needs
                                                         # a C part, so let's use
                                                         # already built one)

     Install packages needed to build YaST modules in general:

         $ sudo zypper in yast2-devtools                 # Needed to create package source
         $ sudo zypper in osc                            # Needed to create package source
         $ sudo zypper in libtool                        # Needed to create package source
         $ sudo zypper in ca-certificates-mozilla        # Needed to create package source
         $ sudo zypper in expect                         # Needed by tests
         $ sudo zypper in dejagnu                        # Needed by tests

     Install packages needed to build specific YaST modules:

         $ sudo zypper in openslp-devel                  # Needed by slp
         $ sudo zypper in swig                           # Needed by storage
         $ sudo zypper in dia                            # Needed by nfs-client
         $ sudo zypper in docbook-xsl-stylesheets        # Needed by dbus-server
         $ sudo zypper in dbus-1-devel                   # Needed by dbus-server
         $ sudo zypper in polkit-devel                   # Needed by dbus-server
         $ sudo zypper in yast2-core-devel               # Needed by installation
         $ sudo zypper in trang                          # Needed by installation
         $ sudo zypper in rubygem-racc                   # Needed by drbd
         $ sudo zypper in libldapcpp-devel               # Needed by ldap-server
         $ sudo zypper in boost-devel                    # Needed by ldap-server
         $ sudo zypper in xorg-x11-libX11-devel          # Needed by printer
         $ sudo zypper in alsa-devel                     # Needed by sound
         $ sudo zypper in libyui-devel                   # Needed by ycp-ui-bindings
         $ sudo zypper in ImageMagick                    # Needed by nis-server

     Install packages needed to build YaST module packages:

         $ sudo zypper in build                          # Needed by "osc build"

     Install packages needed to submit specific YaST modules into OBS:

         $ sudo zypper in obs-service-format_spec_file   # Needed by perl-bindings

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
  * Generate `Makefile.am` files in all source directories matching the new
    structure (usually only `src`).
  * Create a YaST module package source.
  * Build the package locally.
  * Submit a package into OBS.

All these tasks (and some more) can be executed by commands described in the
[Usage](#usage) section.

YCP Killer stores its data in `$XDG_DATA_HOME/ycp-killer` (usually
`~/.local/share/ycp-killer`). The directory structure looks like this:

    $XDG_DATA_HOME/ycp-killer
    ├─ work
    │  ├─ add-on-creator
    │  ├─ ...
    │  └─ ycp-ui-bindings
    ├─ result
    │  ├─ add-on-creator
    │  ├─ ...
    │  └─ ycp-ui-bindings
    └─ obs
       └─ YaST:Head:ruby
          ├─ autoyast2
          ├─ ...
          └─ yast2-ycp-ui-bindings

For each YaST module, YCP Killer creates three directories:

  * **Work directory** (`$XDG_DATA_HOME/ycp-killer/work/<module-name>`)

    Contains clone of module Git repository. Restructuring, patching and module
    compilation all happen here.

  * **Result directory** (`$XDG_DATA_HOME/ycp-killer/result/<module-name>`)

    Contains module source code after translation into Ruby.

  * **OBS directory** (`$XDG_DATA_HOME/ycp-killer/obs/YaST:Head:ruby/<module-package-name>`)

    Contains translated module package source, ready to be built locally or
    submitted to OBS. Techically, this directory is an OBS package checkout as
    created by `osc`.

Data in the `$XDG_DATA_HOME/ycp-killer` directory can easily grow into
gigabytes, so make sure you have enough free space.

Usage
-----

The entry point to YCP Killer is the `yk` script. It accepts commands (like
`git` or `bundler`).

Each command (except `help`) can be applied to a set of YaST modules passed as
arguments. A special value `all` will apply a command to all YaST modules. If
you don't specify any module name and you are in a work directory of some
module, the command is applied to that module.

The `help` command can be used to display a short overview of available commands:

    $ ./yk help
    Tasks:
      yk build <module>...        # Build package for converted module locally
      yk clone <module>...        # Clone module source from Git repository
      yk convert <module>...      # Run all conversion-related tasks for module
      yk genpatch <module>...     # Generate module's patch from changes in its work directory
      yk help [TASK]              # Describe available tasks or one specific task
      yk makefile <module>...     # Generate Makefile.am file(s) for converted module
      yk package <module>...      # Create package source for converted module
      yk patch <module>...        # Patch module(s)
      yk pull <module>...         # Update the module(s) work directory to the latest state (git pull)
      yk reset <module>...        # Revert module(s) work directory to clean state
      yk restructure <module>...  # Change module(s) work directory structure to fit the Y2DIR scheme
      yk ruby <module>...         # Convert module's YCP files into Ruby
      yk submit <module>...       # Submit converted module package source to OBS
      yk test <module>...         # Run tests for converted module
      yk ybc <module>...          # Compile module's YCP modules into YCP bytecode

    Options:
      [--debug]      # verbosely log what commands are run
      [--with-deps]  # also include module dependencies in operations
      [--threads=N]  # limit the number of threads in parallel tasks (default: all detected CPUs)

### Commands

#### yk build

Builds package for each specified module locally using `osc build`. The module
must be already converted to Ruby and it's package source must be created. The
package is built from converted module's package source in module's OBS
directory.

#### yk clone

Clones module source from Git repository for each specified module using `git
clone`. The clone is placed into module's work directory. If the work directory
already exists, it is deleted before cloning.

#### yk convert

Runs all conversion-related tasks for each specified module. Rough equivalent of
running `yk clone` (or `yk pull` if module's work directory exists), `yk
restructure`, `yk patch`, `yk ybc`, `yk ruby`, `yk makefile` and `yk package`.

#### yk genpatch

Generates patch for each specified module from changes in its work directory
using `git diff`. The patch is stored in YCP Killer's `patches` directory. If
the patch already exists, it is overwritten.

#### yk makefile

Generates `Makefile.am` file(s) for each specified module. The module must be
already converted to Ruby.

The `Makefile.am` files are created in all exported directories (as specified by
[module metadata](#module-metadata)) in module's result directory. All existing
`Makefile.am` files in exported directories are deleted.

Content of each `Makefile.am` file is determined by contents of the exported
directory it is created in.

#### yk package

Creates package source for each specified module using `make package-local`. The
module must be already converted to Ruby.

The package source is created from converted source in module's result directory
and placed in module's OBS directory. All previously existing files in the OBS
directory are deleted. If no OBS directory exists, it is created using `obs co`.

#### yk patch

Applies patch of each specified module to its source using `git apply`. The
patch is stored in the YCP Killer's `patches` directory. If a module doesn't
have a patch, nothing happens.

#### yk pull

Updates module source from Git repository for each specified module using `git
pull`.

Before running this command, module's work directory needs to be in clean state
(without any restructuring, patching, etc.). Use `yk reset` to put it into that
state.

#### yk reset

Reverts work directory of each specified module into clean state (in which it
was right after cloning) using `git reset`.

This commands also checks if module source is up-to-date with the Git repository
using `git fetch` and `git status`. It prints a warning if it is not.

#### yk restructure

Restructures work directory of each specified module to fit the [new
structure](#yast-module-new-structure).

Restructuring is driven by the `moves` section in [module
metadata](#module-metadata). The command goes through items specified in the
`moves` section sequentially. For each item, it moves all files specified by a
glob in the `from` key into a directory specified by the `to` key. It prints a
warning if the glob does not match any file.

All moves are done using `git mv` and thus are stored in Git index. This makes
work with patches easier, because changes done by patching can be distinguished
from changes done by restructuring.

#### yk ruby

Converts YCP files of each specified module into Ruby using
[Y2R](https://github.com/yast/y2r).

Before the conversion, module's work directory is copied into its result
directory and all *.ybc files inside (typically a result of running `yk ybc`)
are deleted. If the result directory already exists, it is deleted. All *.ycp
and *.yh files in the result directory are then replaced with converted *.rb
files. All files specified in the `excluded` section in [module
metadata](#module-metadata) are excluded from compilation and kept intact.

Some include files are not standalone and need to be compiled in context of
another file (called a *wrapper*). These include files and their wrappers need
to be specified in the `include_wrappers` section in [module
metadata](#module-metadata).

Compilation of each file can pass or fail with one of the following error:

  * **ERROR(y2r)** – the compilation failed when running `y2r`
    on the module code
  * **ERROR(ruby)** – the compilation failed because it produced a result which
    was invalid Ruby (as determined by `ruby -c`)
  * **ERROR(other)** – the compilation failed for some other reason

Errors are not fatal and their details are logged in the `error.log` file in the
YCP Killer directory. When the command finishes, it prints a short summary.

#### yk submit

Submits package source of each specified module to OBS using `osc commit`. The
module must be already converted to Ruby and it's package source must be
created. Submitted package source is taken from module's OBS directory.

#### yk test

Runs tests for each specified module using `make check`. The module must be
already converted to Ruby. The tests are executed on converted source in
module's result directory.

#### yk ybc

Compiles YCP modules of each specified module into YCP bytecode using `ycpc`.

The YCP modules to compile are looked up in module's work directory. More
specifically, all `modules` subdirectories in all exported directories (as
specified by [module metadata](#module-metadata)) are searched for *.ycp files.
Compiled *.ybc files are written next to the source files. The order of
compilation is determined automatically by module dependencies (including
indirect ones via include files).

Compilation of each file can pass or fail with one of the following error:

  * **ERROR(ybc)** – the compilation failed when running `ycpc`
    on the module code
  * **ERROR(other)** – the compilation failed for some other reason

Errors are not fatal and their details are logged in the `error.log` file in the
YCP Killer directory. When the command finishes, it prints a short summary.

Compiling YCP modules is necessary because otherwise these module couldn't be
imported by other modules during conversion to Ruby.

Module Metadata
---------------

Some of YCP Killer's tasks are driven by YaST module metadata. These are stored
in [YAML](http://en.wikipedia.org/wiki/YAML) files in YCP Killer's `data`
directory (there is one file for each YaST module). The format looks like this:

```
# A list of YaST modules that need to be compiled into YCP bytecode before this
# module can. Only direct dependencies need to be listed here (the indirect ones
# are computed automatically).
#
# Default: []
ybc_deps:
  - yast2

# A list of YaST modules that need to be converted into Ruby before this module
# can. Both direct and indirect dependencies need to be listed here.
#
# This list is mainly used to avoid circular dependencies in ybc_deps.
#
# Default: []
ruby_deps:
  - testsuite

# A list of moves that should be performed by "yk restructure" when
# restructuring this module.
#
# Default: []
moves:
    # A glob specifying files to move (in the original structure). Use quotes
    # around it to make sure the glob doesn't make the YAML invalid.
  - from: "src/NfsServer.ycp"
    # A directory where to move the files in (in the new structure). It will be
    # created if needed.
    to: src/modules
  - from: "src/nfs[-_]server*.ycp"
    to: src/clients
    # Note the moves are performed in the order specified by this list, so we
    # can just glob the rest of the files here.
  - from: "src/*.ycp"
    to: src/include/nfs_server

# A list of files to exclude from compilation to Ruby (performed by "yk ruby").
# The reason for exclusion should be supplied in a comment.
#
# All paths here are in the new structure.
#
# Default: []
excluded:
  # We agreed to exclude docs from automatic conversion.
  - library/sequencer/doc/examples/example1.ycp
  - library/sequencer/doc/examples/example2.ycp
  # This include file is not self-contained and can't be converted now.
  - library/packages/src/include/packages/common.ycp

# A hash that maps include files that are not standalone into files in whose
# context they should be compiled in ("wrappers").
#
# All paths here are in the new structure.
#
# Default: {}
include_wrappers:
  src/include/network/isdn/config.ycp: src/modules/ISDN.ycp
  src/include/network/lan/wireless.ycp: src/clients/lan.ycp
  src/include/network/lan/bridge: src/clients/lan.ycp

# A list of module's exported directories. These are added to include path and
# module path of YaST modules that depend on this module when compiling them
# into YCP bytecode ("yk ybc") or converting them into Ruby ("yk ruby"). In
# addition, Makefile.am files generated by "yk makefile" are placed in these
# directories.
#
# For most modules, this section doesn't need to be specified as the default
# value is sufficient.
#
# All paths here are in the new structure.
#
# Default: ["src"]
exports:
  - src
  - library/sequencer/src
  - library/packages/src
```

New YaST Module Structure
-------------------------

The existing directory tree layout of nearly all YaST modules is rather random
and stupid. Translation into Ruby is a good opportunity to unify it. This is why
YCP Killer contains the `yk restructure` command, which does exactly that, and
the `yk makefile` command, which uses the unified structure to generate
`Makefile.am` files.

The following scheme shows how exported directories (see [Module
Metadata](#module-metadata)) of each YaST module should look like and where the
files contained there will be installed.

```
tictactoe-server
└─ src
   ├─ bin              ->   /usr/lib/YaST2/bin
   ├─ servers_non_y2   ->   /usr/lib/YaST2/servers_non_y2
   ├─ clients          ->   /usr/share/YaST2/clients
   ├─ data             ->   /usr/share/YaST2/data
   ├─ include          ->   /usr/share/YaST2/include
   ├─ modules          ->   /usr/share/YaST2/modules
   ├─ scrconf          ->   /usr/share/YaST2/scrconf
   ├─ autoyast-rnc     ->   /usr/share/YaST2/schema/autoyast/rnc
   ├─ control-rnc      ->   /usr/share/YaST2/schema/control/rnc
   ├─ desktop          ->   /usr/share/applications/YaST2
   └─ fillup           ->   /var/adm/fillup-templates
```

(Note that `/usr/lib/*` will be used even on 64-bit machines, where
`/usr/lib64/*` would be more appropriate.)

Other directories, like `doc` and `testsuite`, are not restructured and keep
their existing `Makefile.am` files.
