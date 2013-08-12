---
title: SDK
has_toc: true
custom_toc:
  - ["lang", "/docs/sdk/lang/"]
  - ["structs", "/docs/sdk/structs/"]
  - ["math", "/docs/sdk/math/"]
  - ["os", "/docs/sdk/os/"]
  - ["net", "/docs/sdk/net/"]
  - ["text", "/docs/sdk/text/"]
  - ["threading", "/docs/sdk/threading/"]
  - ["native", "/docs/sdk/native/"]
---

## An overview of the SDK's packages

These pages will give you an overview of what you can find in the SDK:

 1. The [lang package](/docs/sdk/lang/) is imported by default in any ooc file.
    It contains essentials usable without further ado in any .ooc program.

 2. The [structs package](/docs/sdk/struct/) contains useful containers like
    lists and hash maps, but also stacks, and more cornercase stuff like
    multimaps and bags.

 3. The [math package](/docs/sdk/math/) is the home to everything numbers.

 4. The [os package](/docs/sdk/os/) contains lots of goodies, from time
    management to terminal handling, to launching processes, reading from
    pipes, getting hardware information, manipulating environment variables,
    creating a parallel job pool, and even coroutines and channels!

 5. The [net package](/docs/sdk/net/) has modules for relatively low-level
    network operations such as creating TCP and UDP sockets, and making DNS
    requests.

 6. The [text package](/docs/sdk/text/) contains a Regexp class, a JSON encoder
    and decoder, a simple template engine, a string tokenizer, an option
    parser, and a helper classes for escape sequences.

 7. The [threading package](/docs/sdk/threading/) contains all things threads.
    (Shocker, I know!)

 8. The [native package](/docs/sdk/native/) should not be imported directly -
    it contains platform-specific specific implementations of certain features.

If after reading those few pages you still have questions about the usage of
standard SDK modules, feel free to ask on our discussion group (see
[Community](/community)).

