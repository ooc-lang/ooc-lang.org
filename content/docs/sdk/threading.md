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

By default, global variables are shared among all threads. To make a global
that is specific to each thread, use ThreadLocal:

    #!ooc
    val := ThreadLocal<Int> new(42)

    threads := ArrayList<Thread> new()
    for (i in 1..3) {
        threads add(Thread new(||
            val set(i) 
        ))
    }

    for (t in threads) t start()
    for (t in threads) t wait()

    // prints val = 42
    "val = %d" printfln(val get())

In this case, val is initialized from the main application thread, then set by
three other OS threads, and yet the value is still 42 at the end of the program,
in the main thread.

Inside each of these threads, though, the value is still 1 and 2 respectively.

## Mutex

A mutex allows to control access to resources that are shared between threads,
to avoid two threads modifying the same resource, which could potentially result
in invalid state.

    #!ooc
    counter := 0

    threads := ArrayList<Thread> new()
    for (i in 0..10) {
        threads add(Thread new(||
            for (i in 0..1000) {
                counter += 1   
                Thread yield()
            }
        ))
    }

    for (t in threads) t start()
    for (t in threads) t wait()

    // prints counter = ???
    "counter = %d" printfln(counter)

The code above has a problem - many threads may access the counter at the same time,
hence the resulting counter value isn't reliably 10000. In actual testing, it gave
values sucha s 7064, 6111, 5986, etc.

This happens because a thread might be reading the value of counter, then another
thread runs and increments it, then the thread who read the value sets the counter
to the value it reads plus one, resulting in "lost iterations".

To alleviate that problem, we can use a mutex:

    #!ooc
    counter := 0

    mutex := Mutex new()

    threads := ArrayList<Thread> new()
    for (i in 0..10) {
        threads add(Thread new(||
            for (i in 0..1000) {
                mutex lock()
                counter += 1   
                mutex unlock()
                Thread yield()
            }
        ))
    }

    for (t in threads) t start()
    for (t in threads) t wait()

    // prints counter = ???
    "counter = %d" printfln(counter)

Here, we have protected the counter incrementation with `mutex lock()` and
`mutex unlock()` calls. This is known as a critical section. In there, only one
thread can execute at a time - the other threads will block on the `lock` call,
waiting to be able to acquire it exclusively.

Instead of using `lock` and `unlock` by hand, one might want to use the `with`
method, that takes a block:

    #!ooc
    for (i in 0..1000) {
        mutex with(||
            counter += 1
        )
    }

With any of these last two versions, the counter is reliably set to 10000
at the end of every run.

For more information about this problem, read the [Mutual exclusion][mutuwiki]
Wikipedia page.

[mutuwiki]: http://en.wikipedia.org/wiki/Mutual_exclusion

## RecursiveMutex

With a regular mutex, locking multiple times from the same thread results in
undefined behaviour on some platforms (e.g. pthreads).

A recursive mutex, on the other hand, can be locked multiple times, as long
as it's unlocked a corresponding number of times, all by the same thread.

A trivial (non-useful) test might look like:

    #!ooc
    threads := ArrayList<Thread> new()

    mutex := RecursiveMutex new()
    counter := 0

    for (i in 0..42) {
        threads add(Thread new(||
            for (i in 0..10) mutex lock()
            counter += 1
            for (i in 0..10) mutex unlock()
        ))
    }

    for (t in threads) t start()
    for (t in threads) t wait()

    // prints counter = 42
    "counter = %d" printfln(counter)

This program correctly prints `counter = 42` at the end. If we weren't using
a recursive mutex, more funky behaviour could happen. For example, on OSX, the
program enters an infinite waiting loop, as we are trying to lock an already
locked non-recursive mutex acquired by the current thread, resulting in a
deadlock.

