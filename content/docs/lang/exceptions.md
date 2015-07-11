---
title: Exceptions
has_toc: true
---

## Error handling

The C way to do error handling is usually via return codes:

    #!ooc
    openFile: (path: String) -> Int {
      if (error) {
        return -1
      }
      return someFileDescriptor
    }

However, it relies on the user correctly checking the return value:

    #!ooc
    fd := openFile("/etc/hosts")
    doSomethingWithFile(fd) // forgot to check, things might go bad!

## Exceptions

### raise

Another way to handle that would be with exceptions

    #!ooc
    openFile: (path: String) -> File {
      if (error) {
        raise("Could not open %s" format(path))
      }
      return someFile
    }

That way, even if the user doesn't explicitly check for the error, it'll
still interrupt the flow of the program:

    file := openFile("/dev/does/not/exist")
    doSomethingWithFile(file) // we are never even going to reach there

### Throwing

The `raise` function above is a quick method to raise an exception. What
it really does is this:

    #!ooc
    Exception new(message) throw()

There is no special keyword to throw exceptions, it's just a method on the
`Exception` class.

### Catching exceptions

Catching exceptions is done through the `try` / `catch` syntax:

    #!ooc
    try {
      openFile("dev/does/not/exist")
    } catch (e: Exception) {
      // something wrong happened
      "Error: #{e message}" println()
    }

### Exception sub-classes

It is possible to sub-class exceptions to have several exception types.

    #!ooc
    FileNotFoundException: class extends Exception {
      init: func (path: String) {
        super("File not found: %s" format(path))
      }
    }

    openFile: func (path: String) {
      if (error) {
        FileNotFoundException new(path) throw()
      }
    }

Which makes it easy to catch a specific type of exception:

    #!ooc
    try {
      file := openFile("/dev/does/not/exist")
      doSomethingWithFile(file)
    } catch (e1: FileNotFoundException) {
      // The file wasn't found
    } catch (e2: Exception) {
      // Something else went wrong.
    }
