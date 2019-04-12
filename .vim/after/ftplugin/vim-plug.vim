" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

" move between commits, and make preview window display new current commit
nno  <buffer><nowait><silent>  }  :<c-u>call vim_plug#move_between_commits(1)<cr>
nno  <buffer><nowait><silent>  {  :<c-u>call vim_plug#move_between_commits(0)<cr>

nno  <buffer><nowait><silent>  H  :<c-u>call vim_plug#show_documentation()<cr>

nmap  <buffer>  p  o

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | exe 'nunmap <buffer> H'
    \ | exe 'nunmap <buffer> o'
    \ | exe 'nunmap <buffer> }'
    \ | exe 'nunmap <buffer> {'
    \ "

