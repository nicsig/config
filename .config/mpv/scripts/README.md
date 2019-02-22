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

##
# Issues
## Which pitfall should I avoid after redownloading the plugin from github?

The original files are indented with tabs.

If you re-download them, remove the tabs.

Otherwise, if you edit one of them later, you may introduce a line indented with
spaces, and the python interpreter won't like the mix of indentation (some lines
indented with tabs, others with spaces).

## The plugin doesn't work!

A module is probably missing; run `mpv` from the command-line, to see which one.

You probably need a recent version of  the Python interpreter, of pip, and these
Python modules:

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

    https://www.crummy.com/software/BeautifulSoup/bs4/download/

---

Also, see this issue:

    https://github.com/oltodosel/interSubs/issues/9

## The subtitles get invisible when I start interSubs!

Comment this block of code in `interSubs.py`:

    if not self.psuedo_line:
        self.psuedo_line = 1
        return

Consider opening an issue.

## I have the error message: “No module named 'PyQt5.QtCore'”!

Install `python3-pyqt5`:

    $ api python3-pyqt5

## How to get the audio pronunciation of a word?

That's what the `f_listen` function is for.

You can bind it to a key in `interSubs_config.py`.

For example, to bind it to a left click:

    mouse_buttons = [
            ['LeftButton',              'NoModifier',           'f_listen'],
            ...

However, at the moment, it doesn't work:

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

Consider opening an issue.

## How to translate a whole sentence?

I think that's what the `f_deepl_translation` function is for.

However, at the moment, it doesn't work:

    {'jsonrpc': '2.0', 'error': {'message': 'Too many requests.', 'code': 1042901}}

Consider opening an issue.

