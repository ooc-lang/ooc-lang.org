---
title: About ooc
has_toc: true
---

## What is ooc?

ooc was born out of the desire to write cross-platform applications with
a concise, yet clear syntax, and to produce native binaries rather than
relying on a downloadable runtime.

It's a general-purpose, language with a source-to-source compiler (to C99),
and a portable SDK, readily available bindings for quite a few C libraries,
a flexible module system, testing facilities and a set of utilities to make
one's life easier.

## History

It was 2009, <abbr title="Amos Wenger (also - wow, you can aim).">I</abbr> had
just started studying micro-engineering at <abbr title="Ecole Polytechnique Fédérale de Lausanne">EPFL</abbr>,
and we were given a programming assignment, something about a prey/predator
simulation.

After having spent years using Java in my spare time, I did not want to go
back to something as low-level as C, so I did what any lazy programmer would
have done: I spent the first few months writing a source-to-source compiler
from a Java-ish language to C, and then the last 48 hours actually coding the
project.

Everything turned out fine - I got the maximum grade, and immediately began
rewriting the compiler ([implemented in Java][jooc], back then). And then I
rewrote it again.

[jooc]: https://github.com/nddrylliog/jooc-legacy

A community started to form around it. By 2011, we were overy fourty regulars
on the IRC channel. Then, time passed, some of us got jobs, we had our share
of leadership problems within the project, and interest in the project slowly
faded.

A small team kept maintaining the compiler and SDK in the background. Bugs were
fixed, long-awaited features were implemented. Development has quietly continued,
and the project was never actually abandoned. After a long while with just
a single page website, we decided to rebuild a proper one to help newcomers
get up and running quickly. You are reading it right now!

## Why use ooc?

It's a hard choice to make nowadays, to spend a chunk of your time learning
and writing a codebase in a language that isn't "mainstream". Some would
argue, not without reason, that it is a dangerous enterprise - that choosing
a more established platform is the right thing to do. That hobby programming
language skills aren't marketable, etc., etc.

However, a good programmer is a good programmer in any language. Discovering
new ways of perceiving, designing, and manufacturing pieces of software is
always a worthy pursuit.

Hence, for small to medium-sized, personal projects - a personal command-line
utility, a graphical front-end for an application you like, a custom piece of
zeromq-powered network infrastructure, or an indie game - ooc is a practical
alternative to what's out there.

It's been a while since the "marketing" phase of the ooc project has been
abandoned. Although it is motivating to push for adoption, imperatives like
paying the bills, maintaining healthy relationships, and preserving one's
sanity, have pushed for a more intimate approach to development.

Since its inception, many novelty programming languages have come and gone.
The naiveté of youth, combined with a relentless thirst for experimentation,
have inspired many developers to try and do their own thing. ooc survived
through sheer, continued usefulness.

I sincerely hope you find it useful, quirky, and enlightening as well.
