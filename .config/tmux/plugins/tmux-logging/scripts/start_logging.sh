#!/bin/bash

# path to log file - global variable
FILE="$1"

ansifilter_installed() {
	type ansifilter >/dev/null 2>&1 || return 1
}

pipe_pane_ansifilter() {
	tmux pipe-pane "exec cat - | ansifilter >> $FILE"
}

pipe_pane_sed() {
	local ansi_codes="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]|)"
	tmux pipe-pane "exec cat - | sed -r 's/$ansi_codes//g' >> $FILE"
}

start_pipe_pane() {
	if ansifilter_installed; then
		pipe_pane_ansifilter
	else
		pipe_pane_sed
	fi
}

main() {
	start_pipe_pane
}
main
