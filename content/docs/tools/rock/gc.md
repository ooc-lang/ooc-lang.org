---
title: Garbage Collection
has_toc: true
---

## Garbage Collection in rock

rock uses the [Boehm GC][boehm]. It is a conservative garbage collector that
tends to play well with C libraries, hence the choice for a "compile-to-C"
implementation of ooc.

[boehm]: http://www.hpl.hp.com/personal/Hans_Boehm/gc/

### Distribution

The Boehm GC (along with `lib_atomic_ops`) is vendored in rock's repository,
under `libs/`. When building the compiler, rock's Makefile will check for an
installed GC version and, if absent, it will compile its own.

Depending on your platform, the static version of the library compiled when
building rock might be in the following places:

    * Linux: `rock/libs/linux32` or `rock/libs/linux64`, as `libgc.a`
    * OSX: `rock/libs/osx`
    * Windows: `rock/libs/win32`

By default, rock links statically with the GC. However, for multithreaded
applications on Windows, that might not be such a good idea. Read on for
more details.

### Threads

On Windows, for the GC to work correctly, it has to be linked dynamically,
not statically. At some point, rock should handle that case itself, but for
now here's what you have to do.

The first step is to build your own copy of the GC. Thanks to [winbrew][brew],
that is as easy as doing `brew install bdw-gc`.

[brew]: https://github.com/nddrylliog/winbrew

You should now have Boehm-GC-related files in both `/usr/local/lib` and 
`/usr/local/bin` (`/usr/local` being mapped to a Windows path like `C:\MinGW\msys\1.0\local`).

To make rock use that version, simply do:

    rock --gc=dynamic -I/usr/local/include -L/usr/local/lib

...and when distributing applications, include `libgc-1.dll` with it. See the [Packaging][pack]
chapter for more details.

[pack]: /docs/tools/rock/packaging/

Linking dynamically with the GC on other platforms is as simple as using `--gc=dynamic` - the
`-I` and `-L` options above are just to add include paths and library paths, since homebrew installs
libraries in its own prefix.

### Disabling the GC

One can prevent rock from linking with the GC with the command line option `--gc=off`. Keep in mind
that the SDK was written with the GC in mind though.

When the GC is disabled, `version(gc)` block will get discarded, and `version(!gc)` blocks will be
used. You can use this to write both GC and non-GC friendly code.

