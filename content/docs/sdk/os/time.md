---
title: Time
has_toc: true
---

## The os/Time module

The `Time` module allows for both time measurement and sleeping.

### Sleep

There are three granularities for sleep: second, milli, and microseconds.
Note that each system has different guarantees as to the actual clock
granularity, but the SDK will use the most precise method available.

    #!ooc
    // sleep for one second
    Time sleepSec(1) 

    // then for 12 milliseconds
    Time sleepMilli(12)

    // then for 300 microseconds
    Time sleepMicro(300)

### Date and time

`dateTime` will return the current time date and time formatted as a
human-readable string. The exact format might depend on the locale and
operating system.

    #!ooc
    "Today is: %s" printfln(Time dateTime())

`hour`, `min`, and `sec` return the current hour, minute, and second.

Executed at 12h34 and 56 seconds, the following will print 123456:

    #!ooc
    "%d%d%d" printfln(Time hour(), Time min(), Time sec())

`microtime` returns the microseconds that have elapsed in the current
minute, whereas `microsec` returns the microseconds that have elapsed
int he current second.

`runTime` returns the number of milliseconds elapsed since program start.

    #!ooc
    "Uptime: %d seconds." printfln(Time runTime() / 1_000)

### Measure

The `measure` function accepts a block and returns the number of milliseconds
spent elapsing it. It might be used as a poor humanoid's profiler:

    #!ooc
    duration := Time measure(||
        // some time-consuming task
    )
    "Huge task done in %d ms" printfln(duration)


