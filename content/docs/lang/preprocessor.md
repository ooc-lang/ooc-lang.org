---
title: Preprocessor
has_toc: true
---

## Version blocks

Version blocks allows one to write platform-specific code. For example:

    #!ooc
    runThing: class {
      version (windows) {
        // use CreateProcess ...
        return
      }

      version (!windows) {
        // use something more unix-y
      }
    }

Version blocks support complex binary expressions, like `&&`, `||`, `!`, and
any depth of parenthesis nesting. For example:

    #!ooc
    version (!(osx || linux)) {
      // not on osx, nor on linux
    }

Available version blocks and their corresponding C defines are as follow:

<table class="pretty">
<tbody>

<tr>
<td>Identifier</td>
<td>Description</td>
</tr>

<tr>
<td>windows</td>
<td>Windows OS, both 32 and 64-bit</td>
</tr>

<tr>
<td>linux</td>
<td>Linux</td>
</tr>

<tr>
<td>solaris</td>
<td>Solaris</td>
</tr>

<tr>
<td>unix</td>
<td>Unices (Apple products do not define this)</td>
</tr>

<tr>
<td>beos</td>
<td>BeOS</td>
</tr>

<tr>
<td>haiku</td>
<td>Haiku (BeOS-like)</td>
</tr>

<tr>
<td>apple</td>
<td>All things apple: iOS, OSX</td>
</tr>

<tr>
<td><em>ios</em></td>
<td>iOS: iPhone, iPad</td>
</tr>

<tr>
<td><em>ios_simulator</em></td>
<td>iOS compiled for the ios simulator</td>
</tr>

<tr>
<td><em>osx</em></td>
<td>Mac OSX (consider using <tt>apple</tt> instead)</td>
</tr>

<tr>
<td>freebsd</td>
<td>FreeBSD</td>
</tr>

<tr>
<td>openbsd</td>
<td>OpenBSD</td>
</tr>

<tr>
<td>netbsd</td>
<td>NetBSD</td>
</tr>

<tr>
<td>dragonfly</td>
<td>DragonFly BSD</td>
</tr>

<tr>
<td>cygwin</td>
<td>Cygwin toolchain</td>
</tr>

<tr>
<td>mingw</td>
<td>MinGW 32 or 64-bit toolchain</td>
</tr>

<tr>
<td>mingw64</td>
<td>MinGW 64-bit toolchain</td>
</tr>

<tr>
<td>gnuc</td>
<td>GCC (GNU C)</td>
</tr>

<tr>
<td>msvc</td>
<td>Microsoft Visual C++</td>
</tr>

<tr>
<td>android</td>
<td>Android toolchain</td>
</tr>

<tr>
<td>arm</td>
<td>ARM processor architecture</td>
</tr>

<tr>
<td>i386</td>
<td>Intel x86 architecture (defined by GNU C)</td>
</tr>

<tr>
<td>x86</td>
<td>Intel x86 architecture (defined by MinGW)</td>
</tr>

<tr>
<td>x86_64</td>
<td>AMD64 architecture</td>
</tr>

<tr>
<td>ppc</td>
<td>PPC architecture</td>
</tr>

<tr>
<td>ppc64</td>
<td>PPC 64-bit architecture</td>
</tr>

<tr>
<td>64</td>
<td>64-bit processor architecture and toolchain</td>
</tr>

<tr>
<td>gc</td>
<td>Garbage Collector activated on compilation</td>
</tr>

</tbody>
</table>

The specs in _italics_ are "complex" specs - they can't be in a composed version
expression, e.g. this is invalid:

    #!ooc
    version (64 && osx) {
        // code here
    }

Consider doing this instead:

    #!ooc
    version (64) {
        version (osx) {
            // code here
        }
    }

The reason for this is that `osx`, `ios`, and `ios_simulator` are not simple `#ifdef`s
in the generated code, but they require an include and an equality test.

## Line continuations

Any line can be broken down on several lines, by using the backslash character, `\`,
as a line continuation:

    #!ooc
    someList \
    map(|el| Something new(el))

If it wasn't for that `\` before the end of the line, `map` would be interpreted as
a separate function call, and not a method call.

## Constants

Some constants are accessible anywhere and will be replaced at compile time with
strings. Those are:

  * `__BUILD_DATETIME__`
  * `__BUILD_TARGET__`
  * `__BUILD_ROCK_VERSION__`
  * `__BUILD_ROCK_CODENAME__`
  * `__BUILD_HOSTNAME__`

## Call chaining

While not technically a preprocessor feature, the following code:

    #!ooc
    a := ArrayList<Int> new(). add(1). add(2). add(3)

Is equivalent to:

    #!ooc
    a := ArrayList<Int> new()
    a add(1). add(2). add(3)

Itself equivalent to:

    #!ooc
    a := ArrayList<Int> new()
    a add(1)
    a add(2)
    a add(3)

## Slurping

The compiler can read a text file at compile time, and insert it
as a string literal in the code.

    #!ooc
    // assuming 'secret-assets' is a directory we don't ship
    secrets := slurp("../secret-assets/secrets.txt")

    secrets split("\n") each(|secret|
      secret println()
    )

`slurp` only takes a single argument, and it *must* be a string
literal (so you can't compute paths, as that would requiring interpreting
ooc code at compile time, effectively requiring macros).

It is not guaranteed to work with non-text files as it is transformed
into an (escaped) string literal.

The path passed to `slurp` should be relative to the `SourcePath` of the
.use file to which the source file using `slurp` corresponds. It is
*not* relative to the source file itself.

Example directory structure for the example above:

    .
    ├── secret-assets
    │   ├── secrets.txt
    ├── source
    │   └── foobar
    │       └── package
    │           └── something.ooc
    └── foobar.use

In this example, foobar.use contains `SourcePath: source`, as is usual
with ooc libraries.

`slurp` is used for example in dye, to [ship shader files in the executable][dye].
Note that dye uses that as a fallback, only if it fails to read shader files
from disk, which allows customization without recompiling.

[dye]: https://github.com/fasterthanlime/dye/blob/master/source/dye/shader.ooc

