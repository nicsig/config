# Purpose: Make ranger log all opened files for fasd.
# Source: https://github.com/ranger/ranger/wiki/Integration-with-other-programs#fasd

import ranger.api
# Why do you import `shlex.quote`?{{{
#
# We need it to handle a filename containing a single quote.
# The original code did this:
#
#     fm.execute_console("shell fasd --add '" + fm.thisfile.path + "'")
#                                          ^                        ^
#                                          ✘                        ✘
#
# But if  you open  a file whose  filename contains a  single quote,  this error
# message may be printed on the shell command-line when you quit ranger:
#
#     zsh:1: unmatched '
#
# The issue is a little weird.
# For example, you may need to be in tmux to see the message.
# Anyway, one  solution is to  *not* use single  quotes to explicitly  quote the
# filename, but instead `shlex.quote()`:
#
#     fm.execute_console("shell fasd --add " + quote(fm.thisfile.path))
#                                              ^^^^^^^^^^^^^^^^^^^^^^^
#
# I found the solution here:
# https://github.com/ranger/ranger/wiki/Keybindings#open-highlighted-files-in-splits-windows
#}}}
try: from shlex import quote
except ImportError: from pipes import quote

old_hook_init = ranger.api.hook_init

def hook_init(fm):
    def fasd_add():
        fm.execute_console("shell fasd --add " + quote(fm.thisfile.path))
    fm.signal_bind('execute.before', fasd_add)
    return old_hook_init(fm)

ranger.api.hook_init = hook_init

