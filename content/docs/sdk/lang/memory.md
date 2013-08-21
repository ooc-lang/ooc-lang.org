---
title: Memory
has_toc: true
---

## Memory

Sometimes, you just have to handle memory yourself. None of that class
or cover stuff, just give me a raw block of memory any day.

You'll see the `gc_` prefix being used in the following page: that stands
for Garbage Collection, which is enabled by default in ooc. However, when
the GC is disabled, those will point to non-GC version of the functions.

So that your code remains flexible, do yourself a favor and use the `gc_`
variants regardless.

### Allocating memory

Use `gc_malloc` to get a chunk of memory all to yourself.

    #!ooc
    // get ourselves a slice of 4 bytes
    block := gc_malloc(4)

However, you'll get a `Pointer` back - which is a little bit pointless.
Plus you'll probably want to determine how much you are allocating as
a function of the size of some other type instead:

    #!ooc
    // get ourselves room to store 4 doubles.
    doubles := gc_malloc(4 * Double size) as Double*

That's better. Now you can index that, like any pointer:

    #!ooc
    doubles[0] = 3.14    
    doubles[1] = 6.28    
    // etc.

Pointer arithmetic works:

    #!ooc
    addressOfSecondDouble := doubles + 1

Then again, why not write it the explicit way:

    #!ooc
    addressOfSecondDouble := doubles[1]&

Note that `gc_malloc` returns zeroed memory (even when the GC is disabled),
just like the C function `calloc` does. While a small performance hit, a
little additional safety can't hurt.

### Allocating in bulks

`calloc` is typically used in C to get zeroed memory (e.g. all null bytes).
This is unnecessary in ooc, since `gc_malloc` returns zeroed memory anyway.

In the rare cases where you do mean to allocate `num` members of size `size`,
use `gc_calloc`:

    #!ooc
    members := gc_calloc(num, size)

### Re-allocating memory

Didn't get enough the first time around? Misjudged your budget needs?

Fear not, `gc_realloc` is here:

    #!ooc
    // get ourselves 4 bytes
    block := gc_malloc(4)

    // woops, make that 8
    block = gc_realloc(block, 8)

### Duplicating memory

In our family of memory-related functions, `gc_strdup`, nostalgically
named as if it was only used with strings, is here. It'll make a copy of
a block of memory so that the original may be disposed of.

    #!ooc
    someCallback: func (word: CString) {
      // CString is a pointer to a memory block that will get
      // overriden sometimes after this function returns - hence,
      // we want to make a copy so that the data we got doesn't
      // get tampered with.
      storeString(String new(gc_strdup(word)))
    }

The block of code above shows the typical use case, anyway.

### Freeing memory

Technically, since we are using a garbage collector, you don't need to
free explicitly. Should you feel the need to do so, however, `gc_free` is
here to do the job:

    #!ooc
    // you know what, I'm good for now, thanks.
    gc_free(block)

