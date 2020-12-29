vim9script noclear

def plugin#fugitive#glogConceal(when: string)
    if when == 'on_quickfixcmdpost'
        au QuickFixCmdPost * ++once plugin#fugitive#glogConceal('now')
    else
        qf#set_matches('my_fugitive:glog_conceal', 'Conceal', 'location')
        qf#create_matches()
    endif
enddef

