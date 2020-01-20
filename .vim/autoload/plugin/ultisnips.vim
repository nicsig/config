fu plugin#ultisnips#cancel_expansion() abort "{{{1
    if !get(g:, 'expanding_snippet', 0) | return | endif
    try
        py3 UltiSnips_Manager._current_snippet_is_done()
    " Vim(py3):IndexError: pop from empty list
    catch
        " This fixes the following issue:{{{
        "
        " Install this snippet:
        "
        "     snippet cc "color property" bm
        "     color: $1`!p snip.rv = complete(t[1], ['red', 'green', 'blue'])`
        "     $0
        "     endsnippet
        "
        " If the snippet file imports python code, make sure to comment the relevant block:
        "
        "     global !p
        "     from snippet_helpers import *
        "     endglobal
        "
        " Now,  try to  expand the  tab  trigger `cc`);  it fails,  and a  stack
        " trace is  displayed in  a new  split.  This  is expected,  because the
        " `complete()` function is not defined.
        "
        " But the  `[Ulti]` flag  remains displayed in  the status  line because
        " `g:expanding_snippet` is still set.
        " Because  of that,  when  you  insert a  trailing  space, it's  wrongly
        " highlighted even while you're insert mode.
        " Besides, if  you get back  to the file where  you tried to  expand the
        " snippet, and press `:` to enter the command-line, you get this error:
        "
        "     Error detected while processing function plugin#ultisnips#cancel_expansion:
        "     line    2:
        "     Traceback (most recent call last):
        "}}}
        unlet! g:expanding_snippet
        sil! nunmap <buffer> :
    endtry
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

