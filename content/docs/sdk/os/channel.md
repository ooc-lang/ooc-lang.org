---
title: Channel
has_toc: true
---

## The os/Channel module

Channels are another way to think about data flow in the program.
Perhaps most famous in their Go implementation, 'goroutines', can
communicate via channels.

The `os/Channel` module contains a trivial implementation of channels
which may be used like so:

    #!ooc
    import os/Channel

By importing this module, a scheduler is set to run before the program
exits. Let's start by making a channel by which Ints can travel:

    #!ooc
    chan := make(Int)

Then let's make a data producer coroutine:

    #!ooc
    go(||
        for (i in 0..5) {
            chan << i
            yield()
        }
    )

And another one:

    #!ooc
    go(||
        for (i in 5..10) {
            chan << i
            yield()
        }
        chan << -1
    )

-1 will be used as a stopping signal here. `go` create a new
coroutine, and `chan << value` sends a value down a channel.
`yield` switches from the current coroutine back to the scheduler.

Let's now make a consumer channel:

    #!ooc
    go(||
        while (true) match (i := !chan) {
            case -1 => break
            case => "%d" printfln(i)
        }
    )

We're reading from the channel with the not operator: `!chan`

This will print 0, 5, 1, 6, 2, 7, 3, 8, 4, 9, and then exit, as
expected.

