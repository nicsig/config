finish

" TODO: Finish refactoring/assimilating this  code using variable names/snippets
" from `~/.vim/indent/mymatlab.vim`. Also, integrate the comments from the latter.

" You can test the script on this text:{{{
"
"     if true, disp foo, end
"
"     if true, if true
"                     A = [8 1
"                             3 5];
"             end, end
"
"     myCell = {'text'
"         {11;
"         22;
"
"         33}
"         };
"
"     s = 1 - 1/2 + 1/3 - 1/4 + 1/5 ...
"       - 1/6 + 1/7 - 1/8 + 1/9;
"
"     ans =
"     {
"       [1,1] =
"       {
"         [1,1] = 1
"         [1,2] = 1
"         [1,3] = 1
"         [1,4] = 9
"         [1,5] = hello
"         [1,6] = 3
"       }
"       [2,1] =
"       {
"         [1,1] = 1
"         [1,2] = 1
"         [1,3] = 1
"         [1,4] = -33
"         [1,5] = world
"         [1,6] = 3
"       }
"     }
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
let s:snr = get(s:, 'snr', s:snr())
let &l:inde = s:snr..'get_indent()'
let &l:indk = "!\x06,o,O,e,0=end,0=elseif,0=case,0=otherwise,0=catch,0=function,0=elsei"

" the last value of `b:changedtick`
let b:MATLAB_lasttick = -1
" the address of the last indented line
let b:MATLAB_lastline = -1
" whether the line above was a line continuation
" TODO: Is it "line continuation" or "continuation line"?
let b:MATLAB_was_lc = 0
let b:MATLAB_bracketlevel = 0

let b:did_indent = 1
let b:undo_indent = get(b:, 'undo_indent', 'exe')..'| setl inde< indk<'

if exists('*s:get_indent') | finish | endif

let s:end = '\<end\>\%([^({]*[)}]\)\@!' " array indexing heuristic
let s:open_pat = 'for\|if\|parfor\|spmd\|switch\|try\|while\|classdef\|properties\|methods\|events\|enumeration'
let s:start_pat = '\C\<\%(function\|'..s:open_pat..'\)\>'
const s:BRACKET_PAT = '\([[{]\)\|\([]}]\)'

fu s:get_indent() abort "{{{1
    let prevlnum = prevnonblank(v:lnum - 1)

    " TODO: Understand why the logic dealing with brackets is much more complex than the one dealing with keywords.{{{
    "
    " I *think* that indentation is cosmetic (!= semantic) in matlab.
    " And I  *think* that  the author  of the default  matlab indent  plugin has
    " chosen an arbitrary style regarding the indentation inside brackets:
    "
    " >     All warmed up yet? Great! Next I thought it  would be fun to see how one
    " >     could  go about  implementing  indenting of  MATLAB brackets. These  are
    " >     interesting for one reason: they require context beyond the current line
    " >     and the one above. Take, for example, this cell array literal:
    " >     [...]
    " >     When indenting the line  containing 22 we have to be  aware that we were
    " >     already inside one pair of braces.
    "
    " I find that their style leads to an "ugly" indentation.
    " Copy-paste the first block of code from this question inside a matlab file:
    " https://stackoverflow.com/q/31824783/9780968
    " And press `gg=G`; imo the original indentation made the code more readable.
    "
    " If you want to try on another sample code, look for `[matlab] cell array nest`
    " on stackoverflow.
    "
    " ---
    "
    " In any case, try to understand exactly what their style is.
    " If it really makes the code  more complex, maybe we should handle brackets
    " exactly like keywords.
    " However, doing so, we would probably  not need the `b:` variables anymore;
    " they are interesting because they show us:
    "
    "    - a real example where `b:changedtick` is useful
    "
    "    - that `b:changedtick` is not always updated
    "      (when you press `gg=G`, it's only incremented once; not after each line in the file is re-indented)
    "
    "    - how to reduce the complexity of an algorithm from `O(n^2)` to `O(n)`
    "      using cache variables
    "
    " Try to document all of this before eliminating the variables.
    " Or choose  another indentation style, less ugly, but  which still requires
    " similar `b:` variables.
    " Or just bite the bullet, and keep the original ugly style.
    "}}}
    if b:changedtick != b:MATLAB_lasttick || b:MATLAB_lastline != prevlnum
        " recalculate bracket count (only have to check same block and line above)
        let b:MATLAB_bracketlevel = 0
        let previndent = indent(prevlnum) | let lnum = prevlnum
        let g = 0 | while g < 999 | let g += 1
            let lnum = prevnonblank(lnum - 1) | let indent = indent(lnum)
            if lnum <= 0 || previndent < indent | break | endif
            let b:MATLAB_bracketlevel += s:get_unclosed_lvl(lnum, s:BRACKET_PAT)
            if previndent > indent | break | endif
        endwhile

        let b:MATLAB_was_lc = s:continues_on_next_line(prevlnum - 1)
    endif

    " if line above was blank it can't have been a LC
    if b:MATLAB_lastline == prevlnum
        let above_lc = 0
    else
        let above_lc =
            \ b:MATLAB_lasttick == b:changedtick
            \ && prevlnum != v:lnum - 1
            \ && s:continues_on_next_line(v:lnum - 1)
    endif

    let pair_pat = '\C\<\('
        \ ..    s:open_pat
        \ ..    '\|function'
        \ ..    '\|\%(^\s*\)\@<=\%(else\|elseif\|case\|otherwise\|catch\)'
        \ ..'\)\>'
        \ ..'\|\S\s*\zs\('..s:end..'\)'
    let [open, close, b_open, b_close] = prevlnum
        \ ? s:submatches_counts(prevlnum, pair_pat..'\|'..s:BRACKET_PAT)
        \ : [0, 0, 0, 0]
    let curbracketlevel = b:MATLAB_bracketlevel + b_open - b_close

    call cursor(v:lnum, 1)
    let submatch = search('\C^\s*\zs\<\%(end\|else\|elseif\|catch\|\(case\|otherwise\|function\)\)\>', 'cpz', v:lnum)
    if submatch && !s:is_comment_or_string(v:lnum, col('.'))
        " align end, et cetera with start of block
        let [lnum, col] = searchpairpos(s:start_pat, '',  '\C'..s:end, 'bW',
            \ 's:is_comment_or_string(line("."), col("."))')
        let final_indent = lnum
            \ ? indent(lnum) + shiftwidth() * (s:get_unclosed_lvl(lnum, pair_pat, col) + submatch == 2)
            \ : 0
    else
        " Count how many blocks the previous line opens/closes
        " Line continuations/brackets indent once per statement
        let final_indent = (prevlnum > 0) * indent(prevlnum) + shiftwidth() * (open - close
        \ + (b:MATLAB_bracketlevel ? -!curbracketlevel : !!curbracketlevel)
        \ + (curbracketlevel <= 0) * (above_lc - b:MATLAB_was_lc))
    endif

    let b:MATLAB_was_lc = above_lc
    let b:MATLAB_bracketlevel = curbracketlevel
    let b:MATLAB_lasttick = b:changedtick
    let b:MATLAB_lastline = v:lnum
    return final_indent
