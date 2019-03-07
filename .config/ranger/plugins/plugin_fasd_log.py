# Purpose: Make ranger log all opened files for fasd.
# Source: https://github.com/ranger/ranger/wiki/Integration-with-other-programs#fasd

import ranger.api

old_hook_init = ranger.api.hook_init

def hook_init(fm):
    def fasd_add():
        fm.execute_console("shell fasd --add '" + fm.thisfile.path + "'")
    fm.signal_bind('execute.before', fasd_add)
    return old_hook_init(fm)

ranger.api.hook_init = hook_init
