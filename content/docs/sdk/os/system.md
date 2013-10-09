---
title: System
has_toc: true
---

## The os/System module

The `System` module allows to get information about the system, such
as the number of processors, as an `Int`:

    #!ooc
    cores := System numProcessors()

Or the hostname of the machine, as a `String`

    #!ooc
    hostname := System hostname()

