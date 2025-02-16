vim9script noclear

# Interface {{{1
def plugin#undotree#show() #{{{2
    if &bt != ''
        echo printf('no undotree for a special buffer (&bt == %s)', &bt)
        return
    endif

    # Purpose:{{{
    #
    # If you had several windows in your  tab page prior to opening the undotree
    # window, when you close the diff panel, the geometry of your windows may be
    # altered (not if you've opened undotree from the last window).
    #
    # To fix this, when closing the diff  panel, we'll fire `do WinEnter` in the
    # window from which we've opened undotree; but to do this, we need its id.
    #}}}
    # Warning: The way we handle this variable is not totally reliable.{{{
    #
    # It doesn't  update the  variable if  we focus  a different  regular window
    # (without  closing  the undotree  window),  then  focus back  the  undotree
    # window.
    #
    # Such a use case is tricky to support.
    # You would  need to  install an autocmd  listening to  `WinEnter <buffer>`.
    # But undotree often  temporarily focuses regular windows on  its own (among
    # other things to add/remove signs when we open/close the diff panel).
    # So, you  would need to find  a way to ignore  those involuntary `WinEnter`
    # events.   Or  you  could  try  to   refactor  undotree  so  that  it  uses
    # `win_execute()`.
    #}}}
    t:undotree_prevwinid = win_getid()

    # A similar autocmd is already installed in `...#diff_toggle()`.  Why installing yet another one here?{{{
    #
    # If  you close  the undotree  window  while the  diff panel  is open,  then
    # re-open the undotree window, the diff panel is automatically re-opened.
    # But in  that case, `D` has  not been pressed, and  `...#diff_toggle()` has
    # not been invoked; so the autocmd is not installed.
    #
    # MWE:
    #
    #     $ vim file
    #     " press -u to open undotree window
    #     " press D to open diff panel
    #     " press q to close undotree window and diff panel
    #     " press -u to open undotree window again
    #}}}
    # Ok, but why the guard?{{{
    #
    # Well, when you  press `-u`, there's no guarantee that  the diff panel will
    # be automatically opened; it depends on what you did the last time (did you
    # open the diff panel or not?).
    # So, we need  a guard to be  sure that we customize the  right diff buffer;
    # that is one which is associated to an undotree buffer.
    #}}}
    au FileType diff ++once if winnr('#')->getwinvar('&ft') == 'undotree'
        |     CustomizeDiffPanel()
        | endif

    UndotreeShow
    au BufWinLeave <buffer> ++once unlet! t:undotree_prevwinid
enddef

def plugin#undotree#showHelp() #{{{2
    var help: list<string> =<< END
   ===== Marks =====
>num<: The current state
{num}: The next redo state
[num]: The latest state
  s: Saved states
  S: The last saved state

  ===== Hotkeys =====
u: Undo
<c-r>: Redo
}: Move to the previous saved state
{: Move to the next saved state
): Move to the previous undo state
(: Move to the next undo state
D: Toggle the diff panel
T: Toggle relative timestamp
C: Clear undo history (with confirmation)
END
    echo join(help, "\n")
enddef

fu plugin#undotree#diffToggle() abort "{{{2
    let pv_bufnr = tabpagebuflist()
        \ ->filter({_, v -> bufwinnr(v)->getwinvar('&pvw')})
        \ ->get(0, 0)
    " if there is already a preview window, ask the user to close it (to avoid `E590`)
    if pv_bufnr && bufname(pv_bufnr) !~# '^diffpanel_\d\+$'
        unsilent echo 'close the preview window first'
        return
    endif
    " check we are going to *open* the diff panel (and not close it)
    if !pv_bufnr
        au FileType diff ++once call s:CustomizeDiffPanel()
    endif
    call t:undotree.Action('DiffToggle')
    if exists('t:undotree_prevwinid')
        call win_execute(t:undotree_prevwinid, 'do <nomodeline> WinEnter')
    endif
endfu

fu plugin#undotree#closeDiffPanel() abort "{{{2
    " This function is public because we need to be able to call it when we press `SPC q`.
    let bufnr = tabpagebuflist()
        \ ->filter({_, v -> getbufvar(v, '&ft') is# 'undotree'})
        \ ->get(0, 0)
    if bufnr
        let winnr = bufwinnr(bufnr)
        exe winnr .. 'wincmd w'
        if &ft is# 'undotree'
            call t:undotree.Action('DiffToggle')
        else
            echo 'press "D" from the undotree buffer for signs to be removed'
        endif
    else
        echo 'press "D" from the undotree buffer for signs to be removed'
    endif
endfu

def plugin#undotree#stl(): string #{{{2
    return g:statusline_winid == win_getid()
        ? ' %l,%c%=%{&l:pvw ? "[pvw]" : ""}%p%% '
        : '%=%{&l:pvw ? "[pvw]" : ""}%p%% '
enddef
#}}}1
# Core {{{1
def CustomizeDiffPanel() #{{{2
    setl pvw
    # In the diff panel, the undotree plugin sets a status line, which I don't find useful.
    # Let's use our own.
    &l:stl = '%!plugin#undotree#stl()'
    b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe') .. '| set stl<'
    nno <buffer><nowait> q <cmd>call plugin#undotree#closeDiffPanel()<cr>
enddef

