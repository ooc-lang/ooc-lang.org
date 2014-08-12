---
title: Editor support
has_toc: true
---

## ooc support in text editors

ooc has a varying level of support among different text editors.

Read on to find if your favourite flavor is supported. If you add
support for a new editor, please open an issue on the [ooc-lang.org repo][site-repo].

## vim

ooc support for vim is provided by the [ooc.vim][ooc.vim] plug-in. It provides:

  * Syntax highlighting
  * Indentation support
  * A syntastic plug-in for use with [sam][sam]
  * `:make` command support (launches `rock -v`)

You can read more at the [project repository][ooc.vim]'s page.

## emacs

ooc support for emacs is provided by [ooc-mode][ooc-mode]. It provides:

  * Syntax highlighting
  * Indentation support
  * On the fly syntax check with flymake-ooc

## TextMate

ooc support for TextMate is provided by [ooc.tmbundle][ooc.tmbundle].

## Atom

The [Atom editor][atom] can use converted TextMate bundles.

You can easily convert [ooc.tmbundle][ooc.tmbundle] for your own usage, like so:

    apm init --package ~/.atom/packages/language-ooc --convert https://github.com/nilium/ooc.tmbundle

You might need to restart Atom to see the changes.

## Brackets

The [Brackets editor][brackets] now has an extension for ooc syntax highlighting.
It can be installed from the Extensions Manager by searching for `ooc syntax`.
The source is available [on GitHub][brackets-ooc]

## gtksourceview

gtksourceview-based tools such as gedit, meld, etc. have
ooc support out of the box.

## pygments

[pygments][pygments] has relatively good ooc support built-in. It is a python
solution for syntax highlighting used on GitHub and easy to integrate with
static website generators such as [nanoc][nanoc].

[site-repo]: https://github.com/fasterthanlime/ooc-lang.org
[ooc.vim]: https://github.com/fasterthanlime/ooc.vim
[ooc-mode]: https://github.com/nixeagle/ooc-mode
[ooc.tmbundle]: https://github.com/nilium/ooc.tmbundle
[pygments]: http://pygments.org/ 
[nanoc]: http://nanoc.ws/ 
[sam]: https://github.com/fasterthanlime/sam
[atom]: https://atom.io/
[brackets]: http://brackets.io/
[brackets-ooc]: https://github.com/fasterthanlime/brackets-ooc
