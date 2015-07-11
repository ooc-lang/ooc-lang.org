---
title: Tools
has_toc: true
index: true
---

## Frequently used ooc tools

There are some tools you should know about when you start looking into ooc.

 1. [rock](/docs/tools/rock/) is the ooc compiler. In most cases,
   you will use it to generate C sources and executables from your ooc sources.

 2. [sam](/docs/tools/sam/) helps you grab ooc libraries from git repos and
    keep them up-to-date. It also allows code checking, and can run simple
    test suites.

 3. [editors](/docs/tools/editors/) - describes how to get syntax highlighting,
   program checking, indentation in vim, emacs, TextMate?

Tools like autoconf, automake, even CMake, are irrelevant in the context of
ooc, since rock drives the whole compilation process.

ooc libraries have one, standardized way to be built - as such, the ooc ecosystem
is a lot more homogenous than, say, the C ecosystem. Complexity is dealt with
through [usefiles](/docs/tools/rock/usefiles/) and the such.

Still, the ooc toolchain is quite flexible, working on major desktop OSes, and
more constrained platform such as Android.
