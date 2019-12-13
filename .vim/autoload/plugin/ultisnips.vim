fu plugin#ultisnips#cancel_expansion() abort "{{{1
    py3 UltiSnips_Manager._current_snippet_is_done()
    redraws
    return ''
endfu

fu plugin#ultisnips#toggle_autotrigger() abort "{{{1
    if exists('#UltiSnips_AutoTrigger')
        au! UltiSnips_AutoTrigger
        aug! UltiSnips_AutoTrigger
        echom '[UltiSnips AutoTrigger] OFF'
    else
        augroup UltiSnips_AutoTrigger
            au!
            au InsertCharPre,TextChangedI,TextChangedP * call UltiSnips#TrackChange()
        augroup END
        echom '[UltiSnips AutoTrigger] ON'
    endif
endfu

fu plugin#ultisnips#save_info() abort "{{{1
    if &ft isnot# 'markdown' || exists('g:my_ultisnips_info')
        return
    endif
    sil let g:my_ultisnips_info = {
        \ 'lsb_release -d': matchstr(systemlist('lsb_release -d')[0], '\s\+\zs.*'),
        \ 'st -v': systemlist('st -v')[0],
        \ 'tmux -V': systemlist('tmux -V')[0],
        \ 'vim --version': system('vim --version | sed -n "1s/VIM - Vi IMproved\|(.*//gp ; 2p" | tr -d "\n"'),
        \ 'nvim --version': systemlist('nvim --version | sed -n "1p"')[0],
        \ 'xterm -v': systemlist('xterm -v')[0],
        \ 'zsh --version' : systemlist('zsh --version')[0],
        \ }
endfu

fu plugin#ultisnips#status() abort "{{{1
    return exists('g:expanding_snippet') ? '[Ulti]' : ''
endfu

