" FIXME: in a tmux file, if a commented code block precedes a command,
" the command is highlighted as a comment.
"
" MWE:
"     $ cat <<'EOF' >/tmp/tmux.conf
"     #     x
"     set -s default-terminal tmux-256color
"     EOF
"
"     :syn clear
"     :syn region tmuxComment start=/#/ end=/$/
"     :syn region tmuxCommentCodeBlock matchgroup=Comment start=/# \{5,}/ end=/$/ keepend contained containedin=tmuxComment oneline
"
" I can reproduce the issue in a conf file, with a MWE.
" But in practice, there's no issue in a conf file; so the issue must affect
" all filetypes, but sth must fix it in most of them, except in tmux...
"
" Update:
" The issue is that a comment in tmux is defined as a region whose end is `$`.
" The latter is consumed by our codeblock.
" If the  region defining a tmux  comment was defined with  `keepend`, there
" would be no issue.
"
" I think we have a fundamental issue every time we used `end=/$/` in this file...
" Maybe also with sth like `.*` in a match...
"
" ---
"
" Also, why doesn't a comment codeblock work in a C file?
"
syn clear tmuxComment
syn region tmuxComment start=/#/ skip=/\\\@<!\\$/ end=/$/  contains=tmuxTodo keepend

