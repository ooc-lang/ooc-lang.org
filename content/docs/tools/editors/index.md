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

## gtksourceview

gtksourceview-based tools such as gedit, meld, etc. have
ooc support out of the box.

## pygments

[pygments][pygments] has relatively good ooc support built-in. It is a python
solution for syntax highlighting used on GitHub and easy to integrate with
static website generators such as [nanoc][nanoc].

[site-repo]: https://github.com/nddrylliog/ooc-lang.org
[ooc.vim]: https://github.com/nddrylliog/ooc.vim
[ooc-mode]: https://github.com/nixeagle/ooc-mode
[ooc.tmbundle]: https://github.com/nilium/ooc.tmbundle
[pygments]: http://pygments.org/ 
[nanoc]: http://nanoc.ws/ 
[sam]: https://github.com/nddrylliog/sam

