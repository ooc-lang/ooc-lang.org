---
title: Generics
has_toc: true
---

## Generic functions

Since ooc is strongly typed, usually when definining a function,
it will only accept one type of argument:

    #!ooc
    printInt: func (value: Int) {
      value toString() println()
    }

But what if a function is meant to accept various types and react
accordingly? Generics can be used for that:

    #!ooc
    printAnything: func <T> (value: T) {
      value toString() println()
    }

Well, that's a step in the right direction. But it won't work, because
you can't call methods on generics types. Since `T` could be anything,
from a String to an array to an Int, we can't make sure it even has a
`toString` method.

What we can do is match on `T`:

    #!ooc
    printAnything: func <T> (value: T) {
      match T {
        case Int =>
          value as Int toString() println()
        case =>
          "<unknown>" println()
      }
    }

That's not very convenient - here's another way to write it:

    #!ooc
    printAnything: func <T> (value: T) {
      match value {
        case i: Int =>
          i toString()
        case =>
          "<unknown>"
      } println()
    }

### Inference

Notice how we didn't have to specify `T` when calling `printAnything`,
above? That's because the type of `T` is inferred. More complex inference
is supported as well:

    #!ooc
    map := HashMap<String, Int> new()
    map put("one", 1)
    printMap(map)

    printMap: func <K, V> (list: HashMap<K, V>) {
      // when called from above, K == String, and V == Int
    }

It works for closures as well:

    #!ooc
    import structs/[ArrayList, List]

    map: func <T, U> (list: List<T>, f: Func (T) -> U) -> List<U> {
      copy := ArrayList<U> new()
      for (elem in list) {
        copy add(f(elem))
      }
      copy
    }

    a := [1, 2, 3] as ArrayList<Int>
    b := map(a, |i| i toString())
    b join(", ") println()

Here, `U` is inferred from the return type of the closure.

## Generic classes

Above, we have used generic types, such as `ArrayList<T>` and
`HashMap<K, V>` - how can they be defined? Just like functions, by
putting generic type arguments in-between chevrons (`<Type1, Type2>`)
in the class definition:

    #!ooc
    Container: class <T> {
      t: T

      init: func (=t)
      get: func -> T { t }
      set: func (=t)
    }

    c := Container<Int> new(24)
    c set(12)
    c get() toString() println()

Note that inference works here too - since we are passing
a `T` to the constructor, the instanciation part could be
simply rewritten as:

    #!ooc
    c := Container new(24)

### Inheritance

Generic types can have subtypes:

    #!ooc
    ContainerToo: class <T> extends Container<T> {
      print: func {
        match t {
          case i: Int => i toString()
          case => "<unknown>"
        } print()
      }
    }

    c := ContainerToo new(24)
    c print()

### Specialization

Specialization happens when a sub-type has fewer type parameters
than its super-type:

    #!ooc
    IntContainer: class extends Container<Int> {
      print: func {
        get() toString() println()
      }
    }


