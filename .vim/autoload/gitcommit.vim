fu! gitcommit#remap_minus() abort "{{{1
    let minus_map = maparg('-', 'n', 0, 1)
    if !has_key(minus_map, 'rhs') || !has_key(minus_map, 'sid')
        return
    endif
    "                                         ┌ We could use just -, but if we press it
    "                                         │ on the wrong line, we may end up opening
    "                                         │ the file explorer.
    "                                         │
    exe printf('nno <buffer><nowait><silent>  `-  %s',
    \           substitute(
    \               substitute(minus_map.rhs, '\c<sid>', '<snr>'.minus_map.sid.'_', 'g'),
    \           '|', '<bar>', 'g'))
endfu

fu! gitcommit#read_last_message() abort "{{{1
    let file = $XDG_RUNTIME_DIR.'/vim_last_commit_message'
    if filereadable(file)
        exe '0r '.file
        " need  to write,  otherwise if  we just  execute `:x`,  git doesn't  commit
        " because, for some reason, it thinks we didn't write anything
        w
    endif
endfu

fu! gitcommit#save_next_message() abort "{{{1
    augroup my_commit_msg_save
        au! * <buffer>
        au BufWinLeave <buffer> 1;/^# Please enter the commit message/-2w! $XDG_RUNTIME_DIR/vim_last_commit_message
        \|                      exe 'au! my_commit_msg_save'
        \|                      exe 'aug! my_commit_msg_save'
    augroup END
endfu
