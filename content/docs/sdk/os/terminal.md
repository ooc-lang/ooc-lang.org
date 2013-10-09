---
title: Terminal
has_toc: true
---

## The os/Terminal module

Terminal is used to control the terminal output, mostly by setting colors and
attributes on there.

## Colors

The `Color` enum contains colors that are possible to set on the terminal:

To change the foreground color, use `setFgColor`:

    #!ooc
    Terminal setFgColor(Color black)

To change the background color, use `setBgColor`:

    #!ooc
    Terminal setBgColor(Color white)

### List of colors

Here are the colors defined in the Color enum:

  * black
  * red
  * green
  * yellow
  * blue
  * magenta
  * cyan
  * grey
  * white

Note that depending on your terminal emulator, these colors
might not map to their actual names.

## Attributes

Attributes can be set using `setAttr`:

    #!ooc
    Terminal setAttr(Attr bright)

### List of attributes

Here are the attributes defined in the `Attr` enum:

  * reset
  * bright
  * dim
  * under
  * blink
  * reverse
  * hidden

## Resetting

Reset all color and attribute settings to default by using the
`reset` method:

    #!ooc
    Terminal reset()

## Cross-platform considerations

On *nix platforms, all attributes are supposed. On Windows, only
the `reset` attribute is supported.

On *nix, the `Terminal` module outputs ANSI escape sequences to
stdout, whereas on Windows it uses the console text attribute API.

That's why there is no cross-platform way to transform a string
into a "colored string", because it would make no sense on Windows.

Also, on *nix, color escapes will only be outputted if stdout is
a terminal and not if it's redirected to a file or a pipe.

