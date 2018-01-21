" Mappings {{{1

" https://github.com/junegunn/vim-plug/wiki/extra

" move between commits, and make preview window display new current commit
nno  <buffer><nowait><silent>  <c-n>  :<c-u>call vim_plug#move_between_commits(1)<cr>
nno  <buffer><nowait><silent>  <c-p>  :<c-u>call vim_plug#move_between_commits(0)<cr>

nno  <buffer><nowait><silent>  H  :<c-u>call vim_plug#show_documentation()<cr>

if has_key(get(g:, 'plugs', {}), 'vim-lg-lib') && !exists('b:repeatable_motions')
    call lg#motion#repeatable#main#make({
    \        'mode':   'n',
    \        'buffer': 1,
    \        'axis':   {'bwd': ',', 'fwd': ';'},
    \        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
    \        'motions': [
    \                     {'bwd': '<c-p>',  'fwd': '<c-n>'},
    \                   ]
    \ })
endif

" Teardown {{{1

let b:undo_ftplugin =          get(b:, 'undo_ftplugin', '')
\                     . (empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
\                     . "
\                         exe 'nunmap <buffer> H'
\                      |  exe 'nunmap <buffer> <c-n>'
\                      |  exe 'nunmap <buffer> <c-p>'
\                       "
