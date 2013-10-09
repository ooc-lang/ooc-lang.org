---
title: Dynlib
has_toc: true
---

## The os/Dynlib module

The `Dynlib` module allows one to load dynamic libraries on all
major platforms.

### Basic usage

Let's open a library:

    #!ooc
    import os/Dynlib

    lib := Dynlib load("libm")

We don't need to specify the `.so`, `.dynlib`, or `.dll` extension here, it is
set automatically by platform, although the original path will be tested first,
in case of non-standard file extension.

If the lib returned is null, it wasn't found or couldn't be opened:

    #!ooc
    if (!lib) {
        raise("Couldn't load library!")
    }

We can then retrieve a symbol:

    #!ooc
    cosAddr := lib symbol("cos")

And cast it to a more useful function. Since `Func` is actually
a function pointer and a context, we use a cover literal, passing
null for the context:

    #!ooc
    cos := (cosAddr, null) as Func (Double) -> Double

Which we can then use!

    #!ooc
    "cos(PI / 4) = %.3f" printfln(cos(3.14 * 0.25))

This prints `cos(PI / 4) = 0.707`, as expected.

When we're done with the library we can just close it:

    #!ooc
    lib close()

Note: on Windows, failing to close a library may lead to a
crash on application exit.

