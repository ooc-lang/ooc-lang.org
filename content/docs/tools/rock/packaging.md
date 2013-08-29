---
title: Packaging
has_toc: true
---

## Intro

While ooc provides facilities to write highly cross-platform applications, and
makes it rather easy to develop on all these platforms, distributing standalone
applications is another matter entirely.

Until a tool comes along and in the darkness binds them, this chapter documents
the manual process that goes into releasing neatly packaged software for
Windows, OSX and Linux.

## Windows

Windows is surprisingly easy to package for — a 32-bit executable will happily
run on both 32-bit and 64-bit systems, there is no library path headache if you
include all the required DLLs in the same directory as the .exe, and the
current working directory is always the one with the .exe file.

### Dynamic GC

If your application is multi-threaded, make sure to link with the GC
dynamically as explained in [the Garbage Collection chapter][gc-win].

[gc-win]: /docs/tools/rock/gc/#threads

If you link statically with the GC and use multiple threads, chances are you
will run into very ugly memory corruption bugs that seemingly make no sense.
So, make sure to double-check that first.

Since you'll link dynamically with it, you'll need to include `libgc-1.dll`,
and you might also need `pthreadGC2.dll`, which lives in `/mingw/bin/` under
MinGW.

### Resource file

To bundle an icon with your executable, and add the full program name, author,
etc, create a .rc file containing something like that:

    id ICON "art/foo.ico"
    1 VERSIONINFO
    FILEVERSION     1,0,0,0
    PRODUCTVERSION  1,0,0,0
    BEGIN
      BLOCK "StringFileInfo"
      BEGIN
        BLOCK "040904E4"
        BEGIN
          VALUE "CompanyName", "Company Name"
          VALUE "FileDescription", "Application Name"
          VALUE "FileVersion", "1.0"
          VALUE "InternalName", "applicationname"
          VALUE "LegalCopyright", "Author Name"
          VALUE "OriginalFilename", "foo.exe"
          VALUE "ProductName", "Application Name"
          VALUE "ProductVersion", "1.0"
        END
      END
    
      BLOCK "VarFileInfo"
      BEGIN
        VALUE "Translation", 0x409, 1252
      END
    END

Adjust these values as needed. To create a high-quality `.ico` file from a
PNG image, the usage of a tool such as [IcoFX][icofx] might be needed.

[icofx]: http://icofx.ro/

Then, compile this `.rc` file with the `windres` command-line utility - if
you have a Makefile you might want to add a target for this.

    windres -i foo.rc -o foo.res -O coff

The final step to include these resources is to link them with your executable.
This can be done easily if you already have a .use file, by adding a section in
a `version(windows)` block. For example, in foo.use:

    Name: foo
    Version: 1.0
    Description: Foo builds upon bar baz and does wonderful stuff
    SourcePath: source
    Requires: bar, baz
    Main: foo/foo

    # Add resources on Windows
    version (windows) {
      Libs: ./foo.res
    }

Make sure to `use foo` in the main file of your application so that rock takes
these into account. The resulting executable should have the icon built-in,
along with the author and product information you have specified in the
`foo.rc` file.

Note that every time `foo.rc` changes, it needs to be recompiled to `foo.res`.
You don't need to distribute either the `.rc` or the `.res` file with the
executable, it's all baked in!

### DLL dependencies

To figure out which libraries someone will need to run your application, you can use
[Dependency Walker][depends], also known as `depends.exe`.

[depends]: http://www.dependencywalker.com/

Loading your .exe in it, with the right working directory, will allow you to
see which DLLs it loads and from where. Then, all you need is to copy those
DLLs to the directory of your application and distribute them along.

Be warned: there may be several versions of a given library on your system.
Make sure to pick the right one.

If your program can be launched by double-clicking on it in the Windows GUI
(instead of running it from the command-line), it's a good sign - but it might
not be enough. Some open-source programs install libraries to system paths, and
your application may be relying on that.

To make sure the application runs everywhere, testing it on a "virgin" install
of Windows is recommended. If there was a time to use a virtual machine, that
would be it.

