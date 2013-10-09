---
title: Env
has_toc: true
---

## The os/Env module

The `Env` module allows to get and set environment variables.

    #!ooc
    import os/Env

Getting an environment variable:

    #!ooc
    path := Env get("PATH")

`get` will return `null` if the given environment variable is not set.

Setting an environment variable:

    #!ooc
    Env set("CFLAGS", "-Os")

Environment variables can be unset as well:

    #!ooc
    Env unset("PKG_CONFIG_PATH")

