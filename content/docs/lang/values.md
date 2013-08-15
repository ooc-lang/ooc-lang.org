---
title: Values
has_toc: true
---

## Values

Values are just a fancy term for data - in fact, most of what programs
do is to manipulate data, to compute numbers from other numbers, to process
strings, etc.

The type of nothing is `Void`, based on C's `void` type.

## Numbers

There are two classes of numbers built into the language. Integers, like `3`,
`-45` or `124_500`, and reals, like `3.14` or `-0.124_325_963`. Underscores
in number literals are ignored, thus they are purely cosmetic, allowing numbers
to be expressed in code in a more human-friendly way.

### Integer types

There are fixed-length integer types, like:

<table class="pretty">
<tbody>

<tr>
<td>ooc types</td>
<td>Width</td>
</tr>

<tr>
<td>Int8, UInt8</td>
<td>8</td>
</tr>

<tr>
<td>Int16, UInt16</td>
<td>16</td>
</tr>

<tr>
<td>Int32, UInt32</td>
<td>32</td>
</tr>

<tr>
<td>Int64, UInt64</td>
<td>64</td>
</tr>

</tbody>
</table>

And others, mapped on C types:

<table class="pretty">
<tbody>

<tr>
<td>ooc types</td>
<td>C types</td>
<td>Width</td>
</tr>

<tr>
<td>Char, UChar</td>
<td>signed char, unsigned char</td>
<td>8</td>
</tr>

<tr>
<td>Short, UShort</td>
<td>signed short, unsigned short</td>
<td>at least 16</td>
</tr>

<tr>
<td>Int, UInt</td>
<td>signed int, unsigned int</td>
<td>at least 16</td>
</tr>

<tr>
<td>Long, ULong</td>
<td>signed long, unsigned long</td>
<td>at least 32</td>
</tr>

<tr>
<td>LLong, ULLong</td>
<td>signed long long, unsigned long long</td>
<td>at least 32</td>
</tr>

</tbody>
</table>

There are several type of integer literals. Decimal literals are the most
common, but octal, hexadecimal, and binary literals exist as well, for
example:

    #!ooc
    75 // decimal
    0c113 // octal
    0x4b // hexadecimal
    0b1001011 // binary

### Floating point types

Similarly, real number types are based on C types:

<table class="pretty">
<tbody>

<tr>
<td>ooc types</td>
<td>C types</td>
<td>Width</td>
</tr>

<tr>
<td>Float</td>
<td>float</td>
<td>32</td>
</tr>

<tr>
<td>Double</td>
<td>double</td>
<td>64</td>
</tr>

<tr>
<td>Double</td>
<td>double</td>
<td>64</td>
</tr>

<tr>
<td>LDouble</td>
<td>long double</td>
<td>64, 80, 96</td>
</tr>

</tbody>
</table>

## Text

### Characters

A character in ooc is akin to a byte, it's not a Unicode character. A character literal
is enclosed in single quotes, and supports the following escape codes:

    #!ooc
    'a' // regular character
    '\\' // literal backslash
    '\'' // single quote
    '\n' // new line
    '\r' // carriage return
    '\b' // backspace
    '\t' // horizontal tab
    '\f' // form feed
    '\a' // alert (bell)
    '\v' // vertical tab
    '\nnn' // character with octal value nnn
    '\xhh' // character with hexadecimal value hh

Multi-character literals are syntax errors, e.g. `'abcd'` is invalid.

The ooc type `Char` is based on the C type `char`.

### Strings

There are two types of strings in ooc. `CString` is a cover from `Char*` and
is a vanilla C string, null-terminated. `String` is a class that contains a
length and may be implemented however the implementor chooses.

A string literal is enclosed in double quotes, gives an ooc `String`, and supports
the following escape codes:

    #!ooc
    "a" // regular character
    "\\" // literal backslash
    "\"" // double quote
    "\n" // new line
    "\r" // carriage return
    "\b" // backspace
    "\t" // horizontal tab
    "\f" // form feed
    "\a" // alert (bell)
    "\v" // vertical tab
    "\nnn" // character with octal value nnn
    "\xhh" // character with hexadecimal value hh

