---
title: Debugging
has_toc: true
---

## Intro

Debugging applications is a natural cycle of writing software. One simply cannot
anticipate every single problem they are going to run into while using an piece
of software.

For rock, since we compile to C, we can use traditional debugging tools like gdb,
and the next few sections explain exactly how.

## Debug symbols

By default, rock compiles in the debug profile. The corresponding command line
option is `-pg`.

Not only will this pass the corresponding option to the C compiler used (gcc,
clang, etc.) but it will also:

  * Add `#line` directives for debuggers to map back to .ooc files
  * Keep produced C files around for further inspection.
  * On Linux, it'll add -rdynamic so that all symbols are exported
  * On OSX, it'll run dsymutil so that a `.dSYM` archive will be produced,
  containing debug symbols.

When releasing a production build of your software, use the release profile
instead, using:

    rock -pr

This will omit debug symbols.

## Fancy backtraces

While the next sections cover using a debugger, which is a prerequisite for
pretty much all hardcore problem-solving sections, there is a way to get
information about program crashes without using a debugger.

The fancy-backtrace rock extension produces output like this when a program crashes:

    [OutOfBoundsException in ArrayList]: Trying to access an element at offset 0, but size is only 0!
    [fancy backtrace]
    0     fancy_backtrace.c                                        (from C:\msys64\home\amwenger\Dev\rock\bin\fancy_backtrace.DLL)
    1     BacktraceHandler backtrace_impl()  in lang/Backtrace     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Backtrace.ooc:50)
    2     BacktraceHandler backtrace()       in lang/Backtrace     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Backtrace.ooc:243)
    3     Exception addBacktrace_impl()      in lang/Exception     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Exception.ooc:108)
    4     Exception addBacktrace()           in lang/Exception     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Exception.ooc:212)
    5     Exception throw_impl()             in lang/Exception     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Exception.ooc:177)
    6     Exception throw()                  in lang/Exception     (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Exception.ooc:232)
    7     ArrayList get_impl()               in structs/ArrayList  (at C:/msys64/home/amwenger/Dev/rock/sdk/structs/ArrayList.ooc:82)
    8     ArrayList get()                    in structs/ArrayList  (at C:/msys64/home/amwenger/Dev/rock/sdk/structs/ArrayList.ooc:40)
    9     __OP_IDX_ArrayList_Int__T()        in structs/ArrayList  (at C:/msys64/home/amwenger/Dev/rock/sdk/structs/ArrayList.ooc:290)
    10    foo()                              in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:32)
    11    bar()                              in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:41)
    12    App runToo_impl()                  in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:72)
    13    App runToo()                       in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:84)
    14    __crash_closure403()               in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:67)
    15    __crash_closure403_thunk()         in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:66)
    16    loop()                             in lang/Abstractions  (at C:/msys64/home/amwenger/Dev/rock/sdk/lang/Abstractions.ooc:2)
    17    App run_impl()                     in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:65)
    18    App run()                          in crash              (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:80)
    19    main()                             in                    (at C:/msys64/home/amwenger/Dev/rock/test/sdk/lang/crash.ooc:1)
    20    crtexe.c                                                 (from C:\msys64\home\amwenger\Dev\rock\test\sdk\lang\crash.exe)
    21    crtexe.c                                                 (from C:\msys64\home\amwenger\Dev\rock\test\sdk\lang\crash.exe)
    22    BaseThreadInitThunk                                      (from C:\Windows\system32\kernel32.dll)
    23    RtlUserThreadStart                                       (from C:\Windows\SYSTEM32\ntdll.dll)

In the case above, 

Fancy backtraces works on Windows, Linux, and OSX, on both 32 and 64-bit machines.

To use it, simply go in the rock directory and do:

    make extensions

A few dependencies might be needed, such as `binutils-dev` and `zlibg1-dev` on
Debian, or a few brew formulas on OSX.

### Fancy backtrace principle

Basically, whenever an exception is thrown, a backtrace is captured. It
contains a list of frames, e.g. the addresses of the various function calls (as
can be seen above).

