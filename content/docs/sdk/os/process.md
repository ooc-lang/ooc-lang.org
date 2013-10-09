---
title: Process
has_toc: true
---

## The os/Process module

The Process module deals with everything related to launching a child process, waiting for
its status or signals, and communicating with it.

## Basic usage

A process can be launched by providing an array or a list of arguments to the `Process` constructor:

    #!ooc
    import os/Process

    p := Process new(["cat", "/etc/hosts"])
    exitCode := p execute()

    // at this point, the process has ended
    // and 'exitCode' contains the value returned by the program

Instead of running execute, one might want to run `getOutput` directly, to get
the standard output of the process as a string

    #!ooc
    p := Process new(["cat", "/etc/hosts"])
    out := p getOutput()
    // out now contains the contents of the /etc/hosts file

Or getErrOutput to get the standard error output:

    #!ooc
    p := Process new(["cat", "/etc/hosts"])
    err := p getErrOutput()
    // err is empty

To retrieve the result of both stderr and stdout, see the 'Redirecting' section
below.

However, depending on your use case, that might not be the best way to do it.

### Manual wait and pid

`execute` will start the child process, wait for it to finish, and print the output.

However, we can do things manually if we want:

    #!ooc
    p := Process new(["curl", "example.org"])
    p executeNoWait()
    p wait()

The `wait` method will wait until the child process has exited or errored. If you
just want to check if a process is still running, `waitNoHang` can be used instead:

    #!ooc
    p := Process new(["curl", "example.org"])
    p executeNoWait()
    while (p waitNoHang() == -1) {
        Time sleepMilli(20)
    }

To execute a bunch of processes in parallel, using a [JobPool][jobpool] is easier and
more suitable.

[jobpool]: /docs/sdk/os/jobpool

## Process settings

### Current working directory

By default, a process will inherit from the current working directory. To make
the child process run in a specified directory, use the `setCwd` method

    #!ooc
    p := Process new(["cat", "hosts"])
    p setCwd("/etc")
    p execute()

### Environment

To specify custom environment variables for a process, use the `setEnv` method
with a `HashMap<String, String>`:

    #!ooc
    p := Process new(["bash", "-c", "echo $MYVAR"])

    env := HashMap<String, String> new()
    env put("MYVAR", "42")
    p setEnv(env)

    // prints 42
    p execute()

## Communicating with a process

### Redirecting stdin, stdout, stderr

One may use [pipes][pipe] to redirect the standard input, output, or error stream of
a process.

[pipe]: /docs/sdk/os/pipe/

    #!ooc
    import os/[Process, Pipe, PipeReader]

    p := Process new(["some", "process"])

    (out, err) := (Pipe new(), Pipe new())
    p setStdout(out)
    p setStderr(err)

    exitCode := p execute()

    outString := PipeReader new(out) toString()
    errString := PipeReader new(err) toString()

    out close('r'). close('w')
    err close('r'). close('w')

    // we now have the exit code in exitCode, the
    // stdout in outString, and the stderr in errString

### Streaming output

This can be used to stream stdout to the output of our main program, if the launched
process is interactive. If blinkenlights is still up and running when you try this, it
should display star wars scene in ASCII art:

    #!ooc
    p := Process new(["nc", "towel.blinkenlights.nl", "23"])

    out := Pipe new()
    out setNonBlocking()
    p setStdout(out)

    p executeNoWait()

    while (true) {
        chr := out read()
        if (chr != '\0') {
            chr print()
        } else if(p waitNoHang() > 0) {
            // process is done
            break
        }
    }

## Terminate or kill a process

The `terminate` method will send a process the `SIGTERM` message, while the `kill` method
will send a process the `SIGKILL` message.

This can be used to gracefully end a process:

    #!ooc
    p terminate()
    if (p waitNoHang() != -1) {
        // give a few seconds of grace..
        Time sleepSec(3)
    }

    if (p waitNoHang() != -1) {
        // still not finished? alright, that's enough
        p kill()
    }

