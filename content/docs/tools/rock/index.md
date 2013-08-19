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

 2. The [Drivers](/doc/tools/rock/drivers/) section gives an overview of rock's various
    drivers, akin to compiling strategies, like the sequence driver (default), the make
    driver, and the android driver.

 3. The [Advanced usage](/docs/tools/rock/advanced/) section covers some less-often used
    options like using a different C compiler, keeping source files, etc.

 4. The [Usefiles](/docs/tools/rock/usefiles/) section describes the format of `.use` files,
    which define the characteristics of an ooc app or library.