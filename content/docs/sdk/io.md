---
title: The io package
has_toc: true
---

## The io package

Whether you want to read from file, write to files,
walk through directories, or build data in-memory, the
io package contains everything you need

## File

The `io/File` module is a good starting point to handle
files. Instanciating one with a path will allow to test for
various attributes:

    #!ooc
    f := File new("/etc/hosts")

    f exists?()
    f dir?() // is a directory?
    f file?() // is a file?
    f link?() // is a symlink?

    f getSize() // size in bytes

### Paths

For paths like `/path/to/somewhere`, `getName()` will return
the `somewhere` part, and `getParent` will return an instance
of `File` corresponding to `/path/to`, or null if the path is
at the root of a file system.

The `getReducedPath` method will resolve paths like `a/b/../../c`
to `c`. It is a form of canonicalization, suitable for comparing
paths.

### Basic I/O

The `copyTo` method will copy a file to the given `dstFile`.

    #!ooc
    src := File new("./conf/default.conf")
    dst := File new(Env get("HOME"), ".myapp")
    src copyTo(dst)

The `remove` method will remove a file, but will fail to remove
a directory.

    #!ooc
    tmpFile remove()

### Walking through directories

The `getChildren` method will return a list of `File` instances
corresponding to the files in a directory, whereas the `getChildrenNames`
method will return a list of strings corresponding to the name of
files in the given directory.

    #!ooc
    f := File new("/etc")
    for (child in f getChildren()) {
      // child might be a file or a directory with
      // children of its own
    }

The `walk` method allows a recursive walk on all the children
of a given directory. When the callback returns false, the search
is terminated.

    #!ooc
    findFile: func (prefix: String) {

    }

### Permissions

The methods `ownerPerm`, `groupPerm`, and `otherPerm` return
an int mask with permissions.

Note that using octal number literals might be a good idea
to test against that. Unlike C, `0777` is decimal in ooc.
You want to write `0c777` instead.

### Current directory

The static method `File getCwd()` will return the current
working directory on any platform.

