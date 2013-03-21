YCP Killer
==========

YCP Killer is a tool that manages translation of
[YCP](http://doc.opensuse.org/projects/YaST/SLES10/tdg/Book-YCPLanguage.html)
code in [YaST](http://en.opensuse.org/Portal:YaST) into Ruby. To perform the
actual translation, it uses [Y2R](https://github.com/yast/y2r).

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
     are not present in `ycpc` bundled with openSUSE 12.3.

         $ sudo zypper in make yast2-devtools libtool gcc-c++ bison \
           docbook-xsl-stylesheets expect dejagnu flex boost-devel doxygen
         $ git clone git://github.com/yast/yast-core.git
         $ cd yast-core
         $ make -f Makefile.cvs
         $ make
         $ cd ..

  3. **Install basic Ruby environment**

         $ sudo zyppper in ruby ruby-devel
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
