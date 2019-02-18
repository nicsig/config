#!/bin/bash

# Some definitions{{{
#
# `$ man update-alternatives` talks about `master` and `slave` links.
# Example:
#
#     $ update-alternatives --query awk
#     Name: awk~
#     Link: /usr/bin/awk~
#     Slaves:~
#      awk.1.gz /usr/share/man/man1/awk.1.gz~
#      nawk /usr/bin/nawk~
#      nawk.1.gz /usr/share/man/man1/nawk.1.gz~
#     Status: manual~
#     Best: /usr/local/bin/gawk~
#     Value: /usr/local/bin/gawk~
#
#     ...~
#
#     Alternative: /usr/local/bin/gawk~
#     Priority: 60~
#     Slaves:~
#      awk.1.gz /usr/local/share/man/man1/gawk.1.gz~
#
# The master link of the group is:
#
#     /usr/bin/awk → /etc/alternatives/awk
#
# According to the `Value:` field, it currently points to `/usr/local/bin/gawk`.
#
# One slave link is:
#
#     /usr/share/man/man1/awk.1.gz → /etc/alternatives/awk.1.gz
#
# According to the `Slaves:` field of the `/usr/local/bin/gawk` alternative,
# it currently points to `/usr/local/share/man/man1/gawk.1.gz`.
#
# Usually the slave links are for manpages.
#
# The master link determine how the slaves will be configured.
#
# Also, a master link and its slaves make up a *link group*.
#}}}
# Some useful commands{{{
#
#     $ update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
#
# Add the  alternative `/usr/local/bin/vim` to  the group whose generic  name is
# `/usr/bin/editor`, with the priority 1.
#
# ---
#
#     $ update-alternatives --remove editor /usr/local/bin/vim
#
# Remove the alternative `/usr/local/bin/vim` from the group `editor`.
# If the link group contains slave links (usually for manpages), they're updated
# or removed.
#
# ---
#
#     $ update-alternatives --set editor /usr/local/bin/vim
#
# Configure `/usr/local/bin/vim` to be *the* alternative providing `editor`.
#
#     $ update-alternatives --config editor
#
# Configure the group editor interactively.
#
#     $ update-alternatives --auto editor
#
# Reconfigure  the  group  `editor`  so  that,  from  now  on,  it  will  always
# automatically use the alternative with the highest priority.
#
#     $ update-alternatives --all --skip-auto
#
# Reconfigure all groups of alternatives in  which the used alternative has been
# selected manually.
#
#     $ update-alternatives --query editor
#     $ update-alternatives --display editor
#
# Display  information about  the group  of alternatives  whose generic  name is
# `editor`. Useful to check which alternative provides `/usr/bin/editor`.
#
#     $ update-alternatives --get-selections
#
# Show:
#
#    - all group of alternatives
#    - the alternative they use
#    - in which mode they are (manual / auto)
#}}}
# Why does `update-alternatives` use an extra level of indirection?{{{
# Why not a single symlink?
#
#         /usr/bin/editor → /etc/alternatives/editor → /usr/local/bin/vim
#
# It allows to confine the changes of the sysadmin to `/etc`, which is a good
# thing according to the FHS. IOW, it creates a convenient centralised point of
# config.
#}}}

# We need to be root.
#
#      ┌─ Effective User ID
#      │
#      │  0 is the EUID of the root user.
#      │  Check we're root, otherwise
#      │  the next `update-alternatives` will fail.
#      │
if [[ "${EUID}" -ne 0 ]]; then
  cat <<EOF >&2
Please run as root:
    sudo -E env PATH="\$PATH" bash -c '$(basename "$0")'
EOF
  # Why the `PATH=$PATH`?{{{
  #
  # To make sure that `~/bin` is in root's PATH.
  #}}}
  # 77 = not sufficient permission
  exit 77
fi

#          ┌─ names of alternatives which we want to be provided by `/usr/local/bin/vim`
#          │  Vim can be invoked with any of these names. And, from a running Vim
#          │  instance, we can get this name with `v:progname`.
#          │
#          │  We can also get the path to the Vim binary which was executed with `v:progpath`.
#          │  Useful to make the difference between several Vim installed on the system.
#          │
typeset -a names=(editor eview evim ex gview gvim gvimdiff rgview rgvim rview rvim vi view vim vimdiff)

for name in "${names[@]}"; do
  # add our compiled Vim to each group of alternatives
  #
  update-alternatives --install /usr/bin/"${name}" "${name}" /usr/local/bin/vim 60
  #                             ├────────────────┘ ├───────┘ ├────────────────┘ ├┘{{{
  #                             │                  │         │                  └ priority
  #                             │                  │         └ path to alternative
  #                             │                  │
  #                             │                  └ name of the alternative (again, symlink)
  #                             │                    in the alternatives directory `/etc/alternatives`
  #                             │
  #                             └ generic name (symlink)
  #}}}

  # set our compiled Vim to be the master link
  update-alternatives --set "${name}" /usr/local/bin/vim
  #                     │
  #                     └─ to configure a link group:
  #
  #                            * `--set`    is useful in a script
  #                            * `--config` is useful on the command-line
done

