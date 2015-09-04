---
title: The text package
has_toc: true
---

## The text package

This package contains various helper classes to work with text
and JSON.

## Escape sequences

The module `text/EscapeSequence` contains a class `EscapeSequence` which defines
some methods to work with backslash escape sequences. In the real world, you probably
just need the two following methods:

`escape` takes a string and converts all special characters to escape sequences.
In this context, special characters are:

 * non-printable characters
 * single and double quotes
 * backslashes

Use it like this:

    #!ooc
    escaped := EscapeSequence escape("This is\na 'String'")
    // now, `escaped` looks like this:
    escaped == "This is \\n a \\'String\\'"

But that is only one half of the truth: You can additionally pass a
string of all characters that should not be escaped as the
second argument:

    #!ooc
    escaped := EscapeSequence escape("This is\na 'String'", "'\n")
    // The method did not escape anything now.
    escaped == "This is\na 'String'"

`unescape` is useful if you have a string containing escape sequences
and you need a string with these sequences converted to their real character
counterparts. This method supports one-character escape sequences like
"\n", "\r" or "\t", but also hexadecimal sequences like "\x34".
Usage is easy:

    #!ooc
    "\\x27\\163up\\t\\x62ro\\n\\x3f" println()

which will print

    #!bash
    'sup	bro
    ?

## StringTokenizer

Sometimes, one needs to split a string at a special character and turn
it into an array. In ooc, the `text/StringTokenizer` module adds
every desirable variation of the good old `split` method to `Buffer` and `String`,
each returning an `ArrayList`:

    #!ooc
    import text/StringTokenizer
    import structs/ArrayList

    // split at a specific character
    "A|simple and stupid|example" split('|')
    // This creates an ArrayList:
    //  ["A", "simple and stupid", "example"]

    // split until a specific number of tokens is reached.
    // This will produce an ArrayList like
    //    ["A", "simple and stupid|example"]
    "A|simple and stupid|example" split('|', 2)

    // There is also a function to split at delimiters longer
    // than one char:
    ":-)A case :-)of intimidating:-)smiley abuse :-)" split(":-")
    // ... produces
    //  ["", "A case ", "of intimidating", "smiley abuse ", ""]

## StringTemplate

The `io/StringTemplate` module adds a lightweight `formatTemplate` string interpolation
function to strings, which can be used in cases where `format` is not enough. This function
uses a hashmap to access items by value:

{{=<% %>=}}

    #!ooc
    import text/StringTemplate
    import structs/HashMap

    values := HashMap<String, String> new()
    values put("day", "Saturday") \
          .put("weather", "cloudy")

    "Hi! Today's {{day}}, and it is a pretty {{  weather   }} {{ day }}!" formatTemplate(values) println()

<%={{ }}=%>

This will print:

    Hi! Today's Saturday, and it is a pretty cloudy Saturday!

As you can see, you can access the values by their keys, order isn't important
and you can interpolate one value multiple times.  
However, this is still pretty basic, since it does not support filters or control
structures, but this is often enough.

In case a key is referenced that does not exist in the hashmap, it will be
replaced by an empty string.

## Shell-like Lexer

The `text/Shlex` module implements a basic lexer for strings containing
quoted strings and backslash escape sequences. Basically, it splits an input
string into an Array, using whitespace characters as delimiters. Single and double
quotes can be used to include whitespace in the string items.

The public API can be accessed like this:

    #!ooc
    import text/Shlex
    import structs/ArrayList
    Shlex split("'This is a \\'quoted\\' string'     and I \"like \\x69\\x74.\"")
    // This produces the following ArrayList:
    // ["This is a 'quoted' string", "and", "I", "like it."]

This can be useful to parse command-line arguments. However, be careful, since
this module was not designed with security in mind.

## Regular Expressions

The SDK provides a simple cover for the [Perl Compatible Regular Expressions](http://www.pcre.org/)
library. Its use is pretty straightforward. First, you need to compile a regular
expression pattern, passing some options as a bitmask if you want to:

    #!ooc
    import text/Regexp

    pattern := Regexp compile("on (?P<year>[0-9]{4})-?P<month>[0-9]{1,2})-(?P<day>[0-9]{1,2})", RegexpOption CASELESS)
    pattern matches("foo") // this will return null, since the pattern could not be matched

    someDate := pattern matches("On 2013-08-07")
    // `someDate` is now a `Match` object. You can access groups by index or by name:
    someDate group(1)
    someDate group("year")
    // ... both return "2013".
    // Group zero is the whole matched string:
    someDate group(0) // is "On 2013-08-07"

    // You can also iterate over the matches. This will include
    // group 0 (the whole string), though.
    for(group in someDate) {
        // `group` is now a String.
    }

For more information about the Perl regular expression syntax, take a look
at the [Perl documentation](http://perldoc.perl.org/perlre.html).

## JSON

### Basic reading and writing

The `text/json/` package contains a JSON parser and generator, written in ooc
without external dependencies, which is able to deal with basic JSON. However,
if you care about speed or compliance (especially when dealing with numbers),
you should check out [ooc-yaml](https://github.com/fasterthanlime/ooc-yaml).

The JSON classes operate on nested [HashBags and Bags](/docs/sdk/structs/#bag-variants),
so if you parse JSON, you get some (Hash)Bags, and if you want to generate JSON, you need
to pass the data as (Hash)Bags.

To parse or generate JSON, you can just use the convenience `text/json` module.
Every function exists in two flavours: Normally, you need to pass the class
of your expected base value. So, for example, if you want to parse JSON like that:

    #!json
    ["Hi", "World"]

You need to pass `Bag` as the base value class. However, since most of the time
you will parse JSON objects that will represented by a `HashBag`, `HashBag` is
used by default if you do not pass a class explicitly.

Here are some examples:

    #!ooc
    import text/json
    import structs/HashBag

    // if you have a `Reader` (to read directly from a file, for example):
    import io/FileReader
    myObject := JSON parse(FileReader new("package.json"))

    // ... and if your base value is not a JSON object:
    import structs/Bag
    myArray := JSON parse(FileReader new("myarray.json"), Bag)

    // reading directly from strings is also supported:
    JSON parse("{\"hello\": \"world\"}")
    JSON parse("\"just a string\"", String)

    // and to generate JSON, there is:
    myBag := HashBag new()
    myBag put("integer", 1234) \
         .put("string", "Yes")

    import io/FileWriter
    JSON generate(FileWriter new("output.json"), myBag)

    myJSONString := JSON generateString(myBag)

When dealing with the `HashBag` class, you should take a look at its
[getPath](/docs/sdk/structs/#hashbag) function, which will save you
a lot of typing.

### A JSON generation DSL

If you find yourself generating a lot of JSON, you might find
the `HashBag`/`Bag` objects create a lot of syntactic noise. For this
reason, the SDK contains another convenience module implementing
a small DSL for JSON generation.

    #!ooc
    // Let's import the module into a namespace, since `make`
    // is a bit ambiguous.
    import text/json/DSL into JSON

    data := JSON make(|j|
        j object(
            "some-key",
                "some-value",
            "here comes a list",
                j array(
                    1, 2, "three", 4
                ),
            "and a nested object",
                j object(
                    "true", true
                )
        )
    )
    data println()

`make` creates a helper object with `object` and `array` functions and passes
it to the function you provide; using a closure is the most convenient way here.
You can use `object` to create JSON objects, passing as many key-value pairs
as you want, and `array` for JSON arrays.

When it's done, it returns the JSON data as a string.
