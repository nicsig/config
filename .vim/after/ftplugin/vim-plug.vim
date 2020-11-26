" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

" move between commits, and make preview window display new current commit
nno <buffer><nowait> ) <cmd>call plugin#plug#move_between_commits()<cr>
nno <buffer><nowait> ( <cmd>call plugin#plug#move_between_commits(v:false)<cr>

nno <buffer><nowait> H <cmd>call plugin#plug#show_documentation()<cr>

nmap <buffer> p o

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| call plugin#plug#undo_ftplugin()'