### Final notes

You can choose to generate an installer of course, but a .zip file is fine as
well.  Windows systems usually have facilities to extract .zip files without
the need for an external program.

Creating a zip file can be done with the command line GNU zip utility:

    zip -r Foo-1.0-Windows.zip Foo-1.0-Windows

..or by using a graphical tool, for example, [7-Zip][7z]

[7z]: http://www.7-zip.org/

## OSX

Releasing an app on OSX is relatively easy, as tools exist to make it easier.
64-bit executables are the norm for recent versions of Mac OS X, so there is no
pain there either.

The only part where it needs a little hand holding is when creating the app
bundle.

### dylibbundler

We need to distribute libraries inside the app bundle - however, so that the
paths are resolve correctly, we'll need to use [dylibbundler][dyb] to modify
the executable and 'fix' the paths to these libraries.

[dyb]: http://macdylibbundler.sourceforge.net/

The first step is to tell the C compiler to reserve enough room to modify the
library paths later:

    rock +-headerpad_max_install_names

Then, we'll have to create a folder that will be our app bundle, such as
`Foo.app`, with the following directory structure:

    Foo.app/
      Contents/
        Info.pList
        MacOS/
          foo
          wrapper
        Resources/
          foo.icns
        libs/

`Contents/MacOS/foo` is our executable that we have copied from before, and
`Contents/MacOS/wrapper` will be our launcher script (described in a further
section).

The `Contents/MacOS` directory should also contain any files the executable
expects to find in the current working directory when launched (e.g. for game
that would be the graphics, sounds, etc.)

The next step is to dylibbundler on the executable so that libs are copied and
the paths are fixed:

    dylibbundler -od -b -x ./Foo.app/Contents/MacOS/helloworld -d ./Foo.app/Contents/libs/

### Info.pList

The `Info.pList` file is similar to the `foo.rc` file we discussed in the
Windows section. A stock plist file looks something like:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleGetInfoString</key>
      <string>Application Name</string>
      <key>CFBundleExecutable</key>
      <string>wrapper</string>
      <key>CFBundleIdentifier</key>
      <string>com.yourdomain.www</string>
      <key>CFBundleName</key>
      <string>applicationname</string>
      <key>CFBundleIconFile</key>
      <string>foo.icns</string>
      <!-- Don't modify those! -->
      <key>CFBundleShortVersionString</key>
      <string>1.0</string>
      <key>CFBundleInfoDictionaryVersion</key>
      <string>6.0</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>IFMajorVersion</key>
      <integer>0</integer>
      <key>IFMinorVersion</key>
      <integer>1</integer>
    </dict>
    </plist>

It should live in `Foo.app/Contents/Info.pList`. Just like a Windows RC file,
it references a `foo.icns` file. A tool like [img2icns][icns] can be used 
to convert a high-resolution PNG image to a Mac OSX icon.

[icns]: http://www.img2icnsapp.com/

### Launcher script

Finally, we have to use a launcher script so that the current working
directory of the app will be correct.

    #!bash
    #!/bin/bash
    cd "${0%/*}"
    ./foo

### Troubleshooting

It's not uncommon to encounter an error if an app Bundle is malformed or
otherwise problematic. Instead of double-clicking on the .app bundle to
launch it, one can open it from the command line:

    open Foo.app

If you get an "error -10180", it means something went wrong while launching
the app. Make sure the files inside `Contents/MacOS/` are executable, and
that the wrapper is trying to launch the correct executable.

In doubt, running `plutil` can help proofread the `pList` file:

    plutil Foo.app/Contents/Info.pList

### Final notes

OSX apps are sometimes encountered as `.dmg` files in the wild, which are
image files that contain partitions, which can be mounted and read from.
This allows a nice "drag and drop" window to be displayed.

However, distributing an OSX application by just zipping up the `.app`
bundle is acceptable. It can be done either on the command line:

    zip -r Foo.OSX.zip Foo.app

