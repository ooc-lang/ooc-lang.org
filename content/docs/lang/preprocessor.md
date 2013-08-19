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
<td>identifier</td>
<td>C symbol</td>
</tr>

<tr>
<td>windows</td>
<td>__WIN32__) || defined(__WIN64__</td>
</tr>

<tr>
<td>linux</td>
<td>__linux__</td>
</tr>

<tr>
<td>solaris</td>
<td>__sun</td>
</tr>

<tr>
<td>unix</td>
<td>__unix__</td>
</tr>

<tr>
<td>beos</td>
<td>__BEOS__</td>
</tr>

<tr>
<td>haiku</td>
<td>__HAIKU__</td>
</tr>

<tr>
<td>apple</td>
<td>__APPLE__</td>
</tr>

<tr>
<td>freebsd</td>
<td>__FreeBSD__</td>
</tr>

<tr>
<td>openbsd</td>
<td>__OpenBSD__</td>
</tr>

<tr>
<td>netbsd</td>
<td>__NetBSD__</td>
</tr>

<tr>
<td>dragonfly</td>
<td>__DragonFly__</td>
</tr>

<tr>
<td>gnuc</td>
<td>__GNUC__</td>
</tr>

<tr>
<td>arm</td>
<td>__arm__</td>
</tr>

<tr>
<td>i386</td>
<td>__i386__</td>
</tr>

<tr>
<td>x86</td>
<td>__X86__</td>
</tr>

<tr>
<td>x86_64</td>
<td>__x86_64__</td>
</tr>

<tr>
<td>ppc</td>
<td>__ppc__</td>
</tr>

<tr>
<td>ppc64</td>
<td>__ppc64__</td>
</tr>

<tr>
<td>64</td>
<td>__x86_64__) || defined(__ppc64__</td>
</tr>

<tr>
<td>gc</td>
<td>__OOC_USE_GC__</td>
</tr>

<tr>
<td>android</td>
<td>__ANDROID__</td>
</tr>

</tbody>
</table>

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

