---
title: The structs package
has_toc: true
---

## The structs package

A few frequently used data structures ship with the SDK.

## Lists

`structs/List` contains the generic interface for lists, which are ordered, indexed
collections of elements of any type `T`.

    #!ooc
    list: List<String> = // something

Elements can be added to or removed from anywhere in the list

    #!ooc
    list add("hi") // append "hi" to the list
    list add(0, "hoe") // prepend "ho" to the list
    list remove("hi") // remove the first element equal to "hi"
    list removeAt(0) // remove the first element

    list addAll(otherList) // append all elements from other list

They can also be retrieved from anywhere in the list:

    #!ooc
    list get(24) == list[24] // get the 24th element
    list first() // get the first element
    list last() // get the last element

The number of elements in a list is available as the `size` property:

    #!ooc
    "There are %d elements in this list." printfln(list size)

Going through each element is easy as well, either using a foreach:

    #!ooc
    for (elem in list) {
      elem println()
    }

Or by passing a closure:

    #!ooc
    list each(|elem|
      elem println()
    )

Removing all elements can be done via `clear`:

    #!ooc
    list clear()



### ArrayList

An array list is backed by an array, which it grows or shrinks depending
on how many elements are in there.

Removing or adding an element in the middle of an ArrayList is expensive, as
it shifts all elements after it.

    #!ooc
    // constructed through successive add() calls:
    a1 := ArrayList<Int> new()
    a1 add(1); a1 add(2); a2 add(3)

    // constructed from an array literal
    a1 := [1, 2, 3] as ArrayList<Int>

An ArrayList can be easily converted to an array:

    #!ooc
    printArray(list toArray())

### LinkedList

A `LinkedList` is a doubly linked list, ie. each element points to the
element after it and the element before it.

Unlike the ArrayList, removing or adding an element in the middle of a linked list
is inexpensive.

## Maps

Maps are associative objects, ie. they associate keys to values.

### HashMap

The most oftenly used map collection is `structs/HashMap`. It can only associate
a given key to one value. E.g. there cannot be duplicate keys.

    #!ooc
    map := HashMap<String, Int> new()

Key->value pairs are added to a HashMap using `put`:

    #!ooc
    map put("one", 1)
    map put("two", 2)
    map put("three", 3)

..and retrieved using `get`. Key presence is tested with `containsKey?`:

    #!ooc
    map get("two") == 2 // true
    map containsKey?("two") // true

The whole point of a HashMap is that checking for presence or finding the
value corresponding to a key is faster than storing values in a list and
iterating through it entirely every time.

To remove pairs, one has to specify the key:

    #!ooc
    map remove("two")

A HashMap can be iterated through:

    #!ooc
    map each(|key, value|
      "%s => %s" printfln(key, value)
    )

It's possible to get a list of all keys contained in a map:

    #!ooc
    map getKeys()

Note that in a HashMap, iteration order is not guaranteed to be equivalent to
insertion order - due to the hashing done, keys might get reordered for efficiency.

### MultiMap

MultiMap is a HashMap variant that can contain multiple values for a given key.

### OrderedMultiMap

OrderedMultiMap is a MultiMap variant that will maintain the order in which keys
were inserted, for iteration.

## Bag variants

In the structures presenting above, all elements must have the same type in a given
collection. Bags are different: each element can be a different type.

### Cell

Actually defined in `lang/types`, Cell can contain anything:

    #!ooc
    intCell := Cell new(42)
    stringCell := Cell new("turtle")
    // and so on

Unwrapping a cell can be done via the indexing operator `[]`:

    #!ooc
    number := cell[Int]

Note that unwrapping a cell with an incompatible type will throw an error.

### Bag

Technically, a Bag can be seen as a list of cells, with convenience methods to
deal directly with the values contained inside the cells.

    #!ooc
    bag := Bag new()
    bag add(93) // add an Int
    bag add("seaside") // add a String
    bag add(bag) // add itself! the fun never ends.

To retrieve elements from a bag, one has to specify the type:

    #!ooc
    number := bag get(0, Int)
    title := bag get(1, String)
    // and so on

### HashBag

A HashBag maps string values to any type of value.

    #!ooc
    hash := HashBag new()
    hash put("number", 93)
    hash put("title", "seaside")
    hash put("ourselves", hash)

To retrieve elements from a `HashBag`, one has to specify both the string key
and the type:

    #!ooc
    number := hash get("number", Int)
    title := hash get("title", String)
    // etc.

HashBags are particularly useful to represent a tree-like document, that was originally
encoded as JSON or YAML, for example.

The `getPath` method allows one to retrieve an element of a tree of `HashBag`s and `Bag`s.

Let's say the original JSON looked like this:

    #!json
    "elements": {
      "house": {}
      "car": {
        "wheels": [
          { "diameter" => 2.23 }
        ]
      }
    }

One could use the following code to retrieve the diameter of the first wheel:

    #!ooc
    data: HashBag = // read from JSON
    diameter := data getPath("elements/car/wheels#0", Float)

## Stacks

Stacks are list-like data structures, except their primary purpose is to have elements
pushed on top of them and popped from the top, in a LIFO (last-in, first-out) fashion.

    #!ooc
    stack := Stack<Int> new()
    stack push(1). push(2). push(3)

    stack pop() == 3 // true
    stack pop() == 2 // also true
    stack pop() == 1 // left as an exercise to the reader

### Stick

The ill-named `Stick` data structure can be thought of as a bag stack - e.g. a Stack
that can contain any type of element.

Example usage:

    #!ooc
    stick := Stick new(Float size + Object size)
    stick push(1.23)
    stick push("Hi!")

    stick pop(String) == "Hi!" // true
    stick pop(Float) == 1.23 // truthful

`Stick` is quite low-level - it doesn't resize automatically, it does no
bounds checking, no type checking at all. To be used when you absolutely,
positively need to squeeze bytes together as close as possible and don't care
about safety at all.

