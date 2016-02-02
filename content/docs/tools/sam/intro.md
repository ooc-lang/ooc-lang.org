---
title: Introduction
has_toc: true
---

## Installing sam

To use sam, apart from a working [rock][], you need [git](http://git-scm.com/).
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
    git clone https://github.com/ooc-lang/sam.git
    cd sam/
    rock -v sam.use

This should produce a `sam` executable. Just add it to the path:

    #!bash
    export PATH=$PATH:$OOC_LIBS/sam

You should now be able to invoke sam just by typing

    #!bash
    sam

When invoked without arguments, sam displays its version and a short usage
guide.

## Updating sam

sam has a very simple update mechanism for both itself and its grimoire.

When running:

    #!bash
    sam update

sam will attempt to find its repository, pull it, and recompile itself.
Should anything go wrong and you end up with a broken build of sam, you
can always go into the directory yourself, clean with `rock -x`, switch
to whichever commit last worked for you and run `rock -v sam.use` again.

Since formulas (ooc libraries you can install with sam) are just YAML files
in a folder of sam's repo, pulling the repo from git updates all formula
definitions at the same time. However, it doesn't fetch them until `sam get`
is ran in a project that depends on them.

[rock]: /docs/tools/rock/

