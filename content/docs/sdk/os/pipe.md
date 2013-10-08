---
title: Pipe
has_toc: true
---

### The os/Pipe module

The Pipe module allows one to deal with pipes. Pipes are basically a pair of
read and write file descriptors.

The writer writes into the write file descriptor and the reader reads into the
read file descriptor.

A read call may either:

  * successfully read, if there's data in the pipe
  * block to wait for some more data (in blocking mode)
  * return immediately with no data (in non-blocking mode)

A write call may either:

  * return immediately if there's room in the pipe
  * block to wait for some data to be read, making room to write something

### Basic usage

Here's a not so useful pipe:

    #!ooc
    pipe := Pipe new()

We can write a string into it:

    #!ooc
    pipe write("Hello")

And then read the result back:

    #!ooc
    cstr := pipe read(128)
    cstr println()

Since pipes are kind of low-level, we get `CString` instance back from the read call.

We could have also read into our own buffer:

    #!ooc
    b := Buffer new(128)
    pipe read(b)
    b println()

Then, we shouldn't forget to close both the reading and the writing end:

    #!ooc

### Basic thread communication



