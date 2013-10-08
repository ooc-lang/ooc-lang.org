---
title: Pipe
has_toc: true
---

## The os/Pipe module

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

## Basic usage

Here's a not so useful pipe:

    #!ooc
    pipe := Pipe new()

We can write a string into it:

    #!ooc
    pipe write("Hello")

And then read the result back:

    #!ooc
    str := pipe read(128)
    str println()

Even though we requested 128 bytes from the pipe, only 5 bytes have been written,
so we the call immediately returns with a String of size 5.

We could have also read into our own buffer:

    #!ooc
    b := Buffer new(128)
    pipe read(b)
    b println()

Same here, the buffer has 128 bytes capacity, but only 5 bytes have been read, and
the buffer's length has been set accordingly. Using a buffer is more efficient
because fewer allocations are being done.

Then, we shouldn't forget to close both the reading and the writing end of the pipe

    #!ooc
    pipe close('r')
    pipe close('w')

Or simply:

    #!ooc
    pipe close()

## Inter-thread communication

Pipes can be used to communicate between threads.

Let's create a pipe:

    #!ooc
    pipe := Pipe new()

Then a thread that is going to read out of it until it's closed:

    #!ooc
    reader := Thread new(||
        while (!pipe eof?()) {
            result := pipe read(128)
            if (result) result print()
        }
        pipe close('r')
    )

Then a writer path which is going to write ten hellos, one every 100
milliseconds:

    #!ooc
    writer := Thread new(||
        for (i in 0..10) {
            pipe write("Hello %d\n" format(i))
            Time sleepMilli(100)
        }
        pipe close('w')
    )

Let's start them both:

    #!ooc
    reader start(); writer start()
    reader wait();  writer wait()

## Inter-process communication

Similarly, pipes can be (and are mostly) used to communicate with other
processes. This is covered in the [Process][process] section.

[process]: /docs/sdk/os/process/

## Non-blocking I/O

A pipe can be set to non-blocking mode to use non-blocking read operations.
This is used in the streaming example in the [Process][process] section.

Let's create a pipe in non-blocking mode for reading only:

    #!ooc
    pipe := Pipe new()
    pipe setNonBlocking('r')

Then a state variable that'll be shared by both threads:

    #!ooc
    done := false

Then we'll make a writer thread that never closes the pipe itself (much like a
process launched in the background that you never blockingly wait on):

    #!ooc
    t := Thread new(||
      for (i in 0..10) {
        Time sleepSec(1)
        pipe write("Hello %d" format(i))
      }
      done = true
    )

    t start()

It does set done to true after it's done, though - much like you could know if
a background process is still running with `waitNoHang`.

Then we'll read, from the main thread, as much as we can, and when we don't receive
anything, we'll check if we're done:

    #!ooc
    while (true) {
      res := pipe read(128)
      if (res) {
        "Received: %s" printfln(res)
      } else if (done) break
    }

And let's not forget to clean up:

    #!ooc
    pipe close()
    t wait()

That behaves as expected. Note that in the main thread loop we could be doing anything
really, without blocking on the read.

## Pipes disclaimer

If you have read all the way down, and you're thinking of doing some complex
stuff with pipes, you probably want some queuing library instead of using raw
pipes, both for cross-platform support, performance, and ease of use.
[zeromq][zmq] is an interesting library and it has [ooc bindings][ooc-zeromq].

[zmq]: http://zeromq.org/
[ooc-zeromq]: https://github.com/nddrylliog/ooc-zeromq

