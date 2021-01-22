vim9

finish

# TODO: Finish refactoring/assimilating this  code using variable names/snippets
# from  `~/.vim/indent/mymatlab.vim`.  Also,  integrate  the  comments from  the
# latter.

# You can test the script on this text:{{{
#
#     if true, disp foo, end
#
#     if true, if true
#                     A = [8 1
#                             3 5];
#             end, end
#
#     myCell = {'text'
#         {11;
#         22;
#
#         33}
#         };
#
#     s = 1 - 1/2 + 1/3 - 1/4 + 1/5 ...
#       - 1/6 + 1/7 - 1/8 + 1/9;
#
#     ans =
#     {
#       [1, 1] =
#       {
#         [1, 1] = 1
#         [1, 2] = 1
#         [1, 3] = 1
#         [1, 4] = 9
#         [1, 5] = hello
#         [1, 6] = 3
#       }
#       [2, 1] =
#       {
#         [1, 1] = 1
#         [1, 2] = 1
#         [1, 3] = 1
#         [1, 4] = -33
#         [1, 5] = world
#         [1, 6] = 3
#       }
#     }
#
# To get a bigger file, run this command:
#
#     :%t$
#
# Then repeat it as many times as you want (press `@:`, then `@@`).
#}}}

if exists('b:did_indent')
    finish
endif

b:did_indent = true

&l:indk = "!\x06,o,O,e,0=end,0=elseif,0=case,0=otherwise,0=catch,0=function,0=elsei"

# the last value of `b:changedtick`
b:MATLAB_lasttick = -1
# the address of the last indented line
b:MATLAB_lastline = -1
# whether the line above was a line continuation
# TODO: Is it "line continuation" or "continuation line"?
b:MATLAB_was_lc = 0
b:MATLAB_bracketlevel = 0

b:undo_indent = get(b:, 'undo_indent', 'exe') .. '| set inde< indk<'

if exists('*GetIndent')
    finish
endif

var end = '\<end\>\%([^({]*[)}]\)\@!' # array indexing heuristic
var open_pat = 'for\|if\|parfor\|spmd\|switch\|try\|while\|classdef\|properties\|methods\|events\|enumeration'
var start_pat = '\C\<\%(function\|' .. open_pat .. '\)\>'
const BRACKET_PAT = '\([[{]\)\|\([]}]\)'

&l:inde = expand('<SID>') .. 'GetIndent()'

