#!/bin/bash

# Output file is:    /tmp/gif.gif

# TODO: screenkey{{{
#
# The script should make sure the `screenkey` program is installed, and bail out
# if it's not.
#
# Also, if possible, the script should configure it to get the same result as if
# you had configured it interactively, like so:
#
#     • reduce the amount of time the typed keys are displayed (2.5s by default)
#
#     • enable 'persistent window'
#
#     •    select window/region
#       >  click on the terminal
#
#         `screenkey` is automatically  placed at the bottom of  the terminal no
#         matter where the latter is
#
#     •   modifiers mode
#       > emacs
#
#        to display 'C-a' rather than 'Ctrl+a'
#}}}
# TODO:
# comment the code more thorougly

# Warning: If you modify the script to quote the shell command it must record:{{{
#
#     gifrec.sh shell_cmd  →  gifrec.sh 'shell_cmd'
#
# Make sure your script manually expands a  possible tilde at the beginning of a
# file path in the command.
# Indeed, the shell won't expand it if it's inside a string.
# Try this syntax:
#
#     var="${var/#\~/$HOME}"
#
# Source:
#
#     https://stackoverflow.com/a/27485157/9477010
#}}}
# My complex command contains many single and double quotes.  `$ gifrec.sh complex_cmd` doesn't work!{{{
#
#     $ gifrec.sh zsh
#     $ complex_cmd
#     $ C-d
#}}}

# Functions {{{1
encode_to_gif() { #{{{2
  gifenc.sh /tmp/recording_desktop.mkv /tmp/gif.gif >/dev/null 2>&1
  rm /tmp/recording_desktop.mkv 2>/dev/null
}

get_geometry() { #{{{2
  # We use tmux in fullscreen. But if  we want to capture something, it probably
  # doesn't need the whole screen. Think about a Vim session for example.
  if [[ -n "${TMUX}" ]]; then
    X=0
    # 0 would capture a black and thin horizontal line at the top
    Y=3

    # open a horizontal  pane below, and a  vertical one on the  right to reduce
    # the geometry of the current pane
    #
    # save their IDs, so that we can reliably kill them later

    pane_id1=$(tmux split-window -c /tmp -d -v -p 40 -PF "#D")
    pane_id2=$(tmux split-window -c /tmp -d -h -p 30 -PF "#D")

    H=590
    W=1330
  else

    # xwininfo -id $(xdotool getactivewindow)
    #
    #         Pour obtenir les valeurs {x},  {y}, {height} et {width} (nécessite
    #         l'installation de xdotool):
    #
    #         Source:
    #         http://unix.stackexchange.com/a/14170/125618
    #
    #         D'après les commentaires,  il se peut que  cette dernière commande
    #         retourne  la géométrie  de la  fenêtre sans  sa décoration.   Pour
    #         inclure la déco:
    #
    #                 xdotool getactivewindow getwindowgeometry


    # Capture the output of `xwininfo` into a variable.
    # Requires the user to click on a window.
    local XWININFO
    XWININFO="$(xwininfo)"

    # extract relevant info from the output
    read X <<< $(awk -F: '/Absolute upper-left X/{print $2}' <<< "${XWININFO}")
    read Y <<< $(awk -F: '/Absolute upper-left Y/{print $2}' <<< "${XWININFO}")
    read H <<< $(awk -F: '/Height/{print $2}' <<< "${XWININFO}")
    read W <<< $(awk -F: '/Width/{print $2}' <<< "${XWININFO}")

    # Alternative to `xwininfo`:
    #     https://github.com/naelstrof/slop
  fi
}

main() { #{{{2
  get_geometry
  start_recording "${@}"
  stop_everything
  maybe_close_panes
  encode_to_gif

  # show the size (some sites have a size limit for gifs)
  du -sh /tmp/gif.gif
}

maybe_close_panes() { #{{{2
  if [[ -n "${TMUX}" ]]; then
    # we've opened 2 panes to reduce the geometry of the recorded pane
    # close them
    tmux kill-pane -t "${pane_id1}"
    tmux kill-pane -t "${pane_id2}"
  fi
}

start_recording() { #{{{2
  # https://trac.ffmpeg.org/wiki/Capture/Desktop
  #
  # For a better quality, add these options after `-i`:
  #
  #        -c:v libx264 \
  #        -qp 0 \
  #        -preset ultrafast \

  ffmpeg -draw_mouse 0                     \
         -f x11grab                        \
         -framerate 25                     \
         -video_size "${W}x${H}"           \
         -i :0.0+"${X},${Y}"               \
         -y                                \
                /tmp/recording_desktop.mkv \
                >/dev/null 2>&1 &

  ffmpeg_pid=$!

  if [[ -n "${TMUX}" ]]; then
    # https://github.com/wavexx/screenkey#command-line-placement
    screenkey -g 1330x800+0+0
  else
    # We can't start screenkey as a job. It does it automatically.
    # So, we can't save its pid with:    screenkey_pid=$!
    # We'll kill it with `killall screenkey`, instead of `kill <pid>`.
    screenkey
  fi

  # When we start a Vim session opening a file, the 1st line is briefly hidden,
  # then appears. It looks as if the screen was “jumping“.
  # Sleeping half a second prevent that. Anything below doesn't work.
  sleep .5

  # start the command whose activity we want to record
  "$@"
}

stop_everything() { #{{{2
  # once the command is finished, stop ffmpeg
  kill "${ffmpeg_pid}"

  # We could have NOT saved `ffmpeg_pid` and replace the previous command with:
  #
  #     kill %%
  # or
  #     kill %+
  #
  # But, the advantage of the current method is that even if we start other jobs
  # in the future, we'll still kill the right one. No need to change anything.

  killall screenkey
}

# Execution {{{1

if [[ -z "$@" ]]; then
  printf -- 'usage: %s some_command_to_record\n' "$(basename "$0")" >&2
  exit 64
fi

main "${@}"

