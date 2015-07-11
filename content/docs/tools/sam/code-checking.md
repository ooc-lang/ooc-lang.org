---
title: Code checking
has_toc: true
---

## Concepts

rock is nice to build entire projects, but the downside is that checking
individual files is tricky. sam solves most of that problem.

Let's say you have the following directory structure:

    .
    ├── source
    │   └── foobar
    │       └── package
    │           └── foo.ooc
    │           └── bar.ooc
    └── foobar.use

Running `rock --onlyparse source/foobar/package/foo.ooc` wouldn't work, because
it wouldn't be compiled in the context of the foobar project (the source path
would be set to `source/foobar/package` instead of `source`)

sam solves that with its `check` command, by walking up the file tree until
it finds an .use file that contains the .ooc file it was passed by argument.

Then, sam writes a custom [.use file][use] in its cache directory, with `Main`
set to, in our case, `foobar/package/foo`, and runs rock.

[use]: /tools/rock/usefiles/

## Usage

Simply run:

    #!bash
    sam check /absolute/path/to/any/file.ooc

And check the return status. If the check goes well, sam will not output
anything by default (except in verbose mode). If it goes wrong, it will relay
rock's output.

The `--mode` argument lets sam know how deep the check should be:

  - `--mode syntax` only makes sure the code is valid ooc syntax
  - `--mode check` (default) will catch undefined symbols, missing imports, etc.
  - `--mode codegen` (rarely needed) makes sure rock can actually generate C code from it

## Integration

`sam check` is designed to be integrated with code editors. An example of
that can be found in [ooc.vim][], where a sam-based syntastic checker is
implemented.

[ooc.vim]: https://github.com/fasterthanlime/ooc.vim

![fill](/assets/images/sam-checker.png)

