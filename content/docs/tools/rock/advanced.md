---
title: Advanced rock usage
has_toc: true
---

## Using more rock options

Often, rock does the right thing by itself, but if it doesn't, you can use some of these more
advanced options and flags.

## Keep the C sources

If rock somehow generates invalid C code and you want to know why, it can be helpful to actually
take a look at all the C. Normally, rock deletes everything it has generated at exit, but you can
tell rock to keep the sources for you:

<pre>
rock --noclean ...
</pre>

## More information

Also useful in these cases: Let rock tell its story of compilation. That means: print everything about
all stages of symbol resolution and code generation. Invoke rock with:

<pre>
rock -vv ...
</pre>

## Ditch gcc for your compiler of choice

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


