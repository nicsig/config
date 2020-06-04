let b:did_ftplugin = 1

" to be able to make a search from several Vim instances
setl noswf

" to avoid polluting the buffer list
" Why the value 'wipe', and not 'delete'?{{{
"
" If we press `SPC q` to quit the window, `window#quit#main()` will run `:close`.
" If we have unsaved changes, this will raise `E37`:
"
"     Vim(close):E37: No write since last change (add ! to override)
"
" However, if the value of 'bh' is 'wipe', then `window#quit#main()` adds a bang
" (`:close!`), which avoids the error.
"}}}
setl bh=wipe nobl

setl nowrap

setl cul

sil! call lg#set_stl('%y%=%l ', '%y')

let b:url = 'https://www.startpage.com/do/search?cat=&language=english&cmd=process_search&query='

nno <buffer><expr><nowait> q reg_recording() isnot# '' ? 'q' : ':<c-u>q!<cr>'
nno <buffer><nowait><silent> <cr> :<c-u>call plugin#websearch#main()<cr>
nmap <buffer><nowait><silent> ZZ <cr>

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| call websearch#undo_ftplugin()'

