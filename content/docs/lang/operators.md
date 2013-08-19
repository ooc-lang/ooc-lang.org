---
title: Operators
has_toc: true
---

## Foreword

This lists all ooc operators, from highest precendence to lowest precedence

## Access

### Array access

The array-index operator is `[]`, the array-modify operator's short form is `[]=`

Examples:

    #!ooc
    arr[0] = '\n'
    return arr[0]

### Pointers

The address-of operator is a post-fix `&`, the dereference operator is a post-fix
`@`:

    #!ooc
    a := 42
    aPtr := a&
    aToo := aPtr@

### Call

Technically not an operator, but call is in that priority level:

    #!ooc
    a := func -> Int { 42 }
    a()

### Member access

Also technically not an operator. Simply two identifiers side by side,
not using dot, unlike some other programming languages:

    #!ooc
    dog name
    dog race

### Casting

The `as` operator is used to cast from one type to the other:

    #!ooc
    pi := 3.14
    roughlyPi := pi as Int

## Product

### Binary operators

The exponent operator is `**`, the multiplication operator is `*`,
and the division operator is `/`.

### Unary operators

Logical not is a prefixed `!`, binary not is a prefixed `~`.

## Sum

The addition operator is `+`, subtraction is `-`,
modulo is `%`

## Shift

Right shift is `>>`, left shift is `<<`

## Inequality

You have your regular less than `<`, greater than `>`,
less than or equal `<=`, more than or equal `>=`,
but also the comparison operator `<=>` (evaluates to -1
if less than, 0 if equal, 1 if greater than).

## Equality

Equality operator is `==`, inequality operator is `!=`

## Binary and boolean operations

Binary and is `&`, xor is `^`, or is `|`.

Logical and is `&&`, logical or is `||`.

## Ternary

The ternary operator is `?:` as in `condition ? ifTrue : ifFalse`.

## Assignment

The assignment operator is `=`, the following variants exist:
`+=`, `-=`, `*=`, `**=`, `/=`, `>>=`, `<<=`, `^=`, `|=`, `&=`.

The declare-assignment operator is `:=`

## Double arrow

The double arrow operator `=>` - it must be overloaded.

## Operator overloading

Overloading an operator can be done as a function-like, using the
`operator` keyword:

    #!ooc
    operator + (v1, v2: Vec2) -> Vec2 { v1 add(v2) }

However, if the operator is linked to a type, it's better to declare
it in the type itself, so that it'll be usable even if the module containing
the type declaration isn't explicitly imported:

    #!ooc
    Vec2: class {
      // other stuff

      operator + (v: This) -> This { add(this) }
    }
