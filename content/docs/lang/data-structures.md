---
title: Data Structures
has_toc: true
---

## Foreword

The array situation in ooc is a bit delicate right now - while
I (Amos) am definitely not happy with it, I am still going to 
document the current state of things, if only as a motivation to
make it better.

## C arrays

### On the heap

C arrays are really just pointers:

    #!ooc
    tenInts := gc_malloc(10 * Int size) as Int*
    for (i in 0..10) {
      tenInts[i] = i
    }
    printInts(tenInts, 10)

    printInts: func (arr: Int*, length: Int) {
      for (i in 0..length) {
        "%d" printfln(arr[i])
      }
    }

### On the stack

Above, we are calling `gc_malloc` to allocate a block of GC-managed
memory on the heap. If for some reason a stack-allocated C array
is desirable, this syntax will work:

    #!ooc
    tenInts: Int[10]
    for (i in 0..10) {
      tenInts[i] = i
    }
    printInts(tenInts[0]&, 10)

    printInts: func (arr: Int*, length: Int) {
      for (i in 0..length) {
        "%d" printfln(arr[i])
      }
    }

## ooc arrays

ooc arrays are more convenient / safer than C arrays because they:

  * hold the length (number of elements)
  * do bounds checking when accessing / writing to them

The syntax is as follows:

    #!ooc
    tenInts := Int[10] new()
    for (i in 0..10) {
      tenInts[i] = i
    }
    printInts(tenInts)

    printInts: func (arr: Int[]) {
      for (i in 0..arr length) {
        "%d" printfln(arr[i])
      }
    }

## ArrayList

ArrayList is not technically part of the language - it is usually available in
the ooc SDK. Its advantages over ooc arrays are:

  * you can accept an `ArrayList<T>` for any `T`
  * you can query the `T` of an ArrayList (ie. match the type)
  * you can add and remove elements anywhere in the list
    (whereas arrays are fixed-length)

### Array-like usage

They can be used with array-like operators:

    #!ooc
    import structs/ArrayList

    tenInts := ArrayList<Int> new()
    for (i in 0..10) {
      tenInts add(i)
    }
    printInts(tenInts)

    printInts: func (list: ArrayList<Int>) {
      for (i in 0..list size) {
        "%d" printfln(list[i])
      }
    }

### Foreach usage

The `printInts` method above can be rewritten using a
foreach to iterate over the list's elements:

    #!ooc
    printInts: func (list: ArrayList<Int>) {
      for (i in list) {
        "%d" printfln(i)
      }
    }

### Iterator usage

Let's say we want to remove every odd number from the list.

Since we are modifying it while iterating through it, the best
device for that is an iterator:

    #!ooc
    removeOdds: func (list: ArrayList<Int>) {
      iter := list iterator()
      while (iter hasNext?()) {
        if (iter next() % 2 == 1) {
          // removes the element we just got.
          // NOTE: we are calling it on the iterator,
          // not on the list itself.
          iter remove()
        }
      }
    }

### Generics usage

Example usage of [generics][generics]:

[generics]: /docs/lang/generics/

    #!ooc
    import structs/ArrayList

    printList(ArrayList<Int> new())
    printList(ArrayList<String> new())

    printList: func <T> (list: ArrayList<T>) {
      "Got a list of %s" printfln(list T name)
    }

In this case, `list T` is just a [class][class].

[class]: /docs/lang/classes/#classes

### Literals

Simple array literals will give ooc arrays:

    #!ooc
    tenInts := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    printInts(tenInts)

    printInts: func (arr: Int[]) {
      for (i in 0..arr length) {
        "%d" printfln(arr[i])
      }
    }

Specifying the type the array literal is supposed to be allows
C array literals:

    #!ooc
    tenInts := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as Int*
    printInts(tenInts, 10)

    printInts: func (arr: Int*, length: Int) {
      for (i in 0..length) {
        "%d" printfln(arr[i])
      }
    }

In the same fashion, ArrayList literals exist:

    #!ooc
    import structs/ArrayList

    tenInts := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as ArrayList<Int>
    printInts(tenInts)

    printInts: func (list: ArrayList<Int>) {
      for (elem in list) {
        "%d" printfln(elem)
      }
    }

## Others

The ooc sdk is full of other data structures, such as `LinkedList`, 
`HashMap` (an dictionary associating keys and values), etc.

For more information, read up on the [structs package][structs].

[structs]: /docs/sdk/structs/
