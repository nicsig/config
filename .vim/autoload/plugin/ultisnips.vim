vim9 noclear

def plugin#ultisnips#cancelExpansion(): string #{{{1
    if !get(g:, 'expanding_snippet', false)
        return ''
    endif
    try
        py3 UltiSnips_Manager._current_snippet_is_done()
    # Vim(py3):IndexError: pop from empty list
    catch
    finally
        # Make sure `UltiSnipsExitLastSnippet` is fired.{{{
        #
        # If an error occurred when expanding a snippet, the event is not fired.
        # This can lead to several issues; for example, install this snippet:
        #
        #     snippet cc "color property" bm
        #     color: $1`!p snip.rv = complete(t[1], ['red', 'green', 'blue'])`
        #     $0
        #     endsnippet
        #
        # If the  snippet file  imports python  code, make  sure to  comment the
        # relevant block:
        #
        #     global !p
        #     from snippet_helpers import *
        #     endglobal
        #
        # Now,  try to  expand the  tab  trigger `cc`);  it fails,  and a  stack
        # trace is  displayed in  a new  split.  This  is expected,  because the
        # `complete()` function is not defined.
        #
        # But the  `[Ulti]` flag  remains displayed in  the status  line because
        # `g:expanding_snippet` is still set.
        # Because  of that,  when  you  insert a  trailing  space, it's  wrongly
        # highlighted even while you're insert mode.
        # Besides, if  you get back  to the file where  you tried to  expand the
        # snippet, and press `:` to enter the command-line, you get this error:
        #
        #     Error detected while processing function plugin#ultisnips#cancelExpansion:~
        #     line    2:~
        #     Traceback (most recent call last):~
        #}}}
        timer_start(0, () => execute('do <nomodeline> User UltiSnipsExitLastSnippet'))
        # the timer is necessary to avoid `E523` which is caused by the `<expr>` argument
    endtry
    redraws
    return ''
enddef

def plugin#ultisnips#toggleAutotrigger() #{{{1
    var augroup_name: string = 'UltiSnips_AutoTrigger'
    if exists('#' .. augroup_name)
        exe 'au! ' .. augroup_name
        exe 'aug! ' .. augroup_name
        echom '[UltiSnips AutoTrigger] OFF'
    else
        exe 'augroup ' .. augroup_name | au!
            au InsertCharPre,TextChangedI,TextChangedP * UltiSnips#TrackChange()
        augroup END
        echom '[UltiSnips AutoTrigger] ON'
    endif
enddef

def plugin#ultisnips#saveInfo() #{{{1
    if &ft != 'markdown' || exists('g:my_ultisnips_info')
        return
    endif
    sil g:my_ultisnips_info = {
        'lsb_release -d': systemlist('lsb_release -d')[0]->matchstr('\s\+\zs.*'),
        'st -v':          systemlist('st -v')[0],
        'tmux -V':        systemlist('tmux -V')[0],
        'vim --version':  system('vim --version | sed -n "1s/VIM - Vi IMproved\|(.*//gp ; 2p" | tr -d "\n"'),
        'xterm -v':       systemlist('xterm -v')[0],
        'zsh --version':  systemlist('zsh --version')[0],
        }
enddef

def plugin#ultisnips#status(): string #{{{1
    return exists('g:expanding_snippet') ? '[Ulti]' : ''
enddef

def plugin#ultisnips#preventMemoryLeak(on_enter = true): string #{{{1
    if on_enter
        nno <buffer><expr><nowait> : plugin#ultisnips#cancelExpansion()
            \ .. ':' .. plugin#ultisnips#preventMemoryLeak(v:false)
        nno <buffer><expr><nowait> p plugin#ultisnips#cancelExpansion()
            \ .. 'p' .. plugin#ultisnips#preventMemoryLeak(v:false)
    else
        # We already unmap those on `UltiSnipsExitLastSnippet`.  Why do it again here?{{{
        #
        # Once, the mappings were not removed correctly.
        # I think that sometimes the event is not fired as expected.
        #}}}
        sil! nunmap <buffer> :
        sil! nunmap <buffer> p
    endif
    return ''
enddef

