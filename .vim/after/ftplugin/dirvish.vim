" Mappings {{{1
" [oP  ]oP  coP {{{2

" Dirvish installs the mappings `C-n` and `C-p` to preview the contents
" of the previous/next file or directory.
" It's redundant with `coP`, and it clashes with our own `C-n` and `C-p`
" to move across tabpages.
sil nunmap  <buffer>  <c-n>
sil nunmap  <buffer>  <c-p>

nno  <buffer><nowait><silent>  [oP  :<c-u>call my_dirvish#toggle_auto_preview(1)<cr>
nno  <buffer><nowait><silent>  ]oP  :<c-u>call my_dirvish#toggle_auto_preview(0)<cr>
nno  <buffer><nowait><silent>  coP  :<c-u>call my_dirvish#toggle_auto_preview(
\                                                  !exists('#my_dirvish_auto_preview'))<cr>

" c-s {{{2

nno  <buffer><nowait><silent>  <c-s>  :<c-u>call dirvish#open('split', 1)<cr>

" c-t {{{2

nno  <buffer><nowait><silent>  <c-t>  :<c-u>call dirvish#open('tabedit', 1)<cr>
xno  <buffer><nowait><silent>  <c-t>  :call dirvish#open('tabedit', 1)<cr>

" c-v c-v {{{2

nno  <buffer><nowait><silent>  <c-v><c-v>  :<c-u>call dirvish#open('vsplit', 1)<cr>

" gh {{{2

" Map `gh` to toggle dot-prefixed entries.
nno  <buffer><nowait><silent>  gh  :<c-u>call my_dirvish#toggle_dot_entries()<cr>

" h    l {{{2

nmap  <buffer><nowait><silent>  h  <plug>(my_dirvish_update)<plug>(dirvish_up)
nmap  <buffer><nowait><silent>  l  <cr>

" q {{{2

" Why?{{{
"
" MWE:
"
"     $ cat /tmp/vimrc
"
"         set rtp^=~/.vim/plugged/vim-dirvish
"         filetype plugin indent on
"
"     $ vim -Nu /tmp/vimrc
"     :tabnew
"     :e /etc/apt
"     q
"         ✘ nothing happens
"
" The issue comes from this file:
"
"     ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim:204
"
" More specifically from this line:
"
"     \ && (1 == bufnr('%') || (prevbuf != bufnr('%') && altbuf != bufnr('%')))
"
" Probably because `prevbuf`, `bufnr('%')` and `altbuf` have all the same value.
"}}}
" FIXME:{{{
"
" We shouldn't need to overwrite this simple dirvish mapping.
" Submit a bug report.
" Or re-implement dirvish.
"}}}
"       nno  <buffer><nowait><silent>  q  :<c-u>bd<cr>
"
" Update:
" I've commented the mapping, because of this:
"
"      $ vim file
"      :tabnew
"      --
"      q
"          →  closes the current window and tabpage (✘)

" R {{{2

" To "toggle" this, just press `R` to reload.
nno  <buffer><nowait><silent>  R  :<c-u>call my_dirvish#reload()<cr>

" x {{{2

xmap  <buffer>         x                               <plug>(my_dirvish_show_arg_pos)<plug>(dirvish_arg)
xno   <buffer><expr>  <plug>(my_dirvish_show_arg_pos)  execute('let g:my_stl_list_position = 2')[0]

" Sort entries, and (maybe) hide the dot-prefixed ones {{{1

let g:dirvish_mode = ':call my_dirvish#sort_and_maybe_hide()'

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   exe 'nunmap <buffer> <c-s>'
                    \|  exe 'nunmap <buffer> <c-t>'
                    \|  exe 'xunmap <buffer> <c-t>'
                    \|  exe 'nunmap <buffer> <c-v><c-v>'
                    \|  exe 'nunmap <buffer> R'
                    \|  exe 'nunmap <buffer> [oP'
                    \|  exe 'nunmap <buffer> ]oP'
                    \|  exe 'nunmap <buffer> coP'
                    \|  exe 'nunmap <buffer> h'
                    \|  exe 'nunmap <buffer> l'
                    \|  exe 'nunmap <buffer> gh'
                    \|  exe 'xunmap <buffer> x'
                    \  "

