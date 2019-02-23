# Where did you find the interSubs plugin?

<https://github.com/oltodosel/interSubs>

# Which files does the plugin install?

   - `interSubs.lua`
   - `interSubs.py`
   - `interSubs_config.py`

##
# How to change the keys to press to start/quit interSubs?

By default, the keys are `F5` and `F6`.
If you wanted to use `F1` and `F2` instead:

    $ sed -i "s/keybinding\s*=\s*'F5'/keybinding = 'F1'/" interSubs.lua
    $ sed -i "s/keybinding\s*=\s*'F6'/keybinding = 'F2'/" interSubs.lua

# How to make interSubs start automatically when I watch a video in a directory containing `XDCC` in its path?

    $ sed -i "s/^autostart_in = {'.*'}/autostart_in = {'XDCC'}/" interSubs.lua

# How to change the browser and the site opened when I left-click on a word?

Edit `interSubs_config.py`, and replace this line:

    show_in_browser = 'chromium "http://www.linguee.com/german-english/search?source=german&query=${word}"'

With this one:

    show_in_browser = 'firefox "https://www.linguee.com/english-french/search?query=${word}"'

# How to increase the distance between the subtitles and the bottom of the video?

Edit `interSubs_config.py`, and replace this line:

    subs_screen_edge_padding = 1

With this one:

    subs_screen_edge_padding = 40

# How to change the appearance of the subtitles?

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

# How to get the audio pronunciation of a word?

That's what the `f_listen` function is for.

You can bind it to a key in `interSubs_config.py`.

For example, to bind it to a right click:

    mouse_buttons = [
            ['RightButton',              'NoModifier',           'f_listen'],
            ...

---

If it fails with this error:

    Traceback (most recent call last):1%) A-V:  0.000
      File "/home/user/.config/mpv/scripts/interSubs.py", line 1286, in mousePressEvent
        exec('self.%s(event)' % mouse_action[2])
      File "<string>", line 1, in <module>
      File "/home/user/.config/mpv/scripts/interSubs.py", line 1302, in f_listen
        listen(self.word, config.listen_via)
      File "/home/user/.config/mpv/scripts/interSubs.py", line 675, in listen
        gTTS(text = word, lang = config.lang_from, slow = False).save('/tmp/gtts_word.mp3')
      File "/home/user/.config/mpv/scripts/interSubs.py", line 878, in save
        self.write_to_fp(f)
      File "/home/user/.config/mpv/scripts/interSubs.py", line 891, in write_to_fp
        'tk' : self.token.calculate_token(part)}
      File "/home/user/.config/mpv/scripts/interSubs.py", line 719, in calculate_token
        seed = self._get_token_key()
      File "/home/user/.config/mpv/scripts/interSubs.py", line 752, in _get_token_key
        tkk_expr = re.search(".*?(TKK=.*?;)W.*?", line).group(1)
    AttributeError: 'NoneType' object has no attribute 'group'
    AV: 00:01:17 / 01:52:31 (1%) A-V:  0.000

Set `listen_via` to `'forvo'`:

    listen_via = 'forvo'

<https://github.com/oltodosel/interSubs/issues/18>

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

A module is probably missing; run `mpv` from the command-line to see which one.

You probably  need a  more recent version  of the Python  interpreter –  and pip
which should come with it – as well as these Python modules:

   - beautifulsoup4
   - lxml
   - numpy
   - pyqt5
   - requests
   - six
   - soupsieve

---

If you have issues to install one of those modules, try to find them on github.
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

### When I try to manually install/update the `lxml` module, an error is raised because of `Cython`!

    $ git clone https://github.com/lxml/lxml
    $ cd lxml
    $ python3 -m pip install --user --upgrade .
    RuntimeError: ERROR: Trying to build without Cython, but pre-generated 'src/lxml/etree.c' is not available (pass --without-cython to ignore this error).~


Install the python module `cython`:

    $ cd ..
    $ git clone https://github.com/cython/cython
    $ cd cython
    $ python3 -m pip install --user --upgrade .

Then, the packages `libxml2-dev` and `libxslt1-dev`:

    # https://stackoverflow.com/a/15761014/9780968
    $ sudo aptitude install libxml2-dev libxslt1-dev

Finally, retry installing `lxml`:

    $ cd ../lxml
    $ python3 -m pip install --user --upgrade .

### Which influence does the version of my python interpreter (e.g. `v3.5` vs `v3.7`) has over an installed module?

It  determines  the  installation  location  of the  module,  and  which  python
interpreter will be able to use the latter.

Each python version has its own modules.
For  example, if  you have  python3.5 and  python3.7, and  you've installed  the
module `six` with both of them:

    $ python3.5 -m pip install --user --upgrade six
    $ python3.7 -m pip install --user --upgrade six

They will be located in 2 directories:

    $ ls -l ~/.local/lib/python3.5/site-packages | grep six
    drwxrwxr-x  2 jean jean  4096 Feb 22 17:41 six-1.12.0-py3.5.egg-info~
    -rw-rw-r--  1 jean jean 32452 Feb 22 17:41 six.py~

    $ ls -l ~/.local/lib/python3.7/site-packages | grep six
    drwxrwxr-x  2 jean jean  4096 Feb 22 17:41 six-1.12.0-py3.7.egg-info~
    -rw-rw-r--  1 jean jean 32452 Feb 22 17:41 six.py~

If the program for which you install a python module runs python3.7, you need to
be sure that you installed the module for python3.7.

---

If  you have  several python  interpreters,  you can  see  the whole  list –  in
descreasing order of priority – with:

    $ type -a python3
    python3 is /usr/local/bin/python3~
    python3 is /usr/bin/python3~
    python3 is /bin/python3~

The first  line contains the  path to  the binary which  is called when  you run
`python3` without `.X`.
Note that here, the compiled  interpreter was installed in `/usr/local/bin`, and
it has priority over the default  one – in `/usr/bin` – because `/usr/local/bin`
comes before `/usr/bin` in `$PATH`.

---

I think you can  use `python3` with `-m pip install ...` as  long as it runs the
latest python release you've been able to install on your system.
Just  make  sure  that  if  your compiled  interpreter  has  been  installed  in
`/usr/local/bin`, the latter comes before `/usr/bin` in `$PATH`.

##
## I have the error message: “No module named 'PyQt5.QtCore'”!

Install `python3-pyqt5`:

    $ api python3-pyqt5

## The subtitles get invisible when I start interSubs!

Try to update `pyqt5`.

Or comment this `return` statement in `interSubs.py`:

    if not self.psuedo_line:
        self.psuedo_line = 1
        return

<https://github.com/oltodosel/interSubs/issues/17>

The purpose of `return` is to get  rid of some flickering introduced by a recent
version of `pyqt5` (5.12).

## How to translate a whole sentence?

That's what the `f_deepl_translation` function is for.

However, at the moment, it doesn't work:

    {'jsonrpc': '2.0', 'error': {'message': 'Too many requests.', 'code': 1042901}}

It may be due to our AS being blacklisted by [deepl.com](https://www.deepl.com/translator).

Or maybe you need to subscribe to a pro account:

<https://www.deepl.com/pro.html#api>

Or it may be related to one of these issues:

<https://github.com/m9dfukc/deepl-alfred-workflow/issues/14#issuecomment-402965296>
<https://github.com/vsetka/deepl-translator/issues/9>

Don't open an issue: <https://github.com/oltodosel/interSubs/issues/19>

