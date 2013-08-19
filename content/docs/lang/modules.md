---
title: Modules
has_toc: true
---

## Modules

Any `.ooc` file is a module. Modules are organized in packages, relative
to source path elements.

For example, for the following directory structure:

    source
    |-- czmq
    |   `-- extras
    |       `-- PipeSink.ooc
    `-- czmq.ooc

We have two modules, and their fully qualified names are `czmq` and `czmq/extras/PipeSink`.
We'll say that the `czmq` module is in the root package, and that the `PipeSink` module is
in the `czmq/extras` package.

### Import

The example modules above can be imported like this:

    #!ooc
    import czmq
    import czmq/extras/PipeSink

Or, on one single line:

    #!ooc
    import czmq, czmq/extras/PipeSink

Import paths can be relative, so when in the `czmq.ooc` module, one can import
with the full path, `czmq/extras/PipeSink`, or with the relative path, `extras/PipeSink`.

Similarly, inside PipeSink, one could import another extra via `../KitchenSink`

When importing several modules from the same package, one can use the multi-import
syntax:

    #!ooc
    import os/[Process, Terminal, Env]

## Non-modules

Other files may be involved in the compilation process, especially when using
C libraries. Dynamic libraries and header paths will typically be specified
in a [usefile][usefile], whereas C headers can be directly included in .ooc files

[usefile]: /docs/tools/rock/usefiles/

### Include

To include a standard header ssuch as `stdio.h`, one can do:

    #!ooc
    include stdio, stdlib

Note the absence of `.h`.

### Include with defines

Some C header files' behaviour vary depending on what's defined when including
them. For example, to use functions such as `GetSystemInfo` or `GetComputerNameEx`
from the Windows API, one needs to define a `_WIN32_WINNT` constant to be equal
or greater than `0x0500`.

The following syntax achieves exactly this:

    #!ooc
    include windows | (_WIN32_WINNT=0x0500)

### Relative include

It might also be useful to include a header file bundled with an ooc library.
Prefixing the path with `./` will do just that:

    #!ooc
    include ./stb-image

The header file will get copied in the output directory with the other
generated C files.

For a good example of relative import, and using additionals in [usefiles][usefile],
see the [ooc-stb-image][stbi] library.

[stbi]: https://github.com/nddrylliog/ooc-stb-image