## Variables

A value can also be simply a variable declaration or a variable access, for example:

    #!ooc
    a := "Hello" // this evaluates to "Hello"
    a // so does this

The `:=` operator is the declare-assign operator. It creates a new variable slot, infers
its type from the right-hand-side value, and assigns the value to the variable. The same
code can be rewritten like so:

    #!ooc
    a: String = "Hello" // this evaluates to "Hello"
    a // this too

Or, in even longer form:

    #!ooc
    a: String
    a = "Hello" // this evaluates to "Hello"
    a // this too

The same applies inside a class declaration:

    #!ooc
    Dog: class {
      age := 23

      init: func {
        age // this evalutes to 23
      }
    }

    dog := Dog new()
    dog age // this evalutes to 23 as well

## Functions

Functions are values as well. For example:

    #!ooc
    Dog: class {
      bark: func { "Woof!" println() }
    }

    Dog bark // this is a value
    a := func { "Waf" println() } // this is a value as well
    a // and so is this

Functions are of type `Func`. Its syntax resembles a function definition.
For example, `Func (Int, Int) -> Int` is the type of a function that takes
two integers and returns an integer. Both the argument list and the return
type are optional.

## Pointers

Pointers are references to a region of memory. For example,

    #!ooc
    Dog: class {
      age := 23
    }

    dog := Dog new()
    age := dog age
    age = 23 // `dog age` is still 23

    agePtr := dog age&
    agePtr@ = 42 // `dog age` is now 42

Post-fixing with `&` takes the address of something. Post-fixing
with `@` returns the value a pointer points to.

The type of a pointer is `Type*` where Type is the underlying type, for
example, `Int*` is a pointer to an Int. To accept or return any kind of
pointer, the catch-all `Pointer` type can be used.

## References

References are a variant of pointers especially useful in functions.

Here's a `mul2` function with pointers:

    #!ooc
    mul2: func (var: Int*) {
      var@ *= 2
    }

    a := 12
    mul2(a&)
    a // now evalutes to 24

And here's the same with references:

    #!ooc
    mul2: func (var: Int@) {
      var *= 2
    }
    
    a := 12
    mul2(a&)
    a // now evalutes to 24

Notice that the function still neds to be called with a pointer, in this
case `a&`. This is so that the caller is aware that the variable being
passed might be modified by the function.

However, inside the body of a function using a by-reference parameter, there
is no need to dereference it (postfix it `@`) every time it is being accessed
or assigned.

## Covers vs Classes

Objects are references, like in Java. For example, the following:

    #!ooc
    Container: class {
      value := 19
    }

    modify: func (c: Container) {
      c value = 23
    }

    c := Container new()
    modify(c)
    c value // now evalutes to 23

However, covers are passed by value, see:

    #!ooc
    Container: cover {
      value: Int
    }

    modify: func (c: Container) {
      // woops, we're modifying a copy of the original
      c value = 23
    }

    c: Container
    c value = 19
    modify(c)
    c value // still evalutes to 19

The same applies inside methods of covers - by default,
they apply to a copy of the cover. To be able to modify
the content of a cover, use `func@` instead.

    #!ooc
    Container: cover {
      value: Int
      setValue: func@ (.value) {
        // since we're using `func@`, `this` is a reference
        this value = value
      }
    }

Hence, any cover constructor should be defined with `func@`,
like so:

    #!ooc
    Container: cover {
      value: Int
      init: func@ (=value)
    }

## Enums

By default, enums are backed by `Int`s. However, that's transparent.
A value from an enum will be of the type of the enum. See:

    #!ooc
    // defining a new type named 'State'
    State: enum {
      // .. with two possible values
      AWAKE
      ASLEEP
    }

    // currentState is of type 'State'
    currentState := State AWAKE

    // only accepts values of type 'State'
    isAsleep?: func (s: State) -> Bool {
      (s == State ASLEEP)
    }
    
