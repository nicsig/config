" Why do you load the 'sh' filetype plugins for 'zsh'?{{{
"
" It's convenient to avoid repeating ourselves.
"
" Besides, the default zsh indent plugin does something similar:
"
"     " $VIMRUNTIME/indent/zsh.vim:14
"     runtime! indent/sh.vim
"}}}
runtime! ftplugin/sh.vim

if expand('<afile>:p') is# $HOME..'/.zsh_history'
    " remove duplicate entries in `~/.zsh_history`
    com -bar -buffer -range=% ZshCleanHistory
        \ %!LC_ALL=C awk -F';' '{ i = index($0, ";"); s = substr($0, i+1); if (\!x[s]) { print $0 }; x[s]++ }'
        "   ^------^
        "   https://stackoverflow.com/a/19156442/9780968
    let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
        \ ..'| delc ZshCleanHistory'
endif

