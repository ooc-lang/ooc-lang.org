---
title: Usefiles
has_toc: true
---

## Usefiles explained

A usefile describes an ooc package, ie. a collection of modules and contains information
how to compile and link that specific collection of ooc files.
It also denotes if the package should compile to an executable or a shared/static library.

Usefiles are not a totally novel concept. They are comparable to `pkg-config` files or, to
some degree, similar to build system files like CMake or SCons.

However, in ooc, (and this is a pretty new thing!),
the compiler rock itself reads and handles these usefiles.

## Examples

Let's start off with some examples. Following is the repository structure of
[ooc-zeromq](https://github.com/fasterthanlime/ooc-zeromq), a [zeromq](http://zeromq.org) binding
for ooc:

    .
    ├── LICENSE
    ├── README.md
    ├── samples
    │   ├── ...
    ├── source
    │   └── zeromq.ooc
    └── zeromq.use

Let's assume that you cloned the repository into a subdirectory of your ooc library path
(which consists of the paths in the `OOC_LIBS` environment variable).

And here are the contents of `zeromq.use` (shortened for brevity):

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

Also, since this is a C library binding, the zeromq C header needs to be included,
and the `-lzmq` flag needs to be passed to the linker.

So far so good. But what are the benefits of writing such a file?

If you now want to use this package in any of your projects, you can just write:

    #!ooc
    use zeromq

at the top of your ooc file, and rock will automatically look through your library path
(the paths in the `OOC_LIBS` environment variable) for a file called `zeromq.use` and find
the usefile above. Now it parses this usefile and instantly knows not only where it can
find the ooc-zeromq ooc files, but also what C headers need to be included and
what libraries need to be linked.

As a result, you can now just import the ooc-zeromq ooc file like this:

    #!ooc
    import zeromq

and hack away.

Another simpler example is the [sam](https://github.com/ooc-lang/sam) usefile. sam is
different because it compiles to an executable file:

    #!yaml
    Name: sam
    Description: Sam keeps your ooc repos up to date
    SourcePath: source
    Main: sam.ooc

Once again, the usefile contains name and description (no version here, though!) and
the sourcepath.

The new thing: `Main` denotes the entry point for the executable, e.g. the file
containing the `main` function. rock looks for a file named this in the source path,
which here contains the subdirectory source/.

To build sam, you can now just run:

    #!bash
    rock -v

which will look for a usefile in your current directory and build the package. As a result,
you get a `sam` executable -- and all of that without using a third party build system!

## Fields

A list of all currently supported fields in usefiles follows.

 * `Name`, `Description` and `Version` contain metadata about the package
   and version
 * `Pkgs` contains a comma-separated list of `pkg-config` packages this
   package depends on. rock will invoke `pkg-config` with these packages
   and add the resulting C flags and linker flags to its pipeline
 * `CustomPkg` can be used to specify the name of a `pkg-config`-like tool
   that should be used instead. For example, the ooc sdl2 binding sets
   this to `sdl2-config`
 * `Libs` contains a comma-separated list of linker flags like `-lSDL2_image`
 * `Frameworks`: OSX-only, specify Frameworks to be linked with (example: `OpenGL`)
 * `Includes` can be used to specify C headers that should be included
   (as a comma-separated list)
 * `PreMains`: List of compiler flags that, if specified from a .pc file or a .use file,
   (maybe conditioned by a version block), must appear before the main compilation unit.
   Example: `-lSDL2main` on Windows.
 * `Linker` can be used to specify a `ld` replacement
 * `LibPaths` and `IncludePaths` are comma-separated lists and contain
   paths that should be added to the linker or C include paths
 * `AndroidLibs`, `AndroidIncludePaths`: Android-specific properties that are
   only used with the Android driver.
 * `Additionals`: can be used to add `.c` files to be compiled along with the .ooc code.
   Relative paths (starting with `./`) will have the .c file be copied locally.
 * `Requires` can be used to specify requirements (denoted by usefile
   names), for example for sam
 * `SourcePath` can be used to add a path to the source path
 * `Imports` contains list of modules that should be implicitly imported when
   `use yourusefile` is used. Grouping syntax (e.g. `folder/[a, b, c]`) is
   supported, just as regular ooc imports.
 * `Origin` is ignored by rock, but it traditionally specifies the
   git repository url of that package
 * `Main` is the name of the entrypoint file
 * all fields starting with `_` are ignored by rock

## Version blocks

Similarily to ooc's [version blocks][ver], usefile version blocks
can be used to work with different requirements on different platforms.

[ver]: /docs/lang/preprocessor/#version-blocks

The syntax is similar to version blocks in ooc. Here is an example from
[Paper Isaac](https://github.com/fasterthanlime/isaac-paper)'s usefile:

    #!ooc
    Name: isaac
    Version: 0.1
    Requires: dye, bleep, gnaar
    SourcePath: source
    Main: isaac

    version (windows) {
      Libs: ./isaac.res
    }

Compiling under windows, the linker command line will contain the additional file
`./isaac.res`.
