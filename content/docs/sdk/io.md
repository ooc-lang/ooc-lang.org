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

The `read` and `write` methods will read a whole file and replace the content
of a file with the given string, respectively.

    #!ooc
    respectify: func (file: File) {
      text := file read()
      file write(text replaceAll("yes", "yes, sir"))
    }

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
    findFile: func (prefix: String) -> File {
      result: File
      baseDirectory walk(|f|
        if (f startsWith?(prefix)) {
          result = f
          return false
        }
        true
      )
      result
    }

### Permissions

The methods `ownerPerm`, `groupPerm`, and `otherPerm` return an int mask with
permissions.

Note that using octal number literals might be a good idea to test against
that. Unlike C, `0777` is decimal in ooc. You want to write `0c777` instead.

### Current directory

The static method `File getCwd()` will return the current working directory on
any platform.

## Reader / Writer

The `io/Reader` and `io/Writer` modules contains interfaces used for input/output.

For files, use the `io/FileReader` and `io/FileWriter` implementations. To work in
memory, use the `io/BufferReader` and `io/BufferWriter` implementations.

A reader or writer should be closed (by calling `reader close()` or `writer close()`)
when done with it, so that the corresponding resources may be freed.

### Reader basics

Some C libraries have an interface similar to `io/Reader`. The main I/O loop might
look like the following:

    #!ooc
    import io/Reader

    process: func (reader: Reader) {
      buffer := Buffer new(1024)

      while (reader hasNext?()) {
        bytesRead := reader read(buffer)
        // do something with buffer
      }
      reader close()
    }

A reader can also work with raw memory chunks:

    #!ooc
    onRead: func (reader: Reader, buffer: UInt8*, bufferSize: Int) {
      // fill buffer from beginning, 0 is the offset
      reader read(buffer, 0, bufferSize)
    }

Or one character at a time:

    #!ooc
    match (reader read()) {
      case 'A' => "Good!"
      case 'F' => "Also good."
      case => "Meh."
    }

An entire stream can be read to a String:

    #!ooc
    fr := FileReader new("file.txt")
    contents := fr readAll()
    fr close()

(Note that this would compactly be achieved by `File new("file.txt") read()`)

For more details, refer to the oocdocs.

### Writer basics

Similarly, the writer interface works with buffers, raw memory chunks, single characters,
or strings as needed:

    #!ooc
    manipulate: func (w: Writer) {
      // char
      w write('a')

      // string
      w write("abc")

      // buffer
      chars := "moonlight" toCString()
      w write(chars, 4) // only writes "moon"
    }

For more details, refer to the oocdocs.

## BinarySequence

The `io/BinarySequence` module is meant to help deal with binary protocols, precise
on the width and endianness of types being written to a stream.

### BinarySequenceReader

Here's an example:

    #!ooc
    // read a file as binary
    file := File new("assets", "binary.dat")
    seq := BinarySequenceReader new(FileReader new(file))

    // read an 16-bit unsigned int:
    numElements := seq u16()

    for (i in 0..numElements) {
      // coordinates are two floats
      x := seq float32()
      y := seq float32()
      // do something with x, y
    }

    // check magicn number at the end
    assert (seq s32() == 0xdeadbeef)

For more details, refer to the oocdocs.

### BinarySequenceWriter

The corresponding module exists for writing binary sequences.

    #!ooc
    // write a binary file
    file := File new("assets", "binary.dat")
    seq := BinarySequenceWriter new(FileWriter new(file))

    seq u16(elements size)

    for (elem in elements) {
      seq float32(elem x)
      seq float32(elem y)
    }

    seq s32(0xdeadbeef)

For more details, refer to the oocdocs.

