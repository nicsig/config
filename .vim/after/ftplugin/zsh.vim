" Why do you load the 'sh' filetype plugins for 'zsh'?{{{
"
" It's convenient to avoid repeating ourselves.
" For example, for folding settings.
"
" Besides, the default zsh indent plugin does something similar:
"
"     " $VIMRUNTIME/indent/zsh.vim:14
"     runtime! indent/sh.vim
"}}}
runtime! ftplugin/sh.vim

