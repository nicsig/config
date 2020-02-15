# Where did you find the interSubs plugin?

<https://github.com/oltodosel/interSubs>

# Which files does the plugin install?

   - `interSubs.lua`
   - `interSubs.py`
   - `interSubs_config.py`

##
# How to
## change the keys to press to start/quit interSubs?

By default, the keys are `F5` and `F6`.
If you wanted to use `F1` and `F2` instead:

    $ sed -i "s/keybinding\s*=\s*'F5'/keybinding = 'F1'/" interSubs.lua
    $ sed -i "s/keybinding\s*=\s*'F6'/keybinding = 'F2'/" interSubs.lua

## make interSubs start automatically when I watch a video in a directory containing `XDCC` in its path?

    $ sed -i "s/^autostart_in = {'.*'}/autostart_in = {'XDCC'}/" interSubs.lua

## change the browser and the site opened when I left-click on a word?

Edit `interSubs_config.py`, and replace this line:

    show_in_browser = 'chromium "http://www.linguee.com/german-english/search?source=german&query=${word}"'

With this one:

    show_in_browser = 'firefox "https://www.linguee.com/english-french/search?query=${word}"'

## increase the distance between the subtitles and the bottom of the video?

Edit `interSubs_config.py`, and replace this line:

    subs_screen_edge_padding = 1

With this one:

    subs_screen_edge_padding = 40

## change the appearance of the subtitles?

Change the value of the `style_subs` variable in `interSubs_config.py`.

A working value is:

    style_subs = '''
            /* looks of subtitles */
            QFrame {
                    background: transparent;
                    color: white;

                    font-family: "Trebuchet MS";
                    font-weight: bold;
                    font-size: 53px;
            }
    '''

## get the audio pronunciation of a word?

That's what the `f_listen` function is for.

You can bind it to a key in `interSubs_config.py`.

For example, to bind it to a right click:

    mouse_buttons = [
            ['RightButton',              'NoModifier',           'f_listen'],
            ...

## change the webservice used to pronounce words?

Edit `interSubs_config.py`, and assign one these values to `'forvo'`:

   - gtts
   - pons
   - forvo

##
# Issues
## Which pitfall should I avoid after redownloading the plugin from github?

The original files are indented with tabs.

If you re-download them, remove the tabs.

Otherwise, if you edit one of them later, you may introduce a line indented with
spaces, and the python interpreter won't like the mix of indentation (some lines
indented with tabs, others with spaces).

##
## The plugin doesn't work!

Run `mpv` from the command-line to get more information.

You probably  need a  more recent version  of the Python  interpreter –  and pip
which should come with it – as well as these Python libraries:

   - beautifulsoup4
   - lxml
   - numpy
   - pyqt5
   - requests
   - six
   - soupsieve

---

If you have issues to install one of those libraries, try to find them on github.
Example:

    https://github.com/facelessuser/soupsieve

Then, cd into the project, and run:

    $ python3 -m pip install --user --upgrade .

Note that sometimes, the installation fails because of a dependency.
In this case, install the dependency, then retry the original installation.

For beautifulsoup4, don't dl from github; dl from here:
<https://www.crummy.com/software/BeautifulSoup/bs4/download/>

---

Also, see this issue:

    https://github.com/oltodosel/interSubs/issues/9

### When I try to manually install/update the `lxml` library, an error is raised because of `Cython`!

    $ git clone https://github.com/lxml/lxml
    $ cd lxml
    $ python3 -m pip install --user --upgrade .
    RuntimeError: ERROR: Trying to build without Cython, but pre-generated 'src/lxml/etree.c' is not available (pass --without-cython to ignore this error).~


Install the python package `cython`:

    $ cd ..
    $ git clone https://github.com/cython/cython
    $ cd cython
    $ python3 -m pip install --user --upgrade .

Then, the deb packages `libxml2-dev` and `libxslt1-dev`:

    # https://stackoverflow.com/a/15761014/9780968
    $ sudo aptitude install libxml2-dev libxslt1-dev

Finally, retry installing `lxml`:

    $ cd ../lxml
    $ python3 -m pip install --user --upgrade .

### Which influence does the version of my python interpreter (e.g. `v3.5` vs `v3.7`) has over an installed library?

