if exists('g:loaded_fugitive') || stridx(&rtp, 'vim-fugitive') == -1 || exists('g:no_plugin')
    finish
endif

" conceal path in qf window after executing `:Glog`

augroup my_fugitive
    au!
    au CmdlineLeave : if getcmdline() is# 'Glog' | call plugin#fugitive#glog_conceal('on_quickfixcmdpost') | endif
augroup END

fu plugin#fugitive#glog_conceal(when) abort
    if a:when is# 'on_quickfixcmdpost'
        au QuickFixCmdPost * ++once sil! call s:glog_conceal('now')
    else
        call qf#set_matches('my_fugitive:glog_conceal', 'Conceal', 'location')
        call qf#create_matches()
    endif
endfu

