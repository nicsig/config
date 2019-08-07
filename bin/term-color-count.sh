#!/bin/bash

# Source: https://raw.githubusercontent.com/l0b0/xterm-color-count/master/xterm-color-count.sh

setbg () { #{{{1
  printf '\e[48;5;%dm' "$1"
}

showcolors() { #{{{1
  # given an integer, display that many colors
  for ((i=0; i<$1; i++)); do
    printf '%4d ' $i
    setbg $i
    tput el
    tput sgr0
    echo
  done
  tput sgr0 el
}

# main {{{1

# clean up even if user hits ^C
 trap 'tput sgr0' exit

# first, test if terminal supports OSC 4 at all
printf '\e]4;%d;?\a' 0
read -d $'\a' -s -t 0.1
if [ -z "$REPLY" ]; then
  # OSC 4 not supported, so we fall back to terminfo
  max=$(tput colors)
else
  # OSC 4 is supported, so use it for a binary search
  min=0
  max=256
  while [[ $((min+1)) -lt $max ]]; do
    i=$(( (min+max)/2 ))
    printf '\e]4;%d;?\a' $i
    read -d $'\a' -s -t 0.1
    if [ -z "$REPLY" ]; then
      max=$i
    else
      min=$i
    fi
  done
fi

case ${1:-none} in
  none)
    echo "$max"
    ;;
  # if -v is given, show all the colors
  -v)
    # Why `--raw-control-chars`?{{{
    #
    # To make `$ less` relay some  escape sequences to the terminal, unmodified,
    # instead of displaying their caret notations.
    #
    # Note   that  we   already  include   `R`  inside   `$LESS`  which   passes
    # `--RAW-CONTROL-CHARS` to `$ less`, but  that's not enough; it only affects
    # ANSI color escape sequences.
    #}}}
    # Why `--no-init`?{{{
    #
    # When we quit `$ less`, it sends the termcap deinitialization string to the
    # terminal, which clears the screen.
    # For the  moment, we  don't want  that; we  want the  last contents  of the
    # screen to be preserved.
    #}}}
    # How could I avoid the repetition of `$ less --raw-control-chars --no-init`?{{{
    #
    # Write the pipe after `esac`:
    #
    #     esac | less --raw-control-chars --no-init
    #}}}
    #   Why don't you do it?{{{
    #
    # I don't want `$ less` to be run in all cases.
    # In particular, if the script just outputs a number, `$ less` is useless.
    #
    # You  could pass  `--QUIT-AT-EOF`  to `$  less`: this  would  make it  quit
    # automatically when there's just a number to display.
    # But, this would also make it quit when  we reach the end of a long list of
    # colors; I don't like that.
    #}}}
    showcolors "$max" | less --no-init
    ;;
  *)
    if [[ "$1" -gt 0 ]]; then
      showcolors "$1" | less --raw-control-chars --no-init
    else
      echo "$max"
    fi
    ;;
esac
