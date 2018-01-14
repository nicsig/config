fu! vim_plug#move_between_commits(is_fwd) abort "{{{1
    call search('^  \X*\zs\x', a:is_fwd ? '' : 'b')
    " don't fire  `WinEnter` nor `WinLeave`  when we (`o`) temporarily  give the
    " focus  to the  preview window;  otherwise,  the latter  will be  minimized
    " (because of one of our custom autocmd?)
    set ei=WinEnter,WinLeave
    norm o
    " Alternative: call feedkeys('o', 'ix')
    "                                   │
    "                                   └ necessary:
    "
    " Otherwise  Vim  will  type  `o`  after  having  finished  processing  this
    " function,  that is  after we  have  reset 'ei',  so the  WinEnter/WinLeave
    " autocmds will interfere.
    set ei=
endfu

fu! vim_plug#show_documentation() abort "{{{1
    let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            exe 'tabe +setf\ help '.doc
        endfor
    endif
endfu
