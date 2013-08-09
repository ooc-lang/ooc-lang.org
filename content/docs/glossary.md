---
title: Glossary
has_toc: true
glossary:
  project: >
    A piece of software written in ooc: usually a [library] or
    an [application], sometimes both. Contains [module]s organized
    in [package]s, and often a [usefile] that specifies dependencies,
    and how to compile the project.
  package: >
    A collection of ooc [module]s. Defined by the directory
    structure of an ooc [project].
  module: >
    An .ooc file is called a module. It can be imported by
    other modules. Modules are usually organized in [package]s.
  library: >
    A reusable piece of code composed of several [module]s and
    a [usefile], made easy to be used from other ooc [project]s
  application: >
    A piece of software made to be run, e.g. a game, a command-line
    utility. Might use several libraries (see [library]).
  usefile: >
    Describes the dependencies of a [project], along with its name,
    version, and a short description.
    See <a href="/docs/tools/rock/usefiles">Usefile Syntax</a>
  class: >
    Defines the structure ([variable]s and [method]s) of an [object].
  cover: >
    Similar to a C struct. Can also contain [variable]s and [method]s.
    Can be seen as a [class] variant.
  object: >
    An instance of a [class].
  variable: >
    Named memory slot that can contain a [value].
  value: >
    Usually either an [object], a [pointer], a number, or a String.
  pointer: >
    Reference to a certain part of memory. In fact, [object]s
    are pointers to the real thing.
  hash map: >
    An association between keys and values. The SDK has a map
    structure as `structs/HashMap`.
  list: >
    An ordered list of [value]s. Values can easily be added or removed
    from a list. The SDK has an array-backed list in
    `structs/ArrayList` and a linked list in `structs/LinkedList`.
  array: >
    Ordered, compact list of [value]s. Can be indexed, sorted, etc.
    Usually fixed, e.g. you can't add or remove values from an array
    without resizing it.
  function: >
    Named or anonymous piece of code accepting a certain number
    of [argument]s and potentially returning a [value].
  generic type: >
    Type argument in a [class], [cover], or [argument] definition
    that can correspond to any [type]. Useful to build reusable
    [container]s.
  container: >
    An [object] that contains several [value]s. Examples: an [array],
    a [list], a [hash map], etc.
  compiler: >
    Piece of software that transforms source code to a more primitive
    form, such as an executable. Example: [rock].
  rock: >
    The main ooc [compiler].
  sourcepath: >
    List of directories in which [rock] looks for ooc [module]s.
---

{{GLOSSARY}}
