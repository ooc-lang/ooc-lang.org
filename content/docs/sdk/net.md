---
title: The net package
has_toc: true
---

## The net package

When you want to deal with TCP and UDP sockets directly, the `net` package is
here for you.

## TCP

TCP guarantees that packets arrive eventually, and that they arrive in the
order in which they were sent.

Usually, on the server side, sockets are bound to a port, and then listen.
When clients attempt to connect, they accept connections (and can later
close them if so they wish).

Accepting a connection via a server socket gives a TCPSocket - so, after
a client has connected, the client and the server use the same data structure
to communicate.

A Socket, like a `TCPSocket`, has a reader / writer pair, since sockets
are bidirectional communication channels. Which means they can write data
to the writer, and read data from the reader.

For more info on readers and writers, go ahead and read (heh) the documentation
on the [io package][io]

[io]: /docs/sdk/io/

### ServerSocket

Here's an example usage of ServerSocket serving as a makeshift HTTP
server (don't do that, though):

    #!ooc
    socket := ServerSocket new("0.0.0.0", 8000)

    while(true) {
        conn := socket accept()
        conn out write("<html><body>\
          Hello, from the ooc socket world!</body></html>")
        conn close()
    }

### TCPSocket

Same as the ServerSocket, but on the client side. Make requests like
that (or don't - use a proper HTTP library):

    #!ooc
    socket := TCPSocket new("ooc-lang.org", 80)
    socket connect()
    socket out write("GET / HTTP/1.1\n")
    socket out write("Host: ooc-lang.org\n")
    socket out write("User-Agent: An anonymous admirer\n")
    socket out write("\n\n")

    line := socket in readLine()
    "We got a response! %s" printfln(line)

Seriously. Use a proper HTTP library. But that's an example.

## UDP



