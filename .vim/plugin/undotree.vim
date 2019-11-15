if exists('g:loaded_undotree') || stridx(&rtp, 'undotree') == -1
    finish
endif

" Give automatically the focus to the `undotree` window.
let g:undotree_SetFocusWhenToggle = 1

" Don't open automatically the diff window.
let g:undotree_DiffAutoOpen = 0

" shorten the timestamps (second → s, minute → m, ...)
let g:undotree_ShortIndicators = 1

" hide "Press ? for help"
let g:undotree_HelpLine = 0

nno <silent><unique> -u :<c-u>call plugin#undotree#show()<cr>

fu g:Undotree_CustomMap() abort "{{{1
    nmap <buffer><nowait><silent> } <plug>UndotreePreviousSavedState
    nmap <buffer><nowait><silent> { <plug>UndotreeNextSavedState
    nmap <buffer><nowait><silent> ) <plug>UndotreePreviousState
    nmap <buffer><nowait><silent> ( <plug>UndotreeNextState

    nno <buffer><nowait><silent> < <nop>
    nno <buffer><nowait><silent> > <nop>
    nno <buffer><nowait><silent> J <nop>
    nno <buffer><nowait><silent> K <nop>

    " Purpose: Override the builtin help which doesn't take into account our custom mappings.
    nno <buffer><nowait><silent> ? :<c-u>call plugin#undotree#show_help()<cr>

    " Purpose: set the preview flag in the diff panel, which allows us to:{{{
    "
    "    1. view its contents without focusing it (otherwise, it's squashed to 0 lines)
    "    2. scroll its contents without focusing it (`M-j`, ...)
    "
    " Regarding  `1.`,   you  could   achieve  the   same  result   by  tweaking
    " `s:height_should_be_reset()` in `vim-window`, and include this condition:
    "
    "     \ ||  (bufname(winbufnr(a:nr)) =~# '^diffpanel_\d\+$')
    "
    " Regarding `2.`, if you had to focus the diff panel to scroll its contents,
    " its height would be maximized; you  could find this sudden height increase
    " jarring.
    "}}}
    nno <buffer><nowait><silent> D :<c-u>call plugin#undotree#diff_toggle()<cr>

    " Purpose:{{{
    "
    " If you  press `C-h` and `C-l`  to alternate the focus  between an undotree
    " buffer  and  a  markdown  buffer,  inside  the  latter,  the  `&showbreak`
    " character is displayed on and off (because of our `my_showbreak` autocmd);
    " it's distracting.
    "
    " Besides, we don't  want the `&showbreak` character to  be displayed inside
    " an undotree buffer either.
    "}}}
    let b:showbreak = 0
endfu

