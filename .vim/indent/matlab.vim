" Purpose:{{{
"
" We keep this file as an example of how to write an indent plugin.
"}}}
" Inspiration:{{{
"
" https://vimways.org/2019/indentation-without-dents/
"}}}
" You can test the script on this text:{{{
"
"     if true, disp foo, end
"
"         if true, if true
"             A = [8 1
"             3 5];
"         end, end
"
" To get a bigger file, run this command:
"
"     :%t$
"
" Then repeat it as many times as you want (press `@:`, then `@@`).
"}}}

if exists('b:did_indent')
    finish
endif

let b:did_indent = 1

fu s:snr() abort
    return matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_')
endfu

let &l:inde = s:snr()..'get_indent()'

" TODO: move code in `autoload/` and use `:const` instead of `:let`
let s:OPEN_KEYWORDS =<< trim END
    function
    for
    if
    parfor
    spmd
    switch
    try
    while
    classdef
    properties
    methods
    events
    enumeration
END

let s:KWD_PAT =
    \ '\C\<\('
    \     ..join(s:OPEN_KEYWORDS, '\|')
    \     ..'\|'
    \     ..'^\s*\zs\%(else\|elseif\|case\|otherwise\|catch\)'
    \ ..'\)\>'
    \ ..'\|\S\s*\zs\(\<end\>\)'

let s:BRACKET_PAT = '\([[{]\)\|\([]}]\)'

fu s:get_indent() abort "{{{1
    let prevlnum = prevnonblank(v:lnum - 1)
    if ! prevlnum | return 0 | endif
    let lvl = s:get_unclosed_level(prevlnum, s:KWD_PAT)
    let final_indent = indent(prevlnum) + lvl * shiftwidth()

    let past_unclosedlvl = 0
    let previndent = indent(prevlnum)
    let l = prevlnum
    let g = 0
    while g < 999
        let l = prevnonblank(l - 1)
        let indent = indent(l)
        if l <= 0 || indent > previndent | break | endif
        let past_unclosedlvl += s:get_unclosed_level(l, s:BRACKET_PAT)
        if indent < previndent | break | endif
    endwhile
    let cur_unclosedlvl = past_unclosedlvl + s:get_unclosed_level(prevlnum, s:BRACKET_PAT)

    if cur_unclosedlvl == 0 && past_unclosedlvl > 0
        return final_indent - shiftwidth()
    elseif cur_unclosedlvl > 0 && past_unclosedlvl == 0
        return final_indent + shiftwidth()
    else
        return final_indent
    endif
endfu

fu s:get_unclosed_level(lnum, pat) abort "{{{1
    let counts = s:submatch_count(a:lnum, a:pat)
    return counts[0] - counts[1]
endfu

fu s:submatch_count(lnum, pat) abort "{{{1
    let counts = [0, 0]
    call cursor(a:lnum, 1)
    let g = 0
    while g < 999
        let [lnum, c, submatch] = searchpos(a:pat, 'cpez', a:lnum)
        if !submatch || c > 999 | break | endif
        if !s:is_comment_or_string(lnum, c) && submatch != 1
            let counts[submatch - 2] += 1
        endif
        " Try to move the cursor one step to the right to not match the same text again.
        " If it remained in place, we've hit the end of the line, so `:break`.
        if cursor(0, c + 1) == -1 || col('.') == c | break | endif
        let g += 1
    endwhile
    return counts
endfu

fu s:is_comment_or_string(lnum, col) abort "{{{1
    return synIDattr(synIDtrans(synID(a:lnum, a:col, 1)), 'name')
        \ =~# 'matlab\%(Comment\|MultilineComment\|String\)'
endfu

