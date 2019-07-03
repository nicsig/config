#!/bin/sh

# Purpose: Run an arbitrary tmux copy mode command, *without* setting the terminal clipboard.{{{
#
# If the  tmux option 'set-clipboard'  (server option)  is set to  'external' or
# 'on', when you copy some text in copy  mode, tmux will try to set the terminal
# clipboard, using the sequence stored in the 'Ms' capability (tmux extension):
#
#     $ infocmp -x | grep Ms
#     Ms=\E]52;%p1%s;%p2%s\007, S0=\E(%p1%c, Se=\E[2 q,~
#
# This is an issue if you want to set the terminal clipboard yourself via `$ xsel` (or `$ xclip`),
# with a modified version of the selection, because there may be a race condition between
# `$ xsel` and tmux, and tmux may win.
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
# The output should be:
#
#     foobar~
#
# See `$ man tmux /^\s*set-clipboard` for more info.
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
#          'buf'"
#}}}

tmux set -F @set-clipboard-save '#{set-clipboard}' \; \
    set set-clipboard off \; \
    send -X "$1" "$2" "$3" \; \
    set -F set-clipboard '#{@set-clipboard-save}' \; set -u @set-clipboard-save

