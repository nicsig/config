if exists('g:loaded_dirvish') || stridx(&rtp, 'vim-dirvish') == -1
    finish
endif

const g:dirvish_mode = ':call fex#formatEntries()'

