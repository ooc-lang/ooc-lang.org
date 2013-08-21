---
title: The lang package
has_toc: true
index: true
---

## The lang package

The lang package is considered built-in: it is imported by default in ooc
modules. There is a reason for that, however - the SDK is distributed as
an ooc library itself, and as such, it has a .use file that specifies which
modules should be imported.

Some of the lang package is essential, like `Object` and `Class`, which
means that the compiler, [rock][rock], will expect them to be present,
have certain names, fields and methods. However, using a custom sdk is
possible, where the implementation for these can be swapped to something
lighter, for example.

[rock]: /docs/tools/rock/

  1. The [Types](/docs/sdk/lang/types/) section describes how Object,
     Class, and other types such as Void, Pointer, Bool, None,
     Cell are defined. It also discusses variable arguments.

  2. The [String](/docs/sdk/lang/string/) section talks about string
     handling, the mutable variant Buffer, and formatting

  3. The [Numbers](/docs/sdk/lang/numbers/) section talks about number
     types, either integers or floats, and the various functions available.

  4. The [Iterators](/docs/sdk/lang/iterators/) section discusses
     how iterators are implemented, and what goes on behind a foreach.

  5. The [Exceptions](/docs/sdk/lang/exceptions/) section talks about
     default properties of exceptions, and how to extend them.

  6. The [Memory](/docs/sdk/lang/memory/) section talks about memory
     management, mostly just how to deal with blocks of memory rather
     than more high-level data structures.

