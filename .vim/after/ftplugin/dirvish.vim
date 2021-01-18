" Options {{{1

let &l:stl = '%!g:statusline_winid == win_getid() ? "%y %F%<%=%l/%L " : "%y %F"'
" in a squashed dirvish window, displaying the line/column position is useless (noise)

" Mappings {{{1
" -m {{{2

nno <buffer><nowait> -m <cmd>call fex#printMetadata()<cr>
xno <buffer><nowait> -m <c-\><c-n><cmd>call fex#printMetadata()<cr>
nno <buffer><nowait> -M <cmd>call fex#printMetadata(v:true)<cr>

" C-n  C-p {{{2

" Dirvish installs the mappings `C-n` and `C-p` to preview the contents
" of the previous/next file or directory.
" It clashes with our own `C-n` and `C-p` to move across tabpages.
" Besides, we'll use `}` and `{` instead.

nunmap <buffer> <c-n>
nunmap <buffer> <c-p>

" gh {{{2

" Map `gh` to toggle dot-prefixed entries.
nno <buffer><nowait> gh <cmd>call fex#toggleDotEntries()<cr>

" h    l {{{2

nmap <buffer><nowait><silent> h <plug>(dirvish_up)
nmap <buffer><nowait><silent> l <cr>

" p ) ( {{{2

nno <buffer><nowait> p <cmd>call fex#preview()<cr>
nno <buffer><nowait> ) j<cmd>call fex#preview()<cr>
nno <buffer><nowait> ( k<cmd>call fex#preview()<cr>

" q {{{2

nmap <buffer><nowait><silent> q gq

" tp {{{2

nno <buffer><nowait> tp <cmd>call fex#trashPut()<cr>
"}}}1
" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| call plugin#dirvish#undoFtplugin()'

