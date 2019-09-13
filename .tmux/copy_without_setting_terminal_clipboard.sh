#!/bin/sh

# Purpose: Run an arbitrary tmux copy mode command, *without* setting the terminal clipboard.
# Rationale:{{{
#
# If the  tmux option 'set-clipboard'  (server option)  is set to  'external' or
# 'on', when you copy some text in copy  mode, tmux will try to set the terminal
# clipboard, using the sequence stored in the 'Ms' capability (tmux extension):
#
#     $ infocmp -x | sed -n '/Ms/s/,.*//p'
#     Ms=\E]52;%p1%s;%p2%s\007~
#
# This  is an  issue if  you want  to set  the terminal  clipboard yourself  via
# `xsel(1x)` (or `xclip(1)`), with a  modified version of the selection, because
# there may be a race condition between `xsel(1x)` and tmux; and tmux may win.
# If  tmux wins,  it's  the original  selection  which will  be  written in  the
# terminal clipboard, not your modified version.
#
# MWE:
#
#     $ tmux -Lx -f =(cat <<'EOF'
#     set -gw mode-keys vi
#     bind -T copy-mode-vi ! send -X copy-pipe-and-cancel "tr -d '\n' | xsel -i --clipboard"
#     EOF
#     )
#
#     $ echo "foo\nbar"
#     C-b [
#     kk
#     Vk
#     !
#
#     $ xsel -b
#     foo~
#     bar~
#
# The output of the last shell command should be:
#
#     foobar~
#
# To fix  this issue, you  could simply turn  off 'set-clipboard', but  then you
# couldn't use  the OSC 52  sequence anymore.
# The latter can be very useful to synchronize a remote clipboard with a local one:
#
#     $ printf '\ePtmux;\e\e]52;c;%s\x07\e\\' $(printf 'hello' | base64)
#     $ xsel -b
#     hello~
#
# For more info, see:
#
# `man tmux /^\s*set-clipboard`
# https://sunaku.github.io/tmux-yank-osc52.html
#}}}
# Synopsis:{{{
#
#     bind -T copy-mode-vi mykey run "${HOME}/.tmux/copy_without_setting_terminal_clipboard.sh \
#          'my-copy-command' \
#          'my shell command' \
#          'my_buffer_name_prefix'"
#}}}
# Example:{{{
#
#     bind -T copy-mode-vi ! run "${HOME}/.tmux/copy_without_setting_terminal_clipboard.sh \
#          'copy-pipe-and-cancel' \
#          \"tr -d '\n' | xsel -i --clipboard\" \
#          'buf_'"
#}}}

copy_mode_command="$1"
shell_command="$2"
buffer_name_prefix="$3"
# Run the copy mode command after temporarily resetting 'set-clipboard'.
tmux set -F @set-clipboard-save '#{set-clipboard}' \; \
  set set-clipboard off \; \
  send -X "$copy_mode_command" "$shell_command" "$buffer_name_prefix" \; \
  set -F set-clipboard '#{@set-clipboard-save}' \; set -u @set-clipboard-save

