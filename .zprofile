# white background in console
# Source: http://www.tuxradar.com/answers/482

# Why do we check that `$DISPLAY` is empty?{{{
#
# To avoid `setterm` being invoked in the GUI environment.
#}}}
# How could this happen?{{{
#
# Suppose a command has failed, and we want to re-execute it with higher
# privileges:
#
#     cmd                  ✘
#     su -l user -c 'cmd'  ✔
#
# The `-l user` allows us to execute `cmd` in the same environment as ours.
# It could be useful, for example, if `cmd` contains a command which is in our
# `$PATH`, but not in root's `$PATH`.
#
# Pb:
# `su -l user` starts a new login shell, which will source this file (`~/.zprofile`).
# It won't cause any issue in the console, but it will in the GUI environment.
# }}}
if [[ -z "${DISPLAY}" ]]; then
  setterm -background white -foreground black -store
#         │
#         └ we could also use `--`, but `man setterm` recommends to use `-` in
#           a script (section `COMPATIBILITY`)
fi

