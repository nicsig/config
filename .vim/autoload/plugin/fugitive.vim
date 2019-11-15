fu plugin#fugitive#glog_conceal(when) abort
    if a:when is# 'on_quickfixcmdpost'
        au QuickFixCmdPost * ++once sil! call s:glog_conceal('now')
    else
        call qf#set_matches('my_fugitive:glog_conceal', 'Conceal', 'location')
        call qf#create_matches()
    endif
endfu