endfu

fu s:get_unclosed_lvl(lnum, pat, ...) abort "{{{1
    let [opening_tokens, closing_tokens; rest] = call('s:submatches_counts', [a:lnum, a:pat] + a:000)
    return opening_tokens - closing_tokens
endfu

fu s:submatches_counts(lnum, pattern, ...) abort "{{{1
    let endcol = a:0 >= 1 ? a:1 : 1 / 0 | let counts = [0, 0, 0, 0]
    call cursor(a:lnum, 1)
    let g = 0 | while g < 999 | let g += 1
        let [lnum, col, submatch] = searchpos(a:pattern, g == 1 ? 'cpz' : 'pz', a:lnum)
        if !submatch || col >= endcol | break | endif
        if !s:is_comment_or_string(lnum, col) | let counts[submatch - 2] += 1 | endif
    endwhile
    return counts
endfu

fu s:is_comment_or_string(lnum, col) abort "{{{1
    " The original plugin did not invoke `synIDtrans()`.{{{
    "
    " I think it's better to invoke it.
    " Suppose the author of the syntax plugin adds a new syntax item linked to `Comment`;
    " without `synIDtrans()`, you'll have to update this function to include it;
    " with `synIDtrans()`, you don't need to.
    "
    " Besides, it simplifies the pattern to the right of `=~#`.
    "}}}
    return synIDattr(synIDtrans(synID(a:lnum, a:col, 1)), 'name')
        \ =~# 'Comment\|String\|Todo'
endfu

fu s:is_line_continuation(lnum, col) abort "{{{1
    return synIDattr(synID(a:lnum, a:col, 1), 'name')
        \ =~# 'matlabLineContinuation'
endfu

fu s:continues_on_next_line(lnum) abort "{{{1
    " returns 1 iff the specified line continues on the next line
    " What does it look like when a line continues on the next one?{{{
    "
    " https://www.mathworks.com/help/matlab/matlab_prog/continue-long-statements-on-multiple-lines.html
    "}}}

    let line = getline(a:lnum)
    let col = match(line, '\.\{3}\s*$')
    " Note: The original plugin uses a while loop. I don't understand why. It seems useless.{{{
    "
    "     $VIMRUNTIME/indent/matlab.vim:47
    "
    " Besides, it  doesn't even  check that the  ellipsis is at  the end  of the
    " line, which seems wrong.
    "}}}
    " Note: The `s:is_line_continuation()` test wrongly fails on an ellipsis used as a line continuation symbol.{{{
    "
    " See our comment at the top of `~/.vim/after/syntax/matlab.vim`.
    "}}}
    " Note: In the original plugin, `col` is not incremented by 1. I think it's a mistake.{{{
    "
    "                                         ✘
    "                                         v
    "     elseif !s:IsCommentOrString(a:lnum, c) | return 1 | endif
    "     " $VIMRUNTIME/indent/matlab.vim:50
    "
    " Without the offset, `c` describes the position right *before* the ellipsis.
    " We need a position *on* the ellipsis, to check which syntax item is highlighting it.
    "}}}
    " Note: In the original plugin, the test checks whether the position is *not* highlighted by a comment/string.{{{
    "
    "            v-----------------------------v
    "     elseif !s:IsCommentOrString(a:lnum, c) | return 1 | endif
    "     " $VIMRUNTIME/indent/matlab.vim:50
    "
    " It  looks  wrong. I  think  we   should  check  whether  the  position  is
    " highlighted by `matlabLineContinuation`.
    "
    " Rationale: A positive assertion is more restrictive.
    "
    " As a result, we need to create the helper function `s:is_line_continuation()`.
    " But the name is already taken in the original plugin.
    "
    "                 v----------------v
    "     function! s:IsLineContinuation(lnum)
    "     " $VIMRUNTIME/indent/matlab.vim:45
    "
    " So, we need to rename the current function into `s:continues_on_next_line()`.
    " Incidentally, I think this is a better name.
    " Indeed, the current function does not  check whether the current line is a
    " line continuation symbol; it checks  whether the current line continues on
    " the next one.
    "}}}
    return s:is_line_continuation(a:lnum, col+1)
endfu

