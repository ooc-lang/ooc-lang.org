---
title: The threading package
has_toc: true
---

## The threading package

As far as concurrency goes, threads are usually lighter than processes,
but heavier than coroutines.

Programming with threads is subjecting yourself to preemptive multithreading,
which means any thread might give up control to another thread (e.g. be
pre-empted) at any time.

Threads also imply shared memory - a variable might be accessed by several
threads concurrently at the same time. Either seemingly, on single processor
machines, or actually in parallel, on multicore machines.

For that reason, threads have a reputation to be tricky - one has to be
careful what is accessed, from where, and when. To prevent the same data
being accessed by multiple threads, one can use a mutex - but those also
tend to open other cans of worms.

## Thread

The following section describes how to create threads, wait on them, and
how to wait for them to finish, or just for a little while. You'll also
learn how to check if a thread is still alive, and how to retrieve the
current thread.

### Creating, starting, and waiting

Creating a thread is as simple as calling `Thread new` and passing a closure -
the code that will get executed in the new thread.

    #!ooc
    import threading/Thread, os/Time

    thread := Thread new(||
      "Doing some long work..." println()
      Time sleepSec(2)
      "Done!" println()
    )

Start the thread with `start()`:

    #!ooc
    thread start()

And wait for it to finish with `wait()` (which will block until the
thread terminates):

    #!ooc
    "Waiting for thread to finish..." println() 
    thread wait()
    "All done!" println() 

### Check if a thread is still running

Instead of calling wait, one can poll for a thread's existence with
`alive?()`

    #!ooc
    "Waiting for thread to finish..." println()
    while (thread alive?()) {
      "Waiting..." println()
      Time sleepSec(1)
    }
    "All done!" println()

### Timed wait

And instead of polling to see if a thread is still a live, one can
wait for the thread to terminate for a certain maximum amount of time:

    #!ooc
    while (!thread wait(1.0)) {
      "Waiting..." println()
    }

This is pretty much equivalent to the `alive?()` version, except more
elegant.

### Retrieve the current thread

The current thread can be retrieved with `Thread currentThread()`:

    #!ooc
    thread := Thread currentThread()
    match (thread alive?()) {
      case true => "Good!"
      case => "Wait, what?"
    } println()

### Yielding to other threads

In some situations it might be useful to give a hint to the operating
system's scheduler, and let it know that the current thread is ready
to be preempted right now - and that the next thread in line can become
active now.

Typically, the following code will usually print `ABCABC`:

    #!ooc
    create: func -> Thread {
      Thread new(||
        for (letter in "ABC") {
          letter print()
        }
      )
    }

    (t1, t2) := (create(), create())
    t1 start(); t2 start()
    t1 wait(); t2 wait()

Whereas adding `Thread yield` in the for loop, like this:

    #!ooc
    create: func -> Thread {
      Thread new(||
        for (letter in "ABC") {
          letter print()
          Thread yield()
        }
      )
    }

Might produce something more along the lines of `AABBCC`. Then again,
the problem with preemptive multitasking is that it is impossible to
predict exactly what will happen, so seeing `AABCBC`, `ABABCC`, and even
`ABCABC` happen are not out of the question either.

## ThreadLocal

## Mutex

## RecursiveMutex

