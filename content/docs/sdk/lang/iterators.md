---
title: Iterators
has_toc: true
---

## Iterators

Iterators are the magic that makes foreach loops work.

The basic premise is that to iterate through something, you have to
be able to know if there's anything left, via `hasNext?`, and to
retrieve the next element, via `next`.

As a bonus, for safe iteration, the `remove` method may be implemented.
If it isn't, though, it will return false.

Since iterators may iterate on all kinds of data structures, they are
generic, ie. `next` will return a T.

Here's a demonstration, iterating through characters of the word `hellfire`:

    #!ooc
    HellfireIterator: class extends Iterator<Char> {
        content := "hellfire"
        index := 0

        init: func

        hasNext?: func -> Bool {
          index < content size 
        }

        next: func -> Char {
          val := content[index]
          index += 1
          val
        }
    }

For a foreach to work, one has to have an iterable type. Thankfully,
an `Iterator` itself extends `Iterable`:

    #!ooc
    for (letter in HellfireIterator new()) {
      "%c" printfln(letter)
    }

### each and eachUntil

Apart from using foreach loops, one can use the each method:

    #!ooc
    HellfireIterator new() each(|letter|
      // do something with letter
    )

Or the eachUntil, which will break if the passed closure returns false:

    #!ooc
    HellfireIterator new() eachUntil(|letter|
      if (letter == 'f') {
        return false // just hell, please 
      }

      // do something with letter
      true
    )

### reduce

An iterable can be reduced using the `reduce` method, accepting a
closure. It'll get called on each pair of two elements, until there
is only one element left.

Example with a list of ints:

    #!ooc
    list := [1, 2, 3] as ArrayList<Int>
    sum := list reduce(|a, b| a + b)

### toList

Any `Iterable<T>` can be transformed to a `List<T>` via the `toList`
method. Let's try it on a string, which is iterable:

    #!ooc
    "ABC" toList() // gives ['A', 'B', 'C']

