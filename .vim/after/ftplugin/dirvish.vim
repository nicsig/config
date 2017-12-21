" Mappings {{{1
" . {{{2

xmap  <buffer>         .                               <plug>(my_dirvish_show_arg_pos)<plug>(dirvish_arg)
xno   <buffer><expr>  <plug>(my_dirvish_show_arg_pos)  execute('let g:my_stl_list_position = 1')[0]

" [oP  ]oP  coP {{{2

nno  <buffer><nowait><silent>  [oP  :<c-u>call my_dirvish#toggle_auto_preview(1)<cr>
nno  <buffer><nowait><silent>  ]oP  :<c-u>call my_dirvish#toggle_auto_preview(0)<cr>
nno  <buffer><nowait><silent>  coP  :<c-u>call my_dirvish#toggle_auto_preview(
\                                                  !exists('#my_dirvish_auto_preview'))<cr>

" a {{{2

nmap  <buffer><nowait><silent>  a  :<c-u>call dirvish#open('vsplit', 1)<cr>

" h    l {{{2

nmap  <buffer><nowait><silent>  h  <plug>(my_dirvish_update)<plug>(dirvish_up)
nmap  <buffer><nowait><silent>  l  <cr>

" R {{{2

" To "toggle" this, just press `R` to reload.
nno  <buffer><nowait><silent>  R  :<c-u>call my_dirvish#reload()<cr>

" s {{{2

nmap  <buffer><nowait><silent>  s  :<c-u>call dirvish#open('split', 1)<cr>

" t {{{2

nno  <buffer><nowait><silent>  t  :<c-u>call dirvish#open('tabedit', 1)<cr>
xno  <buffer><nowait><silent>  t  :call dirvish#open('tabedit', 1)<cr>

" zh {{{2
"
" By default, when we go up in the tree, the cursor is positioned on the
" directory which contained the directory where we came from.
" And, when we go down, it's positioned on the entry where we were the very
" first time we visited the current directory.
"
" This makes it possible to traverse the hierarchy in a direction (up/down),
" and come back where we were easily.
"
" For example, if we go in type `-`, we will open Dirvish in the directory
" containing this file.
" From there, we could smash `h` (go up) until we reach the root of the
" filesystem.
" During our journey, we could make a pause and move the cursor on any entry
" inside a directory (`j`, `k`), before continuing going up.
" Then, to get back exactly where we were at the beginning, all we would have
" to do is smash `l` (go down).
"
" However, it seems using `zh` to toggle the dot-prefixed entries breaks those
" features. Be aware of that pb. If it should become too annoying, try and
" find a solution by reading this:
"
"         https://github.com/justinmk/vim-dirvish/issues/58
"         https://github.com/justinmk/vim-dirvish/issues/45
"
" Or, simply hit `u` to show the dot-prefixed entries.
" `u` doesn't seem to break anything.
" However, `R` (to hide them again) does.
" Summary:
"     • `u`          does NOT  break those features
"     • `R` and `zh`      DOES "

" Map `zh` to toggle dot-prefixed entries.
nno  <buffer><nowait><silent>  zh  :<c-u>call my_dirvish#toggle_dot_entries()<cr>

" Sort and hide dot-prefixed files/directories {{{1

" make sure  that `b:dirvish` exists,  because it  doesn't when we  use this
" command:
"
"     git ls-files | vim +'setf dirvish' -
let b:dirvish = get(b:, 'dirvish', {})

" Save current position before hiding dot-prefixed entries.
let b:dirvish['line'] = getline('.')

" Hide them.
if get(b:, 'hide_dot_entries', 1)
    sil keepp g:\v/\.[^\/]+/?$:d_
endif

" sort directories at the top
sort r /[^/]$/
" find first file
let first_file = search('[^/]$', 'cW')
if first_file
    " sort all the files
    norm gsG
endif

" Restore the position.
call search('\V\^'.escape(b:dirvish['line'],'\').'\$', 'cw')

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   exe 'xunmap <buffer> .'
                    \|  exe 'nunmap <buffer> [oP'
                    \|  exe 'nunmap <buffer> ]oP'
                    \|  exe 'nunmap <buffer> coP'
                    \|  exe 'nunmap <buffer> a'
                    \|  exe 'nunmap <buffer> h'
                    \|  exe 'nunmap <buffer> l'
                    \|  exe 'nunmap <buffer> R'
                    \|  exe 'nunmap <buffer> s'
                    \|  exe 'nunmap <buffer> t'
                    \|  exe 'xunmap <buffer> t'
                    \|  exe 'nunmap <buffer> zh'
                    \  "
