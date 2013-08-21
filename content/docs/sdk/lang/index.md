---
title: The lang package
has_toc: true
---

## The lang package

The lang package is considered built-in: it is imported by default in ooc
modules. There is a reason for that, however - the SDK is distributed as
an ooc library itself, and as such, it has a .use file that specifies which
modules should be imported.

Some of the lang package is essential, like `Object` and `Class`, which
means that the compiler, [rock][rock], will expect them to be present,
have certain names, fields and methods. However, using a custom sdk is
possible, where the implementation for these can be swapped to something
lighter, for example.

[rock]: /docs/tools/rock/

## Object / Class

The `Object` and `Class` classes are written in ooc.

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

### Void

`Void` is the type of nothing. A function that doesn't return anything
has a return type of `Void`, implicitly.

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

## String and Buffer

Those are documented separately: [String documentation][str].

[str]: /docs/sdk/lang/string/

## Iterators

Those are documented separately: [Iterators documentation][iter].

[iter]: /docs/sdk/lang/iterators/

## Exceptions

Those are documented separately: [Exception documentation][exceptions].

[exceptions]: /docs/sdk/lang/exceptions/

## Format

This is documented separately: [Format documentation][format].

[format]: /docs/sdk/lang/format/

