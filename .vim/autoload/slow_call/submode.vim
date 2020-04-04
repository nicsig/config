if stridx(&rtp, 'vim-submode') == -1
    finish
endif

" Normal mode {{{1
" C-w g[hjkl]    tradewinds {{{2

call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gh', '<plug>(tradewinds-h)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gj', '<plug>(tradewinds-j)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gk', '<plug>(tradewinds-k)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gl', '<plug>(tradewinds-l)')
call submode#map(       'tradewinds', 'n', 'r',       'h', '<plug>(tradewinds-h)')
call submode#map(       'tradewinds', 'n', 'r',       'j', '<plug>(tradewinds-j)')
call submode#map(       'tradewinds', 'n', 'r',       'k', '<plug>(tradewinds-k)')
call submode#map(       'tradewinds', 'n', 'r',       'l', '<plug>(tradewinds-l)')

" z C-[hjkl]     resize windows {{{2

call submode#enter_with('resize-window', 'n', 'r', 'z<c-h>', '<plug>(window-resize-h)')
call submode#enter_with('resize-window', 'n', 'r', 'z<c-j>', '<plug>(window-resize-j)')
call submode#enter_with('resize-window', 'n', 'r', 'z<c-k>', '<plug>(window-resize-k)')
call submode#enter_with('resize-window', 'n', 'r', 'z<c-l>', '<plug>(window-resize-l)')

call submode#map('resize-window', 'n', 'r', '<c-h>', '<plug>(window-resize-h)')
call submode#map('resize-window', 'n', 'r', '<c-j>', '<plug>(window-resize-j)')
call submode#map('resize-window', 'n', 'r', '<c-k>', '<plug>(window-resize-k)')
call submode#map('resize-window', 'n', 'r', '<c-l>', '<plug>(window-resize-l)')
"}}}1
" Insert mode {{{1
" C-g [<>]       indent {{{2

" We lost the ability to change the level of indentation on the line.
" Because we prefer to use `C-d` and `C-t` with their readline meanings.
" So, we remap the Vim default `C-d` and `C-t`, to `C-g <` and `C-g >`.
" Besides, these key sequences make much more sense, imho.
"
" Also, make the mappings repeatable without the prefix `C-g`.

call submode#enter_with('change-indent', 'i', '', '<c-g>>', '<c-t>')
call submode#enter_with('change-indent', 'i', '', '<c-g><', '<c-d>')
call submode#map(       'change-indent', 'i', '',      '>', '<c-t>')
call submode#map(       'change-indent', 'i', '',      '<', '<c-d>')

" C-g [jk]       scroll window {{{2

" Make `i^gj` and `i^gk` repeatable with `j` and `k`.

call submode#enter_with('scroll-window', 'i', 'r', '<c-g>j', '<c-x><c-e>' )
call submode#map(       'scroll-window', 'i', 'r',      'j', '<c-x><c-e>')

call submode#enter_with('scroll-window', 'i', 'r', '<c-g>k', '<c-x><c-y>' )
call submode#map(       'scroll-window', 'i', 'r',      'k', '<c-x><c-y>')

" C-x [jk]       duplicate char below/above {{{2
" Why these mappings? {{{
"
" - They are more consistent than the default ones.
" - They are easier to repeat (via `vim-submode`).

"}}}
" What's the issue with the default ones ?{{{
"
" By default, Vim uses `C-e` and `C-y` in inconsistent ways:
"
"    i^e:            duplicate char below, or exit completion menu
"                    ✘ 2 unrelated functionalities
"                    ✘ shadows `end-of-line` in `vim-readline`
"
"    i^y:            duplicate char above
"                    ✘ hard to remember;
"                      it would be easier if Vim used `k` prefixed with some key
"
"    i^x^e  i^x^y:   scroll window
"                    ✘ ^x is usually used to complete text
"
"                    ✘ usually Vim uses `j` and `k` in mappings which must interact
"                      with a line below/above (example: gj, gk)
"
"                    ✘ i^x^e doesn't conflict with our custom c^x^e, but still
"                      it's a little confusing
"}}}

"                                        ┌ recursive (remap {rhs})
"                                        │
call submode#enter_with('char-around', 'i', 'r', '<c-x>j', '<plug>(duplicate-char-below)' )
call submode#map(       'char-around', 'i', 'r',      'j', '<plug>(duplicate-char-below)')
ino <expr> <plug>(duplicate-char-below) <sid>duplicate_char_around(0)

call submode#enter_with('char-around', 'i', 'r', '<c-x>k', '<plug>(duplicate-char-above)' )
call submode#map(       'char-around', 'i', 'r',      'k', '<plug>(duplicate-char-above)')
ino <expr> <plug>(duplicate-char-above) <sid>duplicate_char_around(1)

fu s:duplicate_char_around(above) abort
    " By default, `c-y` only duplicate the character right above.
    " If there's nothing, but there IS a character on the 2nd line above,
    " `c-y` ignores it.
    "
    " We use this function to reimplement `c-y` (and `c-e`) in a more powerful way.

    let vcol = virtcol('.')
    let line = search('\%'..vcol..'v.*\S', (a:above ? 'b' : '')..'nW')
    let char = matchstr(getline(line), '\%'..vcol..'v.')
    return char
endfu

