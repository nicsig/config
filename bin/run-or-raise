#!/bin/bash

# Description: #{{{
#
# Dependencies: xdotool, wmctrl, gawk (with `gensub()`)

# Purpose:
# This script receives the name of a program as an argument,
# and follows this flowchart:
#
#                                                       ________________________________
#                                                      │                                │
#                                                      │     the program is running     │
#                                                      │________________________________│
#                                                      ___yes________|      |_______no___
#                                                     /                                  \
#                                                    v                                    v
#                                       ________________________________              *******
#                                      │                                │          ***       ***
#                                      │ its window is in our desktop ? │          * launch it *
#                                      │________________________________│          ***       ***
#                                      ___yes________|      |_______no___             *******
#                                     /                                  \
#                                    v                                    v
#                           __________________                      *************
#                          |                  |                 ****             ****
#                __yes_____| it's maximized ? |               **                     **
#               /          |__________________|               * move it to our desktop *
#              v                         |                    **                     **
#         *********                      |no                    ****             ****
#     ****         ****               *********                     *************
#     *  minimize it  *           ****         ****
#     ****         ****           *  maximize it  *
#         *********               ****         ****
#                                     *********
#}}}

! pgrep "$1" && "$1" && exit 1

# FIXME:
# sometimes, when firefox is minimized, `xdotool` wrongly finds that it's visible,
# when it happens, test this:
#     xdotool search --onlyvisible --class firefox
#
# I think it's because there's no easy way to detect whether a window is
# visible. And `xdotool` seems to detect the visibility of a window, only in the
# current virtual destkop:    https://github.com/jordansissel/xdotool/issues/23

is_visible="$(xdotool search --onlyvisible --class "$1" 2>/dev/null)"
where_i_am=$(xdotool get_desktop)

#                      ┌── include PIDs in the window list printed by the -l action
#                      │
where_it_is=$(wmctrl -lp | awk -v pids="$(pidof "$1")" '$0 ~ gensub(" ", "|", "g", pids) { print $2 }')
#                               │
#                               └── we use the `-v` flag of awk, to pass the PIDs
#                                   of the program in which we are interested as
#                                   a variable (`pids`);
#                                   we don't rely on the name of our program to
#                                   find its desktop, because it's possible that
#                                   its name doesn't appear in the output of `wmctrl`;
#                                   as an example, this situation occurs when
#                                   we're looking for the window of `urxvt`, and
#                                   open a file in Vim+urxvt, outside tmux

# Alternative using `xdotool`:
# where_it_is=$(xdotool get_desktop_for_window $(xdotool search --class "$1" 2>/dev/null))
#
# But using `xdotool` seems to make the script a little bit slower.
# It consumes a little bit more CPU when we maintain our key binding pressed for
# several seconds.

window_id=$(xdotool search --class "$1" 2>/dev/null)
#           │
#           └── there could be several id in the output
#               don't know why

if [[ ${where_it_is} -eq ${where_i_am} ]] && [[ -n "${is_visible}" ]]; then
  # if we are in the same desktop as our program, and it's maximized, minimize it
  for id in ${window_id}; do
    xdotool windowminimize "${id}"
  done

elif [[ ${where_it_is} -eq ${where_i_am} ]] && [[ -z "${is_visible}" ]]; then
  # if we are in the same desktop as our program, and it's NOT maximized, maximize it
  for id in ${window_id}; do
    xdotool windowactivate "${id}"
  done
  # xdotool search --class "$1" windowactivate
  # xdotool windowactivate "${id}"

else
  # otherwise, bring it in our desktop
  wmctrl -x -R "$1"
  #       │  │
  #       │  └── move the window <WIN> to the current desktop, raise the window,
  #       │      and give it focus
  #       └── interpret <WIN> as the WM_CLASS name

  # For an alternative command using `xdotool`, see `man xdotool`:
  #
  #     set_desktop_for_window [window] desktop_number
  #
  # [window] is probably the id of the window obtained with `xdotool search --class …`

  if [[ -z "${is_visible}" ]]; then
    # and if it's minimized, maximize it
    xdotool windowraise "${window_id}"
    # alternative:    xdotool windowraise %1
  fi
fi



# OLD CODE:
#
# taper  'wmctrl  -lx'  pour  lister  les  fenêtres  actuellement  ouvertes  et
# identifier le  nom des  classes auxquelles elles  appartiennent généralement
# <classe> = <nom du pgm qui a lancé la fenêtre>
#
# ensuite on peut créer des raccourcis  clavier associés à des commandes dont
# la syntaxe est : <chemin vers ce script> <classe> <commande du programme>
#
# la <classe>  fournie au script est  comparée à toutes les  sous-chaînes des
# classes des pgms  actuellement lancés, pour déterminer s'il  faut lancer une
# nouvelle fenêtre ($2) ou donner le focus à une préexistante ($1)

# bring us to the program if it's already running, or launch it otherwise

# wmctrl -x -a "$1" || "$2"
#
# if [[ "$2" == 'emacs' ]];then
#     # bring emacs to current virtual desktop
#     wmctrl -R 'emacs'
#     # (un)hide emacs
#     wmctrl -r 'emacs' -b toggle,shaded
#
#   elif [[ "$2" == 'urxvt' ]]; then
#     wmctrl -R 'urxvt'
#     # wmctrl -r 'urxvt' -b toggle,shaded
# fi
