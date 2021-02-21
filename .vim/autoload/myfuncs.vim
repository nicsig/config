vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

import {
    Catch,
    GetSelectionText,
    GetSelectionCoords,
    IsVim9,
    Opfunc,
    } from 'lg.vim'
const SID: string = execute('fu Opfunc')->matchstr('\C\<def\s\+\zs<SNR>\d\+_')

# Operators {{{1
def myfuncs#opGrep(): string #{{{2
    &opfunc = SID .. 'Opfunc'
    g:opfunc = {core: 'myfuncs#opGrepCore'}
    return 'g@'
enddef

def myfuncs#GrepEx(pat: string, use_loclist: bool)
    # Why does `2>/dev/null` work here but not in `'grepprg'`?{{{
    #
    # `systemlist()` doesn't run the shell command in the same way:
    #
    #     " systemlist()
    #     (rg pat /etc) >/tmp/... 2>&1
    #
    #     " 'grepprg'
    #     :!rg pat /etc 2>&1| tee /tmp/...
    #
    # In the first case, `2>/dev/null` is useful:
    #
    #     (rg 2>/dev/null pat /etc) >/tmp/... 2>&1
    #         ^---------^
    #
    # It prevents errors from being written in the temp file.
    #
    # In the second case, `2>/dev/null` is useless:
    #
    #     :!rg 2>/dev/null pat /etc 2>&1| tee /tmp/...
    #          ^---------^
    #
    # Because, it's overridden by `2>&1` which comes from `'shellpipe'`.
    # In  contrast,  `systemlist()`  uses `'shellredir'`,  which  also  includes
    # `2>&1`, but it doesn't have the same effect, because the command is run in
    # a subshell via braces:
    #
    #     (rg 2>/dev/null pat /etc)>/tmp/... 2>&1
    #     ^                       ^
    #
    # From `:h system() /braces`:
    #
    #    > For Unix, braces are put around {expr} to allow for
    #    > concatenated commands.
    #}}}
    var cmd: string = 'rg 2>/dev/null ' .. pat
    if use_loclist
        sil var items: list<dict<any>> = getloclist(0, {
            lines: systemlist(cmd),
            efm: '%f:%l:%c:%m'
            }).items
        setloclist(0, [], ' ', {items: items, title: cmd})
        do <nomodeline> QuickFixCmdPost lwindow
    else
        sil var items: list<dict<any>> = getqflist({
            lines: systemlist(cmd),
            efm: '%f:%l:%c:%m'
            }).items
        setqflist([], ' ', {items: items, title: cmd})
        do <nomodeline> QuickFixCmdPost cwindow
    endif
enddef

