" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

nno  <buffer> <nowait> <silent>  H       :<c-u>call vim_plug#show_documentation()<cr>
nno  <buffer> <nowait> <silent>  J       :<c-u>call vim_plug#scroll_preview(1)<cr>
nno  <buffer> <nowait> <silent>  K       :<c-u>call vim_plug#scroll_preview(0)<cr>
" move between commits
nno  <buffer> <nowait> <silent>  <c-n>   :<c-u>call search('^  \X*\zs\x')<cr>
nno  <buffer> <nowait> <silent>  <c-p>   :<c-u>call search('^  \X*\zs\x', 'b')<cr>
" move between commits, and make preview window display new current commit
nmap <buffer> <nowait> <silent>  <c-j>   <c-n>o
nmap <buffer> <nowait> <silent>  <c-k>   <c-p>o

" Teardown {{{1

let b:undo_ftplugin =          get(b:, 'undo_ftplugin', '')
\                     . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     . "
\                         exe 'nunmap <buffer> H'
\                      |  exe 'nunmap <buffer> J'
\                      |  exe 'nunmap <buffer> K'
\                      |  exe 'nunmap <buffer> <c-j>'
\                      |  exe 'nunmap <buffer> <c-k>'
\                      |  exe 'nunmap <buffer> <c-n>'
\                      |  exe 'nunmap <buffer> <c-p>'
\                       "
