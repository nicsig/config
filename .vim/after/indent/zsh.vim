" Rationale:{{{
"
" When we  edit some comments  in a `zsh`  file, the automatic  reindentation is
" annoying.
" For example, sometimes,  when we open a  new line (`o`), Vim  adds 2 undesired
" spaces in front of the comment leader.
"
" The issue seems specific to `zsh`.
" It's probably due to the logic in an indent function here:
"
"         /usr/local/share/vim/vim81/indent/sh.vim
"
" Look for the pattern `zsh`.
"}}}
" Why not like this `setl indk-=o,O,)`?{{{
"
" It will work iff 'indk' contains the  values 'o', 'O' and ')', one right after
" the other:
"
"         " ✔
"         indk=...,o,O,),...
"
"         " ✘
"         indk=...,o,O,...,),...
"
" You don't know that.
"}}}
setl indk-=o
setl indk-=O
setl indk-=)

" Teardown {{{1

let b:undo_indent = get(b:, 'undo_indent', 'exe')
    \ .. '| setl indk<'

