" conceal path in qf window after executing `:Glog`

augroup my_fugitive
    au!
    au CmdlineLeave : if getcmdline() is# 'Glog' | call s:glog_conceal(0) | endif
augroup END

fu! s:glog_conceal(step) abort
    if a:step is 0
        augroup my_glog_conceal
            au!
            au QuickFixCmdPost * call s:glog_conceal(1)
                             \ | exe 'au! my_glog_conceal' | aug! my_glog_conceal
        augroup END
    else
        call qf#set_matches('my_fugitive:glog_conceal', 'Conceal', 'location')
        call qf#create_matches()
    endif
endfu
