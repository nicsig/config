fu plugin#fugitive#glog_conceal(when) abort
    if a:when is# 'on_quickfixcmdpost'
        au QuickFixCmdPost * ++once call plugin#fugitive#glog_conceal('now')
    else
        call qf#set_matches('my_fugitive:glog_conceal', 'Conceal', 'location')
        call qf#create_matches()
    endif
endfu

