---
title: Preprocessor
has_toc: true
---

## Line continuations

Any line can be broken down on several lines, by using the backslash character, `\`,
as a line continuation:

    #!ooc
    someList \
    map(|el| Something new(el))

If it wasn't for that `\` before the end of the line, `map` would be interpreted as
a separate function call, and not a method call.

## Constants

Some constants are accessible anywhere and will be replaced at compile time with
strings. Those are:

  * `__BUILD_DATETIME__`
  * `__BUILD_TARGET__`
  * `__BUILD_ROCK_VERSION__`
  * `__BUILD_ROCK_CODENAME__`
  * `__BUILD_HOSTNAME__`

## Call chaining

While not technically a preprocessor feature, the following code:

    #!ooc
    a := ArrayList<Int> new(). add(1). add(2). add(3)

Is equivalent to:

    #!ooc
    a := ArrayList<Int> new()
    a add(1). add(2). add(3)

Itself equivalent to:

    #!ooc
    a := ArrayList<Int> new()
    a add(1)
    a add(2)
    a add(3)

