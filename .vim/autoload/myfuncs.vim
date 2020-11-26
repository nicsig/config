import {Catch, IsVim9, Opfunc} from 'lg.vim'
const s:SID = execute('fu s:Opfunc')->matchstr('\C\<def\s\+\zs<SNR>\d\+_')

" Operators {{{1
fu myfuncs#op_grep() abort "{{{2
    let &opfunc = s:SID .. 'Opfunc'
    let g:opfunc = {'core': 'myfuncs#op_grep_core'}
    return 'g@'
endfu

fu myfuncs#op_grep_core(...) abort
    let type = a:0 == 1 ? a:1 : 'Ex'
    if type is# 'char'
        norm! `[v`]y
    endif
    if type is# 'line' || type is# 'block' || type is# 'char' && @" =~# "\n"
        " `rg(1)` is is line-oriented, unless you use `-U`
        " (which we don't because it's slower and consume more memory)
        return
    endif

    if type is# 'Ex'
        let pat = a:1
        let use_loclist = a:2
        " Why does `2>/dev/null` work here but not in `'grepprg'`?{{{
        "
        " They don't run the shell command in the same way:
        "
        "     " system()
        "     (rg foobar /etc)>/tmp/... 2>&1
        "
        "     " 'grepprg'
        "     :!rg foobar /etc 2>&1| tee /tmp/...
        "
        " In the first case, `2>/dev/null` is useful:
        "
        "     (rg 2>/dev/null foobar /etc)>/tmp/... 2>&1
        "         ^---------^
        "
        " It prevents errors from being written in the temp file.
        "
        " In the second case, `2>/dev/null` is useless:
        "
        "     :!rg 2>/dev/null foobar /etc 2>&1| tee /tmp/...
        "          ^---------^
        "
        " Because, it's overridden by `2>&1` which comes from `'shellpipe'`.
        " In contrast,  `system()` uses `'shellredir'`, which  also includes
        " `2>&1`, but it  doesn't have the same effect,  because the command
        " is run in a subshell via braces:
        "
        "     (rg 2>/dev/null foobar /etc)>/tmp/... 2>&1
        "     ^                          ^
        "
        " From `:h system() /braces`:
        "
        "    > For Unix, braces are put around {expr} to allow for
        "    > concatenated commands.
        "}}}
        let cmd = 'rg 2>/dev/null ' .. a:1
    else
        let use_loclist = 0
        let cmd = 'rg 2>/dev/null --fixed-strings ' .. shellescape(@")
    endif

    if type is# 'Ex' && use_loclist
        sil let items = getloclist(0, {'lines': systemlist(cmd), 'efm': '%f:%l:%c:%m'}).items
        call setloclist(0, [], ' ', {'items': items, 'title': cmd})
        do <nomodeline> QuickFixCmdPost lwindow
    else
        sil let items = getqflist({'lines': systemlist(cmd), 'efm': '%f:%l:%c:%m'}).items
        call setqflist([], ' ', {'items': items, 'title': cmd})
        do <nomodeline> QuickFixCmdPost cwindow
    endif
endfu

fu myfuncs#op_replace_without_yank() abort "{{{2
    let &opfunc = s:SID .. 'Opfunc'
    let g:opfunc = {
        \ 'core': 'myfuncs#op_replace_without_yank_core',
        "\ we don't need to yank the text-object, and don't want `v:register` nor `""` to mutate
        \ 'yank': v:false,
        "\ a third-party text-object might not know that it should pass `v:register` to the opfunc
        "\ https://github.com/wellle/targets.vim/issues/253
        \ 'register': v:register,
        \ }
        " TODO: You can  remove the `v:register`  key (here and in  our snippet)
        " once https://github.com/vim/vim/issues/6374 is fixed.
    return 'g@'
endfu

fu myfuncs#op_replace_without_yank_core(type) abort
    let reg = get(g:opfunc, 'register', '"')
    if a:type is# 'line'
        exe 'keepj norm! ''[V'']"' .. reg .. 'p'
        norm! gv=
    elseif a:type is# 'block'
        exe "keepj norm! `[\<c-v>`]" .. '"' .. reg .. 'p'
    elseif a:type is# 'char'
        call s:handle_char(reg)
    endif
endfu

fu s:handle_char(reg) abort
    let reg_save = getreginfo(a:reg)

    let contents = get(reg_save, 'regcontents', [])
    if get(reg_save, 'regtype', '') is# 'V' && !empty(contents)
        " Tweak linewise register so that it better fits inside a characterwise text.{{{
        "
        " That is:
        "
        "    - reset its type to characterwise
        "    - trim the leading whitespace in front of the first line
        "    - trim the trailing whitespace at the end of the last line
        "
        " Consider this text:
        "
        "     a
        "     b c d
        "
        " If you press `dd` to delete the  `a` line, then press `drl` on the
        " `c` character, you get:
        "
        "     b a d
        "
        " If you didn't tweak the register, you would get:
        "
        "        b
        "        a
        "     d
        "
        " Which is probably not what you want.
        "}}}
        " trim whitespace surrounding the text
        let contents[0] = substitute(contents[0], '^\s*', '', '')
        let contents[-1] = substitute(contents[-1], '\s*$', '', '')
        call deepcopy(reg_save)
            "\ and reset the type to characterwise
            \ ->extend({'regcontents': contents, 'regtype': 'c'})
            \ ->setreg(a:reg)
    endif

    try
        exe 'keepj norm! `[v`]"' .. a:reg .. 'p'
    catch
        return s:Catch()
    finally
        call setreg(a:reg, reg_save)
    endtry
endfu

fu myfuncs#op_trim_ws(...) abort "{{{2
    if !a:0
        let &opfunc = 'myfuncs#op_trim_ws'
        return 'g@'
    endif
    if &l:binary || &ft is# 'diff'
        return
    endif
    let range = line("'[") .. ',' .. line("']")
    exe range .. 'TW'
endfu

fu myfuncs#op_yank_setup(what) abort "{{{2
    let s:op_yank = {'what': a:what, 'register': v:register}
    let &opfunc = expand('<SID>') .. 'Op_yank'
    return 'g@'
endfu

def s:Op_yank(type: string)
    var mods = 'keepj keepp'
    var range = line("'[") .. ',' .. line("']")

    var cmd = s:op_yank.what == 'g//' || s:op_yank.what == 'comments' ? 'g' : 'v'
    var cml = &ft == 'vim'
        ?     '["#]'
        :     '\C\V' .. matchstr(&l:cms, '\S*\ze\s*%s')->escape('\')
    var pat = s:op_yank.what == 'code' || s:op_yank.what == 'comments'
        ?     '^\s*' .. cml
        :     @/

    var z_save = getreginfo('z')
    var yanked: list<string>
    try
        setreg('z', {})
        exe mods .. ' :' .. range .. cmd .. '/' .. escape(pat, '/') .. '/y Z'
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
    if s:op_yank.what == 'v//' || s:op_yank.what == 'code'
        filter(yanked, {_, v -> v !~ '^\s*$'})
    endif

    setreg(s:op_yank.register, yanked, 'l')
enddef
" }}}1

" box_create / destroy {{{1

" TODO:
" We could improve these functions by reading:
" https://github.com/vimwiki/vimwiki/blob/dev/autoload/vimwiki/tbl.vim
"
" In particular, it could update an existing table.
"
" ---
"
" Also, we should improve it to generate this kind of table:
"
"    ┌───────────────────┬─────────────────────────────────────────────────┐
"    │                   │                    login                        │
"    │                   ├─────────────────────────────────┬───────────────┤
"    │                   │ yes                             │ no            │
"    ├─────────────┬─────┼─────────────────────────────────┼───────────────┤
"    │ interactive │ yes │ zshenv  zprofile  zshrc  zlogin │ zshenv  zshrc │
"    │             ├─────┼─────────────────────────────────┼───────────────┤
"    │             │ no  │ zshenv  zprofile         zlogin │ zshenv        │
"    └─────────────┴─────┴─────────────────────────────────┴───────────────┘
"
" The peculiarity here, is the variable number of cells per line (2 on the first
" one, 3 on the second one, 4 on the last ones).
def myfuncs#box_create(type = ''): string
    if type == ''
        &opfunc = 'myfuncs#box_create'
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
        var i = 0
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
        Box_create_border('top', col_pos)

        # Draw the lower border of the box '└────┘':
        Box_create_border('bottom', col_pos)

        # Replace the remaining `|` with `│`:
        var first_line = line("'{") + 2
        var last_line = line("'}") - 2
        for l in range(first_line, last_line)
            for c in col_pos
                exe 'norm! ' .. l .. 'G' .. c .. '|r│'
            endfor
        endfor

        Box_create_separations()
    catch
        return Catch()
    endtry
    return ''
enddef

def s:Box_create_border(where: string, col_pos: list<number>)
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
    for pos in col_pos[1:-2]
        exe 'norm! ' .. pos .. '|r' .. (where == 'top' ? '┬' : '┴')
    endfor
enddef

def s:Box_create_separations()
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
    var line = (line("'{") + 1)->getline()
    line = substitute(line, '\S', '├', '')
    line = substitute(line, '.*\zs\S', '┤', '')
    line = substitute(line, '┬', '┼', 'g')

    # Make the contents of the register linewise, so we don't need to hit
    # `"x]p`, but simply `"xp`.
    setreg('x', [line], 'l')
enddef

def myfuncs#box_destroy(type = ''): string
    if type == ''
        &opfunc = 'myfuncs#box_destroy'
        return 'g@'
    endif

    var lnum1 = line("'[")
    var lnum2 = line("']")
    var range = lnum1 .. ',' .. lnum2
    # remove box (except pretty bars: │)
    exe 'sil :' .. range .. 's/[─┴┬├┤┼└┘┐┌]//ge'

    # replace pretty bars with regular bars
    # necessary, because we will need them to align the contents of the
    # paragraph later
    exe 'sil :' .. range .. 's/│/|/ge'

    # remove the bars at the beginning and at the end of the lines
    # we don't want them, because they would mess up the creation of a box
    # later
    exe 'sil :' .. range .. 's/|//e'
    exe 'sil :' .. range .. 's/.*\zs|//e'

    # trim whitespace
    exe 'sil :' .. range .. 'TW'
    # remove empty lines
    exe 'sil :' .. range .. '-g/^\s*$/d_'

    append(lnum1 - 1, [''])

    # position the cursor on the upper left corner of the paragraph
    exe 'norm! ' .. lnum1 .. 'Gj_'
    return ''
enddef

fu myfuncs#delete_matching_lines(to_delete, ...) abort "{{{1
    let view = winsaveview()
    let fen_save = &l:fen | setl nofen

    " Purpose:{{{
    "
    " The deletions will leave the cursor on  the line below the last line where
    " a match was found.   This line may be far away  from our current position.
    " This  is distracting;  let's try  to stay  as close  as possible  from our
    " current position.
    "
    " To achieve this goal, we need to find the nearest character which won't be
    " deleted, and set a mark on it.
    "}}}
    let pos = getcurpos()
    let global = a:0 && a:1 =~# '\<reverse\>' ? 'v' : 'g'
    if &ft is# 'vim'
        " don't delete a literal dictionary at the start of a line
        let cml = '\%("\|#\%({\%([^{]\|$\)\)\@!\)'
    else
        let cml = '\V' .. matchstr(&l:cms, '\S*\ze\s*%s')->escape('\') .. '\m'
    endif
    let to_search = {
        \ 'empty': ['^\s*$', '^'],
        \ 'comments': ['^\s*' .. cml, '^\%(\s*' .. cml .. '\)\@!'],
        \ '@/': [@/, '^\%(.*' .. @/ .. '\m\)\@!'],
        \ }
    let wont_be_deleted = to_search[a:to_delete][global is# 'g']
    " necessary if the pattern matches on the current line, but the match starts
    " before our current position
    exe 'norm! ' .. (pos[1] == 1 ? '1|' : 'k$')
    call search(wont_be_deleted, pos[1] == 1 ? 'c' : '')
    " if the match is on our original line, restore the column position
    if line('.') == pos[1] | call setpos('.', pos) | endif
    norm! m'
    call setpos('.', pos)

    let mods = 'sil keepj keepp '
    let range = a:0 && a:1 =~# '\<vis\>' ? '*' : '%'
    let pat = to_search[a:to_delete][0]
    " Don't use `/` as a delimiter.{{{
    "
    " It's tricky.
    "
    " Suppose you've just  searched for a pattern containing a  slash with a `/`
    " command.   Vim will  have automatically  escaped the  slash in  the search
    " register.  So, you should not escape it a second time with `escape()`.
    "
    " But suppose `pat`  comes from sth else,  like a `?` search;  in that case,
    " there's no reason to believe that Vim  has already escaped `/`, and you do
    " need to do it yourself.
    "
    " Let's avoid this  conundrum altogether, by using a delimiter  which is not
    " `/` nor `?`.
    "}}}
    exe mods .. range .. global .. ':' .. escape(pat, ':') .. ':d_'

    sil! update
    "  │
    "  └ `:h E32`
    let &l:fen = fen_save
    call winrestview(view)
    " `sil!` because if the pattern was so broad that all the lines were removed,
    " the original line doesn't exist anymore, and the `'` mark is invalid
    sil! norm! `'zv
endfu

fu myfuncs#diff_lines(bang, lnum1, lnum2, option) abort "{{{1
    if a:option is# '-h' || a:option is# '--help'
        let usage =<< trim END
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
        " `:lvim` fails in an unnamed buffer
        echom 'Save the buffer in a file'
        echohl None
        return
    endif

    if exists('w:xl_match')
        call matchdelete(w:xl_match)
        unlet! w:xl_match
    endif

    if a:bang | return | endif

    " If `a:lnum1 == a:lnum2`, it means `:DiffLines` was called without a range.
    if a:lnum1 == a:lnum2
        let [lnum1, lnum2] = [line('.'), line('.') + 1]
    else
        let [lnum1, lnum2] = [a:lnum1, a:lnum2]
    endif
    let [line1, line2] = [getline(lnum1), getline(lnum2)]
    let [chars1, chars2] = [split(line1, '\zs'), split(line2, '\zs')]
    let min_chars = min([len(chars1), len(chars2)])

    " Build a pattern matching the characters which are different
    let pat = ''
    for i in range(min_chars)
        if chars1[i] isnot# chars2[i]
            " FIXME: We need to write `c.` instead of just `c`.{{{
            "
            " Otherwise, we may have duplicate entries.
            " The problem seems to come from `:lvim` and the `g` flag.
            "
            " MWE:
            " This adds 2 duplicate entries in the location list instead of one:
            "
            "     :lvim /\%1l\%2c/g %
            "
            " This adds 2 duplicate entries in the location list, 3 in total instead of two:
            "
            "     :lvim /\%1l\%2c\|\%1l\%3c/g %
            "
            " This adds 2 couple of duplicate entries in the location list, 4 in total instead of two.
            "
            "     :lvim /\%1l\%2c\|\%1l\%4c/g %
            "
            " It seems each time a `%{digit}c` anchor matches the beginning of a group
            " of consecutive characters, it adds 2 duplicate entries instead of one.
            "}}}
            " Don't use `virtcol()` and `\%v`.{{{
            "
            " It wouldn't work as expected  if the lines contain literal control
            " characters, and more generally any multi-cell characters.
            "}}}
            let col1 = matchstr(line1, '^.\{' .. (i + 1) .. '}')->strlen()
            let pat ..= (empty(pat) ? '' : '\|') .. '\%' .. lnum1 .. 'l\%' .. col1 .. 'c.'
            let col2 = matchstr(line2, '^.\{' .. (i + 1) .. '}')->strlen()
            let pat ..= (empty(pat) ? '' : '\|') .. '\%' .. lnum2 .. 'l\%' .. col2 .. 'c.'
        endif
    endfor

    " If one of the lines is longer than the other, we have to add its end in the pattern.
    if strlen(line1) > strlen(line2)
        " It's better to write `\%>123c.` than `\%123c.*`.{{{
        "
        " `\%>123c.` = any character after the 50th character.
        " This will add one entry in the loclist for *every* character.
        "
        " `\%123c.*` = the *whole* set of characters after the 123th.
        " This will add only *one* entry in the loclist.
        "}}}
        let pat ..= (!empty(pat) ? '\|' : '') .. '\%' .. lnum1 .. 'l' .. '\%>' .. strlen(line2) .. 'c.'

    elseif strlen(line1) < strlen(line2)
        let pat ..= (!empty(pat) ? '\|' : '') .. '\%' .. lnum2 .. 'l' .. '\%>' .. len(line1) .. 'c.'
    endif

    " Give the result
    if !empty(pat)
        " Why silent?{{{
        "
        " If the  lines are long, `:lvim`  will print a long  message which will
        " cause a hit-enter prompt:
        "
        "     (1 of 123): ...
        "}}}
        sil noa exe 'lvim /' .. pat .. '/g %'
        let w:xl_match = matchadd('SpellBad', pat, 0)
    else
        echohl WarningMsg
        echom 'Lines are identical'
        echohl None
    endif
endfu

fu myfuncs#dump_wiki(url) abort "{{{1
    " TODO: Regarding triple backticks.{{{
    "
    " Look at this page: https://github.com/ranger/ranger/wiki/Keybindings
    "
    " Some lines of code are surrounded by triple backticks:
    "
    "     ```map X chain shell vim -p ~/.config/ranger/rc.conf %rangerdir/config/rc.conf;
    "        source ~/.config/ranger/rc.conf```
    "
    " It's an error.
    " They should be surrounded by simple backticks.
    " AFAIK, triple backticks are for fenced code blocks.
    " For inline code, a single backtick is enough.
    "
    " More  importantly, these  wrong  triple backticks  are  recognized as  the
    " beginning of a fenced code block by our markdown syntax plugin.
    " As a result, the syntax of all the following lines will be wrong.
    "
    " After dumping a wiki in a buffer, give a warning about that.
    " Give the recommendation to manually inspect the syntax highlighting at the
    " end of the buffer.
    "}}}
    if a:url[:3] isnot# 'http'
        return
    endif

    let [x_save, y_save] = [getpos("'x"), getpos("'y")]
    try
        let url = trim(a:url, '/') .. '.wiki'
        let tempdir = tempname()->substitute('.*/\zs.\{-}', '', '')
        sil call system('git clone ' .. shellescape(url) .. ' ' .. tempdir)
        let files = glob(tempdir .. '/*', 0, 1)
        call map(files, {_, v -> substitute(v, '^\C\V' .. tempdir .. '/', '', '')})
        call filter(files, {_, v -> v !~# '\c_\=footer\%(\.md\)\=$'})

        norm! mx
        call append('.', files + [''])
        exe '+' .. (2 * (len(files) + 1))
        norm! my

        sil keepj keepp 'x+,'y-s/^/# /
        sil keepj keepp 'x+,'y-g/^./exe 'keepalt r ' .. tempdir .. '/' .. getline('.')[2:]
        sil keepj keepp 'x+,'y-g/^=\+\s*$/d_
            \ | eval (line('.') - 1)->getline()->substitute('^', '## ', '')->setline(line('.') - 1)
        sil keepj keepp 'x+,'y-g/^-\+\s*$/d_
            \ | eval (line('.') - 1)->getline()->substitute('^', '### ', '')->setline(line('.') - 1)
        sil keepj keepp 'x+,'y-s/^#.\{-}\n\zs\s*\n\ze##//

        sil keepj keepp 'x+,'y-g/^#\%(#\)\@!/call append(line('.') - 1, '#')
        sil update

    catch
        return s:Catch()

    finally
        call setpos("'x", x_save)
        call setpos("'y", y_save)
    endtry
endfu

" gtfo {{{1

fu s:gtfo_init() abort
    let s:IS_TMUX = !empty($TMUX)
    " terminal Vim running within a GUI environment
    let s:IS_X_RUNNING = !empty($DISPLAY) && $TERM isnot# 'linux'
    let s:LAUNCH_TERM = 'urxvt -cd'
endfu

fu s:gtfo_error(s) abort
    echohl ErrorMsg | echom '[GTFO] ' .. a:s | echohl None
endfu

fu myfuncs#gtfo_open_gui(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif
    sil call system('xdg-open ' .. shellescape(a:dir) .. ' &')
endfu

fu s:gtfo_is_not_valid(dir) abort
    if !isdirectory(a:dir) "this happens if a directory was deleted outside of vim.
        call s:gtfo_error('invalid/missing directory: ' .. a:dir)
        return 1
    endif
endfu

fu myfuncs#gtfo_open_term(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif
    if s:IS_TMUX
        sil call system('tmux splitw -h -c ' .. shellescape(a:dir))
    elseif s:IS_X_RUNNING
        sil call system(s:LAUNCH_TERM .. ' ' .. shellescape(a:dir) .. ' &')
    else
        call s:gtfo_error('failed to open terminal')
    endif
endfu

if !exists('s:gtfo_has_been_init')
    let s:gtfo_has_been_init = 1
    call s:gtfo_init()
endif

fu myfuncs#in_A_not_in_B(...) abort "{{{1
    let [fileA, fileB] = a:000
    if getbufline(fileA, 1, '$')->len() < getbufline(fileB, 1, '$')->len()
        let [fileA, fileB] = [fileB, fileA]
    endif

    let [fileA, fileB] = [shellescape(fileA), shellescape(fileB)]

    " http://unix.stackexchange.com/a/28159
    " Why `wc -l < file` instead of simply `wc -l file`?{{{
    "
    "     $ wc -l file
    "     5 file
    "
    "     $ wc -l < file
    "     5
    "
    " I think that when you reconnect the input of `wc(1)` like this, it doesn't
    " see a  file anymore, only  its contents, which  removes some noise  in the
    " output.
    "}}}
    sil let output = systemlist('diff -U $(wc -l < ' .. fileA .. ') ' .. fileA .. ' ' .. fileB .. " | grep '^-' | sed 's/^-//g'")

    call map(output, {_, v -> {'text': v}})
    call setloclist(0, [], ' ', {'items': output, 'title': 'in  ' .. fileA .. '  but not in  ' .. fileB})

    do <nomodeline> QuickFixCmdPost lopen
    call qf#set_matches('myfuncs#in_A_not_in_B', 'Conceal', 'double_bar')
    call qf#create_matches()
endfu

fu myfuncs#join_blocks(first_reverse = v:false) abort "{{{1
    let [line1, line2] = [line("'<"), line("'>")]

    if (line2 - line1 + 1) % 2 == 1
        echohl ErrorMsg
        echo ' Total number of lines must be even'
        echohl None
        return ''
    endif

    let end_first_block = line1 + (line2 - line1 + 1) / 2 - 1
    let range_first_block = line1 .. ',' .. end_first_block
    let range_second_block = (end_first_block + 1) .. ',' .. line2
    let mods = 'keepj keepp '

    let [fen_save, winid, bufnr] = [&l:fen, win_getid(), bufnr('%')]
    let &l:fen = 0
    try
        if a:first_reverse
            sil exe range_first_block .. 'd'
            sil exe end_first_block .. 'put'
        endif

        sil exe mods .. range_second_block .. "s/^/\x01/e"
        sil exe mods .. range_first_block .. 'g/^/' .. (end_first_block + 1) .. 'm.|-j'

        sil *!column -s $'\x01' -t

    catch
        return s:Catch()
    finally
        if winbufnr(winid) == bufnr
            let [tabnr, winnr] = win_id2tabwin(winid)
            call settabwinvar(tabnr, winnr, '&fen', fen_save)
        endif
    endtry
endfu

fu myfuncs#long_data_join(...) abort "{{{1
    " This function should do the following conversion:{{{
    "
    "     let list = [1,
    "     \ 2,
    "     \ 3,
    "     \ 4]
    " →
    "     let list = [1, 2, 3, 4]
    "}}}
    if !a:0
        let &opfunc = 'myfuncs#long_data_join'
        return 'g@'
    endif

    let range = line("'[") .. ',' .. line("']")

    let bullets = '[-*+]'
    let join_bulleted_list = getline('.') =~# '^\s*' .. bullets

    try
        if join_bulleted_list
            sil exe 'keepj keepp' .. range .. 's/^\s*\zs' .. bullets .. '\s*//'
            sil exe 'keepj keepp' .. range .. '-s/$/,/'
            sil exe range .. 'j'
        else
            let contline = !s:IsVim9() ? '\\' : ''
            sil exe 'keepj keepp ' .. range .. 's/\n\s*' .. contline .. '/' .. (s:IsVim9() ? ' ' : '') .. '/ge'
            call cursor("'[", 1)
            sil keepj keepp s/\m\zs\s*,\ze\s\=[\]}]//e
        endif
    catch
        return s:Catch()
    endtry
endfu

fu myfuncs#long_data_split(...) abort "{{{1
    if !a:0
        let &opfunc = 'myfuncs#long_data_split'
        return 'g@l'
    endif
    let line = getline('.')

    let is_list_or_dict = match(line, '\m\[.*\]\|{.*}') > -1
    let has_comma = stridx(line, ',') > -1
    if is_list_or_dict
        let first_line_indent = repeat(' ', match(line, '\S'))
        " If the  first item in the  list/dictionary begins right after  the opening
        " symbol (`[` or `{`), add a space:
        sil keepj keepp s/\m[\[{]\s\@!\zs/ /e
        " Move the first item in the list on a dedicated line.
        let contline = !s:IsVim9() ? ' \' : ''
        sil keepj keepp s/\m[\[{]\zs/\="\n" .. first_line_indent .. '   ' .. contline/e
        " split the data
        sil keepj keepp s/,\zs/\="\n" .. first_line_indent .. '   ' .. contline/ge
        " move the closing symbol on a dedicated line
        let contline = !s:IsVim9() ? '    \ ' : ''
        sil keepj keepp s/\m\zs\s\=\ze[\]}]/\=",\n" .. first_line_indent .. contline/e

    elseif has_comma
        " We use `strdisplaywidth()` because the indentation could contain tabs.
        let indent_lvl = matchstr(line, '.\{-}\ze\S')->strdisplaywidth()
        let indent_txt = repeat(' ', indent_lvl)
        sil keepj keepp s/\m\ze\S/- /e
        let pat = '\m\s*,\s*\%(et\|and\s\+\)\=\|\s*\<\%(et\|and\)\>\s*'
        let l:Rep = {-> "\n" .. indent_txt .. '- '}
        sil exe 'keepj keepp s/' .. pat .. '/\=Rep()/ge'
    endif
endfu

fu myfuncs#only_selection(lnum1,lnum2) abort "{{{1
    let lines = getline(a:lnum1,a:lnum2)
    sil keepj %d_
    call setline(1, lines)
endfu

fu myfuncs#plugin_install(url) abort "{{{1
    let pat = 'https\=://github.com/\(.\{-}\)/\(.*\)/\='
    if a:url !~# pat
        echo 'invalid url'
        return
    endif
    let rep = 'Plug ''\1/\2'''
    let plug_line = substitute(a:url, pat, rep, '')
    let to_install = matchstr(plug_line, 'Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze''')

    let win_orig = win_getid()
    vnew | e $MYVIMRC
    if &l:ro
        echom 'cannot install plugin (vimrc is readonly)'
        return
    endif

    let win_vimrc = win_getid()

    call cursor(1, 1)
    call search('^\s*Plug', 'cW')
    " We should write `zR` to open all  folds, so that the while loop can search
    " in closed folds (it seems it misses the plugins lines inside folds).
    "
    " But I don't want the new line to be pasted inside a fold.
    " It's not where it should be.
    "
    " It should be pasted just above the fold.
    " I don't know how to detect an open fold, and then how to move to the first
    " line.
    norm! zv
    let plugin_on_current_line = ''

    while to_install >? plugin_on_current_line && search('call plug#end()', 'nW')
        " test if there's still another 'Plug ...' line afterwards, AND move the
        " cursor there, if there's one
        if !search('^\s*"\=\s*Plug ''.\{-}/.\{-}/\=''', 'W')
            break
        endif
        let plugin_on_current_line = getline('.')->matchstr('Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze/\=''')
    endwhile

    call append(line('.') - 1, plug_line)
    update
    " Why?{{{
    "
    " Saving the  vimrc, and  triggering its  resourcing, is  not enough  to let
    " `vim-plug` know that it must manage a new plugin.
    " Indeed we've guarded all `:Plug` commands with `if has('vim_starting')`.
    " So, to avoid having to restart  Vim, we manually tell `vim-plug` about our
    " new plugin.
    "}}}
    exe plug_line
    " now vim-plug can install our new plugin
    PlugInstall
    let win_plug = win_getid()

    call win_gotoid(win_vimrc) | q

    " Before going  back to the  `vim-plug` window, we  go back to  the original
    " one.  This way, once we are in `vim-plug`, the previous window will be the
    " original one, and we can go back there with `C-w w`.

    call win_gotoid(win_orig)
    call win_gotoid(win_plug)
endfu

fu myfuncs#plugin_global_variables(keyword) abort "{{{1
    if a:keyword == ''
        let usage =<< trim END
            usage:

                :PluginGlobalVariables ulti
                display all global variables containing the keyword `ulti`
        END
        echo join(usage, "\n")
        return
    endif
    let variables = deepcopy(g:)
        \ ->filter({k -> k =~# '\C\V' .. escape(a:keyword, '\')
        \             && k !~# '\%(loaded\|did_plugin_\)'})
        \ ->items()
    call map(variables, {_, v -> v[0] .. ' = ' .. string(v[1])})
    new
    setl bt=nofile nobl noswf nowrap
    call setline(1, variables)
endfu

fu myfuncs#remove_tabs(line1, line2) abort "{{{1
    let view = winsaveview()
    let mods = 'sil keepj keepp'
    let range = a:line1 .. ',' .. a:line2
    " Why not simply `\t`?{{{
    "
    " We need  the cursor to be  positioned on the screen  position *before* the
    " tab,  because  that's  what  `strdisplaywidth()`  expects  as  its  second
    " argument.
    "}}}
    " Couldn't I use the pattern `\t`, and `virtcol('.') - 1`?{{{
    "
    " No,  because `virtcol()`  returns  the  index of  the  *last* screen  cell
    " occupied by the tab character; for `virtcol('.') - 1` to work, we would need
    " the index of the *first* screen cell.
    "}}}
    " I want to preserve a tab used to indent a line!{{{
    "
    " Use this pattern instead:
    "
    "     let pat = '\%(^\s*\)\@!\&\(.\)\t'
    "}}}
    let pat = '^\t\|\(.\)\t'
    " Don't remove a leading tab in a heredoc.{{{
    "
    " They have a special meaning in bash and zsh.
    " See `man bash /<<-`.
    "
    " ---
    "
    " We don't use a complex pattern, just: `heredoc`.
    " We could try sth like `^\Cz\=shHereDoc$`,  but it seems there exists other
    " possible syntax groups (e.g. `shHereDoc03`).
    "}}}
    " FIXME: `strdisplaywidth()` doesn't handle conceal.{{{
    "
    " It works as if `'cole'` was set to 0.
    " This  matters, e.g.,  for a  blockquote containing  a tab  character in  a
    " markdown file, where the leading `> ` is concealed because `'cole'` is 3.
    "}}}
    let l:Rep = {->
        \ synstack('.', col('.'))->map({_, v -> synIDattr(v, 'name')})->match('heredoc') != -1
        \ ? submatch(0)
        \ : submatch(1) .. repeat(' ', strdisplaywidth("\t", col('.') == 1 ? 0 : virtcol('.')))}
    " We need the loop because there may be several tabs consecutively.{{{
    "
    " If that happens, a single substitution would fail to replace all of them, for
    " the same reason that the pattern `.w` fails to match both `w` in `zww`.
    " The regex  engine moves after  the end of a  match, before trying  to find
    " another one.  In the process, it may skip a tab.
    "
    " If a line contains 8 tabs, the first iteration will replace the tabs 1, 3, 5 and 7.
    " The second iteration will replace the tabs 2, 4, 6 and 8.
    "}}}
    for i in [1, 2]
        exe mods .. ' ' .. range .. 's/' .. pat .. '/\=Rep()/ge'
    endfor
    call winrestview(view)
endfu

fu myfuncs#search_todo(where) abort "{{{1
    try
        sil noa exe 'lvim /\CFIX' .. 'ME\|TO' .. 'DO/j ' .. (a:where is# 'buffer' ? '%' : './**/*')
    catch /^Vim\%((\a\+)\)\=:E480:/
        echom 'no TO' .. 'DO or FIX' .. 'ME'
        return
    catch
        return s:Catch()
    endtry

    " Because we've prefixed  `:lvim` with `:noa`, our autocmd which  opens a qf
    " window hasn't kicked in.  We must manually open it.
    do <nomodeline> QuickFixCmdPost lwindow
    if &bt isnot# 'quickfix' | return | endif

    "                                         ┌ Tweak the text of each entry when there's a line
    "                                         │ with just `todo` or `fixme`;
    "                                         │ replace it with the text of the next non empty line instead
    "                                         │
    let items = getloclist(0)->map({_, v -> s:search_todo_text(v)})
    " remove indentation (reading lines with various indentation levels is jarring)
    call map(items, {_, v -> extend(v, #{text: substitute(v.text, '^\s*', '', '')})})
    call setloclist(0, [], 'r', #{items: items, title: 'FIX' .. 'ME & TO' .. 'DO'})

    if &bt isnot# 'quickfix'
        return
    endif

    call qf#set_matches('myfuncs:search_todo', 'Conceal', 'location')
    call qf#set_matches('myfuncs:search_todo', 'Todo', '\cfixme\|todo')
    call qf#create_matches()
endfu

fu s:search_todo_text(dict) abort
    let dict = a:dict
    " if the text only contains `fixme` or `todo`
    if dict.text =~# '\c\%(fixme\|todo\):\=\s*\%(' .. split(&l:fmr, ',')[0] .. '\)\=\s*$'
        let bufnr = dict.bufnr
        " get the text of the next line, which is not empty (contains at least one keyword character)
        " Why using `readfile()` instead of `getbufline()`?{{{
        "
        " `getbufline()` works only if the buffer is listed.
        " If the buffer is NOT listed, it returns an empty list.
        " There's no guarantee that all buffers in which a fixme/todo is present
        " is currently listed.
        "}}}
        let lines = bufname(bufnr)->readfile(0, dict.lnum + 4)[-4:]
        let dict.text = filter(lines, {_, v -> v =~ '\k'})->get(0, '')
    endif
    return dict
endfu

def myfuncs#send_to_tab_page(vcount: number) #{{{1
    var curtab = tabpagenr()
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
        #     nno cd <cmd>call fzf#run(#{
        #         \ source: range(1, tabpagenr('$')),
        #         \ sink: function(expand('<SID>') .. 'Func'),
        #         \ options: '+m',
        #         \ left: 30,
        #         \ })<cr>
        #
        #     def Func(line: string)
        #         exe line .. 'tabnext'
        #     enddef
        #
        # We  still need  to figure out  how to  preview all the  windows opened  in the
        # selected tab page.
        #}}}
        var input = input('send to tab page nr: ')
        if input == '$'
            count = tabpagenr('$')
        elseif input =~ '$-\+$'
            var offset = matchstr(input, '-\+')->len()
            count = tabpagenr('$') - offset
        elseif input =~ '$-\d\+$'
            var offset = matchstr(input, '-\d\+')->str2nr()
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
    var bufnr = bufnr('%')
    # let's save the winid of the window we want to move
    var closedwinid = win_getid()
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
    var curwinid = win_getid()
    win_gotoid(closedwinid)
    close
    win_gotoid(curwinid)
enddef

fu myfuncs#send_to_server() abort "{{{1
    sil undo | let contains_ansi = search("\e", 'n') | sil redo
    let bufname = expand('%:p')
    if bufname == '' || bufname =~# '^\C/proc/'
        let file = tempname()
        call getline(1, '$')->writefile(file)
        " if the buffer contained ansi escape codes, we want them to be sent to the Vim server
        if contains_ansi
            sil undo
            call getline(1, '$')->writefile(file)
            sil redo
        else
            call getline(1, '$')->writefile(file)
        endif
    else
        let file = bufname
    endif

    let cmd = 'vim --remote-tab ' .. shellescape(file)
    sil call system(cmd)

    if v:shell_error
        echohl ErrorMsg
        echom printf('the command "%s" failed', cmd)
        echohl NONE
        return
    endif

    " highlight ansi codes; useful for when you run sth like `$ trans word | vipe`
    if contains_ansi && ($_ =~# '\C/vipe$' || bufname == '')
        let cmd = 'vim --remote-expr "execute(''runtime macros/ansi.vim'')"'
        sil call system(cmd)
    endif

    let msg = printf('the %s was sent to the Vim server',
        \ bufname == '' ? 'buffer' : 'file')
    echohl ModeMsg
    echom msg
    echohl NONE
endfu

" trans {{{1

" Update:
" Have a look at this plugin:
" https://github.com/echuraev/translate-shell.vim

" TODO: add `| C-t` mapping, to replay last text
" TODO: Implement a mapping which would translate the word under the cursor in a split.
" Apply text properties to get bold/italics attributes.
" Apply folding to be able to read only one section (`noun`, `verb`, `Synonyms`, `Examples`).

"                ┌ the function is called for the 1st time;
"                │ if the text is too long for `trans(1)`, it will be
"                │ split into chunks, and the function will be called
"                │ several times
"                │
fu myfuncs#trans(first_time = v:true) abort
    let s:trans_tempfile = tempname()

    if a:first_time
        let text = mode() =~ "^[vV\<c-v>]$" ? s:trans_grab_visual() : expand('<cword>')
        if text == ''
            return
        endif
        let s:trans_chunks = split(text, '.\{100}\zs[.?!]')
        "                                    │
        "                                    └ split the text into chunks of around 100 characters
    endif

    " remove characters which cause issue during the translation
    let garbage = '["`*]' .. (!empty(&l:cms) ? '\|' .. matchstr(&l:cms, '\S*\ze\s*%s') : '')
    let chunk = substitute(s:trans_chunks[0], garbage, '', 'g')

    " reduce excessive whitespace
    let chunk = substitute(chunk, '\s\+', ' ', 'g')

    " `exit_io` invokes a callback when the jobs finishes
    " if you want to invoke a callback every time the job sends a message, use
    " `out_cb` instead
    "
    " don't use `close_cb` to read the file where the job writes its output,
    " because when the callback will read the file, the latter will be empty,
    " probably because the job writes in a buffer, and the buffer is written
    " to the file after the callback has been invoked
    " use `exit_cb` instead
    let opts = #{
        \ out_io: 'file',
        \ out_name: s:trans_tempfile,
        \ err_io: 'null',
        \ exit_cb: function('s:trans_output'),
        \ }

    " send the first chunk in the list of chunks to `trans`
    "
    " We execute the command in a shell, otherwise the text seems to be split
    " at each whitespace before being sent to `trans`.
    " This makes the translation wrong (because no global context), and the
    " voice pauses after each word.
    " Besides,  it's a  good habit  to invoke  a shell  so that  our command  is
    " properly parsed by the latter.  Otherwise, I don't know how Vim parses it.
    let s:trans_job = job_start([
        \ '/bin/bash',
        \ '-c',
        \
        \ 'trans -brief -speak'
        \ .. ' -t ' .. get(s:, 'trans_target', 'fr')
        \ .. ' -s ' .. get(s:, 'trans_source', 'en')
        \ .. ' ' .. shellescape(chunk)]
        \ , opts)

    " remove it from the list of chunks
    call remove(s:trans_chunks, 0)
endfu

fu myfuncs#trans_cycle() abort
    let s:trans_target = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_target', 'fr')]
    let s:trans_source = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_source', 'en')]
    echo '[trans] ' .. s:trans_source .. ' → ' .. s:trans_target
endfu

fu s:trans_grab_visual() abort
    let [lnum1, lnum2] = [line("'<"), line("'>")]
    let [c1, c2] = [col("'<"), col("'>)")]

    " single line visual selection
    if lnum1 == lnum2
        let text = getline(lnum1)->matchstr('\%' .. c1 .. 'c.*\%' .. c2 .. 'c.\=\ze.*$')
    else
        " multi lines
        let first = getline(lnum1)->matchstr('\%' .. c1 .. 'c.*$')
        let last = ' ' .. getline(lnum2)->matchstr('^.\{-}\%' .. c2 .. 'c.\=')
        let middle = (lnum2 - lnum1) > 1 ? ' ' .. getline(lnum1 + 1, lnum2 - 1)->join(' ') : ''

        let text = first .. middle .. last
    endif
    return text
endfu

fu s:trans_output(job, exit_status) abort
    if a:exit_status == -1
        return
    endif
    " FIXME:
    " if the text is composed of several chunks, only the last one is echoed
    "
    " instead of `echo`, maybe we should open a scratch buffer to display a long
    " translation
    "
    " we would need to introduce some newlines to format the output
    "
    " also, increase the length of the chunks (150?), so that the voice pauses
    " less often?
    " why not, but then the message won't be echoed properly
    " so we need to distinguish between 3 types of lengths:
    "
    "     short :  < 100 characters  →  one invocation, echo
    "     medium:  < 150 "           →  one invocation, scratch buffer
    "     long  :  > 200 "           →  several invocations, scratch buffer

    echo readfile(s:trans_tempfile)->join(' ')
    if len(s:trans_chunks)
        call myfuncs#trans(v:false)
    endif
endfu

fu myfuncs#trans_stop() abort
    if exists('s:trans_job')
        call job_stop(s:trans_job)
    endif
endfu

fu myfuncs#webpage_read(url) abort "{{{1
    if !executable('w3m')
        echo 'w3m is not installed'
        return
    endif
    let tempfile = tempname() .. '/webpage'
    exe 'tabe ' .. tempfile
    " Alternative shell command:{{{
    "
    "     $ lynx -dump -width=1000 url
    "                         │
    "                         └ high nr to be sure that
    "                           `lynx` won't break long lines of code
    "}}}
    sil exe 'r !w3m -cols 100 ' .. shellescape(a:url, 1)
    setl bt=nofile nobl noswf nowrap
endfu

def myfuncs#word_frequency(line1: number, line2: number, qargs: string) #{{{1
    var flags = {
        min_length: matchstr(qargs, '-min_length\s\+\zs\d\+'),
        weighted: stridx(qargs, '-weighted') != -1,
        }

    var words = getline(line1, line2)
        ->join("\n")
        ->split('\%(\%(\k\@!\|\d\).\)\+')

    var min_length = !empty(flags.min_length) ? flags.min_length : 4

    # open vertical viewport to display future results
    var tempfile = tempname() .. '/WordFrequency'
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
    filter(words, {_, v -> strchars(v, 1) >= min_length && strchars(v, 1) <= 30 && v =~ '\a'})

    # put all of them in lowercase
    map(words, {_, v -> tolower(v)})

    var freq: dict<number> = {}
    for word in words
        freq[word] = get(freq, word, 0) + 1
    endfor

    # In addition to the frequency, take the length of words into consideration when sorting them.{{{
    #
    # This is especially useful  if we want to know for which  words it would be
    # the most useful to create abbreviations.
    #}}}
    if flags.weighted
        var weighted_freq: dict<number> = deepcopy(freq)
        # `v` is the frequence of a word.
        # We multiply  it by  a number which  should be equal  to the  amount of
        # characters which we would save if  we created an abbreviation for that
        # word.
        map(weighted_freq, {k, v -> v * ( strchars(k, 1) -
            # if a word is 4 characters long, then its abbreviation will probably be 2 characters long
            strchars(k, 1) == 4
            ? 2
              # if a word ends with an 's', and the same word without the ending
              # 's'  is also  present,  then its  abbreviation  will probably  4
              # characters long (because it's probably a plural)
              : k[-1:-1] == 's' && keys(freq)->index(k) >= 0
              ?     4
              # otherwise, by default, an abbreviation will probably be 3 characters long
              :     3
            )})
        for item in items(weighted_freq)->sort({a, b -> b[1] - a[1]})
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

    exe 'vert res ' .. (range(1, line('$'))->map({_, v -> virtcol([v, '$'])})->max() + 4)
    nno <buffer><expr><nowait><silent> q reg_recording() != '' ? 'q' : ':<c-u>q<cr>'
    wincmd p
enddef

def myfuncs#wf_complete(_a: any, _l: any, _p: any): string
    return ['-min_length', '-weighted']->join("\n")
enddef

fu myfuncs#zshoptions() abort "{{{1
    " this function is invoked from the zsh alias `options` (defined in our zshrc)

    call append(0, '# options whose value has been reset')
    wincmd l
    call append(0, '# options which have kept their default value')

    " reverse the state of the options in the right window
    " Why? {{{
    "
    " Because the meaning of the output of `unsetopt` is:
    "
    "     the values of these options is NOT ...
    "
    " This 'NOT' reverses the reading:
    "
    "     NOT nooption = NOT disabled = enabled
    "     NOT option   = NOT enabled  = disabled
    " }}}
    "   Is there an alternative?{{{
    "
    " Yes:  `set -o`.
    "}}}
    "     Why don't you use it?{{{
    "
    " It  doesn't tell  you whether  the  default values  of the  options have  been
    " changed.
    "}}}
    sil keepj keepp 1;/^[^ \#]/,$s/^../\=submatch(0) is# 'no' ? '' : 'no' .. submatch(0)/e
    1
endfu