...or in the graphical interface (Right Click -> Compress Foo.app).

## Linux

Linux may be one of the comfiest platform for ooc development, but ironically,
it is one of the most painful to package standalone applications for. As a rule
of thumb, do not assume that your users will want to install libraries
themselves — always package them with the software.

### Multiarch

64-bit installs of Linux that aren't multi-arch will complaing about missing
32-bit libraries, and conversely, 32-bit installs won't be able to run a 64-bit
application at all. Which leaves us with the only option of providing both a
32-bit and a 64-bit executable.

An example folder hierarchy is:

    foo-1.0-linux/
      bin/
        foo32
        foo64
        libs32/
        libs64/
      foo.sh

Since we are going to ship dynamic libraries with the app, we should specify
the path where they are with the `-rpath` linker option. The rock command looks
a little bit like this:

    rock +-Wl,-rpath=bin/libs32 -o=foo32

...for the 32-bit version, and similarly for the 64-bit version.

### Chroot

One of the easiest ways to build both a 32-bit and a 64-bit executable is to
have a 64-bit VM of Ubuntu, and set up a 32-bit chroot inside of it, then copy
files out of the chroot to retrieve the binaries and associated libraries.

Setting up a chroot with debootstrap is [documented on the Ubuntu website][debchroot].

[debchroot]: https://wiki.ubuntu.com/DebootstrapChroot

### Copying libs

To figure out the libraries you need to copy to `libs32` or `libs64`, the `ldd`
command line utility can be used. Filtering its output to remove a few
libraries always present on Linux systems can help:

    #!bash
    ldd foo64 | egrep "(/usr/lib/)|(prefix64)" | cut -d ' ' -f 3 | egrep -v "lib(X|x|GL|gl|drm)"

The example above works for an OpenGL-based application. Copying these files
automatically can be done with a shell script such as:

    #!bash
    for l in $(ldd foo64 | egrep "(/usr/lib/)|(prefix64)" | cut -d ' ' -f 3 | egrep -v "lib(X|x|GL|gl|drm)" | tr '\n' ' '); do
      cp $l libs64/
    done

Checking that it well can be done by running `ldd bin/foo64` in the release
directory.  Here's some example output that shows the libs are resolved to
their relative paths:

    $ ldd bin/foo64
    libSDL2-2.0.so.0 => bin/libs64/libSDL2-2.0.so.0 (0x00007fc6fa615000)
    libSDL2_mixer-2.0.so.0 => bin/libs64/libSDL2_mixer-2.0.so.0 (0x00007fc6f9ee0000)
    libmxml.so.1 => bin/libs64/libmxml.so.1 (0x00007fc6f9cd3000)
    libfreetype.so.6 => bin/libs64/libfreetype.so.6 (0x00007fc6f9a37000)
    libyaml-0.so.2 => bin/libs64/libyaml-0.so.2 (0x00007fc6f9815000)

### Launcher script

Courtesy of [Ethan Lee][flibi], such a launcher script will detect the architecture
of the machine it's running on and launch the right executable:

[flibi]: https://twitter.com/flibitijibibo

    #!bash
    #!/bin/bash
    # Move to the script's directory
    cd "`dirname "$0"`"

    # Get the kernel/architecture information
    UNAME=`uname`
    ARCH=`uname -m`

    # Pick the proper executable
    if [ "$ARCH" == "x86_64" ]; then
      ./bin/foo64
    else
      ./bin/foo32
    fi

### Final notes

The `.tar.gz` or `.tar.bz2` archive formats is well-suited to distribute
applications for Linux, but `.zip` works just as well, and `.tar.xz` is usually
a little smaller.

To create a `.tar.gz`, do:

    tar czvf foo-1.0-linux.tar.gz foo-1.0-linux

To create a `.tar.bz2`, use `cjvf` instead.

TO create a `.tar.xz`:

    tar cf --xz foo-1.0-linux.tar.xz foo-1.0-linux

To create a `.zip`, do:

    zip -r foo-1.0-linux.tar.zip foo-1.0-linux

