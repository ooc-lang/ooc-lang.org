---
title: Development
has_toc: true
---

## Reporting bugs

If you find a bug in rock, you should [report it][gh-issues]! But before you do, please make sure you have the latest version installed, and see if you can still reproduce the bug there. It is also helpful to make sure the issue hasn't already been reported - a quick search should take care of that.

[gh-issues]: https://github.com/ooc-lang/rock/issues/new

## Submitting feature requests

If you have a particular itch to scratch and you think it would make a nice addition to the ooc language, its compiler, or one of its assorted tools, feel free to open an issue on the relevant GitHub repository. However, bear in mind that we are trying to keep bloat to a minimum (well, at least to prevent it from getting worse), and feature requests have lower priorities than bug reports.

You can read a list of [pending feature requests][rock-features] on rock's GitHub issue tracker.

[rock-features]: https://github.com/ooc-lang/rock/issues?labels=Feature&state=open

## Getting the source code

The source code for rock is available in the [rock repository on github][rock-repo].

[rock-repo]: https://github.com/ooc-lang/rock/

Here's how we handle branches:

  * The `master` branch contains the latest stable release - important fixes are sometimes backported there.
  * Upcoming releases leave in their own branch. For rock 0.9.7, that would be the branch '97x'.

If you want to benefit from the latest features and bugs, feel free to follow these instructions to [live on the edge](/install/#installing-from-git).
