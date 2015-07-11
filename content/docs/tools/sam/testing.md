---
title: Testing
has_toc: true
---

## Concepts

Let me start off this section by admitting that testing in ooc is unfortunately
more painful than in many other languages, and hasn't been a big enough part of
the culture. As rock development progresses, its test suite improves, but it's
still ways off of where I (amos) would like it to be.

One of the reasons is that running a test involves a lot of steps. Parsing
the whole sdk and the test. Resolving all those. Generating C code. Compiling
it with a C compiler. And finally, running the executable. It's not uncommon
for an individual test to take around one second to run on a modern machine,
and that's obviously a hindrance.

To alleviate that, sam will precompile the SDK when running several tests
in sequence. This shaves a significant amount of time off the rock test
suite for example.

As for all its other features, sam makes some assumption about the structure
of your project:

    .
    ├── source
    │   └── foobar
    │       └── foo.ooc
    ├── test
    │   └── basic
    │       └── bar.ooc
    │       └── kux.ooc
    │   └── advanced
    │       └── barkux.ooc
    │       └── kuxbar.ooc
    └── foobar.use

When running:

    #!bash
    sam test

sam will look for a [.use file][use] in its usual way, then look for a `test` folder
next to the .use file, and try to run all tests contained in it, by walking the
file tree recursively.

[use]: /tools/rock/usefiles/

## Writing tests

Tests are simply ooc programs, that exit with code 0 on success, and code 1 on
failure. The simplest passing test is an empty file, and the simplest failing
test is:

    #!ooc
    exit(1)

Or:

    #!ooc
    main: func -> Int { 1 }

For tests that should fail to compile with a compile error from rock (there
are many of those in rock's test suite), the comment `//! shouldfail` is
recognized by sam. It inverts the outcome of the test: if the test compiles
successfully, it'll count as a failure, and vice versa. `shouldfail` tests
are never ran, even if they compile successfully.

`//! shouldcrash` is another special comment that lets sam know that the
test should compile correctly, but return a non-zero exit code (for example,
throw an ooc exception at runtime).

## sam-assert

sam ships with a basic assertion library, that contains both `describe`
(accepting a textual description of a particular test), and `expect`, that
compares given values with expected values and fails with a message if they
don't match.

A simple passing test with sam-assert looks like:

    #!ooc
    describe("42 should always equal 42", ||
      expect(42, 42) 
    )

A failing test with sam-assert looks like:

    #!ooc
    //! shouldfail

    describe("should always fail", ||
      expect(1, 0) 
    )

## Running specific tests

sam accepts a `--test` argument to specify a particular test .ooc file:

    #!bash
    sam test --test test/advanced/barkux.ooc

Or a folder, which it'll walk recursively:

    #!bash
    sam test --test test/advanced # runs both advanced/barkux and advanced/kuxbar

When running a single test, sam skips ooc precompilation, as it would be slower.

## Debugging sam

To find out exactly what commands sam are running, the `-v` (verbose) flag can
be used.

    #!bash
    sam test -v

## Passing arguments to rock

For all sam commands that run an instance of rock (check, test), the `--rockargs`
flag can be used.

    #!bash
    # let rock be very verbose and force usage of our own test lib
    sam test --rockargs=-vv,--use=foobar-assert

