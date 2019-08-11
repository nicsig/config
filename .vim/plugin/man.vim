if has('nvim')
    " Why ?{{{
    "
    "     $ man man
    "     :Man man
    "
    " The lines are too long and `'showbreak'` is on.
    "}}}
    let g:man_hardwrap = 1
    augroup my_man
        au!
        au FileType man nmap <buffer><nowait><silent> <cr> <c-]>
        au FileType man nmap <buffer><nowait><silent> -t gO
    augroup END
else
    let g:ft_man_folding_enable = 1
endif

