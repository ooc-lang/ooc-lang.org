---
title: Troubleshooting
has_toc: true
---

## Stuck? Stranded on a desert island?

Chances are, this page might help. If you're actually on a desert island right now
you probably have better things to read though. However, if your problems are
ooc-related, read on - who knows, maybe it's a common problem.

## rock fails at ooc compilation stage

In most cases, rock gives a helpful error message, along with the exact location
of the problem (file name, line and column). When possible, the troublesome part
of your code is underlined.

Here's an example:

    #!text
    tests/trouble1.ooc:5:1 ERROR No such function display(String)
    display("Huhu")
    ~~~~~~~

In this case, the `display` function either:

  * Isn't defined anywhere
  * Is defined, but in another module that has not been imported
    in the current scope.
  * Is defined and in scope, but we are passing arguments of incompatible
    types, or too many or too few arguments.

Some errors are more cryptic. However, if it fails at the ooc stage, you're
still in a good place - those are usually easy to fix.

A few typical "ooc compilation stage" errors are listed below.

## Use not found in the ooc library path

An ooc library is missing, or can't be found by rock. Explanation: ooc libraries are
just folders with a .use file of a given name, and most often, a set of `.ooc` 
source files.

The recommended way to install ooc libraries is to set your `$OOC_LIBS` environment
variable to a folder of your choice, and clone/extract/copy the libraries you need
in there.

Tools like [sam](/tools/sam) can do that for you. Installing a library is as easy
as `sam clone curl`, but most of the time, you'll just want to run `sam get` to get
all the dependencies of the current project.

## ERROR Expected include, import, statement or declaration

This happens during the parsing stage. It is one of the most opaque errors you can
come across from rock - it usually means something is wrong with your syntax. Let us
take a look at one practical example:

    tests/syntax.ooc:2:2 ERROR Expected include, import, statement or declaration

    a: (b, c: Int) -> Int {
    ~
    [FAIL]

In this case, the code seems to be trying to define a function - however, the
`func` keyword is missing. As a result, rock's parser gets confused, and said it
encountered something it wasn't expecting.

While it is not smart enough to guess that you meant to declare a function, it
is still kind enough to indicate the place that needs fixing. In this case, simply
turning it into `a: func (b, c: Int) -> Int {` is enough.

Similar messages can be caused by syntax errors in other contexts. In this piece of
code:

    #!ooc
    match input {
        case % 2 == 0 => "even"
        case => "odd"
    }

...the case statement on the second line is incorrect. As is, it will prompt an error
that looks like:

    tests/syntax.ooc:4:9 ERROR Expected case in match
            case % 2 == 0 => even
            ~
    [FAIL]

A correct way to write it would be:

    #!ooc
    match (input % 2) {
      case 0 => "even"
      case => "odd"
    }

Or even:

    #!ooc
    match {
      case (input % 2 == 0) =>
        "even"
      case =>
        "odd"
    }

Although in that particular case, an if-else would probably do the job better.

## rock fails at C compilation stage

These are more delicate. To investigate the causes of a failure during the C
compilation phase (to be clear: that's when gcc, clang, or whatever C compiler
you are using is being launched on each ooc module), you should try to run
`rock -g -v -j0` (enable debug, verbose, compiles using only 1 thread).

When using `-g`, the source of the error indicated by the C compiler should
refer to the ooc file, like in this example:

    gcc -std=gnu99 -Wall -g -I.libs -D__OOC_USE_GC__ -DGC_NO_THREAD_REDIRECTS -I/Users/amos/Dev/rock/libs/headers/ -c rock_tmp/ooc/a/b.c -o .libs/ooc/a/b.o
    /Users/amos/Dev/tests/membe/a.ooc: In function ‘a_load’:
    /Users/amos/Dev/tests/membe/a.ooc:3: error: dereferencing pointer to incomplete type
    C compiler failed (got code 1), aborting compilation process
    [FAIL]
    
If working out the problem from the location in the .ooc file is not helpful
enough, you can use rock's `--nolines` command line option to get the location
of the error in the generated C file instead, for example:

    gcc -std=gnu99 -Wall -g -I.libs -D__OOC_USE_GC__ -DGC_NO_THREAD_REDIRECTS -I/Users/amos/Dev/rock/libs/headers/ -c rock_tmp/ooc/a/b.c -o .libs/ooc/a/b.o
    rock_tmp/ooc/a/a.c: In function ‘a_load’:
    rock_tmp/ooc/a/a.c:39: error: dereferencing pointer to incomplete type
    C compiler failed (got code 1), aborting compilation process
    [FAIL]

In this case, the offending line is:

    #!c
    lang_String__String_println(b__getC()->name);

Still, gcc errors are seldom self-explanatory. Using another compiler, such as clang,
could help. Adding the `--cc=clang` flag gives us (provided that we have clang installed
on the system, obviously):

    clang -std=gnu99 -Wall -g -I.libs -D__OOC_USE_GC__ -DGC_NO_THREAD_REDIRECTS -I/Users/amos/Dev/rock/libs/headers/ -c rock_tmp/ooc/a/b.c -o .libs/ooc/a/b.o
    rock_tmp/ooc/a/a.c:39:46: error: incomplete definition of type 'struct _c__C'
            lang_String__String_println(b__getC()->name);
                                        ~~~~~~~~~^
    .libs/ooc/a/c-fwd.h:7:8: note: forward declaration of 'struct _c__C'
    struct _c__C;
          ^
    1 error generated.
    C compiler failed (got code 1), aborting compilation process
    [FAIL]

Which is a little more helpful. Still, to learn more about that kind of errors and other
(hopefully not too) frequently encountered errors in the C compilation stage, read
the others section below

## gcc error: dereferencing pointer to incomplete type

The corresponding clang error is `error: incomplete definition of type 'struct something'`

This happens in the following scenario. You have a module, `a.ooc`, that accesses
some member of an object, like this:

    #!ooc
    import b

    getC() name println()

In module `b.ooc`, you have some way to access an object of type `C`:

    #!ooc
    import c

    getC: func -> C { C new("ohum") }

And in module `c.ooc`, you have the actual definition of type `C`:

    #!ooc
    C: class {
      name: String
      init: func (=name)
    }

In that particular case, due to implementation details, and for the time being,
it will result in a compilation error during the C phase. The fix is simply to
include module c from module a.

