---
title: String
has_toc: true
---

## String

A string in ooc is a chain of bytes with no particular property.
In most cases, you'll want to deal with UTF-8 encoded strings.

The `String` type is the full-blown ooc String - it is a pascal
string in the sense that the length is stored with it. It is
backed by the `Buffer` type, which contains the actual bytes.

Buffers are mutable, whereas Strings are immutable. Therefore,
to build up a long String from several elements, using `Buffer`
is preferable.

### Basic usage

The size of a String can be retrieved through the `size` property.

    #!ooc
    "dumb luck" size == 9 // true

### Tests

`startsWith?` and `endsWith?` do exactly what they sound like.
`equals?` tests for equality, and is aliased to the `==` operator
and, for non-equality, the `!=` operator:

    #!ooc
    "moonlight" startsWith?("moon") // true
    "lightscape" endsWith?("scape") // true

    "moon" == "moon" // true
    "light" != "darkness" // true

### Indexing

One can retrieve the n-th byte with the array indexing operator, `[]`
and an integer value:

    #!ooc
    "abcdef"[2] // == 'c'

Note that the indexes are 0-based, like arrays.

To iterate through each byte of a String, a foreach can be used:

    #!ooc
    "Let's spell!" println()
    for (c in "violin") {
      "%c, " printfln(c)
    }

### Formatting and printing

The `format` method can be used to format a string with various
elements such as integers, floats, other strings, etc:

    #!ooc
    "%d" format(42) // == "42"
    "%.2f" format(3.1567) // == "3.16"
    "%s" format("Hi!") // == "Hi!"

The `print` method will print a string to the standard output.
Since it is so convenient to print a string followed by a newline,
`println` does exactly that. And since formatting is often used,
`printfln` does formatting, then print the result followed by a newline.

    #!ooc
    "Hello world!\n" print()
    // is equivalent to:
    "Hello world!" println()
    // itself equivalent to:
    "Hello %s!" printfln("world")

### Concatenation

One can use the `append` and `prepend` methods:

    #!ooc
    "light" prepend("moon") // == "moonlight"
    "storm" append("born") // == "stormborn"

Or simply, the `+` operator:

    #!ooc
    "not" + "with" + "standing" // == "notwithstanding"

### Finding and replacing

The `indexOf` method returns the index of a character or string inside
a string:

    #!ooc
    "abcdef" indexOf?('c') // 2

Using `replaceAll`, one can replace all instances of a String with
another String:

    #!ooc
    // yields "Brother | father | lover."
    "Brother, father, lover." replaceAll(",", " |")

### Slicing

The `substring` method allows one to get a slice of a String:

    #!ooc
    "observe" substring(2) // == "serve"
    "laminate" substring(2, 5) // == "min"

Alternatively, the array indexing operator, `[]`, can be used
with a range literal.

    #!ooc
    "observe"[2..-1] // == "serve"
    "laminate"[2..5] // == "min"

### Trimming

To get rid of extra whitespace, use the `trim` method, or its variants,
`trimLeft` and `trimRight`.

    "  Hi!  " trim() // = "Hi!"
    "  Hi!  " trimLeft() // = "Hi!  "
    "  Hi!  " trimRight() // = "  Hi!"

They also have versions that accept which characters to trim:

    "[Hola.]" trim() // = "[Hola.]"
    "[Hola.]" trim("[]()") // = "Hola."

## CString

While a pure ooc program will want to deal mostyl with `String`s,
when dealing with C functions, one will want to convert back and forth
with `toCString()`, which gives a `CString`, a cover of `char*`.

Conversely, converting a CString to a String can be done with `toString()`.

