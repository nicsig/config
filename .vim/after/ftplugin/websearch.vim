" to be able to make a search from several Vim instances
setl noswf

augroup my_websearch
    au! * <buffer>
    au BufWinEnter <buffer> setl cul
augroup END

let b:url = 'https://www.startpage.com/do/search?cat=&language=english&cmd=process_search&query='

nno  <buffer><nowait><silent>  q  :<c-u>q<cr>
nno  <buffer><nowait><silent>  <cr>  :<c-u>sil call system('xdg-open ' . shellescape(b:url . getline('.')))<bar>q<cr>
nmap <buffer><nowait><silent>  ZZ    <cr>

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl cul< swf<
    \ | unlet! b:url
    \ | exe 'au! my_websearch * <buffer>'
    \ | exe 'nunmap <buffer> q'
    \ | exe 'nunmap <buffer> <cr>'
    \ "

