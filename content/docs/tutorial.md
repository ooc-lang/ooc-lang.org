---
title: Tutorial
has_toc: true
---

## Once Upon A Time...

Once upon a time, there was a sysadmin who wanted to make sure her website
was always online. However, she figured that she was pretty good at compiling,
installing, and configuring software, but that her programming skills were a bit
rusty.

Oh, sure, she remembered her days at university where she learned a bit of Java,
and C++, and the cool mind-bending exercises in LISP, but today she felt like trying
something new. She followed the [installation instructions][install] carefully, and then
jumped in without waiting.

[install]: /install/

After fishing online for information, she decided to start with the following
program:

    #!ooc
    "The website may or may not be online." println()

Saving it as `watchcorgi.ooc` and running `rock -v watchcorgi` sure produced a lot
of output. And - as a token of its appreciation, the compiler even left an executable
on the hard drive. What a promising relationship, she thought.

However, not one to be overly chatty, she decided that instead of having to type
`rock watchcorgi` every time she wanted to compile her new program, she was going
to write a [usefile][use] for it, and put them both together in a directory.

[use]: /docs/tools/rock/usefiles

    #!text
    Name: Watch Corgi
    Description: Tells on the bad websites that go down
    Version: 0.1.0
    SourcePath: source
    Main: watchcorgi

Saving it as `watchcorgi.use`, she realized that, if she wanted her usefile to be
valid, she needed to move her ooc module into `source/watchcorgi.ooc`. So then, her
folder hierarchy now looked like:

    .
    ├── source
    │   └── watchcorgi.ooc
    └── watchcorgi.use

Now, all she had to do was type `rock` to have her program compiled. If she felt
like reading a bit, all she had to do was `rock -v` - it reminded her of the countless
hours spent installing packages on Gentoo.

## The Great Illusion

However, that program was not quite as useful as she had hoped so far. While it was
technically correct — the best kind of correct — it did not, in fact, bring any new
information to the table.

That was not meant to last, though, as she quickly devised a devious scheme. Before
the era of watchcorgi, she was using `curl`, a command-line utility, to check if the
website was still online. It looked a little something like this:

    #!bash
    curl -I http://example.org/