# Interface {{{1
def GetIndent(): number #{{{2
    var prevlnum: number = prevnonblank(v:lnum - 1)

    # TODO: Understand why the logic dealing with brackets is much more complex than the one dealing with keywords.{{{
    #
    # I *think* that indentation is cosmetic (!= semantic) in matlab.
    # And I  *think* that  the author  of the default  matlab indent  plugin has
    # chosen an arbitrary style regarding the indentation inside brackets:
    #
    #    > All warmed up yet? Great! Next I thought it  would be fun to see how one
    #    > could  go about  implementing  indenting of  MATLAB brackets. These  are
    #    > interesting for one reason: they require context beyond the current line
    #    > and the one above. Take, for example, this cell array literal:
    #    > [...]
    #    > When indenting the line  containing 22 we have to be  aware that we were
    #    > already inside one pair of braces.
    #
    # I find that their style leads to an "ugly" indentation.
    # Copy-paste the first block of code from this question inside a matlab file:
    # https://stackoverflow.com/q/31824783/9780968
    # And press `gg=G`; imo the original indentation made the code more readable.
    #
    # If you want to try on another sample code, look for `[matlab] cell array nest`
    # on stackoverflow.
    #
    # ---
    #
    # In any case, try to understand exactly what their style is.
    # If it really makes the code  more complex, maybe we should handle brackets
    # exactly like keywords.
    # However, doing so, we would probably  not need the `b:` variables anymore;
    # they are interesting because they show us:
    #
    #    - a real example where `b:changedtick` is useful
    #
    #    - that `b:changedtick` is not always updated
    #      (when you press `gg=G`, it's only incremented once; not after each line in the file is re-indented)
    #
    #    - how to reduce the complexity of an algorithm from `O(n^2)` to `O(n)`
    #      using cache variables
    #
    # Try to document all of this before eliminating the variables.
    # Or choose  another indentation style, less ugly, but  which still requires
    # similar `b:` variables.
    # Or just bite the bullet, and keep the original ugly style.
    #}}}
    if b:changedtick != b:MATLAB_lasttick || b:MATLAB_lastline != prevlnum
        # recalculate bracket count (only have to check same block and line above)
        b:MATLAB_bracketlevel = 0
        var previndent: number = indent(prevlnum)
        var lnum: number = prevlnum
        var g: number = 0 | while g < 999 | g += 1
            lnum = prevnonblank(lnum - 1)
            var indent: number = indent(lnum)
            if lnum <= 0 || previndent < indent
                break
            endif
            b:MATLAB_bracketlevel += GetUnclosedLvl(lnum, BRACKET_PAT)
            if previndent > indent
                break
            endif
        endwhile

        b:MATLAB_was_lc = ContinuesOnNextLine(prevlnum - 1) ? 1 : 0
    endif

    # if line above was blank it can't have been a LC
    var above_lc: number
    if b:MATLAB_lastline == prevlnum
        above_lc = 0
    else
        above_lc =
            b:MATLAB_lasttick == b:changedtick
            && prevlnum != v:lnum - 1
            && ContinuesOnNextLine(v:lnum - 1)
            ? 1 : 0
    endif

    var pair_pat: string = '\C\<\('
        ..    open_pat
        ..    '\|function'
        ..    '\|\%(^\s*\)\@<=\%(else\|elseif\|case\|otherwise\|catch\)'
        .. '\)\>'
        .. '\|\S\s*\zs\(' .. end .. '\)'
    var open: number
    var close: number
    var b_open: number
    var b_close: number
    [open, close, b_open, b_close] = prevlnum != 0
        ? SubmatchesCounts(prevlnum, pair_pat .. '\|' .. BRACKET_PAT)
        : [0, 0, 0, 0]
    var curbracketlevel: number = b:MATLAB_bracketlevel + b_open - b_close

    cursor(v:lnum, 1)
    var submatch: number = search(
        '\C^\s*\zs\<\%(end\|else\|elseif\|catch\|\(case\|otherwise\|function\)\)\>',
        'cpz',
        v:lnum
        )
    var final_indent: number
    if submatch != 0 && !IsCommentOrString(v:lnum, col('.'))
        # align end, et cetera with start of block
        var lnum: number
        var col: number
        [lnum, col] = searchpairpos(start_pat, '', '\C' .. end, 'bW',
            'IsCommentOrString(line("."), col("."))')
        final_indent = lnum != 0
            ? indent(lnum) + shiftwidth() * (GetUnclosedLvl(lnum, pair_pat, col) + (submatch == 2 ? 1 : 0))
            : 0
    else
        # Count how many blocks the previous line opens/closes
        # Line continuations/brackets indent once per statement
        final_indent = (prevlnum > 0 ? 1 : 0) * indent(prevlnum) + shiftwidth() * (open - close
            + (b:MATLAB_bracketlevel != 0 ? -(!curbracketlevel ? 1 : 0) : !!curbracketlevel ? 1 : 0)
            + (curbracketlevel <= 0 ? 1 : 0) * (above_lc - b:MATLAB_was_lc))
    endif

    b:MATLAB_was_lc = above_lc
    b:MATLAB_bracketlevel = curbracketlevel
    b:MATLAB_lasttick = b:changedtick
    b:MATLAB_lastline = v:lnum
    return final_indent
enddef
#}}}1
# Core {{{1
def GetUnclosedLvl(lnum: number, pat: string, col = 0): number #{{{2
    var opening_tokens: number
    var closing_tokens: number
    var rest: any
    [opening_tokens, closing_tokens; rest] =
        call(SubmatchesCounts,
            [lnum, pat] + (col != 0 ? [col] : [])
            )
    return opening_tokens - closing_tokens
