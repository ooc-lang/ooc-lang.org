---
title: Basic rock usage
has_toc: true
---

## Using rock, the basic way

If you have a usefile, calling rock is pretty easy:

<pre>
rock
</pre>

will look for usefiles in your current directory and, if possible, build them.

Since the world is not always perfect, it's also possible to pass an `.ooc` file directly:

<pre>
rock mmorpg.ooc
</pre>

Sadly, it's possible that rock thinks your ooc code is alright and passes the C files to your
C compiler which then prints pages of errors and explodes subsequently.
In that case, you'll need to increase rock's verbosity to see the compiler output:

<pre>
rock -v ...
</pre>

Building an executable and tired of typing `./mmorpg` all over again?

<pre>
rock -r ...
</pre>

will run your executable after having built it successfully.

To speed up the compilation process and to save you some time, rock caches compiled dependencies
in a hidden subdirectory called `.libs`. In most cases, this is awesome, but sometimes, something
goes wrong and you get pretty strange unexplainable error messages. Just to be sure, you can just

<pre>
rock -x
</pre>

then, recompile and see if it works.
