---
title: SDK
has_toc: true
index: true
---

## An overview of the SDK's packages

These pages will give you an overview of what you can find in the SDK:

 1. The [lang](/docs/sdk/lang/) package is imported by default in any ooc file.
    It contains essentials usable without further ado in any .ooc program.

 2. The [structs](/docs/sdk/structs/) package contains useful containers like
    lists and hash maps, but also stacks, and more cornercase stuff like
    multimaps and bags.

 3. The [io](/docs/sdk/io/) package has modules for reading files, writing
    to files, and other input/output related matters.

 4. The [math](/docs/sdk/math/) package is the home to everything numbers.

 5. The [os](/docs/sdk/os/) package contains lots of goodies, from time
    management to terminal handling, to launching processes, reading from
    pipes, getting hardware information, manipulating environment variables,
    creating a parallel job pool, and even coroutines and channels!

 6. The [net](/docs/sdk/net/) package has modules for relatively low-level
    network operations such as creating TCP and UDP sockets, and making DNS
    requests.

 7. The [text](/docs/sdk/text/) package contains a Regexp class, a JSON encoder
    and decoder, a simple template engine, a string tokenizer, an option
    parser, and a helper classes for escape sequences.

 8. The [threading](/docs/sdk/threading/) package contains all things threads.
    (Shocker, I know!)

 9. The [native](/docs/sdk/native/) package should not be imported directly -
    it contains platform-specific specific implementations of certain features.

If after reading those few pages you still have questions about the usage of
standard SDK modules, feel free to ask on our discussion group (see
[Community](/community)).

