if fnamemodify(expand('%:p'), ':t') ==# 'COMMIT_EDITMSG'
    call gitcommit#read_last_message()
    call gitcommit#save_next_message()
endif

" Mappings {{{1

" To save a buffer, we use a mapping like this:
"
"     nno <silent> <c-s> :call Func()<cr>
"     fu! Func()
"         sil update
"     endfu
"
" Pb:
"
" For some reason, when we save, the current line becomes temporarily transparent.
" It reappears after we move the cursor on a different line.
" The problem seems to come from an interaction between:
"
"         :silent
"         <silent>
"         a git commit buffer

" Solution:
" Define a simpler buffer-local mapping which doesn't use `:silent`.
nno  <buffer><nowait><silent>  <c-s>  :<c-u>update<cr>

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
\                     .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     ."exe 'nunmap <buffer> <c-s>'"
