---
title: JobPool
has_toc: true
---

## The os/JobPool module

JobPool is useful when several background tasks have to be launched in
parallel. It allows to control how many tasks are run in parallel, and to wait
until all tasks have ended.

A good example of JobPool usage would be a build system, where multiple
instances of a compiler have to be ran on different files, and the number of
instances running in parallel should be limited.

## Basic usage

Creating a job pool is trivial:

    #!ooc
    import os/JobPool
    pool := JobPool new()

Then jobs should be added. Jobs are attached to processes, so the process
must be launched beforehand.

    #!ooc
    p := Process new(["find", "./", "-name", "*.log"])
    p executeNoWait()

Then an associated job can be created and added to the pool:

    #!ooc
    job := Job new(p)
    pool add(job)

Note that the `pool add` call might block, if there already is too many
jobs running in parallel, waiting for at least one job to complete.

When all jobs have been added, one can wait for all jobs to finish.

    #!ooc
    exitCode := pool waitAll()

If at least one job failed (returned with a non-zero exit code),
`waitAll` will return its exit code. If they all succeeded, `waitAll`
will just return 0.

### Proof of concept

To demonstrate how it works, we can launch several `sleep` commands
in the background, and wait for them all to finish:

    #!ooc
    pool := JobPool new()

    for (i in 0..pool parallelism) {
        p := Process new(["sleep", "1"])
        p executeNoWait()
        pool add(Job new(p))
    }

    pool waitAll()

This program wil take about 1 second to complete, no matter the level
of parallelism. Instead of being executed sequentially (which would add
up the time of execution), they're being executed in parallel.

Note that this is a contrived example. In a real example, one would not
adjust the total number of jobs from the `pool parallelism` setting, but
rather let the natural number of jobs be distributed by the job pool itself.

## Customization

### Parallelism

By default, `JobPool` tries to have a level of parallelism (max jobs in
parallel) equal to the number of cores on the machine it's running on.

It can be adjusted by hand:

    #!ooc
    // never run more that 2 jobs in parallel
    pool parallelism = 2

### Custom job

In our examples above we've always used the default `Job` class. But it can be
extended as well. By making a subclass of it, we can override the `Job onExit`
method, allowing us to take action after each job is finished.

    #!ooc
    CompilationJob: class extends Job {
        init: func {
            p := Process new(["gcc", "-v"])
            p executeNoWait()
            super(p)
        }

        onExit: func (code: Int) {
            if (code != 0) {
                raise("Compilation failed!")
            }
        }
    }

Our new job type can then be used, like so:

    #!ooc
    pool := Pool new()
    for (i in 0..10) {
        pool add(CompilationJob new())
    }
    pool waitAll()

