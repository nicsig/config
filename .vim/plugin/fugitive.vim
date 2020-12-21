if exists('g:loaded_fugitive') || stridx(&rtp, 'vim-fugitive') == -1
    finish
endif

" conceal path in qf window after executing `:Glog`

augroup MyFugitive | au!
    au CmdlineLeave : if getcmdline() is# 'Glog'
        \ | call plugin#fugitive#glog_conceal('on_quickfixcmdpost')
        \ | endif
augroup END

