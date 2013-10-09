---
title: The os package
has_toc: true
index: true
---

## The os package

The os packages contains various modules pertaining to Operating System functionality such as:

### Concurrency

 1. [Process](/docs/sdk/os/process/), to launch child processes

 2. [JobPool](/docs/sdk/os/jobpool/), to easily control a pool of child processes

 3. [Coro](/docs/sdk/os/coro/), which provides a basic coroutine implementation

### I/O

 1. [Terminal](/docs/sdk/os/terminal/), used to control terminal text output (color, etc.)

 2. [Pipe](/docs/sdk/os/pipe/), to open, read from, and write to pipes

 3. [Dynlib](/docs/sdk/os/dynlib/), which deals with dynamic library loading

 4. [mmap](/docs/sdk/os/mmap/), which exposes memory mapping capabilities

 5. [Channel](/docs/sdk/os/channel/), which implements channels

### System

 1. [System](/docs/sdk/os/system/), to get information such as the number of processors,
    the hostname, etc.

 2. [Env](/docs/sdk/os/env/), to deal with environment variables

 3. [ShellUtils](/docs/sdk/os/shellutils/), used mostly to find executables

 3. [Time](/docs/sdk/os/time/), to get the current time and date, and sleep


