if has('nvim')
    " Why?{{{
    "
    " In the past it was needed:
    "
    "     $ man man
    "     :Man man
    "
    " The lines were too long and `'showbreak'` was on.
    "
    " Now, I  think it's not needed  anymore, provided you set  `$MANWIDTH` to a
    " low value (e.g. `80`) in a shell init file; but I keep it just in case.
    "}}}
    let g:man_hardwrap = 1
    augroup my_man
        au!
        au FileType man nmap <buffer><nowait><silent> <cr> <c-]>
        au FileType man nmap <buffer><nowait><silent> -t gO
    augroup END
else
    let g:ft_man_folding_enable = 1
    " make `:Man {number} {name}` behave like `man {number} {name}`,
    " not running `man {name}` if no page is found
    let g:ft_man_no_sect_fallback = 1
endif

