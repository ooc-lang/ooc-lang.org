---
title: Covers
has_toc: true
---

## Covers

One selling point of ooc is that it makes it easy to use C libraries which
design is object-oriented. Covers are one way to do that.

## Struct-like covers

Covers are a by-value, lighter, lower-level alternative to classes.

    #!ooc
    Vec2: cover {
      x, y: Float

      norm: func -> Float {
        sqrt(x * x + y * y)
      }
    }

    v: Vec2
    v x = 1.5
    v y = 4
    "Norm = %.2f" printfln(v norm())

## Covers from

Covers from are based on an external, C type, and provide a way to access
members of the external type (if it's a struct), and to call methods on it -
either existing, external functions, or adding whole new methods.

For example:

    #!ooc
    Int: cover from int
    UInt8: cover from uint8_t
    LLong: cover from long long
    UInt: cover from unsigne int

## Members

Members can be declared extern, like functions - which means they are defined
somewhere else and need to be accessed from ooc code.

    #!ooc
    CpFloat: cover from cpFloat

    CpVect: cover from cpVect {
      x, y: extern CpFloat
    }

Members can be aliased by using the `extern(original_name)` function.

    #!ooc
    Rectangle: cover from bar_rectangle_t {
      width: extern(Width)
      height: extern(Height)
    }

## Methods

The `extern` function can be used to describe cover methods as well. Aliasing is
often good practice, as it allows to get rid of the unnecessary prefixes.

    #!ooc
    FooContext: cover from foo_context_t {
      // extern constructor
      new: static extern(foo_context_new) func (CString, Int) -> This

      // extern method
      doSomething: extern(foo_context_do_something) -> CString

      // additional method
      doSomethingTwice: func {
        doSomething()
        doSomething()
      }
    }

And so, a properly covered C struct with methods can be used as if it was an object:

    #!ooc
    context := FooContext new()
    context doSomething()