If an Exception isn't caught, the program will abort, but before it does, the
backtrace captured when the exception was thrown is formatted nicely and
printed out to the standard error stream.

Similarly, when the program receives a signal (such as SIGSEGV), a backtrace is
printed to help the developer know when things were wrong.

Since fancy-backtrace has more dependencies than rock itself, it's a little bit
harder to build, and that's why it exists as a dynamic library (a .dll file on
Windows, .dylib on OSX, and .so on Linux).

When a program compiled in the debug profile starts up, it attempts to load the
library. If it succeeds, it will use it to display friendly stack traces. If it
doesn't, it will fall back to the execinfo interface (which displays only
function names, not source files or line numbers), or to... nothing, on
Windows.

By default, the fancy_backtrace.{dll,so,dylib} file is copied along to the rock
binary, in `${ROCK_DIST}/bin`. An ooc executable will first look in its own
directory (useful if the application is distributed on a system that doesn't
have rock), and will then search in the directory where the rock executable
resides (useful on a developer system).

### Fancy backtrace configuration

The default setting is to display something as helpful as possible. However, if
one wants unformatted backtraces, one may define the `RAW_BACKTRACE`
environment variable:

    RAW_BACKTRACE=1 ./myprogram

To disable the usage of fancy-backtrace altogether, one may use the
`NO_FANCY_BACKTRACE` environment variable:

    NO_FANCY_BACKTRACE=1 ./myprogram

## Crash course in gdb

GDB, the [GNU Debugger][gdb], is the canonical tool to debug C applications compiled with gcc
(or even clang).

[gdb]: https://www.gnu.org/software/gdb/

For example, writing this in `dog.ooc`

    #!ooc
    Dog: class {
        shout: func {
            raise("Woops, not implemented yet")
        }
    }

    main: func {
        work()
    }

    work: func {
        Dog new() shout()
    }

Compiling with `rock -pg` gives an executable, `dog`, and a folder with C files.

### Running

We can run it with gdb like this:

    gdb dog

If we wanted to pass arguments we could do

    gdb --args dog arg1 arg2 arg3

Inside gdb, we are greeted with a prompt. Typing `run` (or `r`) for short, followed
by a line feed, runs the program. In this case, it aborts and tells us where it failed:

    (gdb) r
    Starting program: /Users/amos/Dev/tests/dog
    Reading symbols for shared libraries +.............................. done
    [Exception]: Woops, not implemented yet

    Program received signal SIGABRT, Aborted.
    0x00007fff96b82d46 in __kill ()

### Getting a backtrace

However, as-is, we don't know much. So it died in `__kill` — that seems to be a system
function on OSX (where this doc was written). How about a nice backtrace instead? Running
`backtrace` or simply `bt` will give you that:

    (gdb) bt
    #0  0x00007fff96b82d46 in __kill ()
    #1  0x00007fff8edfadf0 in abort ()
    #2  0x0000000100007121 in lang_Exception__Exception_throw_impl (this=0x100230030) at Exception.ooc:205
    #3  0x00000001000072a3 in lang_Exception__Exception_throw (this=0x100230030) at Exception.ooc:241
    #4  0x0000000100008090 in lang_Exception__raise (msg=0x100231600) at Exception.ooc:104
    #5  0x0000000100000e9b in dog__Dog_shout_impl (this=0x100238ff0) at dog.c:3
    #6  0x0000000100000ef0 in dog__Dog_shout (this=0x100238ff0) at dog.ooc:11
    #7  0x0000000100001131 in dog__work () at dog.ooc:12
    #8  0x0000000100001102 in main (__argc2=1, __argv3=0x7fff5fbff230) at dog.ooc:8

We have from left to right - the frame number, the address of the function (we
can ignore), the name of the function, then the arguments and their values, and
then the files where they were defined (if they can be found) along with the
line number.

### Reading code with context

As expected, we can see ooc line numbers in the backtrace. What if we want to
investigate the code without opening the .ooc file ourselves? We can just place
ourselves in the context of frame 7 with `frame 7` or simply `f 7`:

    (gdb) f 7
    #7  0x0000000100001131 in dog__work () at dog.ooc:12
    12	    Dog new() shout()

