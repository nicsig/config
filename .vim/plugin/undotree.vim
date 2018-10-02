if exists('g:loaded_undotree') || stridx(&rtp, 'undotree') == -1
    finish
endif

" Give automatically the focus to the `undotree` window.
let g:undotree_SetFocusWhenToggle = 1

" Open automatically the diff window.
let g:undotree_DiffAutoOpen = 1

fu! g:Undotree_CustomMap() abort
    nmap  <buffer><nowait><silent>  }  <plug>UndotreeGoPreviousSaved
    nmap  <buffer><nowait><silent>  {  <plug>UndotreeGoNextSaved
    nmap  <buffer><nowait><silent>  )  <plug>UndotreeGoPreviousState
    nmap  <buffer><nowait><silent>  (  <plug>UndotreeGoNextState
endfu

