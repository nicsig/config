#!/bin/bash

# TODO: make the script remove old kernels.{{{
#
# You could try this command:
#     $ sudo apt autoremove
#
# You would need to add sth like this in `/etc/sudoers.d/my_modifications`:
#     user ubuntu=(root)NOPASSWD:/usr/bin/apt autoremove
#
# To do so, execute this:
#     $ sudo visudo -f /etc/sudoers.d/my_modifications
#
# For more info, read this:
#     https://askubuntu.com/a/100953/867754
#}}}
# Why don't you do it atm?{{{
#
# Here's what `apt` prints when we invoke it in a script:
#
#     WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
#
# I need to think of a reliable way to remove old kernels.
#
# Update:
# We should probably write another script whose purpose would be to clean the system.
# We would use it less often, and would  be more careful when using it (read all
# the  messages, don't  answer yes  automatically without  making sure  it's not
# going to remove sth important).
#}}}

main() { #{{{1
  # make sure `~/log/` exists
  [[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
  local LOGFILE="${HOME}/log/update_system.log"
  update_system "${LOGFILE}" 2>&1 | tee -a "${LOGFILE}"
}

run_until_it_succeeds() { #{{{1
  i=0
  until $@; do
    sleep 1
    i=$((i+1))
    if [[ "$i" -gt 100 ]]; then
      break
    fi
  done
}

update_system() { #{{{1
  # Why putting the month before the day?{{{
  #
  # It's a good habit.
  # If you have files  whose name begin with a date, it's easier  to find a file
  # dating from a particular time in the  output of `$ ls` (or in `ranger`) when
  # the month comes before the day.
  #}}}
  cat <<EOF
---
---
$(date +%m-%d\ %H:%M)
===========
EOF

  update_apt "$1"
  update_mpv_completion_function
  update_pandoc_completion_function
  update_pip
  update_ranger
  update_terminfo
  update_texlive
  update_tldr
  update_youtube_dl
  update_zsh_plugins
}

update_apt() { #{{{1
  cat <<EOF
aptitude
------

EOF

  sudo aptitude update
  sudo aptitude safe-upgrade

  # What does it do?{{{
  #
  # Resynchronize the package contents from their sources.
  # The  lists of  the  contents  of packages  are  fetched  from the  location(s)
  # specified in /etc/apt/sources.list.
  #}}}
  # Why do you do it?{{{
  #
  # As time goes on, some new file(s) may be included in a package.
  # One day, we may be looking for which package contains it:
  #
  #     $ apt-file search <missing_file>
  #
  # If our local package contents are not up-to-date, the previous command
  # may return nothing (or not the package we need).
  # Thus we may wrongly assume that we can't get that file.
  #}}}
  # Why do you use `script`?{{{
  #
  # `apt-file` is a perl script, which doesn't write on its standard output,
  # but on `/dev/tty`.
  #
  # Usually, they seem to be the same thing: the standard output of a process is
  # often connected to the terminal.
  # But here, you've redirected the standard output the input of `tee`.
  # So, they're not the same anymore.
  # And I don't think it's possible to redirect `/dev/tty` to a file.
  #
  # So, we use `script` instead.
  #
  # For more:
  #   https://askubuntu.com/a/1074946/867754
  #   https://stackoverflow.com/a/4668579/9780968
  #}}}
  # Why don't you use it to log the whole function?{{{
  #
  # When you pass a value to the `-c` option of the `script` command,
  # I think that the normal shell  function lookup is suppressed, i.e. you can't
  # execute a function only a command.
  # Same thing with `bash -c '...'`.
  #
  # Besides,  `script` logs the linefeeds  as literal carriage returns  which is
  # distracting.
  # It does the same thing with other characters such as backspaces.
  #}}}
  cat <<EOF

apt-file
--------

EOF
  script -a -c 'apt-file update' -q "$1"
  #       │  │                    │   │{{{
  #       │  │                    │   └ log the output in this file
  #       │  │                    │
  #       │  │                    └ be quiet (no message when `script` starts/ends)
  #       │  │
  #       │  └ execute the next command,
  #       │    instead of waiting the user to execute commands interactively
  #       │
  #       └ append to the logfile
  #}}}
}

update_git_programs() { #{{{1
  local plugin_name width dashes
  plugin_name="$(basename "$1")"
  # How to get the length of a string?{{{
  #
  #   $ string='hello'
  #   $ echo ${#string}
  #       → 5
  #
  # Source:
  #
  #     https://stackoverflow.com/a/17368090/9780968
  #}}}
  width=${#plugin_name}
  # How to repeat a string (like in VimL: `repeat('foo', 3)`)? {{{
  #
  # Contrary to Vim's `printf()`, you  can give more expressions than `%s` items
  # in the format:
  #
  #     " ✘
  #     :echo printf('%s', 'a', 'b', 'c')
  #
  #         → E767: Too many arguments to printf()
  #
  #     # ✔
  #     $ printf -- '%s' 'a' 'b' 'c'
  #
  #         → abc
  #
  # `$ printf` repeats the format as many times as necessary.
  # So:
  #
  #     $ printf -- '-%s' {1..5}
  #
  #         → -1-2-3-4-5
  #
  #     $ printf -- '%.0s' {1..5}
  #
  #         → -----
  #         (no numbers because the precision flag `.0` asks for 0 characters)
  #
  # Source:
  #
  #     https://stackoverflow.com/a/5349842/9780968
  #}}}
  dashes="$(printf -- '-%.0s' $(seq 1 "${width}"))"
  #                │
  #                └ necessary for bash, not zsh
  # `zsh` alternative:{{{
  #
  #   dashes="$(printf -- '-%.0s' {1..${width}})"
  #
  # In bash, inside a brace expansion, you can't refer to a variable.
  # So, instead of writing this:
  #
  #     # ✘
  #     $ echo {1..${width}}
  #
  # You have to write this
  #
  #     # ✔
  #     $ echo $(seq 1 ${width})
  #}}}

  cat <<EOF

${plugin_name}
${dashes}

EOF

  local path="${2}${plugin_name}"
  [[ -d "${path}" ]] || git -C "$2" clone "$1"
  git -C "${path}" stash
  git -C "${path}" checkout master
  git -C "${path}" pull
}

update_mpv_completion_function() { #{{{1
  cat <<EOF

mpv completion function
-----------------------

EOF

  curl -Ls 'https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/zsh.pl' | \
    perl - \
    >"${HOME}/.zsh/my-completions/_mpv"
  [[ $? ]] && printf -- 'Done\n'
}

update_pandoc_completion_function() { #{{{1
  cat <<EOF

pandoc completion function
--------------------------

EOF

  pandoc --bash-completion >"${HOME}/.zsh/my-completions/_pandoc"
  [[ $? ]] && printf -- 'Done\n'
}

update_pip() { #{{{1
  cat <<EOF

pip
---

EOF

  run_until_it_succeeds python  -m pip install --upgrade --user pip
  run_until_it_succeeds python3 -m pip install --upgrade --user pip

  # https://stackoverflow.com/a/3452888/9780968
  # Knowing the current state of the packages could be useful to restore it later;{{{
  # copy the logged output of `pip freeze` in a file `/tmp/req.txt`, then:
  #
  #     $ python[3] -m pip install -r /tmp/req.txt
  #}}}
  cat <<EOF

current versions of the python2 packages
----------------------------------------

EOF

  python -m pip freeze
  cat <<EOF

update python2 packages
-----------------------

EOF

  # FIXME: `xargs` can't run a shell function, so it can't run `run_until_it_succeeds`
  python -m pip list --outdated --format=freeze \
    | grep -Ev '^(-e|#)' \
    | cut -d= -f1 \
    | xargs -r -n1 python -m pip install --user --upgrade
    #        │  │{{{
    #        │  └ pass only one package name at a time to `pip install`,
    #        │    so that if one installation fails, the other ones go on
    #        │
    #        └ don't run the command if the input is empty
    #          (we need at least one package name)
    #}}}

  cat <<EOF

current versions of the python3 packages
----------------------------------------

EOF

  python3 -m pip freeze
  cat <<EOF

update python3 packages
-----------------------

EOF

  python3 -m pip list --outdated --format=freeze \
    | grep -Ev '^(-e|#)' \
    | cut -d= -f1 \
    | xargs -r -n1 python3 -m pip install --user --upgrade
}

update_ranger() { #{{{1
  update_git_programs 'https://github.com/ranger/ranger' "${HOME}/GitRepos/"
  cd "${HOME}/GitRepos/ranger"
  # Why installing ranger as a pip package?{{{
  #
  # You  could just  use  the  script `ranger.py`,  but  you  wouldn't have  the
  # manpages `ranger(1)` and `rifle()`.
  #}}}
  python3 -m pip install --user --upgrade .
  # You may enhance ranger by installing some optional dependencies:
  # https://github.com/ranger/ranger#dependencies
}

update_terminfo() { #{{{1
  curl -L http://invisible-island.net/datafiles/current/terminfo.src.gz -o /tmp/terminfo.scr.gz
  gunzip /tmp/terminfo.scr.gz
  tic -sx /tmp/terminfo.scr
}

update_texlive() { #{{{1
  # For more info:{{{
  #
  #     https://tex.stackexchange.com/a/55459/169646
  #}}}
  cat <<EOF

texlive packages
----------------

EOF

  #       ┌ https://stackoverflow.com/a/677212/9780968
  #       ├────────┐
  if [[ $(command -v tlmgr) ]]; then
    tlmgr update --self --all --reinstall-forcibly-removed
    #              │      │     │{{{
    #              │      │     └ reinstall a package
    #              │      │       if it was corrupted during a previous update
    #              │      │
    #              │      └ update all packages
    #              │
    #              └ update `tlmgr` itself}}}
  fi

}

update_tldr() { #{{{1
  cat <<EOF
tldr
----
EOF

    # https://github.com/raylee/tldr#installation
    curl -Lso "${HOME}/bin/tldr" 'https://raw.githubusercontent.com/raylee/tldr/master/tldr'
    chmod +x "${HOME}/bin/tldr"
}

update_youtube_dl() { #{{{1
  cat <<EOF

youtube-dl
----------

EOF

  up_yt.sh
}

update_zsh_plugins() { #{{{1
  local zsh_plugins_dir="${HOME}/.zsh/plugins/"
  [[ -d "${zsh_plugins_dir}" ]] || mkdir -p "${zsh_plugins_dir}"
  update_git_programs 'https://github.com/zsh-users/zsh-completions'         "${HOME}/.zsh/"
  update_git_programs 'https://github.com/changyuheng/zsh-interactive-cd'    "${zsh_plugins_dir}"
  # FIXME: https://github.com/zsh-users/zsh-syntax-highlighting/issues/565
  #     update_git_programs 'https://github.com/zsh-users/zsh-syntax-highlighting' "${zsh_plugins_dir}"
  update_git_programs 'https://github.com/zsh-users/zaw'                     "${zsh_plugins_dir}"
}

# Execution {{{1

main

