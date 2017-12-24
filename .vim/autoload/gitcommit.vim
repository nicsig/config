fu! gitcommit#save_next_message() abort "{{{1
    augroup my_commit_msg_save
        au! * <buffer>
        au VimLeave <buffer> 1;/^# Please enter the commit message/-2w! $XDG_RUNTIME_DIR/vim_last_commit_message
        \|                   exe 'au! my_commit_msg_save'
        \|                   exe 'aug! my_commit_msg_save'
    augroup END
endfu
