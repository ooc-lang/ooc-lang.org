---
title: rock
has_toc: true
index: true
---

## About rock

rock is the main ooc compiler. It parses ooc files using nagaqueen, does some
checking and inference, produces .c files, and then drives the C compilation process
to produce either an executable or a library.

 1. The [Basic usage](/docs/tools/rock/basic/) section explains how to quickly get
    up and running, using rock to compile ooc projects.

 2. The [Drivers](/docs/tools/rock/drivers/) section gives an overview of rock's various
    drivers, akin to compiling strategies, like the sequence driver (default), the make
    driver, and the android driver.

 3. The [Advanced usage](/docs/tools/rock/advanced/) section covers some less-often used
    options like using a different C compiler, keeping source files, etc.

 4. The [Usefiles](/docs/tools/rock/usefiles/) section describes the format of `.use` files,
    which define the characteristics of an ooc app or library.

 5. The [Garbage Collection](/docs/tools/rock/gc/) section talks about the Garbage Collection
    strategy in rock, how to make sure things work well on different plaforms, how the
    Boehm GC is bundled, etc.

 6. The [Debugging](/docs/tools/rock/debug/) section talks about what to do when a program
    doesn't behave correctly. Debug symbols, stack traces, debugging on particularly painful
    platforms like Windows.

 7. The [Packaging](/docs/tools/rock/packaging/) section talks about releasing standalone
    applications coded in ooc, such as games — when you don't want to have users install
    dependencies on their own, but would rather bundle everything together.

