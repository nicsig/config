vim9script noclear

if exists('loaded') || stridx(&rtp, 'limelight.vim') == -1
    finish
endif
var loaded = true

# Number of preceding/following paragraphs to include (default: 0)
g:limelight_paragraph_span = 0

