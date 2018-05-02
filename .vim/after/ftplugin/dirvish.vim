" FIXME:{{{
"
" MWE:
"     $ cat /tmp/vimrc
"         set rtp^=~/.vim/plugged/vim-dirvish
"         set rtp+=~/.vim/plugged/vim-dirvish/after
"         set wig+=*/.git/**/*
"
"     $ vim -Nu /tmp/vimrc
"         :e ~/.vim/plugged/vim-dirvish
"             → `.git/` is displayed              ✘ (it shouldn't because of our 'wig' value)
"         R
"             → `.git/` is not displayed anymore  ✔
"}}}

" Mappings {{{1
" C-n  C-p {{{2

" Dirvish installs the mappings `C-n` and `C-p` to preview the contents
" of the previous/next file or directory.
" It's redundant with `coP`, and it clashes with our own `C-n` and `C-p`
" to move across tabpages.

sil nunmap  <buffer>  <c-n>
sil nunmap  <buffer>  <c-p>

" c-s {{{2

nno  <buffer><nowait><silent>  <c-s>  :<c-u>call dirvish#open('split', 1)<cr>

" c-t {{{2

nno  <buffer><nowait><silent>  <c-t>  :<c-u>call dirvish#open('tabedit', 1)<cr>
xno  <buffer><nowait><silent>  <c-t>  :call dirvish#open('tabedit', 1)<cr>

" c-v c-v {{{2

nno  <buffer><nowait><silent>  <c-v><c-v>  :<c-u>call dirvish#open('vsplit', 1)<cr>

" [oP  ]oP  coP {{{2

nno  <buffer><nowait><silent>  [oP  :<c-u>call my_dirvish#toggle_auto_preview(1)<cr>
nno  <buffer><nowait><silent>  ]oP  :<c-u>call my_dirvish#toggle_auto_preview(0)<cr>
nno  <buffer><nowait><silent>  coP  :<c-u>call my_dirvish#toggle_auto_preview(
\                                                  !exists('#my_dirvish_auto_preview'))<cr>

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

" x {{{2

xmap  <buffer>         x                               <plug>(my_dirvish_show_arg_pos)<plug>(dirvish_arg)
xno   <buffer><expr>  <plug>(my_dirvish_show_arg_pos)  execute('let g:my_stl_list_position = 2')[0]

" !m {{{2

nno  <buffer><nowait><silent>  !m  :<c-u>call my_dirvish#show_metadata('manual')<cr>
nno  <buffer><nowait><silent>  !M  :<c-u>call my_dirvish#show_metadata('auto')<cr>

" g:dirvish_mode {{{1

let g:dirvish_mode = ':call my_dirvish#format_entries()'

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   exe 'nunmap <buffer> <c-s>'
                    \ | exe 'nunmap <buffer> <c-t>'
                    \ | exe 'xunmap <buffer> <c-t>'
                    \ | exe 'nunmap <buffer> <c-v><c-v>'
                    \ | exe 'nunmap <buffer> [oP'
                    \ | exe 'nunmap <buffer> ]oP'
                    \ | exe 'nunmap <buffer> coP'
                    \ | exe 'nunmap <buffer> h'
                    \ | exe 'nunmap <buffer> l'
                    \ | exe 'nunmap <buffer> gh'
                    \ | exe 'nunmap <buffer> !m'
                    \ | exe 'nunmap <buffer> !M'
                    \ | exe 'xunmap <buffer> x'
                    \  "

