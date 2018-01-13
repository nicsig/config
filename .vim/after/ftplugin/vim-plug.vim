" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

nno  <buffer><nowait><silent>  H  :<c-u>call vim_plug#show_documentation()<cr>
" move between commits
nno  <buffer><nowait><silent>  <c-n>  :<c-u>call search('^  \X*\zs\x')<cr>
nno  <buffer><nowait><silent>  <c-p>  :<c-u>call search('^  \X*\zs\x', 'b')<cr>
" move between commits, and make preview window display new current commit
nmap  <buffer><nowait><silent>  <c-j>  <plug>(my_noa_on)<c-n>o<plug>(my_noa_off)
nmap  <buffer><nowait><silent>  <c-k>  <plug>(my_noa_on)<c-p>o<plug>(my_noa_off)
"                                      └───────────────┤
"                                                      └ don't fire `WinEnter` nor `WinLeave`
"                                                      when we (`o`) temporarily give the focus
"                                                      to the preview window;
"                                                      otherwise, the latter will be minimized
"                                                      (because of one of our custom autocmd?)

nno  <buffer><nowait><silent>  <plug>(my_noa_on)   :<c-u>set ei=WinEnter,WinLeave<cr>
nno  <buffer><nowait><silent>  <plug>(my_noa_off)  :<c-u>set ei=<cr>

" Teardown {{{1

let b:undo_ftplugin =          get(b:, 'undo_ftplugin', '')
\                     . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     . "
\                         exe 'nunmap <buffer> H'
\                      |  exe 'nunmap <buffer> <c-j>'
\                      |  exe 'nunmap <buffer> <c-k>'
\                      |  exe 'nunmap <buffer> <c-n>'
\                      |  exe 'nunmap <buffer> <c-p>'
\                      |  exe 'nunmap <buffer> <plug>(my_noa_on)'
\                      |  exe 'nunmap <buffer> <plug>(my_noa_off)'
\                       "
