---
title: Coro
has_toc: true
---

## The os/Coro module

That module was originally an ooc port of Steve Dekorte's [libcoroutine][libco].

[libco]: https://github.com/stevedekorte/coroutine

Coroutines help achieve cooperative multi-tasking, as opposed to threads, which 
achieve preemptive multitasking. In cooperative multi-tasking, each task (or
'coroutine') is responsible for handing the control to another coroutine.

## Basic usage

First, we have to create a main coroutine:

    #!ooc
    import os/Coro

    mainCoro := Coro new()
    mainCoro initializeMainCoro

We can then create another coroutine, which we'll here use as a generator

    #!ooc
    letter: Char

    coro1 := Coro new()
    mainCoro startCoro(coro1, ||
        for (c in "LLAMACORE") {
            letter = c
            coro1 switchTo(mainCoro)
        }
        exit(0)
    )

Then we can retrieve those letters one by one:

    #!ooc
    while (true) {
        "%c" printfln(letter)
        mainCoro switchTo(coro1)
    }

This example is quite simple, just printing each letter that
`coro1` gives us on separate lines, but complex tasks can be
broken down in various coroutines and be achieved in a much
more lightweight fashion than threads or processes.


