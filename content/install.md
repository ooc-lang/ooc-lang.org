---
title: Installing ooc
has_toc: true
---

## Quick install

### OSX

rock is provided by [homebrew][hb]:

[hb]: http://brew.sh/

    #!bash
    brew install rock

That will usually get you the last stable version. If that seemed
to work, carry on to the [post-install instructions](#post-install-instructions).

### Linux

Depending on your distribution, rock might be available via your package
manager. However, [installing from git](#installing-from-git) is recommended
to get the latest version.

### Windows

First off, you probably want to use a gcc build from the [MinGW][mingw]
project, as well as an MSYS environment.

rock is provided by [winbrew][wb]:

    #!bash
    brew install rock

Or, if you prefer, you can proceed to a [manual installation](#manual-installation).

[mingw]: http://mingw.org/
[wb]: https://github.com/nddrylliog/winbrew

## Installing from Git

To install rock, simply clone the git repo and run make rescue:

    #!bash
    git clone https://github.com/nddrylliog/rock.git
    cd rock
    make rescue

Then, add it to your `$PATH`. One way to do that is to edit your
`~/.bashrc` or `~/.zshrc` file to add the line:

    #!bash
    export PATH="$PATH:/path/to/rock/bin"

And then close and re-open your terminal - or simply `source ~/.bashrc`
or similar.

## Post-install instructions

The first thing you want to do is test that rock has been installed
correctly. Running `rock -v` should greet you with something like:

    rock 0.9.7-head codename pacino, built on 8/2/2013 1:31:24

Then, you want to choose a directory where you will put all your ooc-related
stuff. For this page, we will assume you are using `$HOME/Dev`.

Edit your `~/.bashrc` or `~/.zshrc` file to add the line:

    #!bash
    export OOC_LIBS="$HOME/Dev"

And then close and re-open your terminal - or simply `source ~/.bashrc`
or similar.

## Installing sam

[sam][sam] is a very useful command-line tool that will allow you to:

  * clone any ooc project in its grimoir
  * make sure the dependencies are present and up-to-date
  * tell you if you forgot to push any of your repos
  * run a test suite and generate a report

It is simply a must-have. Don't wait up and do the following:

    #!bash
    git clone https://github.com/nddrylliog/sam.git $OOC_LIBS/sam
    cd $OOC_LIBS/sam
    rock -v

If compilation went fine, you should be able to execute `./sam`. Then,
you need to add it to your `$PATH`, just like rock, by adding this line
to your `~/.bashrc` or `~/.zshrc`:

    #!bash
    export PATH="$PATH:$OOC_LIBS/sam"

Running `sam` should now print its version, along with a little help text.
Feel free to [read more][sam] about the many wonders of sam.

[sam]: /docs/tools/sam/
