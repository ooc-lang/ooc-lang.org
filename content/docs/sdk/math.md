---
title: The math package
has_toc: true
---

## The math package

The math package piggybacks on libc for basic mathematical operations with
standard integer and floating point types.

## math

By simply importing `math`, a most of the math functions from libc will get
imported.

Often, math operations are available both in function form and in method form.
The function form would be similar to C, e.g.:

    #!ooc
    sin(2 * PI)

Whereas the method form would be more.. object-oriented-ish:

    #!ooc
    2 pow(16)

### Powers and roots

`pow` elevates the first argument to the power of the second:

    #!ooc
    2 pow(8) // 256

`exp` returns the value of e (the base of natural logarithms) raised to the
power of x:

    #!ooc
    exp(2) // approx. 7.389

`sqrt` returns the square root of a number:

    #!ooc
    144 sqrt() // 12

`cbrt` returns the cube root of a number:

    #!ooc
    8 cbrt() // 2

### Trigonometry

`PI` is a constant defined in math as:

    #!ooc
    PI := 3.14159_26535_89793_23846_26433_83279

`sin`, `cos`, and `tan`, are available, both in method and function form:

    #!ooc
    sin(2 * PI) // 0
    cos(- (3 / 4) * PI) // -0.707, etc.
    tan(PI / 4) // 1

As are their arc equivalents, `asin`, `acos`, `atan`, their hyperbolic
variants, `sinh`, `cosh`, `tanh`, and their arc hyperbolic tandems,
`asinh`, `acosh`, `atanh`.

As for `atan2`, straight from Wikipedia:

    In a variety of computer languages, the function atan2 is the arctangent
    function with two arguments. The purpose of using two arguments instead of
    one, is to gather information of the signs of the inputs in order to return
    the appropriate quadrant of the computed angle, which is not possible for
    the single-argument arctangent function.
    
    For any real number (e.g., floating point) arguments x and y not both equal
    to zero, atan2(y, x) is the angle in radians between the positive x-axis of
    a plane and the point given by the coordinates (x, y) on it. The angle is
    positive for counter-clockwise angles (upper half-plane, y > 0), and
    negative for clockwise angles (lower half-plane, y < 0).

Source: <http://en.wikipedia.org/wiki/Atan2>

### Logarithms

The `log` function returns the natural logarithm of x:

    #!ooc
    log(2) // about 0.69

The `log10` function returns the base 10 logarithm of x:

    #!ooc
    log10(4000) // about 3.6

### Rounding and truncation

The `round`, `roundLong` and `roundLLong` are methods that will round to the
nearest integer:

    3.14 round() // 3.00
    4.78 roundLong() // 5
    0.92 roundLLong() // 1

The `ceil` and `floor` methods will round to the nearest upper and lower
integer, respectively:

    3.14 ceil() // 4.00
    8.92 floor() // 8.00

### Floating-point remainder

The `mod` function computes the floating-point remainder of dividing x by y.
The return value is x - n * y, where n is the quotient of x / y, rounded toward
zero to an integer.

    12 mod(5) // 2

### Various

To get the absolute value of a number, use `abs()`:

    #!ooc
    (-4) abs() // 4

## Random

By importing `math/Random`, one can generate random numbers.

**Disclaimer: neither the libc random number generator or the fast prng
exposed by math/Random are suitable for cryptographic usage. Find a library
that does it right, this was not planned for it.**

When the module is loaded (probably at program start-up), the libc random
number generator will be seeded with the current time in microseconds.

Then, various functions can be used to get random numbers.

### libc generator

To get any number between `INT_MIN` and `INT_MAX`, call:

    #!ooc
    number := Random random()

To get any number within a range, use either:

    #!ooc
    // gives a number between 0 (included) and 10 (included)
    number := Random randInt(0, 10)

    // gives a number between 0 (included) and 9 (included)
    number = Random randRange(0, 10)

Those both have variants to get a number in a range, excluding any
number already contained in a list:

    #!ooc
    // get 10 unique numbers between 0 and 100
    list := ArrayList<Int> new()

    10 times(||
        list add(Random randInt(0, 100, list))
    )

To pick out a random element ouf ot a list, use `choice`:

    #!ooc
    // get one of those 10 unique numbers we just generated:
    num := Random choice(list)

Note that `choice` is generic, so it will work with lists of any
type of element.

### fast prng

Most of the methods above have a `fast` variant, working from a PRNG ([pseudorandom
number generator][prng-wiki]) coded directly into the Random class.

[prng-wiki]: http://en.wikipedia.org/wiki/Pseudorandom_number_generator

    #!ooc
    // all these are documented above, they work in a similar fashion
    Random fastRandom()

    Random fastRandInt(0, 10)
    Random fastRandRange(0, 10)

    Random fastRandInt(0, 10, list)
    Random fastRandRange(0, 10, list)

    Random fastChoice(list)

The `fast` variants are meant to be faster, as the name implies, but they're even
less guaranteed to have good random qualities - the numbers it generates might be
less even / repeat more easily.


