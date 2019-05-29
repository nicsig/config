let b:did_ftplugin = 1

" to be able to make a search from several Vim instances
setl noswf

" to avoid polluting the buffer list
setl bh=delete nobl

setl nowrap

augroup my_tmux_prompt
    au! * <buffer>
    au BufWinEnter <buffer> setl cul
augroup END

nno <buffer><expr><nowait><silent> q reg_recording() isnot# '' ? 'q' : ':<c-u>q!<cr>'
nno  <buffer><nowait><silent>  <cr>  :<c-u>sil call system('tmux ' . getline('.'))<cr>
nmap <buffer><nowait><silent>  ZZ    <cr>

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl bh< bl< cul< swf< wrap<
    \ | exe 'au! my_tmux_prompt * <buffer>'
    \ | exe 'nunmap <buffer> q'
    \ | exe 'nunmap <buffer> <cr>'
    \ | exe 'nunmap <buffer> ZZ'
    \ "

