if exists('g:loaded_limelight') || stridx(&rtp, 'limelight.vim') == -1
    finish
endif

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 0

