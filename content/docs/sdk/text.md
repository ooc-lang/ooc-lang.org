---
title: The text package
has_toc: true
---

## The text package

This package contains various helper classes to work with text
and JSON.

## EscapeSequence

This module contains a class `EscapeSequence` which defines some methods
to work with backslash escape sequences. In the real world, you probably
just need the two following methods:

`escape` takes a string and converts all special characters to escape sequences.
In this context, special characters are:

 * non-printable characters
 * single and double quotes
 * backslashes

Use it like this:

    #!ooc
    escaped := EscapeSequence escape("This is\na 'String'")
    // now, `escaped` looks like this:
    escaped == "This is \\n a \'String\'"

But that is only one half of the truth: You can additionally pass a
string of all characters that should not be escaped as the
second argument:

    #!ooc
    escaped := EscapeSequence escape("This is\na 'String'", "'\n")
    // The method did not escape anything now.
    escaped == "This is\na 'String'"

`unescape` is useful if you have a string containing escape sequences
and you need a string with these sequences converted to their real character
counterparts. This method supports one-character escape sequences like
"\n", "\r" or "\t", but also hexadecimal sequences like "\x34".
Usage is easy:

    #!ooc
    "\\x27\\x73up\\t\\x62ro\\n\\x3f" println()

which will print

    #!bash
    'sup	bro
    ?

### StringTokenizer

Sometimes, one needs to split a string at a special character and turn
it into an array. In ooc, the `text/StringTokenizer` module adds
every desirable variation of the good old `split` method to `Buffer` and `String`,
each returning an `ArrayList`:

    #!ooc
    import text/StringTokenizer

    // split at a specific character
    list := "A|simple and stupid|example" split('|')
    // split until a specific number of tokens is reached.
    // This will produce an ArrayList like
    //	["A", "simple and stupid|example"]
    list := "A|simple and stupid|example" split('|', 2)
    // The same for strings as delimiters, produces:

    list := ":-)A case :-)of intimidating:-)smiley abuse :-)"