Want more context, e.g. the lines of code around? Use `list` (or simply `l`)

    (gdb) l
    7	main: func {
    8	    work()
    9	}
    10
    11	work: func {
    12	    Dog new() shout()
    13	}
    (gdb)

### Inspecting values

GDB can also print values. For example, going back to frame 2, we can inspect
the exception being thrown by using `print` (or `p`, for short):

    (gdb) f 2
    #2  0x0000000100007121 in lang_Exception__Exception_throw_impl (this=0x100230030) at Exception.ooc:205
    205	            abort()
    (gdb) p this
    $4 = (lang_Exception__Exception *) 0x100230030

Getting an address is not that useful, though, how about printing the content
of an object instead? We can dereference the object from within gdb:

    (gdb) p *this
    $10 = {
      __super__ = {
        class = 0x100047e60
      },
      backtraces = 0x100234f40,
      origin = 0x0,
      message = 0x100231600
    }

What if we want to read the message? Since it's an ooc String, we'll need to
print the content of the underlying buffer:

    (gdb) p *this.message._buffer
    $11 = {
      __super__ = {
        __super__ = {
          class = 0x100047490
        },
        T = 0x1000478c0
      },
      size = 26,
      capacity = 0,
      mallocAddr = 0x0,
      data = 0x10002fe24 "Woops, not implemented yet"
    }

### Inspecting generics

Inspecting generics is a bit trickier - one has to cast it directly to the
right type. For example, the `Exception` class has a LinkedList of backtraces,
which is a generic type. We can inspect it:

    (gdb) p *this.backtraces
    $21 = {
      __super__ = {
        __super__ = {
          __super__ = {
            __super__ = {
              class = 0x10004b2b0
            },
            T = 0x100047df0
          }
        },
        equals__quest = {
          thunk = 0x10001a660,
          context = 0x0
        }
      },
      _size = 0,
      head = 0x100239f60
    }

Not so useful. What about head?

    (gdb) p *this.backtraces.head
    $22 = {
      __super__ = {
        class = 0x10004b4a0
      },
      T = 0x100047df0,
      prev = 0x100239f60,
      next = 0x100239f60,
      data = 0x100238fe0 ""
    }

