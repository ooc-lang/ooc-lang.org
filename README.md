# ooc-lang.org

This is the Markdown sources for the ooc language website, <https://ooc-lang.org>

## Building

[nanoc][] is used to transform Markdown into HTML. It's a piece of ruby software.

To build the website, make sure that you have Ruby 2.x+, run this once:

```bash
bundle install
```

(If you don't have `bundle`, get it with `gem install bundler`)

And then run this everytime you want to build it:

```bash
bundle exec nanoc
```

[nanoc]: http://nanoc.ws/

## Deploying

nanoc produces output in the `output/` directory as per `nanoc.yaml`, we host
the website on Github Pages for free hosting, which means you can deploy by
doing the following:

Once:

```bash
git clone git@github.com:ooc-lang/ooc-lang.github.io.git output
```

After building the site, every time you want to deploy:

```bash
(cd output && git add . && git commit -m "Changed this and that" && git push origin master)
```

(Note: since the deploy repo is named `ooc-lang.github.io`, the `master` branch
is used rather than the `gh-pages` branch.)

## Links

  * The nanoc project: <http://nanoc.ws/>
