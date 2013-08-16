---
title: Classes
has_toc: true
---

## Classes

Define classes with the `class` keyword:

    #!ooc
    Dog: class {
      name: String
      race: Race

      init: func (=name, =race)
      bark: func { "Woof!" println() }
    }

    dog := Dog new()

There are a few properties always available on classes. You can access the
class of anything via the `class` member. For example:

    #!ooc
    // will be equal to 'Dog'
    dog class name

    // since objects are reference, will be the size of a pointer
    dog class size

    // the actual size of a dog object, including members
    dog class instanceSize

The class hierarchy can also be accessed:

    #!ooc
    // in this case, the Object class - otherwise, whatever super class it has
    dog class super

    // evaluates to true
    dog instanceOf?(Dog)

    // also evaluates to true
    dog instanceOf?(Object)

    // evaluates to false
    dog instanceOf?(Cat)

The equivalent of `instanceOf?` called on classes, is `inheritsFrom?`

    #!ooc
    // true
    Dog inheritsFrom?(Dog)

    // true
    Dog inheritsFrom?(Object)

    // false
    Dog inheritsFrom?(Cat)

### Members

Members are variable declarations in the class body

    #!ooc
    Dog: class {
      name: String
    }

### Methods

Methods are function declarations in the class body. `this` is accessible
inside, and refers to the object the method is being called on. `This` refers
to the type being defined.

    #!ooc
    Dog: class {
      bark: func {
        "Woof!" println()
      }
    }

    dog := Dog new()
    dog bark()

Example usage of `this`

    Building: class {
      height: Int

      // argument name shadows member name
      setHeight: func (height: Int) {
        if (height < 0 || height > 300) return

        // using `this` explicitly to differenciate them
        this height = height
      }
    }

Example usage of `This`

    Engine: class {
      logger := Log getLogger(This name)
    }

## Static fields

### Members

### Methods

## Constructors

Define the `init` method (with a suffix to have different constructors), and
a `new` static method will get defined automatically.

    #!ooc
    Dog: class {
      name: String

      init: func (=name)
      init: func ~default { name = "Fido" }
    }
