if exists('g:loaded_undotree') || stridx(&rtp, 'undotree') == -1 || exists('g:no_plugin')
    finish
endif

" Give automatically the focus to the `undotree` window.
let g:undotree_SetFocusWhenToggle = 1

" Don't open automatically the diff window.
let g:undotree_DiffAutoOpen = 0

fu! g:Undotree_CustomMap() abort
    nmap  <buffer><nowait><silent>  }  <plug>UndotreePreviousSavedState
    nmap  <buffer><nowait><silent>  {  <plug>UndotreeNextSavedState
    nmap  <buffer><nowait><silent>  )  <plug>UndotreePreviousState
    nmap  <buffer><nowait><silent>  (  <plug>UndotreeNextState

    nno <buffer><nowait><silent>  <  <nop>
    nno <buffer><nowait><silent>  >  <nop>
    nno <buffer><nowait><silent>  J  <nop>
    nno <buffer><nowait><silent>  K  <nop>
endfu

" shorten the timestamps (second → s, minute → m, ...)
let g:undotree_ShortIndicators = 1

" hide "Press ? for help"
let g:undotree_HelpLine = 0

