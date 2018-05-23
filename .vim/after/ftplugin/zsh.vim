" load filetype plugin for `sh`

runtime! ftplugin/sh.vim

" Why?{{{
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
setl indk-=o,O

