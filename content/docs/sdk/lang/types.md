---
title: Base types in the lang package
has_toc: true
---

## Base types in the lang package

Some types are useful enough that they are imported into every ooc
module out there. For example, `Object`, which is the default super type
of all objects.

Integer types, both fixed-width (`Int32`, `Int64`) and variable-width
(`Long`, `LLong`) are also in `lang/types`, along with the boolean type
`Bool`.

## Object / Class

The `Object` and `Class` classes are written in ooc itself, and not part
of some separate C runtime.

Anytime a type is referred to, you have something of type `Class`:

    #!ooc
    type := Int
    type name // "Int"
    type size // 4
    type instanceSize // 4

Actually, in this case, it's an instance of `IntClass`, as demonstrated
by this chunk of code:

    #!ooc
    type class name // "IntClass"

Even base types have classes, although they aren't available via the
`class` property, unlike objects.

    #!ooc
    dog := Dog new()
    dog class == Dog // true

    a := 42
    a class // invalid, not an object, it doesn't have fields

This is especially useful for generics, where classes are passed
along with actual arguments:

    #!ooc
    acceptAnything: func <T> (t: T) {
      T // is a subtype of Class, can access 'name', etc.
    }

### size vs instanceSize

For basic types such as Int, Float, Char - there is no difference between size
and instanceSize. For complex types, e.g. objects, there is a difference between
size and instanceSize.

For objects, `size` is always equal to the size of a pointer - since objects are
references. However, `instanceSize` is equal to the amount of memory an object
takes in memory.

For more information on the subject, read about [ooc classes][classes]

[classes]: /docs/lang/classes/

## Various types

### Bool

Booleans in ooc, equal to either the boolean literal `true`, or `false`,
are of type `Bool`.

    #!ooc
    b := true

### Void

`Void` is the type of nothing. A function that doesn't return anything
has a return type of `Void`, implicitly.

It is never used explicitly throughout the SDK, it is mostly there so
that compiler iternals work fine.

### Pointer

`Pointer` is the umbrella term for any type of pointer. When possible,
using a more precise type such as `Int*` is desirable.

### None

None can be used as an object representing nothing. It has a single
no-argument constructor:

    #!ooc
    nothing := None new()

It can be used in place of null when adopting a pattern-matching approach.

### Cell

Cell is documented in the [structs package][structs].

[structs]: /docs/sdk/structs/

## VarArgs

This is the sdk-side implementation of variable arguments. Basically,
it allows packing different values in the `VarArgs` structure with
`_addValue` - although the compiler will typically write those out
with a static initializer for efficiency.

They can be iterated through thanks to `VarArgsIterator`:

    #!ooc
    something: func (args: ...) {
      iter := args iterator()
      while (iter hasNext?()) {
        T := iter getNextType()
        match T {
          case Int =>
            value := iter next(Int)
            // do something with value
          case =>
            raise("Unsupported argument type: %s" format(T name))
        }
      }
    }

Or, more simply, with `each`:

    #!ooc
    something: func (args: ...) {
      args each(|arg|
        match arg {
          case value: Int =>
            // do something with value
          case =>
            raise("Unsupported argument type")
        }
      )
    }    

