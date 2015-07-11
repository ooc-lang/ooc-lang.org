---
title: Drivers
has_toc: true
---

## Compilation strategy

Unlike other compilers, rock takes care of building whole projects at
a time, not just single modules. However, how much you want to let up
to rock is your choice, thanks to different `drivers`, or compilation strategies.

## Sequence driver

This is the default driver. It'll parse all relevant .ooc files, generate
C files, and call the C compiler to produce object files, then link the result.

It can be customized using the following options:

### Parsing only

If you only want rock to make sure there are no syntax errors, using
the `--onlyparse` option will work.

### Checking only

If you want rock to parse and make sure that the code is correct ooc
(e.g. types correspond, all functions calls have corresponding definitions,
etc.), the `--onlycheck` option will do that.

### Generation only

If you just want rock to generate C files to look at what is being done
under the hood, the `--onlygen` option can be used. They will be output
in the `rock_tmp` (for .c files) and `.libs` (for header files) folders by default.

If the goal is to tinker with the 

### Parallelism

By default, rock will attempt to max out your processors by launching C
compiler jobs in parallel. One can adjust the level of parallelism by
specifying `-jN` to rock, where `N` is an int. To completely disable
parallelism (ie. behave in a purely sequential way), pass `-j0`.

### Lib-caching

Lib-caching is very convenient, yet at the same time it can cause unforeseen
issues. The basic idea is that, between two compilations, only a portion of
generated C code is affected by the changes, there is no reason to recompile
what hasn't changed.

It is active by default, which means that even though the first compilation
might take some time, subsequent compilations will be shorter. If a compilation
seems to fail because of the remainder of previous compilations, running `rock -x`
should fix it up.

To temporarily disable lib-caching, one can use the `--nolibcache` compiler
option.

## Make driver

The make driver is particularly useful when an ooc project is to be compiled
on another platform lacking the ooc toolchain (for example, when bootstrapping
rock), or when one wants to modify the C output of rock and recompile afterwards.

By using `--driver=make`, the compile process looks something like this:

    #!bash
    # In project directory
    rock --driver=make
    cd build/
    make

The `build` directory which is generated and populated with C files and a
stand-alone Makefile, can be packaged and distributed on other platforms.

Note that the `$GC_PATH` environment variable might need to be adjusted for
the exported sources to build somewhere else. It could be as simple as
installing the Boehm GC in `/usr` and setting `GC_PATH` to `-lgc`.

One can use `make clean` to clean the produced objects and binaries. Modifying
sources and partial recompilation is possible. Make accepts parallelism options
similar to rock, e.g. with 8 cores, one might want to use `make -j7`.

## CMake driver

The CMake driver is similar to the make driver but generates a `CMakeLists.txt`
file instead. The process looks like:

    #!bash
    # In project directory
    rock --driver=cmake
    cd build/
    cmake .
    make

Note that CMake is itself a build file generator. In the example above we're
using the default `Makefile` output of CMake, but it could be used to generate
Visual Studio project files, XCode project files, etc.

## Android driver

In spirit, the Android driver (invoked with `--driver=android`) is similar to
the make driver, excepts that instead of generating Makefiles, it will generate
`Android.mk` files, suitable for usage with the `ndk-build` utility from the
Android NDK toolchain.