(Of course, that wasn't her website's actual URL, which we have sneakingly substituted
with something a tad more common, in order to protect our heroin's privacy.)

Running that simple command was enough to let her know, with a simple look, whether
the website was up and running or down in the ground — in which case prompt maintenance
was needed as soon as humanly possible.

She decided that if she could run that command herself, there was no reason why her
program couldn't do so as well. After a second documentation hunt, she quickly jotted
down a few more lines, replacing the contents of `source/watchcorgi.ooc` with this:

    #!ooc
    import os/Process
    
    exitCode := Process new(["curl", "-I", "http://example.org/"]) execute()
    "Sir Curl exited with: %d" printfln(exitCode)

And sure enough, after a quick recompilation, she saw the expected result: `Sir Curl
exited with: 0`. Curious, she disconnected from the internet, and tried launching
`./watchcorgi` again. This time, she saw: `Sir Curl exited with: 6`.

"It's just like it always is with Unix-like tools" she thought. "An exit code of 0
is a good sign, anything else... not so much. It sure is convenient to be able
to import another ooc module for almost everything. Apparently, this `Process` class
takes an array with the command arguments. And this `execute` method returns the
exit code. Neato!" And so it was.

## Form Follows Function

She was starting to be happy with her program. For all intents and purposes, was doing
its job, and it was doing its job well. However, she could not deny that her program
could have put a little more effort in the presentation. Just because a program does
not have a will of its own, doesn't mean it's okay for it to be rude.

"Time to get to work", she said out loud, forgetting that it was past 2 in the morning,
and that nobody could probably hear her - and even if they could, there was no
certainty that they would agree. While she thought about that, her fingers had kept
tapping on the keyboard. Her program now looked a little bit like that:

    #!ooc
    import os/[Process, Terminal]

    exitCode := Process new(["curl", "-I", "http://example.org/"]) execute()

    match (exitCode) {
      case 0 =>
        "Everything is fine." println()

      case =>
        Terminal setFgColor(Color red)
        "[ERROR] The website is down!" println()
        Terminal reset()
    }

It didn't blink, and there were no 3D effects: disappointing maybe for a sci-fi
fan like her little brother, but having alerts in red, and a human-readable message
was fine enough for her.

While carefully proofreading her code to check if she hadn't missed anything, she
thought about the syntax of the `match` construct. "It's pretty smart, in fact.
Cases are tested from top to bottom - the first that matches, wins. And a case with
no value simply matches everything". It just made sense.

She was also particularly happy with the way she was able to import both `os/Process`
and `os/Terminal` from the same line. Sure, she could have written two different
`import` directives, but she had been promised a concise programming language and it
was about time it delivered.

## Corgi Ever Watching

Now that the program was polite, our programmer felt good enough to take a
small break. As she was looking out the window, waiting for her 3rd cup of
nocturnal coffee to brew, it came to her: "Wait a minute... what good is my
program if I have to keep running it manually?"

A quick sip out of her coffee cup finished to clear her mind completely.
"I am going to need some sort of loop. And I think watchcorgi should shut
up if everything is fine, and only complain if something goes wrong."

As she looked at her timer, waiting for it to run out and allow her to go back
to hacking (self-discipline is important, after all), she came to a second
realization: that there were two main tasks in her program - the checking, and
the notifying. Surely there must be some way to write that in a more modular
way?

She decided to go for broke, and split her program into three different ooc
modules. She started with `source/watchcorgi/checker.ooc`:

    #!ooc
    import os/[Process]

    Checker: class {
      url: String

      init: func (=url)

      /**
       * @return true if the url is reachable, false otherwise
       */
      check: func -> Bool {
        0 == Process new(["curl", "-I", url]) execute()
      }
    }

Then went on with `source/watchcorgi/notifier.ooc`:

    #!ooc
    import os/[Terminal]

    Notifier: class {
      quiet: Bool

      init: func

      notify: func (online: Bool, url: String) {
        if (online) {
          if (quiet) return

          Terminal setFgColor(Color green)
          "[ OK  ] %s is online." printfln(url)
          Terminal reset()
        } else {
          Terminal setFgColor(Color red)
          "[ERROR] %s is not reachable! You may panic now." printfln(url)
          Terminal reset()
        }
      }
    }

And finally, thought it was better to rewrite `source/watchcorgi.ooc` from
scratch using those new modules:

    #!ooc
    import watchcorgi/[checker, notifier]
    import os/Time

    notifier := Notifier new()
    notifier quiet = true // only bother me if something goes wrong
    checker := Checker new("http://example.org/")
    
    while (true) {
      Time sleepSec(5)
      notifier notify(checker check(), checker url)
    }

There. All good. Not only was her program now constantly vigilant, checking
for potential problems every five seconds, she felt that the various components
were just as flexible as needed, small enough, and that it made the main program
file short and sweet.

## The Littlest Things

There was one area of the code she wasn't entirely happy with - in the
notifier, she was using the same pattern twice. First `Terminal setFgColor`,
then `String printfln`, then `Terminal reset`.  She decided to extract that
pattern into a function instead, and added it to the end of the the `Notifier`
class definition:

    #!ooc
    say: func (color: Color, message: String) {
      Terminal setFgColor(color)
      message println()
      Terminal reset()
    }

With that new neighbor, the notify function was happy to be reduced to:

    #!ooc
    notify: (online: Bool, url: String) {
      if (online) {
        if (quiet) return
        say(Color green, "[ OK  ] %s is online" format(url))
      } else {
        say(Color red, "[ERROR] %s is not reachable! You may panic now." \
          format(url))
      }
    }

While this was better, she wasn't satisfied yet - calling `format` like this
(she thought of it as a version of `printfln` that returned the formatted string
instead of printing it) wasn't particularly pretty.

Like with everything that bothered her, she decided to do something about it:

    #!ooc
    say: func (color: Color, message: String, args: ...) {
      Terminal setFgColor(color)
      message printfln(args)
      Terminal reset()
    }

    notify: func (online: Bool, url: String) {
      if (online) {
        if (quiet) return
        say(Color green, "[ OK  ] %s is online", url)
      } else {
        say(Color red, "[ERROR] %s is not reachable! You may panic now.", url)
      }
    }

It was subtle, but for her, it made all the difference. Being able to relay
any number of arguments like that? This language might actually be comfortable
after all.

## All Together Now





