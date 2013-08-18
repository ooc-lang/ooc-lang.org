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

    #!ooc
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

    #!ooc
    Engine: class {
      logger := Log getLogger(This name)
    }

## Static fields

### Members

Static fields belong to a class, rather than to an instance.

    #!ooc
    Node: class {
      count: static Int = 0

      init: func {
        This count += 1
      }
    }

    for (i in 0..10) {
      Node new()
    }
    "Number of nodes: %d" printfln(Node count)

Static fields can also be accessed without explicitly referring to `This`.
The declare-assignment operator, `:=`, also works with the `static` keyword before
the right-hand-side value:

    #!ooc
    Node: class {
      count := static 0

      init: func {
        count += 1
      }
    }

    // etc.

### Methods

Static methods also belong to a class:

    #!ooc
    Map: class {
      tiles := Map<Tile> new()

      generate: static func (width, height: Int) -> This {
        m := This new()
        for (y in 0..height) for (x in 0..width) {
          m addTile(x, y)
        }
        m
      }

      addTile: func (x, y: Int) { /* ... */ }
    }

## Constructors

Define the `init` method (with a suffix to have different constructors), and
a `new` static method will get defined automatically.

    #!ooc
    Dog: class {
      name: String

      init: func (=name)
      init: func ~default { name = "Fido" }
    }

For alternative instanciation strategies, defining a custom, static `new`
method, returning an instance of type `This`, works just as well:

    #!ooc
    Dog: class {
      pool := static Stack<This> new()

      new: static func -> This {
        if (pool empty?()) {
          obj := This alloc()
          obj __defaults__()
          obj
        } else {
          pool pop()
        }
      }

      free: func {
        pool push(this)
      }
    }

## Inheritance

### Extends

Simple inheritance is achieved through the `extends` keyword:

    #!ooc
    Animal: class {}
    Dog: class extends Animal {}

### Super methods

Calling `super` will call the definition of a method in the super-class.

    #!ooc
    SimpleApp: class {
      init: func {
        loadConfig()
      }

      // ...
    }

    NetworkedApp: class extends SimpleApp {
      init: func {
        super()
        initNetworking()
      }
    }

## Properties

Instead of plain, simple members, one can also define properties
for classes - that is, `virtual` members that exist as read-only,
write-only, or read-write behind getters and setters.

    #!ooc
    Person: class {
      lastName, firstName: String

      fullName: String {
        get {
          "%s %s" format(lastName, firstName)
        }
      }
    }

