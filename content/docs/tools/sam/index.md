---
title: sam
has_toc: true
---

## About sam

sam is a minimal package and dependency manager for ooc projects. It operates
similarly to [homebrew](https://brew.sh) for OS X, but in a much more minimal way.

## Installation

To use sam, apart from a working [rock](/docs/tools/rock/), you need [git](http://git-scm.com/).
Also, you have to create a special directory that is writable for you, which will
later contain all ooc packages cloned from their git repositories. This directory
is called the ooc library path -- you also have to specify its location in the special
`OOC_LIBS` environment variable. On most unixes, you can do that like this:

    #!bash
    mkdir ~/development/ooc
    export OOC_LIBS=~/development/ooc

As a first step, you can use git to clone sam itself. You should clone sam into
a subdirectory of the newly created directory. Since sam does not have any dependencies
apart from rock, you can just go ahead and compile it [from the usefile](/docs/tools/rock/usefiles/):

    #!bash
    cd $OOC_LIBS
    git clone https://github.com/nddrylliog/sam.git
    cd sam/
    rock -v

This should proeduce a `sam` executable. Just add it to the path:

    #!bash
    export PATH=$PATH:$OOC_LIBS/sam

You should now be able to invoke sam just by typing

    #!bash
    sam

## Concepts

All ooc projects known to mankind are hosted on github. Therefore, building a
package manager, it makes sense to focus on git as the primary way of code
distribution.

In general, sam consists of a simple executable and a collection of package files:
It keeps a [grimoire](https://github.com/nddrylliog/sam/tree/master/library) of
package metadata, so-called formulas.
In a way, this is ooc's central package repository, similar to
Python's PyPI, but much simpler. Every package is represented by a single YAML file.
For now, the only supported (and required) option is `Origin` containing the URL
of the corresponding git repository.

For example, the [SDL2 formula](https://github.com/nddrylliog/sam/blob/master/library/sdl2.yml)
just says:

    Origin: https://github.com/geckojsc/ooc-sdl2.git

which tells sam that it can find the current ooc-sdl2 code at the given git repository.

## Getting serious

sam assumes a few basic things about a package and its repository layout:

Every package has a unique name and a unique git repository, and every
git repository contains a usefile named exactly like the package. This
enables sam to identify a package by its unique name, clone the right git
repository, find the correct [usefile](/docs/tools/rock/usefiles/) and build the package easily.

Say you are building an ooc project depending on
[deadlogger](https://github.com/nddrylliog/deadlogger)
and [ooc-mxml](https://github.com/geckojsc/ooc-mxml). Looking into
the [grimoire][grimoire], you can figure out the package names and
add the following to your usefile (called `toast.use`):

    #!ooc
    Name: toast
    Description: open toaster firmware
    ...
    Requires: deadlogger, mxml

Now, let sam do the hard work:

    #!bash
    sam get toast.use

This will check if you already have deadlogger and mxml installed in your ooc library
path and clone all missing dependencies. Afterwards, you can just type

    #!bash
    rock -v

and rock will read your usefile, find all dependencies (sam just made sure we
have them!) and compile your project.

Since the formulas reside in a git repository, your local clone will get out of
date from time to time when new formulas are added in the origin repository.
In that case, just run

    #!bash
    sam update

to get the latest formulas and recompile sam automatically.

## Developing a package?

As mentioned above, the [grimoire][grimoire] can be seen as the ooc package index.
Therefore, it is important to include as many packages as possible.

So, if you're developing some open source ooc project, please go ahead, clone
the [sam repository][sam], add a formula and file a
[pull request](https://github.com/nddrylliog/sam/pulls). Everybody wins!

[sam]: https://github.com/nddrylliog/sam
[grimoire]: https://github.com/nddrylliog/sam/tree/master/library