It  determines  the installation  location  of  the  library, and  which  python
interpreter will be able to use the latter.

Each python version has its own libraries.
For example, if both python3.5 and  python3.7 are installed on your machine, and
you've installed the library `six` with both of them:

    $ python3.5 -m pip install --user --upgrade six
    $ python3.7 -m pip install --user --upgrade six

They will be located in 2 directories:

    $ ls -l ~/.local/lib/python3.5/site-packages | grep six
    drwxrwxr-x  2 ... six-1.12.0-py3.5.egg-info~
    -rw-rw-r--  1 ... six.py~

    $ ls -l ~/.local/lib/python3.7/site-packages | grep six
    drwxrwxr-x  2 ... six-1.12.0-py3.7.egg-info~
    -rw-rw-r--  1 ... six.py~

### Why using `$ python3 -m pip install ...` instead of `$ python3.X -m pip install ...`?

To be sure that you install your library for the same interpreter that interSubs
will run later.

When you run  `$ python3 -m pip  install ...`, you install a  python library for
the interpreter called by `python3`.
interSubs will *also* call `python3`, and so should run the same interpreter.

---

Even though the shebang of `interSubs.py` is:

    #! /usr/bin/env python

which, atm, runs  python2.7, interSubs runs `$  python3` because `interSubs.lua`
contains this line:

    # line 13
    start_command = 'python3 "%s" "%s" "%s"'
                           ^

##
## I have an error message!
### “No module named 'PyQt5.QtCore'”

Install `python3-pyqt5`:

    $ api python3-pyqt5

###
### “Cannot find main.* for any supported scripting backend in: ...”

`~/.config/mpv/scripts/` should  only contain lua scripts,  or files/directories
with the extension `.disable`.  See `man mpv /LUA SCRIPTING/;/^\s*Script location/`.

interSubs automatically creates a `__pycache__/` and an `urls/` directories.
Those may be the cause of these warnings.
They  don't  prevent  interSubs  from  working,  but if  you  want  to  get  rid
of  them,  remove  `__pycache__/`  and `urls/`,  then  move  `interSubs.py`  and
`interSubs_config.py` inside a  directory whose name ends  with `.disable`; e.g.
in `python.disable/`.

You'll also need to inform `interSubs.lua` of the new location of `interSubs.py`.

    # ~/.config/mpv/scripts/interSubs.lua
    pyname = '~/.config/mpv/scripts/python.disable/interSubs.py'
                                    ^^^^^^^^^^^^^^^
                                    new path component

And  you'll  need to  inform  `interSubs.py`  of the  new  location  of the  new
directory where the `interSubs_config.py` lives:

    # ~/.config/mpv/scripts/python.disable/interSubs.py
    pth = os.path.expanduser('~/.config/mpv/scripts/python.disable/')
                                                    ^^^^^^^^^^^^^^^

Note that these warnings start from this commit:
<https://github.com/mpv-player/mpv/commit/00cdda2ae80f2f3c5b6fc4302d7edaf14755d037>

#### “Can't load unknown script: ...”

It's a similar issue.
You have a file in `~/.config/mpv/scripts/`  which is not recognized as a lua script.

##
## The subtitles get invisible when I start interSubs!

Try to update `pyqt5`.

Or comment this `return` statement in `interSubs.py`:

    if not self.psuedo_line:
        self.psuedo_line = 1
        return

<https://github.com/oltodosel/interSubs/issues/17>

The purpose of `return` is to get  rid of some flickering introduced by a recent
version of `pyqt5` (5.12).

## I can't get a whole sentence to be translated!

That's what the `f_deepl_translation` function is for.

However, at the moment, it doesn't work:

    {'jsonrpc': '2.0', 'error': {'message': 'Too many requests.', 'code': 1042901}}

It may be due to our AS being blacklisted by [deepl.com](https://www.deepl.com/translator).

Or maybe you need to subscribe to a pro account:

<https://www.deepl.com/pro.html#api>

Or it may be related to one of these issues:

- <https://github.com/m9dfukc/deepl-alfred-workflow/issues/14#issuecomment-402965296>
- <https://github.com/vsetka/deepl-translator/issues/9>

Don't open an issue: <https://github.com/oltodosel/interSubs/issues/19>

