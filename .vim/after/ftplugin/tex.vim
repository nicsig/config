augroup my_tex
    au! * <buffer>
    au BufWinEnter <buffer> setl cocu=nc cole=3

    " FIXME:
    " Replace this autocmd with a custom syntax highlighting.
    au BufWinEnter <buffer> call s:conceal_commentleader()
augroup END

fu! s:conceal_commentleader() abort
    if exists('s:match')
        "  ┌ the match may not exist anymore
        "  │
        "  │ MWE:
        "  │ close a window, and restore it (<space>u),
        "  │ while a tex buffer is open
        sil! call matchdelete(s:match)
    endif

    " For some reason, the previous `matchdelete()` is not enough.
    " A duplicate match may persist.
    let i = index(map(getmatches(), {i,v -> v.group}), 'Conceal')
    if i !=# -1
        sil! call matchdelete(getmatches()[i].id)
    endif

    let s:match = matchadd('Conceal', '^\s*\zs%@\@!\s\?', 0, -1, {'cchar': 'x'})
endfu

nmap  <buffer><nowait><silent>  <bslash>C  <plug>(vimtex-compile)
nmap  <buffer><nowait><silent>  <bslash>c  <plug>(vimtex-compile-ss)
nmap  <buffer><nowait><silent>  <bslash>n  <plug>(vimtex-clean)
nmap  <buffer><nowait><silent>  <bslash>N  <plug>(vimtex-clean-full)
nmap  <buffer><nowait><silent>  <bslash>S  <plug>(vimtex-stop-all)
nmap  <buffer><nowait><silent>  <bslash>s  <plug>(vimtex-stop)
nmap  <buffer><nowait><silent>  <bslash>v  <plug>(vimtex-view)

let b:mc_chain = [
\    'omni',
\    'ulti',
\    'keyp',
\ ]

" teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
\                     .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     ."
\                        setl cocu< cole<
\                      | unlet! b:mc_chain
\                      | exe 'au! my_tex * <buffer>'
\                      | exe 'nunmap <buffer> <bslash>c'
\                      | exe 'nunmap <buffer> <bslash>C'
\                      | exe 'nunmap <buffer> <bslash>n'
\                      | exe 'nunmap <buffer> <bslash>N'
\                      | exe 'nunmap <buffer> <bslash>s'
\                      | exe 'nunmap <buffer> <bslash>S'
\                      | exe 'nunmap <buffer> <bslash>v'
\                      "
