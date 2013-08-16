---
title: Enums
has_toc: true
---

## Enums

A set of values that a variable of that type can take. Useful when there are
three values or more, so a `Bool` doesn't make sense.

    #!ooc
    DoorState: enum {
      OPEN
      CLOSED
      UNKNOWN
    }

One can think of enum values as static members. Enums have their own types.

    #!ooc
    state: DoorState
    state = DoorState OPEN

    // or, simply
    state := DoorState OPEN

    match state {
      case DoorState OPEN =>
        "It's open!"
      case DoorState CLOSED =>
        "It's closed."
      case => "Who knows..."
    } println()

More example code:

    #!ooc
    isOpen?: func (state: DoorState) -> Bool {
      state == DoorState OPEN
    }

### Members

Enums can't have members - they are just values without any added metadata.

### Methods

Enums, however, can have methods:

    #!ooc
    DoorState: enum {
      OPEN
      CLOSED
      UNKNOWN

      chance: func -> Float {
        match this {
          case This OPEN => 1.0
          case This CLOSED => 0.0
          case => 0.5
        }
      }

      random: static func -> Float {
        Random randInt(0, 3) as This
      }
    }

They can be used like regular objects:

    #!ooc
    state := DoorState random()

    "Generated a random door." println()
    "Chance we're passing through = %.2f" printfln(state chance())

## Backing type

By defaults, enums are backed by ints. That's why they can be cast to
`Int`, and vice versa.

### Custom values

Custom values are specified with the assignment operator:

    #!ooc
    Number: enum {
      ONE
      TWO
      FOUR = 4
      FIVE
    }

Values are computed like this:

  * the first value is `increment(0)` if unspecified
  * every value after that is `increment(previousValue)`
  * by default, the increment is `+1`

Read below for more on increments

### Custom increment

Custom increments can be specified after the `enum` keyword:

    #!ooc
    Odds: enum (+2) {
      ONE = 1
      THREE
      FIVE
      SEVEN
      NINE
    }

Multiplication increments are valid as well:

    #!ooc
    Powers: enum (*2) {
      ONE = 1
      TWO
      FOUR
      EIGHT
      SIXTEEN
    }

And multiplication increments are actually quite handy for things like bitsets.

## Extern enums

Enums can be extern, in which case every element will be a bare symbol, which should
be defined externally, in C code for example:

    #!ooc
    ShutdownParam: extern enum {
      SHUT_RD    // generate C name SHUT_RD
      SHUT_WR    // generate C name SHUT_WR
      SHUT_RDWR  // generate C name SHUT_RDWR
    }

Or, each element can be aliased individually:

    #!ooc
    ShutdownParam: extern enum {
      extern(SHUT_RD) read
      extern(SHUT_WR) write
      extern(SHUT_RDWR) readWrite
    }

