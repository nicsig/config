let b:did_ftplugin = 1

" to be able to make a search from several Vim instances
setl noswf

" to avoid polluting the buffer list
" Why the value 'wipe', and not 'delete'?{{{
"
" If we press `SPC q` to quit the window, `lg#window#quit()` will run `:close`.
" If we have unsaved changes, this will raise `E37`:
"
"     Vim(close):E37: No write since last change (add ! to override)
"
" However, if the  value of 'bh' is 'wipe', then  `lg#window#quit()` adds a bang
" (`:close!`), which avoids the error.
"}}}
setl bh=wipe nobl

setl nowrap

setl cul

call lg#set_stl('%y%=%-'..winwidth(0)/8..'l', '%y')

let b:url = 'https://www.startpage.com/do/search?cat=&language=english&cmd=process_search&query='

nno <buffer><expr><nowait><silent> q reg_recording() isnot# '' ? 'q' : ':<c-u>q!<cr>'
" Why do you remove all double quotes in the search?{{{
"
" Double quotes can break `xdg-open(1)`.
"
" Remove `substitute()` and try to search for `"foo bar"`.
" xdg-open will start a second web browser window, in which one tab searches for
" 'foo', and another tab points to this url: https://www.bar.com/
"
" I think the issue is due to the space inside the double quotes.
" For the moment, I don't care about double quotes being preserved in the search.
" I care about the search being  more predictable, even when it contains special
" characters.
"}}}
nno <buffer><nowait><silent> <cr> :<c-u>sil call system('xdg-open '
    \ . shellescape(b:url . substitute(getline('.'), '"', '', 'g')))
    \ <bar>q!<cr>
nmap <buffer><nowait><silent>  ZZ    <cr>

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ ..'| call websearch#undo_ftplugin()'

