---
title: ShellUtils
has_toc: true
---

## The os/ShellUtils module

The entire purpose of the `ShellUtils` module is to find an
executable in the PATH environment variable.

It can be used to implement functionality usually found in the
*nix `which` command-line utility.

For example, to know where `autoconf` is hiding, one can do:

    #!ooc
    import os/ShellUtils
    file := ShellUtils findExecutable("autoconf")

If the executable is not found, `file` here will be null. Otherwise,
it'll correspond to the executable first found in the path:

    #!ooc
    match file {
        case null => "autoconf not found"
        case => "found: %s" format(file path)
    } println()

### Cross-platform

Adding the `.exe` suffix is not necessary on Windows - it'll be
added automatically on this platform when searching.

### Crucial

`findExecutable` can be made to throw an exception in case an
executable is not found, instead of returning null. For this, pass
`true` as its second argument:

    #!ooc
    // if we can't find make, don't even bother
    make := ShellUtils findExecutable("make", true)



