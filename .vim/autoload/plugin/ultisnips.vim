fu plugin#ultisnips#cancel_expansion() abort "{{{1
    if !get(g:, 'expanding_snippet', 0) | return '' | endif
    try
        py3 UltiSnips_Manager._current_snippet_is_done()
    " Vim(py3):IndexError: pop from empty list
    catch
    finally
        " Make sure `UltiSnipsExitLastSnippet` is fired.{{{
        "
        " If an error occurred when expanding a snippet, the event is not fired.
        " This can lead to several issues; for example, install this snippet:
        "
        "     snippet cc "color property" bm
        "     color: $1`!p snip.rv = complete(t[1], ['red', 'green', 'blue'])`
        "     $0
        "     endsnippet
        "
        " If the  snippet file  imports python  code, make  sure to  comment the
        " relevant block:
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
        "     Error detected while processing function plugin#ultisnips#cancel_expansion:~
        "     line    2:~
        "     Traceback (most recent call last):~
        "}}}
        call timer_start(0, {-> execute('do <nomodeline> User UltiSnipsExitLastSnippet')})
        " the timer is necessary to avoid `E523` which is caused by the `<expr>` argument
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
        augroup UltiSnips_AutoTrigger | au!
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
        \ 'lsb_release -d': systemlist('lsb_release -d')[0]->matchstr('\s\+\zs.*'),
        \ 'st -v':          systemlist('st -v')[0],
        \ 'tmux -V':        systemlist('tmux -V')[0],
        \ 'vim --version':  system('vim --version | sed -n "1s/VIM - Vi IMproved\|(.*//gp ; 2p" | tr -d "\n"'),
        \ 'xterm -v':       systemlist('xterm -v')[0],
        \ 'zsh --version':  systemlist('zsh --version')[0],
        \ }
endfu

fu plugin#ultisnips#status() abort "{{{1
    return exists('g:expanding_snippet') ? '[Ulti]' : ''
endfu

fu plugin#ultisnips#prevent_memory_leak(on_enter) abort "{{{1
    if a:on_enter
        nno <buffer><expr><nowait> : plugin#ultisnips#cancel_expansion()
            \ .. ':' .. plugin#ultisnips#prevent_memory_leak(v:false)
        nno <buffer><expr><nowait> p plugin#ultisnips#cancel_expansion()
            \ .. 'p' .. plugin#ultisnips#prevent_memory_leak(v:false)
    else
        " We already unmap those on `UltiSnipsExitLastSnippet`.  Why do it again here?{{{
        "
        " Once, the mappings were not removed correctly.
        " I think that sometimes the event is not fired as expected.
        "}}}
        sil! nunmap <buffer> :
        sil! nunmap <buffer> p
    endif
    return ''
endfu