def myfuncs#opGrepCore(type: string)
    if type == 'char'
        norm! `[v`]y
    elseif type == 'line' || type == 'block' || type == 'char' && @" =~ "\n"
        # `rg(1)` is is line-oriented, unless you use `-U`
        # (which we don't because it's slower and consume more memory)
        return
    endif

    var cmd: string = 'rg 2>/dev/null --fixed-strings ' .. shellescape(@")
    sil var items: list<dict<any>> = getqflist({
        lines: systemlist(cmd),
        efm: '%f:%l:%c:%m'
        }).items
    setqflist([], ' ', {items: items, title: cmd})
    do <nomodeline> QuickFixCmdPost cwindow
enddef

def myfuncs#opReplaceWithoutYank(): string #{{{2
    &opfunc = SID .. 'Opfunc'
    g:opfunc = {
        core: 'myfuncs#opReplaceWithoutYankCore',
        # we don't need to yank the text-object, and don't want `v:register` nor `""` to mutate
        yank: false,
        # a third-party text-object might not know that it should pass `v:register` to the opfunc
        # https://github.com/wellle/targets.vim/issues/253
        register: v:register,
        }
        # TODO: You can  remove the `v:register`  key (here and in  our snippet)
        # once https://github.com/vim/vim/issues/6374 is fixed.
    return 'g@'
enddef

def myfuncs#opReplaceWithoutYankCore(type: string)
    var reg: string = get(g:opfunc, 'register', '"')

    var reg_save: dict<any>
    # Need to save/restore:{{{
    #
    #    - `reg` in case we make it mutate with the next `setreg()`
    #    - `"-` and the numbered registers, because they will mutate when the selection is replaced
    #}}}
    for regname in [reg] + ['-'] + range(10)->mapnew((_, v: any): string => string(v))
        extend(reg_save, {[regname]: getreginfo(regname)})
    endfor

    if type == 'line'
        exe 'keepj norm! ''[V'']"' .. reg .. 'p'
        norm! gv=
    elseif type == 'block'
        exe "keepj norm! `[\<c-v>`]" .. '"' .. reg .. 'p'
    elseif type == 'char'
        HandleChar(reg)
    endif

    keys(reg_save)->mapnew((_, v: string) => setreg(v, reg_save[v]))
enddef

def HandleChar(reg: string)
    var reginfo: dict<any> = getreginfo(reg)
    var contents: list<string> = get(reginfo, 'regcontents', [])
    if get(reginfo, 'regtype', '') == 'V' && !empty(contents)
        # Tweak linewise register so that it better fits inside a characterwise text.{{{
        #
        # That is:
        #
        #    - reset its type to characterwise
        #    - trim the leading whitespace in front of the first line
        #    - trim the trailing whitespace at the end of the last line
        #
        # Consider this text:
        #
        #     a
        #     b c d
        #
        # If you press `dd` to delete the  `a` line, then press `drl` on the
        # `c` character, you get:
        #
        #     b a d
        #
        # If you didn't tweak the register, you would get:
        #
        #        b
        #        a
        #     d
        #
        # Which is probably not what you want.
        #}}}
        # trim whitespace surrounding the text
        contents[0] = substitute(contents[0], '^\s*', '', '')
        contents[-1] = substitute(contents[-1], '\s*$', '', '')
        # and reset the type to characterwise
        reginfo
            ->extend({regcontents: contents, regtype: 'c'})
            ->setreg(reg)
    endif

    try
        exe 'keepj norm! `[v`]"' .. reg .. 'p'
    catch
        Catch()
        return
    endtry
enddef

def myfuncs#opTrimWs(type = ''): string #{{{2
    if type == ''
        &opfunc = 'myfuncs#opTrimWs'
        return 'g@'
    endif
    if &l:binary || &ft == 'diff'
        return ''
    endif
    var range: string = ':' .. line("'[") .. ',' .. line("']")
    exe range .. 'TW'
    return ''
enddef

def myfuncs#opYankSetup(what: string): string #{{{2
    op_yank = {what: what, register: v:register}
    &opfunc = expand('<SID>') .. 'OpYank'
    return 'g@'
enddef
var op_yank: dict<string>

def OpYank(type: string)
    var mods: string = 'keepj keepp'
    var range: string = ':' .. line("'[") .. ',' .. line("']")

    var cmd: string = op_yank.what == 'g//' || op_yank.what == 'comments' ? 'g' : 'v'
    var cml: string = &ft == 'vim'
        ?     '["#]'
        :     '\C\V' .. matchstr(&l:cms, '\S*\ze\s*%s')->escape('\')
    var pat: string = op_yank.what == 'code' || op_yank.what == 'comments'
        ?     '^\s*' .. cml
        :     @/

    var z_save: dict<any> = getreginfo('z')
    var yanked: list<string>
    try
        setreg('z', {})
        exe mods .. range .. cmd .. '/' .. escape(pat, '/') .. '/y Z'
        yanked = getreginfo('z')->get('regcontents', [])
    catch
        Catch()
        return
    finally
        setreg('z', z_save)
        # emulate what Vim does with a  builtin operator; the cursor ends at the
        # *start* of the text object
        cursor(matchstr(range, '\d\+')->str2nr(), 1)
    endtry

    # if `:v` was used, and the pattern matched everywhere, nothing was yanked
    if len(yanked) == 0
        return
    endif

    # the first  time we've  appended a  match to the  `z` register,  it has
    # appended a newline; we *never* want it; remove it
    if yanked[0] == ''
        remove(yanked, 0)
    endif

    # remove *all* empty lines in some other cases
    if op_yank.what == 'v//' || op_yank.what == 'code'
        filter(yanked, (_, v: string): bool => v !~ '^\s*$')
    endif

    setreg(op_yank.register, yanked, 'l')
enddef
# }}}1

# boxCreate / boxDestroy {{{1

# TODO:
# We could improve these functions by reading:
# https://github.com/vimwiki/vimwiki/blob/dev/autoload/vimwiki/tbl.vim
#
# In particular, it could update an existing table.
#
# ---
#
# Also, we should improve it to generate this kind of table:
#
#    ┌───────────────────┬─────────────────────────────────────────────────┐
#    │                   │                    login                        │
#    │                   ├─────────────────────────────────┬───────────────┤
#    │                   │ yes                             │ no            │
#    ├─────────────┬─────┼─────────────────────────────────┼───────────────┤
#    │ interactive │ yes │ zshenv  zprofile  zshrc  zlogin │ zshenv  zshrc │
#    │             ├─────┼─────────────────────────────────┼───────────────┤
#    │             │ no  │ zshenv  zprofile         zlogin │ zshenv        │
#    └─────────────┴─────┴─────────────────────────────────┴───────────────┘
#
# The peculiarity here, is the variable number of cells per line (2 on the first
# one, 3 on the second one, 4 on the last ones).
def myfuncs#boxCreate(type = ''): string
    if type == ''
        &opfunc = 'myfuncs#boxCreate'
        return 'g@'
    endif
    try
        # draw `|` on the left of the paragraph
        exe "norm! _vip\<c-v>^I|"
        # draw `|` on the right of the paragraph
        norm! gv$A|

        # align all (*) the pipe characters (`|`) inside the current paragraph
        sil :'[,']EasyAlign *|

        # If we wanted to center the text inside each cell, we would have to add
        # hit `CR CR` after `gaip`:
        #
        #     sil exe "norm gaip\<cr>\<cr>*|"

        # Capture all the column positions in the current line matching a `|`
        # character:
        var col_pos: list<number>
        var i: number = 0
        for char in getline('.')->split('\zs')
            i += 1
            if char == '|'
                col_pos += [i]
            endif
        endfor

        if empty(col_pos)
            return ''
        endif

        # Draw the upper border of the box '┌────┐':
        BoxCreateBorder('top', col_pos)

        # Draw the lower border of the box '└────┘':
        BoxCreateBorder('bottom', col_pos)

        # Replace the remaining `|` with `│`:
        var first_line: number = line("'{") + 2
        var last_line: number = line("'}") - 2
        for l in range(first_line, last_line)
            for c in col_pos
                exe 'norm! ' .. l .. 'G' .. c .. '|r│'
            endfor
        endfor

        BoxCreateSeparations()
    catch
        return Catch()
    endtry
    return ''
enddef

def BoxCreateBorder(where: string, col_pos: list<number>)
    if where == 'top'
        # duplicate first line in the box
        norm! '{+yyP
        # replace all characters with `─`
        norm! v$r─
        # draw corners
        exe 'norm! ' .. col_pos[0] .. '|r┌' .. col_pos[-1] .. '|r┐'
    else
        # duplicate the `┌────┐` border below the box
        copy '}-
        # draw corners
        exe 'norm! ' .. col_pos[0] .. '|r└' .. col_pos[-1] .. '|r┘'
    endif

    # draw the '┬' or '┴' characters:
    for pos in col_pos[1 : -2]
        exe 'norm! ' .. pos .. '|r' .. (where == 'top' ? '┬' : '┴')
    endfor
enddef

def BoxCreateSeparations()
    # Create a separation line, such as:
    #
    #     |    |    |    |
    #
    # ... useful to make our table more readable.
    norm! '{++yyp
    getline('.')->substitute('[^│┼]', ' ', 'g')->setline('.')

    # Delete it in the `s` (s for space) register, so that it's stored inside
    # default register and we can paste it wherever we want.
    d s

    # Create a separation line, such as:
    #
    #     ├────┼────┼────┤
    #
    # ... and store it inside `x` register.
    # So that we can paste it wherever we want.
    var line: string = (line("'{") + 1)->getline()
    line = substitute(line, '\S', '├', '')
    line = substitute(line, '.*\zs\S', '┤', '')
    line = substitute(line, '┬', '┼', 'g')

    # Make the contents of the register linewise, so we don't need to hit
    # `"x]p`, but simply `"xp`.
    setreg('x', [line], 'l')
enddef

def myfuncs#boxDestroy(type = ''): string
    if type == ''
        &opfunc = 'myfuncs#boxDestroy'
        return 'g@'
    endif

    var lnum1: number = line("'[")
    var lnum2: number = line("']")
    var range: string = ':' .. lnum1 .. ',' .. lnum2
    # remove box (except pretty bars: │)
    exe 'sil ' .. range .. 's/[─┴┬├┤┼└┘┐┌]//ge'

    # replace pretty bars with regular bars
    # necessary, because we will need them to align the contents of the
    # paragraph later
    exe 'sil ' .. range .. 's/│/|/ge'

    # remove the bars at the beginning and at the end of the lines
    # we don't want them, because they would mess up the creation of a box
    # later
    exe 'sil ' .. range .. 's/|//e'
    exe 'sil ' .. range .. 's/.*\zs|//e'

    # trim whitespace
    exe 'sil ' .. range .. 'TW'
    # remove empty lines
    exe 'sil ' .. range .. '-g/^\s*$/d _'

    append(lnum1 - 1, [''])

    # position the cursor on the upper left corner of the paragraph
    exe 'norm! ' .. lnum1 .. 'Gj_'
    return ''
enddef

def myfuncs#deleteMatchingLines(to_delete: string, reverse = false) #{{{1
    var view: dict<number> = winsaveview()
    var fen_save: bool = &l:fen
    setl nofen

    # Purpose:{{{
    #
    # The deletions will leave the cursor on  the line below the last line where
    # a match was found.   This line may be far away  from our current position.
    # This  is distracting;  let's try  to stay  as close  as possible  from our
    # current position.
    #
    # To achieve this goal, we need to find the nearest character which won't be
    # deleted, and set a mark on it.
    #}}}
    var pos: list<number> = getcurpos()
    var global: string = reverse ? 'v' : 'g'
    var cml: string
    if &ft == 'vim'
        # don't delete a literal dictionary at the start of a line
        cml = '\%("\|#\%({\%([^{]\|$\)\)\@!\)'
    else
        cml = '\V' .. matchstr(&l:cms, '\S*\ze\s*%s')->escape('\') .. '\m'
    endif
    var to_search: dict<list<string>> = {
        empty: ['^\s*$', '^'],
        comments: [
            '^\s*' .. cml
                # preserve start of folds when deleting comments
                .. '\%(.*' .. split(&l:fmr, ',')->get(0, '') .. '\d\+$\)\@!',
            '^\%(\s*' .. cml .. '\)\@!'
            ],
        search: [@/, '^\%(.*' .. @/ .. '\m\)\@!'],
        }
    var wont_be_deleted: string = to_search[to_delete][global == 'g' ? 1 : 0]
    # necessary if the pattern matches on the current line, but the match starts
    # before our current position
    exe 'norm! ' .. (pos[1] == 1 ? '1|' : 'k$')
    search(wont_be_deleted, pos[1] == 1 ? 'c' : '')
    # if the match is on our original line, restore the column position
    if line('.') == pos[1]
        call setpos('.', pos)
    endif
    norm! m'
    setpos('.', pos)

    var mods: string = 'sil keepj keepp '
    var range: string
    if mode() =~ "^[vV\<c-v>]$"
        var coords: dict<list<number>> = GetSelectionCoords()
        var lnum1: number = coords.start[0]
        var lnum2: number = coords.end[0]
        range = ':' .. lnum1 .. ',' .. lnum2
    else
        range = ':%'
    endif
    var pat: string = to_search[to_delete][0]
    # Don't use `/` as a delimiter.{{{
    #
    # It's tricky.
    #
    # Suppose you've just  searched for a pattern containing a  slash with a `/`
    # command.   Vim will  have automatically  escaped the  slash in  the search
    # register.  So, you should not escape it a second time with `escape()`.
    #
    # But suppose `pat`  comes from sth else,  like a `?` search;  in that case,
    # there's no reason to believe that Vim  has already escaped `/`, and you do
    # need to do it yourself.
    #
    # Let's avoid this  conundrum altogether, by using a delimiter  which is not
    # `/` nor `?`.
    #}}}
    exe mods .. range .. global .. ':' .. escape(pat, ':') .. ':d _'

    sil! update
    #  │
    #  └ `:h E32`
    &l:fen = fen_save
    winrestview(view)
    # `sil!` because if the pattern was so broad that all the lines were removed,
    # the original line doesn't exist anymore, and the `'` mark is invalid
    sil! norm! `'zv
    if mode() =~ "^[vV\<c-v>]$"
        feedkeys("\<c-\>\<c-n>", 'n')
    endif
enddef

def myfuncs#diffLines(bang: bool, alnum1: number, alnum2: number, option: string) #{{{1
    if option == '-h' || option == '--help'
        var usage: list<string> =<< trim END
            :DiffLines lets you see and cycle through the differences between 2 lines

            usage:
                :5,10DiffLines    diff between lines 5 and 10
                :DiffLines        diff between current line and next one
                :DiffLines!       clear the match

            The differences are in the location list (press [l, ]l, [L, ]L to visit them)
        END
        echo join(usage, "\n")
        return
    endif

    if expand('%:p')->empty()
        echohl ErrorMsg
        # `:lvim` fails in an unnamed buffer
        echom 'Save the buffer in a file'
        echohl None
        return
    endif

    if exists('w:xl_match')
        matchdelete(w:xl_match)
        unlet! w:xl_match
    endif

    if bang
        return
    endif

    # if `alnum1 == alnum2`, it means `:DiffLines` was called without a range
    var lnum1: number
    var lnum2: number
    if alnum1 == alnum2
        lnum1 = line('.')
        lnum2 = lnum1 + 1
    else
        lnum1 = alnum1
        lnum2 = alnum2
    endif
    var line1: string = getline(lnum1)
    var line2: string = getline(lnum2)
    var chars1: list<string> = split(line1, '\zs')
    var chars2: list<string> = split(line2, '\zs')
    var min_chars: number = min([len(chars1), len(chars2)])

    # build a pattern matching the characters which are different
    var pat: string
    var col1: number
    var col2: number
    for i in range(min_chars)
        if chars1[i] != chars2[i]
            # FIXME: We need to write `c.` instead of just `c`.{{{
            #
            # Otherwise, we may have duplicate entries.
            # The problem seems to come from `:lvim` and the `g` flag.
            #
            # MWE:
            # This adds 2 duplicate entries in the location list instead of one:
            #
            #     :lvim /\%1l\%2c/g %
            #
            # This adds 2 duplicate entries in the location list, 3 in total instead of two:
            #
            #     :lvim /\%1l\%2c\|\%1l\%3c/g %
            #
            # This adds 2 couple of duplicate entries in the location list, 4 in total instead of two.
            #
            #     :lvim /\%1l\%2c\|\%1l\%4c/g %
            #
            # It seems each time a `%{digit}c` anchor matches the beginning of a group
            # of consecutive characters, it adds 2 duplicate entries instead of one.
            #}}}
            # Don't use `virtcol()` and `\%v`.{{{
            #
            # It wouldn't work as expected  if the lines contain literal control
            # characters, and more generally any multi-cell characters.
            #}}}
            col1 = matchstr(line1, '^.\{' .. (i + 1) .. '}')->strlen()
            pat ..= (empty(pat) ? '' : '\|') .. '\%' .. lnum1 .. 'l\%' .. col1 .. 'c.'
            col2 = matchstr(line2, '^.\{' .. (i + 1) .. '}')->strlen()
            pat ..= (empty(pat) ? '' : '\|') .. '\%' .. lnum2 .. 'l\%' .. col2 .. 'c.'
        endif
    endfor

    # if one of the lines is longer than the other, we have to add its end in the pattern
    if strlen(line1) > strlen(line2)
        # It's better to write `\%>123c.` than `\%123c.*`.{{{
        #
        # `\%>123c.` = any character after the 50th character.
        # This will add one entry in the loclist for *every* character.
        #
        # `\%123c.*` = the *whole* set of characters after the 123th.
        # This will add only *one* entry in the loclist.
        #}}}
        pat ..= (!empty(pat) ? '\|' : '') .. '\%' .. lnum1 .. 'l' .. '\%>' .. strlen(line2) .. 'c.'

    elseif strlen(line1) < strlen(line2)
        pat ..= (!empty(pat) ? '\|' : '') .. '\%' .. lnum2 .. 'l' .. '\%>' .. len(line1) .. 'c.'
    endif

    # give the result
    if !empty(pat)
        # Why silent?{{{
        #
        # If the  lines are long, `:lvim`  will print a long  message which will
        # cause a hit-enter prompt:
        #
        #     (1 of 123): ...
        #}}}
        sil exe 'lvim /' .. pat .. '/g %'
        w:xl_match = matchadd('SpellBad', pat, 0)
    else
        echohl WarningMsg
        echom 'Lines are identical'
        echohl None
    endif
enddef

def myfuncs#dumpWiki(argurl: string) #{{{1
    # TODO: Regarding triple backticks.{{{
    #
    # Look at this page: https://github.com/ranger/ranger/wiki/Keybindings
    #
    # Some lines of code are surrounded by triple backticks:
    #
    #     ```map X chain shell vim -p ~/.config/ranger/rc.conf %rangerdir/config/rc.conf;
    #        source ~/.config/ranger/rc.conf```
    #
    # It's an error.
    # They should be surrounded by simple backticks.
    # AFAIK, triple backticks are for fenced code blocks.
    # For inline code, a single backtick is enough.
    #
    # More  importantly, these  wrong  triple backticks  are  recognized as  the
    # beginning of a fenced code block by our markdown syntax plugin.
    # As a result, the syntax of all the following lines will be wrong.
    #
    # After dumping a wiki in a buffer, give a warning about that.
    # Give the recommendation to manually inspect the syntax highlighting at the
    # end of the buffer.
    #}}}
    if argurl[: 3] != 'http'
        return
    endif

    var x_save: list<number> = getpos("'x")
    var y_save: list<number> = getpos("'y")
    try
        var url: string = trim(argurl, '/') .. '.wiki'
        var tempdir: string = tempname()->substitute('.*/\zs.\{-}', '', '')
        sil system('git clone ' .. shellescape(url) .. ' ' .. tempdir)
        var files: list<string> = glob(tempdir .. '/*', false, true)
        if empty(files)
            echohl ErrorMsg
            echom 'Could not find any wiki at:  ' .. url
            echohl NONE
            return
        endif
        files
            ->map((_, v: string): string => substitute(v, '^\C\V' .. tempdir .. '/', '', ''))
            ->filter((_, v: string): bool => v !~ '\c_\=footer\%(\.md\)\=$')

        norm! mx
        append('.', files + [''])
        exe ':+' .. (2 * (len(files) + 1))
        norm! my

        sil keepj keepp :'x+,'y-s/^/# /
        sil keepj keepp :'x+,'y-g/^./exe 'keepalt r `=tempdir`/' .. getline('.')[2 :]
        sil keepj keepp :'x+,'y-g/^=\+\s*$/d _
            | eval (line('.') - 1)->getline()->substitute('^', '## ', '')->setline(line('.') - 1)
        sil keepj keepp :'x+,'y-g/^-\+\s*$/d _
            | eval (line('.') - 1)->getline()->substitute('^', '### ', '')->setline(line('.') - 1)
        sil keepj keepp :'x+,'y-s/^#.\{-}\n\zs\s*\n\ze##//

        sil keepj keepp :'x+,'y-g/^#\%(#\)\@!/append(line('.') - 1, '#')
        if &bt == '' && expand('%:p') != ''
            sil update
        endif

    catch
        Catch()
        return
    finally
        setpos("'x", x_save)
        setpos("'y", y_save)
    endtry
enddef

# gtfo {{{1

def GtfoError(msg: string)
    echohl ErrorMsg
    echom '[GTFO] ' .. msg
    echohl None
enddef

def myfuncs#gtfoOpenGui(dir: string)
    if GtfoIsNotValid(dir)
        return
    endif
    sil system('xdg-open ' .. shellescape(dir) .. ' &')
enddef

def GtfoIsNotValid(dir: string): bool
    if !isdirectory(dir) # this happens if a directory was deleted outside of vim.
        GtfoError('invalid/missing directory: ' .. dir)
        return true
    endif
    return false
enddef

def myfuncs#gtfoOpenTerm(dir: string)
    if GtfoIsNotValid(dir)
        return
    endif
    if IS_TMUX
        sil system('tmux splitw -h -c ' .. shellescape(dir))
    elseif IS_X_RUNNING
        sil printf('xterm -e "cd %s; %s"', shellescape(dir), &shell)->system()
    else
        GtfoError('failed to open terminal')
    endif
enddef

const IS_TMUX: bool = !empty($TMUX)
# terminal Vim running within a GUI environment
const IS_X_RUNNING: bool = !empty($DISPLAY) && &term != 'linux'

def myfuncs#HorizontalRulesTextobject(adverb: string) #{{{1
# TODO: Consider moving all or most of your custom text-objects into a dedicated (libary?) plugin.
    var start: string
    var end: string
    var comment: string
    if &ft == 'markdown'
        start = '^\%(---\|#.*\)\n\zs\|\%^'
        end = '\n\@1<=---$\|\n#\|\%$'
    else
        if &ft == 'vim'
            comment = '["#]'
        else
            var cml: string = matchstr(&l:cms, '\S*\ze\s*%s')
            comment = '\V' .. escape(cml, '\') .. '\m'
        endif
        var foldmarker: string = '\%(' .. split(&l:fmr, ',')->join('\|') .. '\)\d*'
        start =
            # just below a `---` line, or just below the start of a fold
            '^\s*' .. comment .. '\s*\%(---\|.*' .. foldmarker .. '\)\n\zs'
            # or the start of a multiline comment
            .. '\|^\%(\s*' .. comment .. '\)\@!.*\n\zs\s*' .. comment
            .. '\|\%^'
        end =
            # a `---` line, or the end of a fold
            '\s*' .. comment .. '\s*\%(---\|.*' .. foldmarker .. '\)$'
            # or the end of a multiline comment
            .. '\|^\s*' .. comment .. '.*\n\%(\s*' .. comment .. '\)\@!'
    endif
    search(start, 'bcW')
    exe 'norm! o' .. (mode() != 'V' ? 'V' : '')
    search('\n\@1<=' .. end, 'cW')

    if adverb == 'around'
        # special case: if we're in the last `---` section of a fold,
        # grab the `---` above
        if &ft == 'markdown' && (getline(line('.') + 1) =~ '^#' || line('.') == line('$'))
        || &ft != 'markdown' && (getline('.') !~ end)
            norm! oko
        endif
        return
    endif

    if &ft == 'markdown'
        if getline('.') =~ '^---$\|^#'
            norm! k
        endif
    else
        if getline('.') =~ '^\s*' .. comment .. '\s*---$'
            norm! k
        endif
    endif
enddef

def myfuncs#inANotInB(argfileA: string, argfileB: string) #{{{1
    var fileA: string
    var fileB: string
    if getbufline(argfileA, 1, '$')->len()
     < getbufline(argfileB, 1, '$')->len()
        fileA = argfileB
        fileB = argfileA
    else
        fileA = argfileA
        fileB = argfileB
    endif

    fileA = shellescape(fileA)
    fileB = shellescape(fileB)

    # http://unix.stackexchange.com/a/28159
    # Why `wc -l < file` instead of simply `wc -l file`?{{{
    #
    #     $ wc -l file
    #     5 file
    #
    #     $ wc -l < file
    #     5
    #
    # I think that when you reconnect the input of `wc(1)` like this, it doesn't
    # see a  file anymore, only  its contents, which  removes some noise  in the
    # output.
    #}}}
    var cmd: string = printf('diff -U $(wc -l < %s) %s %s | grep ''^-'' | sed ''s/^-//g''',
        fileA,
        fileA,
        fileB
        )
    sil var items: list<dict<string>> = systemlist(cmd)
        ->mapnew((_, v: string): dict<string> => ({text: v}))

    setloclist(0, [], ' ', {
        items: items,
        title: 'in  ' .. fileA .. '  but not in  ' .. fileB
        })

    do <nomodeline> QuickFixCmdPost lopen
    qf#setMatches('myfuncs#inANotInB', 'Conceal', 'double_bar')
    qf#createMatches()
enddef

def myfuncs#joinBlocks(first_reverse = false) #{{{1
    var line1: number = line("'<")
    var line2: number = line("'>")

    if (line2 - line1 + 1) % 2 == 1
        echohl ErrorMsg
        echo ' Total number of lines must be even'
        echohl None
        return
    endif

    var end_first_block: number = line1 + (line2 - line1 + 1) / 2 - 1
    var range_first_block: string = ':' .. line1 .. ',' .. end_first_block
    var range_second_block: string = ':' .. (end_first_block + 1) .. ',' .. line2
    var mods: string = 'sil keepj keepp '

    var fen_save: bool = &l:fen
    var winid: number = win_getid()
    var bufnr: number = bufnr('%')
    &l:fen = false
    try
        if first_reverse
            sil exe ':' .. range_first_block .. 'd'
            sil exe ':' .. end_first_block .. 'put'
        endif

        exe mods .. range_second_block .. "s/^/\x01/e"
        exe mods .. range_first_block .. 'g/^/'
            .. ':' .. (end_first_block + 1) .. 'm . | :-j'

        sil :*!column -s $'\x01' -t

    catch
        Catch()
        return
    finally
        if winbufnr(winid) == bufnr
            var tabnr: number
            var winnr: number
            [tabnr, winnr] = win_id2tabwin(winid)
            settabwinvar(tabnr, winnr, '&fen', fen_save)
        endif
    endtry
enddef

def myfuncs#longDataJoin(type = ''): string #{{{1
    # This function should do the following conversion:{{{
    #
    #     let list = [1,
    #     \ 2,
    #     \ 3,
    #     \ 4]
    # →
    #     let list = [1, 2, 3, 4]
    #}}}
    if type == ''
        &opfunc = 'myfuncs#longDataJoin'
        return 'g@'
    endif

    var range: string = ':' .. line("'[") .. ',' .. line("']")

    var bullets: string = '[-*+]'
    var join_bulleted_list: bool = getline('.') =~ '^\s*' .. bullets

    try
        var mods: string = 'keepj keepp '
        if join_bulleted_list
            sil exe mods .. range .. 's/^\s*\zs' .. bullets .. '\s*//'
            sil exe mods .. range .. '-s/$/,/'
            sil exe mods .. range .. 'j'
        else
            contline = !IsVim9() ? '\\' : ''
            sil exe mods .. range .. 's/\n\s*' .. contline .. '/'
                .. (IsVim9() ? ' ' : '') .. '/ge'
            cursor("'[", 1)
            sil keepj keepp s/\m\zs\s*,\ze\s\=[\]}]//e
        endif
    catch
        Catch()
        return ''
    endtry
    return ''
enddef

def myfuncs#longDataSplit(type = ''): string #{{{1
    if type == ''
        &opfunc = 'myfuncs#longDataSplit'
        return 'g@l'
    endif
    var line: string = getline('.')

    # special case: popup options or position (probably)
    if line =~ '^\s*{''highlight''' || line =~ '^\s*{''core_col'''
        :%j!
        first_line = getline(1)
        if first_line[0] == '{' && first_line[-1] == '}'
            sil keepj keepp s/.*/\=first_line->substitute('^{\|}$', '', 'g')/e
            sil keepj keepp s/\%(^\%(\[[^[\]]*\]\|[^[\]]\)*\)\@<=,/\="\r"/ge
            sil keepj keepp :%s/^\s*'\([^']*\)'/\1/
            :%sort
        endif
        return ''
    endif

    # This pattern is useful to split long stacktrace such as:{{{
    #
    #     Error detected while processing function doc#mapping#main[52]..<SNR>205_handle_special_filetype[11]..<SNR>205_use_manpage[21]..function doc#mapping#main[52]..<SNR>205_handle_special_filetype[11]..<SNR>205_use_manpage:
    #}}}
    var stack_pat: string = '\%(^\s*Error detected while .*\)\@<=[.]\@1<!\.\.[.]\@!'
    var is_stacktrace: bool = match(line, stack_pat) > -1
    if is_stacktrace
        var reg_save: dict<any> = getreginfo('"')
        var indent: string = matchstr(line, '^\s*')
        var splitted: list<string> = line
            ->substitute(stack_pat, '\n' .. indent .. '..', 'g')
            ->split('\n')
        setreg('"', splitted)
        norm! Vp
        setreg('"', reg_save)
        return ''
    endif

    var is_list_or_dict: bool = match(line, '\m\[.*\]\|{.*}') > -1
    var has_comma: bool = stridx(line, ',') > -1
    if is_list_or_dict
        first_line_indent = repeat(' ', match(line, '\S'))
        # If the  first item in the  list/dictionary begins right after  the opening
        # symbol (`[` or `{`), add a space:
        sil keepj keepp s/\m[\[{]\s\@!\zs/ /e
        # Move the first item in the list on a dedicated line.
        contline = !IsVim9() ? ' \' : ''
        sil keepj keepp s/\m[\[{]\zs/\="\n" .. first_line_indent .. '   ' .. contline/e
        # split the data
        sil keepj keepp s/,\zs/\="\n" .. first_line_indent .. '   ' .. contline/ge
        # move the closing symbol on a dedicated line
        contline = !IsVim9() ? '    \ ' : ''
        sil keepj keepp s/\m\zs\s\=\ze[\]}]/\=",\n" .. first_line_indent .. contline/e

    elseif has_comma
        # We use `strdisplaywidth()` because the indentation could contain tabs.
        var indent_lvl: number = matchstr(line, '.\{-}\ze\S')->strdisplaywidth()
        var indent_txt: string = repeat(' ', indent_lvl)
        sil keepj keepp s/\m\ze\S/- /e
        var pat: string = '\m\s*,\s*\%(et\|and\s\+\)\=\|\s*\<\%(et\|and\)\>\s*'
        LongDataSplitRep = (): string => "\n" .. indent_txt .. '- '
        sil exe 'keepj keepp s/' .. pat .. '/\=LongDataSplitRep()/ge'
    endif

    return ''
enddef
var first_line: string
var first_line_indent: string
var contline: string
var LongDataSplitRep: func: string

def myfuncs#onlySelection(lnum1: number, lnum2: number) #{{{1
    var lines: list<string> = getline(lnum1, lnum2)
    sil keepj :%d _
    setline(1, lines)
enddef

def myfuncs#pluginInstall(url: string) #{{{1
    var pat: string = 'https\=://github.com/\(.\{-}\)/\(.*\)/\='
    if url !~ pat
        echo 'invalid url'
        return
    endif
    var rep: string = 'Plug ''\1/\2'''
    var plug_line: string = substitute(url, pat, rep, '')
    var to_install: string = matchstr(plug_line, 'Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze''')

    var win_orig: number = win_getid()
    vnew | e $MYVIMRC
    if &l:ro
        echom 'cannot install plugin (vimrc is readonly)'
        return
    endif

    var win_vimrc: number = win_getid()

    cursor(1, 1)
    search('^\s*Plug', 'cW')
    # We should write `zR` to open all  folds, so that the while loop can search
    # in closed folds (it seems it misses the plugins lines inside folds).
    #
    # But I don't want the new line to be pasted inside a fold.
    # It's not where it should be.
    #
    # It should be pasted just above the fold.
    # I don't know how to detect an open fold, and then how to move to the first
    # line.
    norm! zv
    var plugin_on_current_line: string = ''

    while to_install >? plugin_on_current_line && search('plug#end()', 'nW') > 0
        # test if there's still another 'Plug ...' line afterwards, AND move the
        # cursor there, if there's one
        if search('^\s*"\=\s*Plug ''.\{-}/.\{-}/\=''', 'W') == 0
            break
        endif
        plugin_on_current_line = getline('.')
            ->matchstr('Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze/\=''')
    endwhile

    append(line('.') - 1, plug_line)
    update
    # Why?{{{
    #
    # Saving the  vimrc, and  triggering its  resourcing, is  not enough  to let
    # `vim-plug` know that it must manage a new plugin.
    # Indeed we've guarded all `:Plug` commands with `if has('vim_starting')`.
    # So, to avoid having to restart  Vim, we manually tell `vim-plug` about our
    # new plugin.
    #}}}
    exe plug_line
    # now vim-plug can install our new plugin
    PlugInstall
    var win_plug: number = win_getid()

    win_gotoid(win_vimrc) | q

    # Before going  back to the  `vim-plug` window, we  go back to  the original
    # one.  This way, once we are in `vim-plug`, the previous window will be the
    # original one, and we can go back there with `C-w w`.

    win_gotoid(win_orig)
    win_gotoid(win_plug)
enddef

def myfuncs#pluginGlobalVariables(keyword: string) #{{{1
    if keyword == ''
        var usage: list<string> =<< trim END
            usage:

                :PluginGlobalVariables ulti
                display all global variables containing the keyword `ulti`
        END
        echo join(usage, "\n")
        return
    endif
    var variables: list<string> = deepcopy(g:)
        ->filter((k: string): bool =>
                k =~ '\C\V' .. escape(keyword, '\')
             && k !~ '\%(loaded\|did_plugin_\)'
             )
        ->items()
        ->mapnew((_, v: list<any>): string => v[0] .. ' = ' .. string(v[1]))
    new
    setl bt=nofile nobl noswf nowrap
    setline(1, variables)
enddef

def myfuncs#removeTabs(line1: number, line2: number) #{{{1
    var view: dict<number> = winsaveview()
    var mods: string = 'sil keepj keepp'
    var range: string = ':' .. line1 .. ',' .. line2
    # Why not simply `\t`?{{{
    #
    # We need  the cursor to be  positioned on the screen  position *before* the
    # tab,  because  that's  what  `strdisplaywidth()`  expects  as  its  second
    # argument.
    #}}}
    # Couldn't I use the pattern `\t`, and `virtcol('.') - 1`?{{{
    #
    # No,  because `virtcol()`  returns  the  index of  the  *last* screen  cell
    # occupied by the tab character; for `virtcol('.') - 1` to work, we would need
    # the index of the *first* screen cell.
    #}}}
    # I want to preserve a tab used to indent a line!{{{
    #
    # Use this pattern instead:
    #
    #     var pat: string = '\%(^\s*\)\@!\&\(.\)\t'
    #}}}
    var pat: string = '^\t\|\(.\)\t'
    # Don't remove a leading tab in a heredoc.{{{
    #
    # They have a special meaning in bash and zsh.
    # See `man bash /<<-`.
    #
    # ---
    #
    # We don't use a complex pattern, just: `heredoc`.
    # We could try sth like `^\Cz\=shHereDoc$`,  but it seems there exists other
    # possible syntax groups (e.g. `shHereDoc03`).
    #}}}
    # FIXME: `strdisplaywidth()` doesn't handle conceal.{{{
    #
    # It works as if `'cole'` was set to 0.
    # This  matters, e.g.,  for a  blockquote containing  a tab  character in  a
    # markdown file, where the leading `> ` is concealed because `'cole'` is 3.
    #}}}
    RemoveTabsRep = (): string => synstack('.', col('.'))
        ->mapnew((_, v: number): string => synIDattr(v, 'name'))
        ->match('heredoc') >= 0
            ? submatch(0)
            : submatch(1) .. repeat(' ', strdisplaywidth("\t", col('.') == 1 ? 0 : virtcol('.')))
    # We need the loop because there may be several tabs consecutively.{{{
    #
    # If that happens, a single substitution would fail to replace all of them, for
    # the same reason that the pattern `.w` fails to match both `w` in `zww`.
    # The regex  engine moves after  the end of a  match, before trying  to find
    # another one.  In the process, it may skip a tab.
    #
    # If a line contains 8 tabs, the first iteration will replace the tabs 1, 3, 5 and 7.
    # The second iteration will replace the tabs 2, 4, 6 and 8.
    #}}}
    for i in [1, 2]
        exe mods .. ' ' .. range .. 's/' .. pat .. '/\=RemoveTabsRep()/ge'
    endfor
    winrestview(view)
enddef
var RemoveTabsRep: func: string

def myfuncs#searchTodo(where: string) #{{{1
    try
        sil exe 'lvim /\CFIX' .. 'ME\|TO' .. 'DO/j '
            .. (where == 'buffer' ? '%' : './**/*')
    catch /^Vim\%((\a\+)\)\=:E480:/
        echom 'no TO' .. 'DO or FIX' .. 'ME'
        return
    catch
        Catch()
        return
    endtry

    # Because we've prefixed  `:lvim` with `:noa`, our autocmd which  opens a qf
    # window hasn't kicked in.  We must manually open it.
    do <nomodeline> QuickFixCmdPost lwindow
    if &bt != 'quickfix'
        return
    endif

    var items: list<dict<any>> = getloclist(0)
        # Tweak the text of  each entry when there's a line  with just `todo` or
        # `fixme`.  Replace it with the text of the next non empty line instead.
        ->map((_, v: dict<any>): dict<any> => SearchTodoText(v)
            # remove indentation (reading lines with various indentation levels is jarring)
            ->extend({text: substitute(v.text, '^\s*', '', '')})
            )
    setloclist(0, [], 'r', {items: items, title: 'FIX' .. 'ME & TO' .. 'DO'})

    if &bt != 'quickfix'
        return
    endif

    qf#setMatches('myfuncs:search_todo', 'Conceal', 'location')
    qf#setMatches('myfuncs:search_todo', 'Todo', '\cfixme\|todo')
    qf#createMatches()
enddef

def SearchTodoText(dict: dict<any>): dict<any>
    # if the text only contains `fixme` or `todo`
    if dict.text =~ '\c\%(fixme\|todo\):\=\s*\%(' .. split(&l:fmr, ',')[0] .. '\)\=\s*$'
        var bufnr: number = dict.bufnr
        # get the text of the next line, which is not empty (contains at least one keyword character)
        # Why using `readfile()` instead of `getbufline()`?{{{
        #
        # `getbufline()` works only if the buffer is listed.
        # If the buffer is NOT listed, it returns an empty list.
        # There's no guarantee that all buffers in which a fixme/todo is present
        # is currently listed.
        #}}}
        var lines: list<string> = bufname(bufnr)->readfile(0, dict.lnum + 4)[-4 :]
        dict.text = filter(lines, (_, v: string): bool => v =~ '\k')->get(0, '')
    endif
    return dict
enddef

def myfuncs#sendToTabPage(vcount: number) #{{{1
    var curtab: number = tabpagenr()
    var count: number
    if vcount == curtab
        redraw
        echo 'current window is already in current tab page'
        return
    elseif vcount > tabpagenr('$')
        redraw
        echo 'no tab page with number ' .. vcount
        return
    # if we don't press a count before the lhs, we want the chance to provide it afterward
    elseif vcount == 0
        # TODO: It would be nice if we could select the tab page via fzf.{{{
        #
        #     " prototype
        #     nno cd <cmd>call fzf#run({
        #         \ 'source': range(1, tabpagenr('$')),
        #         \ 'sink': function(expand('<SID>') .. 'Func'),
        #         \ 'options': '+m',
        #         \ 'left': 30,
        #         \ })<cr>
        #
        #     def Func(line: string)
        #         exe line .. 'tabnext'
        #     enddef
        #
        # We  still need  to figure out  how to  preview all the  windows opened  in the
        # selected tab page.
        #}}}
        var input: string = input('send to tab page nr: ')
        if input == '$'
            count = tabpagenr('$')
        elseif input =~ '$-\+$'
            var offset: number = matchstr(input, '-\+')->len()
            count = tabpagenr('$') - offset
        elseif input =~ '$-\d\+$'
            var offset: number = matchstr(input, '-\d\+')->str2nr()
            count = tabpagenr('$') - offset
        elseif input =~ '^[+-]\+$'
            count = tabpagenr() + count(input, '+') - count(input, '-')
        elseif input !~ '^[+-]\=\d*[1-9]\d*$'
            redraw
            if input != ''
                echo 'not a valid number'
            endif
            return
        # parse a `+2` or `-3` number as an index relative to the current tabpage
        elseif input[0] =~ '+\|-'
            count = eval(curtab .. ' ' .. input[0] .. ' ' .. matchstr(input, '\d\+'))
        else
            count = matchstr(input, '\d\+')->str2nr()
        endif
    endif
    var bufnr: number = bufnr('%')
    # let's save the winid of the window we want to move
    var closedwinid: number = win_getid()
    # Do *not* try to close it now.{{{
    #
    # Closing a tab page changes the positions of the next ones.
    # So, you would need  to apply an offset when moving to  a later tabpage, if
    # the current one only contains 1 window.
    #
    # Also, you don't know whether `:tabnext` will succeed.
    # If it fails, there's no reason to close the current window.
    #}}}
    # focus target tab page
    try
        # clear output of `input()` from the command-line
        redraw
        exe 'tabnext ' .. count
    catch /^Vim\%((\a\+)\)\=:E475:/
        Catch()
        return
    endtry
    # open new window displaying the buffer from the closed window in the target tab page
    exe 'sb ' .. bufnr
    var curwinid: number = win_getid()
    win_gotoid(closedwinid)
    close
    win_gotoid(curwinid)
enddef

def myfuncs#sendToServer() #{{{1
    if v:servername != ''
        return
    endif

    sil undo | var contains_ansi: bool = search("\e", 'n') > 0 | sil redo
    var bufname: string = expand('%:p')
    var file: string
    if bufname == '' || bufname =~ '^\C/proc/'
        file = tempname()
        getline(1, '$')->writefile(file)
        # if the buffer contained ansi escape codes, we want them to be sent to the Vim server
        if contains_ansi
            sil undo
            getline(1, '$')->writefile(file)
            sil redo
        else
            getline(1, '$')->writefile(file)
        endif
    else
        file = bufname
    endif

    var cmd: string = 'vim --remote-tab ' .. shellescape(file)
    sil system(cmd)

    if v:shell_error
        echohl ErrorMsg
        echom printf('the command "%s" failed', cmd)
        echohl NONE
        return
    endif

    # highlight ansi codes; useful for when you run sth like `$ trans word | vipe`
    if contains_ansi && ($_ =~ '\C/vipe$' || bufname == '')
        cmd = 'vim --remote-expr "execute(''runtime macros/ansi.vim'')"'
        sil system(cmd)
    endif

    var msg: string = printf('the %s was sent to the Vim server',
        bufname == '' ? 'buffer' : 'file')
    echohl ModeMsg
    echom msg
    echohl NONE
enddef

# trans {{{1

# Update: Have a look at this plugin:
# https://github.com/echuraev/translate-shell.vim

# TODO: add `| C-t` mapping, to replay last text
# TODO: Implement a mapping which would translate the word under the cursor in a split.
# Apply text properties to get bold/italics attributes.
# Apply folding to be able to read only one section (`noun`, `verb`, `Synonyms`, `Examples`).

#                ┌ the function is called for the 1st time;
#                │ if the text is too long for `trans(1)`, it will be
#                │ split into chunks, and the function will be called
#                │ several times
#                │
def myfuncs#trans(first_time = true)
    trans_tempfile = tempname()

    if first_time
        var text: string = mode() =~ "^[vV\<c-v>]$"
            ? GetSelectionText()->join("\n")
            : expand('<cword>')
        if text == ''
            return
        endif
        trans_chunks = split(text, '.\{100}\zs[.?!]')
        #                              │
        #                              └ split the text into chunks of around 100 characters
    endif

    # remove characters which cause issue during the translation
    var garbage: string = '["`*]' .. (
        !empty(&l:cms)
            ? '\|' .. matchstr(&l:cms, '\S*\ze\s*%s')
            : ''
        )
    var chunk: string = substitute(trans_chunks[0], garbage, '', 'g')

    # reduce excessive whitespace
    chunk = substitute(chunk, '\s\+', ' ', 'g')

    # `exit_io` invokes a callback when the jobs finishes
    # if you want to invoke a callback every time the job sends a message, use
    # `out_cb` instead
    #
    # don't use `close_cb` to read the file where the job writes its output,
    # because when the callback will read the file, the latter will be empty,
    # probably because the job writes in a buffer, and the buffer is written
    # to the file after the callback has been invoked
    # use `exit_cb` instead
    var opts: dict<any> = {
        out_io: 'file',
        out_name: trans_tempfile,
        err_io: 'null',
        close_cb: TransOutput,
        }

    # send the first chunk in the list of chunks to `trans`
    #
    # We execute the command in a shell, otherwise the text seems to be split
    # at each whitespace before being sent to `trans`.
    # This makes the translation wrong (because no global context), and the
    # voice pauses after each word.
    # Besides,  it's a  good habit  to invoke  a shell  so that  our command  is
    # properly parsed by the latter.  Otherwise, I don't know how Vim parses it.
    trans_job = job_start(['/bin/sh', '-c',
        'trans -brief -speak'
        .. ' -t ' .. (trans_target ?? 'fr')
        .. ' -s ' .. (trans_source ?? 'en')
        .. ' ' .. shellescape(chunk)
        ], opts)

    # remove it from the list of chunks
    remove(trans_chunks, 0)
enddef
var trans_tempfile: string
var trans_chunks: list<string>
var trans_target: string
var trans_source: string

def myfuncs#transCycle()
    trans_target = {fr: 'en', en: 'fr'}[trans_target ?? 'fr']
    trans_source = {fr: 'en', en: 'fr'}[trans_source ?? 'en']
    echo '[trans] ' .. trans_source .. ' → ' .. trans_target
enddef

def TransOutput(channel: channel)
    # FIXME:
    # if the text is composed of several chunks, only the last one is echoed
    #
    # instead of `echo`, maybe we should open a scratch buffer to display a long
    # translation
    #
    # we would need to introduce some newlines to format the output
    #
    # also, increase the length of the chunks (150?), so that the voice pauses
    # less often?
    # why not, but then the message won't be echoed properly
    # so we need to distinguish between 3 types of lengths:
    #
    #     short :  < 100 characters  →  one invocation, echo
    #     medium:  < 150 "           →  one invocation, scratch buffer
    #     long  :  > 200 "           →  several invocations, scratch buffer

    echo readfile(trans_tempfile)->join(' ')
    if len(trans_chunks) > 0
        myfuncs#trans(false)
    endif
enddef

def myfuncs#transStop()
    if job_status('trans_job') == 'run'
        job_stop(trans_job)
    endif
enddef
var trans_job: job

def myfuncs#webpageRead(url: string) #{{{1
    if !executable('w3m')
        echo 'w3m is not installed'
        return
    endif
    var tempfile: string = tempname() .. '/webpage'
    exe 'tabe ' .. tempfile
    # Alternative shell command:{{{
    #
    #     $ lynx -dump -width=1000 url
    #                         │
    #                         └ high nr to be sure that
    #                           `lynx` won't break long lines of code
    #}}}
    sil exe 'r !w3m -cols 100 ' .. shellescape(url, true)
    setl bt=nofile nobl noswf nowrap
enddef

def myfuncs#wordFrequency(line1: number, line2: number, qargs: string) #{{{1
    var flags: dict<any> = {
        min_length: matchstr(qargs, '-min_length\s\+\zs\d\+'),
        weighted: stridx(qargs, '-weighted') >= 0,
        }

    var words: list<string> = getline(line1, line2)
        ->join("\n")
        ->split('\%(\%(\k\@!\|\d\).\)\+')

    var min_length: number = !empty(flags.min_length)
        ? flags.min_length
        : 4

    # open vertical viewport to display future results
    var tempfile: string = tempname() .. '/WordFrequency'
    exe 'lefta :' .. (&columns / 3) .. 'vnew ' .. tempfile
    setl bh=delete bt=nofile nobl noswf wfw nowrap pvw

    # Remove anything which is:{{{
    #
    #    - shorter than `min_length` characters
    #
    #    - longer than 30 characters;
    #      probably not words;
    #      it  could be  for example  a long  sequence of  underscores used  to
    #      divide 2 sections of text
    #
    #    - not containing any letter
    #}}}
    filter(words, (_, v: string): bool => strchars(v, true) >= min_length
        && strchars(v, true) <= 30
        && v =~ '\a')

    # put all of them in lowercase
    map(words, (_, v: string): string => tolower(v))

    var freq: dict<number>
    for word in words
        freq[word] = get(freq, word, 0) + 1
    endfor

    # In addition to the frequency, take the length of words into consideration when sorting them.{{{
    #
    # This is especially useful  if we want to know for which  words it would be
    # the most useful to create abbreviations.
    #}}}
    if flags.weighted
        # `v` is the frequence of a word.
        # We multiply  it by  a number which  should be equal  to the  amount of
        # characters which we would save if  we created an abbreviation for that
        # word.
        var weighted_freq: dict<number> = freq
            ->mapnew((k: string, v: number): number =>
                v * ( strchars(k, true) -
                    # if a word is 4 characters long, then its abbreviation will probably be 2 characters long
                    strchars(k, true) == 4
                    ? 2
                      # if a word ends with an 's', and the same word without the ending
                      # 's'  is also  present,  then its  abbreviation  will probably  4
                      # characters long (because it's probably a plural)
                      : k[-1] == 's' && keys(freq)->index(k) >= 0
                      ?     4
                      # otherwise, by default, an abbreviation will probably be 3 characters long
                      :     3
                    ))
        for item in items(weighted_freq)
                ->sort((a: list<any>, b: list<any>): number => b[1] - a[1])
            join(item)->append('$')
        endfor
    else
        for item in items(freq)
            join(item)->append('$')
        endfor
    endif

    # format output into aligned columns
    if executable('column') && executable('sort')
        sil :%!column -t
        sil :%!sort -rn -k2
        # We don't need to delete the first empty line; `column(1)` doesn't return it.
        # Probably because there's nothing to align in it.
    endif

    exe 'vert res ' .. (
        range(1, line('$'))
            ->map((_, v: number): number => virtcol([v, '$']))->max()
        + 4
        )
    nno <buffer><expr><nowait> q reg_recording() != '' ? 'q' : '<cmd>q<cr>'
    wincmd p
enddef

def myfuncs#wfComplete(_a: any, _l: any, _p: any): string
    return ['-min_length', '-weighted']->join("\n")
enddef

def myfuncs#zshoptions() #{{{1
    # this function is invoked from the zsh alias `zsh_options` (defined in our zshrc)

    append(0, '# options whose value has been reset')
    wincmd l
    append(0, '# options which have kept their default value')

    # reverse the state of the options in the right window
    # Why? {{{
    #
    # Because the meaning of the output of `unsetopt` is:
    #
    #     the values of these options is NOT ...
    #
    # This 'NOT' reverses the reading:
    #
    #     NOT nooption = NOT disabled = enabled
    #     NOT option   = NOT enabled  = disabled
    # }}}
    #   Is there an alternative?{{{
    #
    # Yes:  `set -o`.
    #}}}
    #     Why don't you use it?{{{
    #
    # It  doesn't tell  you whether  the  default values  of the  options have  been
    # changed.
    #}}}
    sil keepj keepp :1;/^[^ \#]/,$s/^../\=submatch(0) == 'no' ? '' : 'no' .. submatch(0)/e
    :1
enddef

