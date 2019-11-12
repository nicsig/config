if exists('g:loaded_undotree') || stridx(&rtp, 'undotree') == -1 || exists('g:no_plugin')
    finish
endif

" Give automatically the focus to the `undotree` window.
let g:undotree_SetFocusWhenToggle = 1

" Don't open automatically the diff window.
let g:undotree_DiffAutoOpen = 0

fu g:Undotree_CustomMap() abort
    nmap <buffer><nowait><silent> } <plug>UndotreePreviousSavedState
    nmap <buffer><nowait><silent> { <plug>UndotreeNextSavedState
    nmap <buffer><nowait><silent> ) <plug>UndotreePreviousState
    nmap <buffer><nowait><silent> ( <plug>UndotreeNextState

    nno <buffer><nowait><silent> < <nop>
    nno <buffer><nowait><silent> > <nop>
    nno <buffer><nowait><silent> J <nop>
    nno <buffer><nowait><silent> K <nop>

    " Purpose: Override the builtin help which doesn't take into account our custom mappings.
    nno <buffer><nowait><silent> ? :<c-u>call <sid>show_help()<cr>

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

" shorten the timestamps (second → s, minute → m, ...)
let g:undotree_ShortIndicators = 1

" hide "Press ? for help"
let g:undotree_HelpLine = 0

fu s:show_help() abort
    let help =<< END
   ===== Marks =====
>num< : The current state
{num} : The next redo state
[num] : The latest state
  s   : Saved states
  S   : The last saved state

  ===== Hotkeys =====
u : Undo
<c-r> : Redo
} : Move to the previous saved state
{ : Move to the next saved state
) : Move to the previous undo state
( : Move to the next undo state
D : Toggle the diff panel
T : Toggle relative timestamp
C : Clear undo history (with confirmation)
END
    echo join(help, "\n")
endfu

