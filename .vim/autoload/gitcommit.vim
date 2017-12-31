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
        au VimLeave <buffer> 1;/^# Please enter the commit message/-2w! $XDG_RUNTIME_DIR/vim_last_commit_message
        \|                   exe 'au! my_commit_msg_save'
        \|                   exe 'aug! my_commit_msg_save'
    augroup END
endfu
