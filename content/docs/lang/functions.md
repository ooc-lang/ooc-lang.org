---
title: Functions
has_toc: true
---

## Functions

A parameterized piece of code is often packaged into a function.

Here's an example function that adds two numbers:

    #!ooc
    add: func (a: Int, b: Int) -> Int {
      return a + b
    }

    add(1, 2)

The syntax for function signatures is `NAME: func (ARG1, ARG2, ...) -> RETURNTYPE`.
Both the argument definition list and the arrow return type parts are optional, in case
a function takes no argument, or returns nothing. Hence, the following definitions are
all perfectly equivalent:

    #!ooc
    f: func () -> Void {}
    f: func -> Void {}
    f: func () {}
    f: func {}

Arguments of the same type may be listed in short form: `name1, name2, name3: Type`.
Also, the `return` keyword is optional - it is only required to exit of the normal
function flow early. Hence, the first example can be rewritten like so:

    #!ooc
    add: func (a, b: Int) -> Int {
      a + b
    }

In the absence of a `return` keyword in the body of a non-void function, the last
expression will be returned. This works with ifs, matches, etc.

## Suffixes / overloading

Functions can have the same name, but different signatures (argument lists and
return type), as long as they have different suffixes. They can be called without
suffix, in which case the compiler will infer the right function to call, or
explicitly by specifying the suffix by hand:

    #!ooc
    add: func ~ints (a, b: Int) -> Int { a + b }
    add: func ~floats (a, b: Float) -> Float { a + b }

    add(1, 2) // calls ~ints variant
    add(3.14, 5.0) // calls ~floats variant
    add~floats(3, 5) // explicit call

## Variable arguments

### ooc varargs

    #!ooc
    f: func (args: ...) {
      // body
    }

Iterable, blah

### C varargs

    #!ooc
    f: func (firstArg: Type, ...) {
      // body
    }

Only accessible through `va_start`, `va_next`, `va_end`. See [Variadic function][varia] on Wikipedia.

[varia]: http://en.wikipedia.org/wiki/Variadic_function

Useful only to relay a variable number of arguments to an extern C function

Example:

    #!ooc
    vprintf: extern (s: CString, ...)

    printf: func (s: String, ...) -> This {
        list: VaList
        va_start(list, this)
        vprintf(s toCString(), list)
        va_end(list)
    }

## Extern functions

To call a function defined elsewhere, for example in a C library, its prototype
needs to be defined

    #!ooc
    exit: extern func (Int)

Lazy way: type-only args, thorough way: variable-decl-args.

## By-ref parameters

    #!ooc
    increment: func (a: Int*) { a@ += 1 }
    // vs
    increment: func (a: Int@) { a += 1 }

Saves typing, saves error, clearer code.

## Closures

ACS
