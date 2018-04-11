" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

" move between commits, and make preview window display new current commit
nno  <buffer><nowait><silent>  <c-j>  :<c-u>call vim_plug#move_between_commits(1)<cr>
nno  <buffer><nowait><silent>  <c-k>  :<c-u>call vim_plug#move_between_commits(0)<cr>

nno  <buffer><nowait><silent>  H  :<c-u>call vim_plug#show_documentation()<cr>

" Commented for the moment, because it breaks the `C-j` mapping.
"
"     if has_key(get(g:, 'plugs', {}), 'vim-lg-lib')
"         call lg#motion#repeatable#make#all({
"         \        'mode':   'n',
"         \        'buffer': 1,
"         \        'axis':   {'bwd': ',', 'fwd': ';'},
"         \        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
"         \        'motions': [
"         \                     {'bwd': '<c-j>',  'fwd': '<c-k>'},
"         \                   ]
"         \ })
"     endif

" Teardown {{{1

let b:undo_ftplugin =          get(b:, 'undo_ftplugin', '')
\                     . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     . "
\                         exe 'nunmap <buffer> H'
\                      |  exe 'nunmap <buffer> <c-j>'
\                      |  exe 'nunmap <buffer> <c-k>'
\                       "
