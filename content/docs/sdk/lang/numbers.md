---
title: Numbers
has_toc: true
---

## Numbers

Numbers come in various shapes and forms. There is no bignum implementation
in ooc's sdk - which means that you are pretty much stuck with C's types,
either varying width (Int, Long, LLong) or fixed-width (Int16, UInt32, Int64,
etc.)

However, they share common methods that come in handy from time to time.
This page summarizes these methods.

## Integers

### String representation

Calling `toString()` will return a default, decimal representation of an
integer.  The `toHexString()` method returns a base 16 representation.

    #!ooc
    0c24222570 toString() // "5318008"
    3_735_928_559 toHexString() // "deadbeef"

### Divisors

Test if a number is odd with `odd?()`, if it's even with `even?()`.

    #!ooc
    3 odd?() // true
    3 even?() // false

Also, to check if a number b is a divisor of a number a, use `divisor?()`

    #!ooc
    9 divisor?(3) // true

Don't use this naive prime algorithm:

    #!ooc
    n := 40_960_001
    for (i in 0..n) if (n divisor?(i)) {
      raise("Not a prime.")
    }
    "Alright, it's a prime." println()

Find something smarter instead.

### Range inclusion

To test if a number is within a range, use `in?(Range)`:

    #!ooc
    9 in?(0..10) // true
    3 in?(5..15) // false

### Absolute value

Use the `abs()` to get the a positive value no matter what:

    #!ooc
    9 abs()  // 9
    -9 abs() // 9

### Times

While not technically number-related, repeating an action `n` times
can be done with the `times` method:

    #!ooc
    3 times(|| knock())

Alternatively, the closure can take the current (0-based) index as an argument

    #!ooc
    99 times(|i|
      takeDownBottle(i)
    )

## Floats

### String representation

Calling `toString()` will return a default, base 10 representation of a
floating point number, with a precision of 2 after the decimal point.

    #!ooc
    3.14 toString() // "3.14", conveniently

