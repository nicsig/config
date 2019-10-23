#!/bin/bash

# init {{{1

readonly REDRAW_COMMAND="toggle-preview+toggle-preview"
typeset -r -x REDRAW_KEY="µ"
typeset -r -x UEBERZUG_FIFO="$(mktemp --dry-run --suffix "fzf-$$-ueberzug")"

# functions {{{1
start_ueberzug() { #{{{2
    mkfifo "$UEBERZUG_FIFO"
    ueberzug layer --parser bash --silent <"$UEBERZUG_FIFO" &
    # prevent EOF
    exec 3>"$UEBERZUG_FIFO"
}

finalise() { #{{{2
    exec 3>&-
    rm "$UEBERZUG_FIFO" &>/dev/null
    kill "$(jobs -p)"
}

calculate_position() { #{{{2
    # TODO costs: creating processes > reading files
    #      so.. maybe we should store the terminal size in a temporary file
    #      on receiving SIGWINCH
    #      (in this case we will also need to use perl or something else
    #      as bash won't execute traps if a command is running)
    < <(</dev/tty stty size) \
        read -r TERMINAL_LINES TERMINAL_COLUMNS

    X=$((TERMINAL_COLUMNS - COLUMNS - 2))
    Y=1
}

on_selection_changed() { #{{{2
    calculate_position

    >"${UEBERZUG_FIFO}" typeset -A -p cmd=( \
        [action]=add [identifier]=preview \
        [x]="$X" [y]="$Y" \
        [width]="$COLUMNS" [height]="$LINES" \
        [scaler]=forced_cover [scaling_position_x]=0.5 [scaling_position_y]=0.5 \
        [path]="$@")
        # add [synchronously_draw]=True if you want to see each change
}

print_on_winch() { #{{{2
    # print "$@" to stdin on receiving SIGWINCH
    # use exec as we will only kill direct childs on exiting,
    # also the additional bash process isn't needed
    </dev/tty \
        exec perl -e '
            while (1) {
                local $SIG{WINCH} = sub {
                    ioctl(STDIN, 0x5412, $_) for split "", join " ", @ARGV;
                };
                sleep;
            }' \
            "$@"
}
#}}}1
# execution {{{1

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    trap finalise EXIT
    # print the redraw key twice as there's a run condition we can't circumvent
    # (we can't know the time fzf finished redrawing it's layout)
    print_on_winch "${REDRAW_KEY}${REDRAW_KEY}" &
    start_ueberzug

    export -f on_selection_changed calculate_position
    SHELL=/bin/bash \
        fzf --preview "on_selection_changed {}" \
            --preview-window "right:70" \
            --bind "$REDRAW_KEY":"$REDRAW_COMMAND"
fi

