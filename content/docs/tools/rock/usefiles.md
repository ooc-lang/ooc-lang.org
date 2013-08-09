---
title: Usefiles
has_toc: true
---

## Usefiles explained

A usefile describes an ooc package, ie. a collection of modules and contains information
how to compile and link that specific package. It also denotes if the package compiles
to an executable or a DLL (resp. an ELF shared object).

Usefiles aren't a totally new concept. It's comparable to `pkg-config` files or, to
some degree, similar to build system files like CMake or SCons.

However (and this is a pretty new thing!), the compiler rock itself reads and handles
these usefiles.

## Examples

Let's start off with some examples. This is the usefile of
[ooc-zeromq](https://github.com/nddrylliog/ooc-zeromq), a [zeromq](http://zeromq.org) binding
for ooc (shortened for brevity):

    #!yaml
    Name: zeromq
    Description: The 0MQ lightweight messaging kernel
    Version: 2010-06-16
    SourcePath: source
    Includes: zmq.h
    Libs: -lzmq

A usefile should always contain the name, description and version of its package.

In addition, this usefile tells rock that the actual ooc files reside in the subdirectory
`source` (which will be added to the so-called sourcepath).

Also, since this is a C library binding, the zeromq header needs to be included,
and the `-lzmq` flag needs to be passed to the linker.

What are the benefits of writing such a file?

If you want to use this package in any of your projects, you can just write:

    #!ooc
    use zeromq

at the top of your ooc file, and rock will automatically look through your library path
(the contents of the `OOC_LIBS` environment variable) for a file called `zeromq.use` and find
the usefile above. Now, it instantly knows where it can find the ooc-zeromq ooc files,
what C files need to be included and what libraries need to be linked in order to get
your package to work properly with zeromq.

Now, you can just use

    #!ooc
    import zeromq/zeromq

and hack away.
