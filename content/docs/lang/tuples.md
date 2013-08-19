---
title: Tuples
has_toc: true
---

## Tuples

Tuples are multiple values, comma-separated, inside a pair of
parenthesis. They don't exist as a value per se, and they don't
have a type - but they are useful for several things.

### Multi-return

It is possible to return multiple values from a function without
using an intermediary data structure.

    #!ooc
    findFile: func (pattern: String) -> (Bool, File) {
      if (found) {
        return (true, file)
      }

      // Didn't find it :/
      return (false, null)
    }

Using a function that returns a tuple can be done in several ways.

    #!ooc
    // get both values
    (found, file) := findFile("report_2013*.md")

    // only get the file
    (_, file) := findFile("report_2013*.md")

    // only want to know if it exists
    (found, _) := findFile("report_2013*.md")

    // this works too, takes the first value
    found := findFile("report_2013*.md")

### Multi-declaration

Tuple syntax can be used to declare multiple variables on the
same line:

    #!ooc
    (x, y) := (3.14, 1.52)

### Variable swap

Tuple syntax can also be used to swap two variables:

    #!ooc
    (x, y) = (y, x)

    // equivalent to
    tmp := x
    x = y
    y = tmp

### Cover literal

Tuple syntax can be used to conjure a cover out of thin air:

    #!ooc
    Vec2: cover {
      x, y: Float
    }

    v := (3.14, 1.52) as Vec2
    // v x = 3.14, v y = 1.52
