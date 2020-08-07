finish

" Purpose:{{{
"
" We keep this file as an example of how to write an indent plugin.
" Although, if we were to really use it, we should autoload the functions.
"}}}
" Inspiration:{{{
"
" https://vimways.org/2019/indentation-without-dents/
"}}}
" FIXME: It doesn't seem to indent exactly like the original indent plugin.
" So,  I've copied  the code  of the  latter in  `~/.vim/indent/matlab.vim`, and
" begun its refactoring.

if exists('b:did_indent')
    finish
endif

setl indk=0=elsei

let b:did_indent = 1
let b:undo_indent = get(b:, 'undo_indent', 'exe') .. '| setl inde< indk<'

if exists('*s:get_indent') | finish | endif

" Init {{{1

const s:BRACKET_PAT = '\([[{]\)\|\([]}]\)'

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

const s:KWD_PAT =
    \ '\C\<\('
    \     .. join(s:OPEN_KEYWORDS, '\|')
    \     .. '\|'
    \     .. '^\s*\zs\%(else\|elseif\|case\|otherwise\|catch\)'
    \ .. '\)\>'
    \ .. '\|\S\s*\zs\(\<end\>\)'
unlet! s:OPEN_KEYWORDS
"}}}1

fu s:get_indent() abort "{{{1
    let prevlnum = prevnonblank(v:lnum - 1)
    if !prevlnum | return 0 | endif
    let unclosedkwd_lvl = s:get_unclosed_lvl(prevlnum, s:KWD_PAT)
    let final_indent = indent(prevlnum) + unclosedkwd_lvl * shiftwidth()

    let cur_unclosedbracket_lvl = s:get_unclosed_lvl(prevlnum, s:BRACKET_PAT)
    let past_unclosedbracket_lvl = 0
    let previndent = indent(prevlnum)
    let lnum = prevlnum
    let g = 0 | while g < 999 | let g += 1
        let lnum = prevnonblank(lnum - 1)
        let indent = indent(lnum)
        if lnum <= 0 || indent > previndent | break | endif
        let past_unclosedbracket_lvl += s:get_unclosed_lvl(lnum, s:BRACKET_PAT)
        if indent < previndent | break | endif
    endwhile
    let cur_unclosedbracket_lvl += past_unclosedbracket_lvl

    if cur_unclosedbracket_lvl == 0 && past_unclosedbracket_lvl > 0
        return final_indent - shiftwidth()
    elseif cur_unclosedbracket_lvl > 0 && past_unclosedbracket_lvl == 0
        return final_indent + shiftwidth()
    else
        return final_indent
    endif
endfu
let &l:inde = expand('<SID>') .. 'get_indent()'

fu s:get_unclosed_lvl(lnum, pat) abort "{{{1
    let [opening_tokens, closing_tokens] = s:submatches_counts(a:lnum, a:pat)
    return opening_tokens - closing_tokens
endfu

fu s:submatches_counts(lnum, pat) abort "{{{1
    let counts = [0, 0]
    call cursor(a:lnum, 1)
    let g = 0 | while g < 999 | let g += 1
        " TODO: Does `z` improve perf on big files? Make some tests.
        " TODO: The `p` flag is neat.{{{
        " It lets you  search for several patterns simultaneously,  and to react
        " differently depending on which one is found:
        "
        "     :echo searchpos('\(pat1\)\|\(pat2\)\|\(\<pat3\)', 'p')
        "
        " Try to document this; and check whether we could/should have used it in the past.
        "}}}
        let flags = 'pz' .. (g == 1 ? 'c' : '')
        let [lnum, col, submatch] = searchpos(a:pat, flags, a:lnum)
        " if there is no match now, there won't be any match in the future; stop counting
        if !submatch | break | endif
        if !s:is_comment_or_string(lnum, col)
            " `submatch` will always be 2 or 3{{{
            "
            " It can't be:
            "
            "   - 0, because we've just checked before it's not 0 (we break if it is).
            "
            "   - 1, because that would mean that the whole pattern matched, while no sub-expression matched.
            "
            "     This is impossible with the patterns we're currently using.
            "     For an overall match to occur, one of the sub-expressions *must* match
            "     (this would not be true if we applied a quantifier such as `\=` to one of them).
            "
            "   - 4 or more, because our current patterns only contain 2 sub-expressions, not more.
            "}}}
            let counts[submatch - 2] += 1
        endif
    endwhile
    return counts
endfu

fu s:is_comment_or_string(lnum, col) abort "{{{1
    return synID(a:lnum, a:col, 1)->synIDtrans()->synIDattr('name')
        \ =~# 'Comment\|String\|Todo'
endfu

