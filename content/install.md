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
manager. However, a [manual installation](#manual-installation) is recommended
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

## Manual installation

To install rock, simply clone the git repo and run make rescue:

    #!bash
    git clone https://github.com/nddrylliog/rock.git
    cd rock
    make rescue

Then, add it to your `$PATH`. One way to do that is to edit your
`~/.bashrc` or `~/.zshrc` file to add the line:

    #!bash
    export PATH="$PATH:/path/to/rock/bin"

## Post-install instructions

The first thing you want to do is test that rock has been installed
correctly. Running `rock -v` should greet you with something like:

    rock 0.9.7-head codename pacino, built on 8/2/2013 1:31:24

Then, you want to choose a directory where you will put all your ooc-related
stuff. For this page, we will assume you are using `$HOME/Dev`.

## About rock

The main implementation of ooc is rock - it's written in ooc itself,
and it is the most up-to-date version.
