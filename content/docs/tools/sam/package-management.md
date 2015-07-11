---
title: Package management
has_toc: true
---

## Concepts

The large majority of ooc projects being hosted on github, it made sense to
focus on git as the primary code distribution channel when building sam's
package manager.

In general, sam consists of a simple executable and a collection of package
files: It keeps a
[grimoire](https://github.com/fasterthanlime/sam/tree/master/library) of
package metadata, so-called formulas.  In a way, this is ooc's central package
repository, similar to Python's PyPI, but much simpler. Every package is
represented by a single YAML file.  For now, the only supported (and required)
option is `Origin` containing the URL of the corresponding git repository.

For example, the [SDL2 formula](https://github.com/fasterthanlime/sam/blob/master/library/sdl2.yml)
just says:

    Origin: https://github.com/geckojsc/ooc-sdl2.git

which tells sam that it can find the current ooc-sdl2 code at the given git repository.

## Getting packages

sam assumes a few basic things about a package and its repository layout:

Every package has a unique name and a unique git repository, and every
git repository contains a usefile named exactly like the package. This
enables sam to identify a package by its unique name, clone the right git
repository, find the correct [usefile](/docs/tools/rock/usefiles/) and build the package easily.

Say you are building an ooc project depending on
[deadlogger](https://github.com/fasterthanlime/deadlogger)
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

## Updating the grimoire

Since the formulas reside in a git repository, your local clone will get out of
date from time to time when new formulas are added in the origin repository.
In that case, just run

    #!bash
    sam update

to get the latest formulas and recompile sam automatically.

## Upgrading packages

`sam update` only fetches the new versions of formulas, not the new libs
themselves. To upgrade all dependencies of a projet, simply run:

    #!bash
    sam get

`sam get` always clones the missing repositories, and pulls the existing ones.

## Developing a package?

As mentioned above, the [grimoire][grimoire] can be seen as the ooc package index.
Therefore, it is important to include as many packages as possible.

So, if you're developing some open source ooc project, please go ahead, clone
the [sam repository][sam], add a formula and file a
[pull request](https://github.com/fasterthanlime/sam/pulls). Everybody wins!

[sam]: https://github.com/fasterthanlime/sam
[grimoire]: https://github.com/fasterthanlime/sam/tree/master/library

