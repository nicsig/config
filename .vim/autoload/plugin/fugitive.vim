vim9 noclear

def plugin#fugitive#glogConceal(when: string)
    if when == 'on_quickfixcmdpost'
        au QuickFixCmdPost * ++once plugin#fugitive#glogConceal('now')
    else
        qf#setMatches('my_fugitive:glog_conceal', 'Conceal', 'location')
        qf#createMatches()
    endif
enddef

