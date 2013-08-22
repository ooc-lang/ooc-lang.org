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
    import net/[ServerSocket]

    socket := ServerSocket new("0.0.0.0", 8000)
    socket listen()
    "Listening..." println()

    while(true) {
        conn := socket accept()
        "Got a connection!" println()

        while (conn in readLine() trim() != "") {
          // read the request
        }

        conn out write("HTTP/1.1 200 OK\r\n")
        conn out write("Content-Type: text/html\r\n")
        conn out write("\r\n")
        conn out write("<html><body>\
          Hello, from the ooc socket world!</body></html>")
        conn out write("\r\n")
        conn close()
    }

Don't forget to call `listen()` before trying to `accept()` connections.

### TCPSocket

Same as the ServerSocket, but on the client side. Make requests like
that (or don't - use a proper HTTP library):

    #!ooc
    import net/[TCPSocket]

    socket := TCPSocket new("ooc-lang.org", 80)
    socket connect()
    socket out write("GET / HTTP/1.1\n")
    socket out write("Host: ooc-lang.org\n")
    socket out write("User-Agent: An anonymous admirer\n")
    socket out write("\n\n")

    line := socket in readLine()
    "We got a response! %s" printfln(line)

Seriously. Use a proper HTTP library. But that's an example.

Also, don't forget to call `connect()` before attempting to use `out`
or `in`.

## UDP

Unlike TCP, UDP is unidirectional - some sockets bind and only get to
receive, and some sockets don't bind and can only send.

There's also no guarantee that anything sent over UDP ever arrives, and
order is not guaranteed either.

### UDPSocket

When you create an `UDPSocket`, always specify a hostname (or an ip) and a port, like this:

    #!ooc
    socket := UDPSocket new("localhost", 5000)

If you want to receive datagrams, call bind():

    #!ooc
    socket bind()

    while (true) {
      buffer := socket receive(128)
      buffer toString() println()
    }

If you want to send datagrams, just call send:

    #!ooc
    socket send("udp is fun")

That's about it for now.


