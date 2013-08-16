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

Special slot in the argument list, can only be at the end, purpose is to accept
any number of arguments.

### ooc varargs

Store the number of arguments, and the types of each argument. Syntax is as follows:

    #!ooc
    f: func (args: ...) {
      // body
    }

Access `args count` to know how many arguments were passed.
Use `args iterator()` to be able to iterate through the arguments:

    #!ooc
    printAll: func (things: ...) {
      "Printing %d things" printfln(things count)
      iter := things iterator()

      while (iter hasNext?()) {
        T := iter getNextType()
        "The next argument is a %s" printfln(T name)

        match T {
          case Int => "%d" printfln(iter next(Int))
          case Float => "%.2f" printfln(iter next(Float))
          case => "Unsupported type"
        }
      }
    }

More simply, `each` can be used on a `VarArgs`:

    #!ooc
    printAll: func (things: ...) {
      things each(|thing|
        match thing {
          case i: Int => "%d" printfln(i)
          case f: Float => "%.2f" printfln(f)
          case => "<unknown>"
        }
      )
    }

### C varargs

Used by writing simply `...` in the argument list, not `args: ...`:

    #!ooc
    f: func (firstArg: Type, ...) {
      // body
    }

Only accessible through `va_start`, `va_next`, `va_end`. See [Variadic
function][varia] on Wikipedia.

[varia]: http://en.wikipedia.org/wiki/Variadic_function

Useful only to relay a variable number of arguments to an extern C function,
since `va_arg` couldn't work (can't quote raw C types in ooc).

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

    #!ooc
    exit: extern func (exitCode: Int)

## By-ref parameters

Instead of having to dereference each time the parameter is accessed, just declare
it as a reference type:

    #!ooc
    increment: func (a: Int*) { a@ += 1 }
    // vs
    increment: func (a: Int@) { a += 1 }

Saves typing, saves error, clearer code. Can still access the address via `argument&`.

## Closures

A very concise way to pass a function as an argument. `each` is a typical
example:

    #!ooc
    // definition
    List: class <T> {
      each: func (f: Func (T)) { /* ... */ }
    }

    // usage
    list := List<Int> new()
    list each(|elem|
      // do something with elem, of type Int
    )

Also works with several parameters:

    #!ooc
    // definition
    Map: class <K, V> {
      each: func (f: Func (K, V)) { /* ... */ }
    }

    // usage
    map := Map<String, Horse> new()
    map each(|key, value|
      // key is of type String, value is of type Horse
    )

Argument types are inferred, hence, the code is very short.

