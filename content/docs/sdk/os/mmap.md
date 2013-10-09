---
title: mmap
has_toc: true
---

## The os/mmap module

As it stands, the `os/mmap` module just exposes the *nix functions for memory
mapping: `mmap`, `munmap`, `mprotect`, `madvise`, `mincore`, `minherit`,
`msync`, `mlock`, and `munlock`, along with the associated constants.

It also contains prototypes / covers for the Windows equivalent,
`VirtualProtect`, and its constants as well.

### Notes

This module is not a high-level or cross-platform interface and is not
documented extensively here.

However, to find more information on memory mapping for various platform
see here:

  * [mmap on Wikipedia][mmap] (for *nix platforms)
  * [VirtualProtect on MSDN][vprotect] (for Windows)

[mmap]: http://en.wikipedia.org/wiki/Mmap
[vprotect]: http://msdn.microsoft.com/en-us/windows/desktop/aa366898(v=vs.85).aspx

On a historical note, this module was originally included in the SDK as support
code for the closure implementation, which back then implied generating
bytecode at runtime and thus marking some memory regions as executable.

