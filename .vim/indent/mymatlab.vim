vim9script

finish

# Purpose:{{{
#
# We keep this file as an example of how to write an indent plugin.
# Although, if we were to really use it, we should autoload the functions.
#}}}
# Inspiration:{{{
#
# https://vimways.org/2019/indentation-without-dents/
#}}}
# FIXME: It doesn't seem to indent exactly like the original indent plugin.
# So,  I've copied  the code  of the  latter in  `~/.vim/indent/matlab.vim`, and
# begun its refactoring.

if exists('b:did_indent')
    finish
endif

setl indk=0=elsei

b:did_indent = true
b:undo_indent = get(b:, 'undo_indent', 'exe') .. '| set inde< indk<'

if exists('*GetIndent')
    finish
endif

# Init {{{1

const BRACKET_PAT: string = '\([[{]\)\|\([]}]\)'

const OPEN_KEYWORDS: list<string> =<< trim END
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

const KWD_PAT =
    \ '\C\<\('
    \     .. join(OPEN_KEYWORDS, '\|')
    \     .. '\|'
    \     .. '^\s*\zs\%(else\|elseif\|case\|otherwise\|catch\)'
    \ .. '\)\>'
    \ .. '\|\S\s*\zs\(\<end\>\)'
#}}}1

&l:inde = expand('<SID>') .. 'GetIndent()'

def GetIndent(): number #{{{1
    var prevlnum: number = prevnonblank(v:lnum - 1)
    if prevlnum == 0
        return 0
    endif
    var unclosedkwd_lvl: number = GetUnclosedLvl(prevlnum, KWD_PAT)
    var final_indent: number = indent(prevlnum) + unclosedkwd_lvl * shiftwidth()

    var cur_unclosedbracket_lvl: number = GetUnclosedLvl(prevlnum, BRACKET_PAT)
    var past_unclosedbracket_lvl: number = 0
    var previndent: number = indent(prevlnum)
    var lnum: number = prevlnum
    var g: number = 0 | while g < 999 | g += 1
        lnum = prevnonblank(lnum - 1)
        var indent: number = indent(lnum)
        if lnum <= 0 || indent > previndent
            break
        endif
        past_unclosedbracket_lvl += GetUnclosedLvl(lnum, BRACKET_PAT)
        if indent < previndent
            break
        endif
    endwhile
    cur_unclosedbracket_lvl += past_unclosedbracket_lvl

    if cur_unclosedbracket_lvl == 0 && past_unclosedbracket_lvl > 0
        return final_indent - shiftwidth()
    elseif cur_unclosedbracket_lvl > 0 && past_unclosedbracket_lvl == 0
        return final_indent + shiftwidth()
    else
        return final_indent
    endif
enddef

def GetUnclosedLvl(lnum: number, pat: string): number #{{{1
    var opening_tokens: number
    var closing_tokens: number
    [opening_tokens, closing_tokens] = SubmatchesCounts(lnum, pat)
    return opening_tokens - closing_tokens
enddef

def SubmatchesCounts(arg_lnum: number, pat: string): list<number> #{{{1
    var counts: list<number> = [0, 0]
    cursor(arg_lnum, 1)
    var g: number = 0 | while g < 999 | g += 1
        # TODO: Does `z` improve perf on big files? Make some tests.
        # TODO: The `p` flag is neat.{{{
        # It lets you  search for several patterns simultaneously,  and to react
        # differently depending on which one is found:
        #
        #     :echo searchpos('\(pat1\)\|\(pat2\)\|\(\<pat3\)', 'p')
        #
        # Try to document this; and check whether we could/should have used it in the past.
        #}}}
        var flags: string = 'pz' .. (g == 1 ? 'c' : '')
        var lnum: number
        var col: number
        var submatch: number
        [lnum, col, submatch] = searchpos(pat, flags, arg_lnum)
        # if there is no match now, there won't be any match in the future; stop counting
        if submatch == 0
            break
        endif
        if !IsCommentOrString(lnum, col)
            # `submatch` will always be 2 or 3{{{
            #
            # It can't be:
            #
            #   - 0, because we've just checked before it's not 0 (we break if it is).
            #
            #   - 1, because that would mean that the whole pattern matched, while no sub-expression matched.
            #
            #     This is impossible with the patterns we're currently using.
            #     For an overall match to occur, one of the sub-expressions *must* match
            #     (this would not be true if we applied a quantifier such as `\=` to one of them).
            #
            #   - 4 or more, because our current patterns only contain 2 sub-expressions, not more.
            #}}}
            counts[submatch - 2] = counts[submatch - 2] + 1
        endif
    endwhile
    return counts
enddef

def IsCommentOrString(lnum: number, col: number): bool #{{{1
    return synID(lnum, col, true)
        ->synIDtrans()
        ->synIDattr('name')
        =~ 'Comment\|String\|Todo'
enddef

