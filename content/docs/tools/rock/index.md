---
title: rock
has_toc: true
---

## About rock

rock takes your ooc sources, tinkers around and, if you're lucky, gives you an executable.

## Basic usage

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
rm -rf .libs/
</pre>

then, recompile and see if it works.

## Advanced usage

### Keep the C sources

If rock somehow generates invalid C code and you want to know why, it can be helpful to actually
take a look at all the C. Normally, rock deletes everything it has generated at exit, but you can
tell rock to keep the sources for you:

<pre>
rock --noclean ...
</pre>

### More information

Also useful in these cases: Let rock tell its story of compilation. That means: print everything about
all stages of symbol resolution and code generation. Invoke rock with:

<pre>
rock -vv ...
</pre>

### Ditch gcc for your compiler of choice

Since gcc is the evergreen of compilers, rock uses it by default. In case you want to use something else
to turn your C sources into machine code, rock provides you with some alternatives:

<pre>
rock --gcc # if you change your mind
rock --tcc # the tiny c compiler
rock --icc # the intel c compiler
rock --clang # llvm's clang
rock --onlygen # no compiler
</pre>

The latter is especially useful if you want to compile your C code to assembler by hand.