Looks like a node from a doubly-linked list. We're on the right track! However,
data is printed as a C string (since generics are `uint8_t*` under the hood, and
`uint8_t` is usually typedef'd to `char`). We can cast it:

    (gdb) p (lang_types__Pointer) *this.backtraces.head.data
    $24 = (lang_types__Pointer) 0x0

Which seems about right, as the exception has not been re-thrown (obviously the
example here is rather specific, but the general techniques can be applied to any
ooc application).

### Breakpoints

What if we want to inspect values somewhere the program wouldn't stop naturally?
In the program above, we could set up a breakpoint when the constructor of `Dog`
is called.

It can be non-trivial to determine the C symbol corresponding to an ooc function.
Tab-completion is here to the rescue though - typing `break dog_` and then hitting
Tab twice will display a helpful list of symbols:

    (gdb) break dog_<TAB><TAB>
    dog__Dog___defaults__       dog__Dog___load__           dog__Dog_init               dog__Dog_shout              dog__work
    dog__Dog___defaults___impl  dog__Dog_class              dog__Dog_new                dog__Dog_shout_impl         dog_load

Here, we seem to want `dog__Dog_new`. As a rule, we have `packagename__ClassName_methodName_suffix`.

Setting up the break point does nothing until we run the program:

    (gdb) break dog__Dog_new
    Breakpoint 1 at 0x100000f3a: file dog.ooc, line 1.
    (gdb) r
    Starting program: /Users/amos/Dev/tests/dog
    Reading symbols for shared libraries +.............................. done
    
    Breakpoint 1, dog__Dog_new () at dog.ooc:1
    1	Dog: class {

### Stepping

From there, we can investigate as before, with `backtrace`, `frame`, `print`, etc. We can also decide
to step line by line. Using `step` will enter the functions being called, whereas `next` will skip them
and return to the prompt when the functions have fully executed.

The shorthand for `step` is `s`, and the shorthand for next is `n`. When we step, we can see everything
being executed, including string and object allocation:

    (gdb) s
    dog__Dog_class () at dog.ooc:25
    Line number 25 out of range; dog.ooc has 13 lines.
    (gdb)
    Line number 26 out of range; dog.ooc has 13 lines.
    (gdb)
    Line number 27 out of range; dog.ooc has 13 lines.
    (gdb)
    lang_types__Object_class () at types.ooc:55
    55	        if(object) {
    (gdb)
    dog__Dog_class () at dog.ooc:28
    Line number 28 out of range; dog.ooc has 13 lines.
    (gdb)
    Line number 29 out of range; dog.ooc has 13 lines.
    (gdb)
    lang_String__makeStringLiteral (str=0x10002fe20 "Dog", strLen=3) at String.ooc:377
    377	    String new(Buffer new(str, strLen, true))
    (gdb)
    lang_Buffer__Buffer_new_cStrWithLength (s=0x10002fe20 "Dog", length=3, stringLiteral__quest=true) at Buffer.ooc:59
    59	    init: func ~cStrWithLength(s: CString, length: Int, stringLiteral? := false) {
    (gdb)
    lang_Buffer__Buffer_class () at Buffer.ooc:157
    157	    clone: func ~withMinimum (minimumLength := size) -> This {
    (gdb)
    158	        newCapa := minimumLength > size ? minimumLength : size
    (gdb)
    163	        copy
    (gdb)
    0x00000001000050dd in lang_Buffer__Buffer_new_cStrWithLength (s=0x10002fe20 "Dog", length=3, stringLiteral__quest=true) at Buffer.ooc:59
    59	    init: func ~cStrWithLength(s: CString, length: Int, stringLiteral? := false) {
    (gdb)
    lang_types__Class_alloc__class (this=0x100047490) at types.ooc:54
    54	        object := gc_malloc(instanceSize) as Object
    (gdb)

Note that some line numbers seem to be problematic here - but we still get to see which parts of the
code get executed and in which order. Instead of typing `s` every time, we can just hit Enter to
re-execute the last command.

When we're done stepping and just want to resume program execution, we can use `continue` (or `c` for short).

### Quitting

When we're done running gdb, we can quit with `quit` (or `q` for short). It might ask for confirmation
if the program is still running, but otherwise, it's all good.

### Attaching to a process

Up to there, we have seen how to run a program from gdb. What if we want to attach gdb to a process that has been
launched somewhere else? Let's try with this program, `sleep.ooc`:

    #!ooc
    import os/Time
    main: func {
        while (true) {
            doThing()
            Time sleepSec(1)
        }
    }
    
    doThing: func {
        "Hey!" println()
    }

Compiling it with `rock -pg` and running it with `./sleep` prints `Hey!` every second, as expected.

To attach to this process, we need to find out its process ID. We can either use the `ps` command line
utility, or we can interrupt its execution with `Ctrl-Z` (in most shells, like bash, zsh, etc.). You
might see something like this:

    amos at coyote in ~/Dev/tests
    $ ./sleep
    Hey!
    Hey!
    Hey!
    ^Z
    [1]  + 48130 suspended  ./sleep

And the process ID is `48130` here. We can attach gdb to that process like this:

    gdb attach 48130

When attaching to a process, GDB will pause execution, waiting for orders. Quitting gdb
will then detach gdb from the process, which will resume execution.

If you need to quit the process, you can bring it back to the front with the `fg` shell
command, then exit it with `Ctrl-C`.

## Other tips
 
### ooc vs C line numbers

By default, rock will output 'sourcemaps', mapping C code back to the original ooc
code that generated it. This allows the debugger to display ooc line numbers, as seen
above. This behavior can be disabled with:

    rock --nolines

In which case gdb will fall back to displaying C line numbers (corresponding to the files
generated by rock). This can be useful if you suspect that rock is generating invalid code,
or if the ooc line numbers are messed up for some reason.

