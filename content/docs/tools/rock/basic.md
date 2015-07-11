---
title: Basic rock usage
has_toc: true
---

## Using rock, the basic way

If you have a usefile, calling rock is pretty easy:

    #!bash
    rock

will look for usefiles in your current directory and, if possible, build them.

If it finds the wrong use file, you can specify it:

    #!bash
    rock mmorpg.use

Or you can directly specify an ooc file:

    #!bash
    rock source/mmorpg.ooc

Sadly, it's possible that rock thinks your ooc code is alright and passes the C files to your
C compiler which then prints pages of errors and explodes subsequently.
In that case, you'll need to increase rock's verbosity to see the compiler output:

    #!bash
    rock -v

Building an executable and tired of typing `./mmorpg` all over again?

    #!bash
    rock -r

will run your executable after having built it successfully.

To speed up the compilation process and to save you some time, rock caches compiled dependencies
in a hidden subdirectory called `.libs`. In most cases, this is awesome, but sometimes, something
goes wrong and you get pretty strange unexplainable error messages. Just to be sure, you can just

    #!bash
    rock -x

then, recompile and see if it works.
