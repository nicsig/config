#!/bin/bash

# Install the `conky-all` package, NOT `conky`!{{{
#
# The `conky` package doesn't include the lua binding.
# In that regard, `conky-all` is similar to `vim-gtk`, and `conky` to `vim-tiny`.
#}}}
# Where can I find tutorials about conky?{{{
#
# https://github.com/brndnmtthws/conky/wiki
# http://crunchbang.org/forums/viewtopic.php?id=17246
#}}}
# How to print info about the weather?{{{
#
# Look at `man conky` / wiki (there're weather functions built-in).
# Or for inspiration, look here:
# https://github.com/edusig/conky-weather
#
# It's in python.
# Conky may need curl to dl information about the weather.
#}}}

[[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
LOGFILE="${HOME}/log/$(basename "$0" .sh).log"

main() {
  cat <<-EOF

	-----------
	$(date +%m-%d\ %H:%M)
	-----------
	EOF

killall conky
# Why?{{{
#
# Without, these errors will be raised:
#
#     conky: llua_load: cannot open ./system_rings.lua: No such file or directory
#     conky: llua_do_call: function conky_main execution failed: attempt to call a nil value
#
# This prevents the rings from being displayed.
#}}}
cd "${HOME}/.config/conky/" || exit

# What's this `-c` option?{{{
#
# Usually, conky reads its config in `~/.config/conky/conky.conf`.
# With the `-c` option, you can specify another path.
# This allows you to start several conky modules with different configs.
#}}}
conky -c "${HOME}/.config/conky/time.lua" &
conky -c "${HOME}/.config/conky/system.lua" &
}

main 2>&1 | tee -a "${LOGFILE}"

