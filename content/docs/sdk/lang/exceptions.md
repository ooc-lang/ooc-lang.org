---
title: Exception
has_toc: true
---

## Exception

The `Exception` class is the super-type of anything that can be thrown
and caught.

There is no special keyword for throwing exceptions in ooc - instead, the
mechanism is implemented transparently thanks to the `throw()` method.

    #!ooc
    e := Exception new("Something bad happened")
    e throw()

### Message

A good exception will have a descriptive message. It can be accessed
via the `message` field of the `Exception` class.

    #!ooc
    try {
      attemptSomethingRisky()
    } catch (e: Exception) {
      "Something bad happened, and here's what: %s" printfln(e message)
    }

### Origin

It might be useful to know which class in particular has thrown an
exception. For this purpose, the `origin` field exists:

    #!ooc
    try {
    } catch (e: Exception) {
      "Something went wrong, and the culprit is: %s" \
        printfln(e origin ? e origin name : "unknown")
    }

To have a default representation of an exception, like it would be
printed as if there was no try block to catch it, use `formatMessage()`,
or, to print it, use `print()` directly.

### Backtrace

On platforms where it is implemented (currently, Linux with the "+-rdynamic"
compiler option), a series of backtrace can be available, containing info
about each stack frame leading up to the point the exception was thrown.

The backtrace can be printed with the `printBacktrace()` method. It'll get
printed in the default representation, for example if there is no particular
exception handler.

### Custom exceptions

To add a custom exception type, simply subclass `Exception` and provide
a constructor:

    #!ooc
    FunnyException: class extends Exception {
      init: func {
        super("Nothing happened, just thought it'd be fun to interrupt the program!")
      }
    }

