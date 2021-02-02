vim9 noclear

if exists('loaded') || exists('g:loaded_undotree') || stridx(&rtp, 'undotree') == -1
    finish
endif
var loaded = true

# Give automatically the focus to the `undotree` window.
g:undotree_SetFocusWhenToggle = true

# Don't open automatically the diff window.
g:undotree_DiffAutoOpen = false

# shorten the timestamps (second → s, minute → m, ...)
g:undotree_ShortIndicators = true

# hide "Press ? for help"
g:undotree_HelpLine = false

nno <unique> -u <cmd>call plugin#undotree#show()<cr>

def g:Undotree_CustomMap() #{{{1
    nmap <buffer><nowait><silent> } <plug>UndotreePreviousSavedState
    nmap <buffer><nowait><silent> { <plug>UndotreeNextSavedState
    nmap <buffer><nowait><silent> ) <plug>UndotreePreviousState
    nmap <buffer><nowait><silent> ( <plug>UndotreeNextState

    nno <buffer><nowait> < <nop>
    nno <buffer><nowait> > <nop>
    nno <buffer><nowait> J <nop>
    nno <buffer><nowait> K <nop>

    # Purpose: Override the builtin help which doesn't take into account our custom mappings.
    nno <buffer><nowait> ? <cmd>call plugin#undotree#showHelp()<cr>

    # Purpose: set the preview flag in the diff panel, which lets us:{{{
    #
    #    1. view its contents without focusing it (otherwise, it's squashed to 0 lines)
    #    2. scroll its contents without focusing it (`M-j`, ...)
    #
    # Regarding  `1.`,   you  could   achieve  the   same  result   by  tweaking
    # `HeightShouldBeReset()` in `vim-window`, and include this condition:
    #
    #     || (winbufnr(a:nr)->bufname() =~ '^diffpanel_\d\+$')
    #
    # Regarding `2.`, if you had to focus the diff panel to scroll its contents,
    # its height would be maximized; you  could find this sudden height increase
    # jarring.
    #}}}
    nno <buffer><nowait> D <cmd>call plugin#undotree#diffToggle()<cr>

    # dummy item to get an empty status line
    setl stl=%h
    b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe') .. '| set stl<'
enddef