enddef

def SubmatchesCounts(arg_lnum: number, pattern: string, arg_col = 0): list<number> #{{{2
    var endcol = arg_col != 0 ? arg_col : v:numbermax
    var counts: list<number> = [0, 0, 0, 0]
    cursor(arg_lnum, 1)
    var g: number = 0 | while g < 999 | g += 1
        var lnum: number
        var col: number
        var submatch: number
        [lnum, col, submatch] = searchpos(pattern, g == 1 ? 'cpz' : 'pz', arg_lnum)
        if !submatch || col >= endcol
            break
        endif
        if !IsCommentOrString(lnum, col)
            counts[submatch - 2] = counts[submatch - 2] + 1
        endif
    endwhile
    return counts
enddef

def IsCommentOrString(lnum: number, col: number): bool #{{{2
    # The original plugin did not invoke `synIDtrans()`.{{{
    #
    # I think it's better to invoke it.
    # Suppose the author of the syntax plugin adds a new syntax item linked to `Comment`;
    # without `synIDtrans()`, you'll have to update this function to include it;
    # with `synIDtrans()`, you don't need to.
    #
    # Besides, it simplifies the pattern to the right of `=~#`.
    #}}}
    return synID(lnum, col, true)
        ->synIDtrans()
        ->synIDattr('name')
        =~ 'Comment\|String\|Todo'
enddef

def IsLineContinuation(lnum: number, col: number): bool #{{{2
    return synID(lnum, col, true)->synIDattr('name')
        =~ 'matlabLineContinuation'
enddef

def ContinuesOnNextLine(lnum: number): bool #{{{2
    # returns 1 iff the specified line continues on the next line
    # What does it look like when a line continues on the next one?{{{
    #
    # https://www.mathworks.com/help/matlab/matlab_prog/continue-long-statements-on-multiple-lines.html
    #}}}

    var line: string = getline(lnum)
    var col: number = match(line, '\.\{3}\s*$')
    # Note: The original plugin uses a while loop.  I don't understand why.  It seems useless.{{{
    #
    #     $VIMRUNTIME/indent/matlab.vim:47
    #
    # Besides, it  doesn't even  check that the  ellipsis is at  the end  of the
    # line, which seems wrong.
    #}}}
    # Note: The `s:IsLineContinuation()` test wrongly fails on an ellipsis used as a line continuation symbol.{{{
    #
    # See our comment at the top of `~/.vim/after/syntax/matlab.vim`.
    #}}}
    # Note: In the original plugin, `col` is not incremented by 1.  I think it's a mistake.{{{
    #
    #                                         ✘
    #                                         v
    #     elseif !s:IsCommentOrString(a:lnum, c) | return 1 | endif
    #     " $VIMRUNTIME/indent/matlab.vim:50
    #
    # Without the offset, `c` describes the position right *before* the ellipsis.
    # We need a position *on* the ellipsis, to check which syntax item is highlighting it.
    #}}}
    # Note: In the original plugin, the test checks whether the position is *not* highlighted by a comment/string.{{{
    #
    #            v-----------------------------v
    #     elseif !s:IsCommentOrString(a:lnum, c) | return 1 | endif
    #     " $VIMRUNTIME/indent/matlab.vim:50
    #
    # It  looks  wrong.   I  think  we should  check  whether  the  position  is
    # highlighted by `matlabLineContinuation`.
    #
    # Rationale: A positive assertion is more restrictive.
    #
    # As a result, we need to create the helper function `s:IsLineContinuation()`.
    # But the name is already taken in the original plugin.
    #
    #                 v----------------v
    #     function! s:IsLineContinuation(lnum)
    #     " $VIMRUNTIME/indent/matlab.vim:45
    #
    # So, we need to rename the current function into `s:ContinuesOnNextLine()`.
    # Incidentally, I think this is a better name.
    # Indeed, the current function does not  check whether the current line is a
    # line continuation symbol; it checks  whether the current line continues on
    # the next one.
    #}}}
    return IsLineContinuation(lnum, col + 1)
enddef

