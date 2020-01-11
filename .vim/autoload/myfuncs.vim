" Operators {{{1
fu myfuncs#op_grep(type, ...) abort "{{{2
    let cb_save  = &cb
    let sel_save = &selection
    let reg_save = ['"', getreg('"'), getregtype('"')]

    try
        set cb-=unnamed cb-=unnamedplus
        set selection=inclusive

        if a:type is# 'char'
            norm! `[v`]y
        elseif a:type is# 'line'
            norm! '[V']y
        elseif a:type is# 'block'
            sil exe "norm! `[\<c-v>`]y"
        elseif a:type is# 'vis'
            norm! gvy
        endif

        let cmd = 'rg 2>/dev/null -FLS --vimgrep '..shellescape((a:0 ? a:1 : @"))
        let use_loclist = a:0 ? a:2 : 0
        if a:type is# 'Ex' && use_loclist
            sil let items = getloclist(0, {'lines': systemlist(cmd), 'efm': '%f:%l:%c:%m'}).items
            call setloclist(0, [], ' ', {'items': items, 'title': cmd})
            do <nomodeline> QuickFixCmdPost lwindow
        else
            sil let items = getqflist({'lines': systemlist(cmd), 'efm': '%f:%l:%c:%m'}).items
            call setqflist([], ' ', {'items': items, 'title': cmd})
            do <nomodeline> QuickFixCmdPost cwindow
        endif

    catch
        return lg#catch_error()
    finally
        let &cb  = cb_save
        let &sel = sel_save
        call call('setreg', reg_save)
    endtry
endfu

" op_replace_without_yank {{{2

" This function is called directly from our `dr` and `drr` mappings.
fu myfuncs#set_reg(reg_name) abort
    " We save the name of the register which was called just before `dr` inside
    " a script-local variable, for the dot command to know which register we
    " used the first time.
    "
    " By default, it will be `"`.
    " Or `+` if we have prepended the value 'unnamedplus' in the 'clipboard'
    " option's value.

    let s:replace_reg_name = a:reg_name
endfu

fu myfuncs#op_replace_without_yank(type) abort
    let cb_save  = &cb
    let sel_save = &selection
    try
        set selection=inclusive

        " save registers and types to restore later.
        " FIXME:
        " We save and restore the register which can be prefixed before the `dr` operator.
        " Is it necessary?
        " If so, have we done the same for the other operators which can be prefixed
        " by a register?
        call lg#reg#save(['"', s:replace_reg_name])

        " Why do you save the visual marks?{{{
        "
        " Suppose you select some lines.
        " Then you search some word inside (`/\%Vword`).
        " You replace it (`ciwreplacement`).
        " You press `n` to go to the next occurrence of the word, and repeat the
        " edit.
        " It won't work, because the visual selection has been altered.
        "}}}
        let visual_marks_save = [getpos("'<"), getpos("'>")]

        " TODO:
        " Should  we use  `getreg(..., 1)`  to properly  restore the  expression
        " register.
        let replace_reg_contents = getreg(s:replace_reg_name)
        let replace_reg_type     = getregtype(s:replace_reg_name)

        " build condition to check if we're replacing the current line

        let replace_current_line =     line("'[") == line("']")
        \                          &&  col("'[") == 1
        \                          && (col("']") == col('$')-1 || col('$') == 1)

        " If we copy a line containing leading whitespace, and try to replace
        " another line like this: `0dr$`
        " The leading whitespace (indentation) will be removed.
        " Why?
        "
        " Because the text on which we operate doesn't include the ending newline.
        " So, `g@` will pass the type `char`.
        " So, our function will trim the leading / ending whitespace.
        " We don't want that for a single line.
        " For multiple lines, yes. A single one, no.
        " We use the `replace_current_line` condition to be informed when this
        " case happens. We treat it as linewise motion/text-object, to keep the
        " indentation.

        if a:type is# 'line' || replace_current_line
            exe 'keepj norm! ''[V'']"'.s:replace_reg_name.'p'
            norm! gv=

        elseif a:type is# 'block'
            exe "keepj norm! `[\<c-v>`]\"".s:replace_reg_name.'p'

        elseif a:type is# 'char'
            " If  pasting linewise  contents in  a *characterwise*  motion, trim
            " surrounding whitespace from the content to be pasted.
            "
            " *Not* the trailing whitespace on each line.
            " *Just* the  leading whitespace of  the first line, and  the ending
            " whitespace of the last.
            if replace_reg_type is# 'V'
                call setreg(s:replace_reg_name, s:trimws_ml(replace_reg_contents), 'v')
            endif

            exe 'keepj norm! `[v`]"'.s:replace_reg_name.'p'
        endif

    catch
        return lg#catch_error()
    finally
        let &cb  = cb_save
        let &sel = sel_save
        call lg#reg#restore(['"', s:replace_reg_name])
        call setpos("'<", visual_marks_save[0])
        call setpos("'>", visual_marks_save[1])
    endtry
endfu

" TRIM WhiteSpace Multi-Line
fu s:trimws_ml(s) abort
    return substitute(a:s, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfu

" op_toggle_alignment {{{2

fu s:is_right_aligned(line1, line2) abort
    let first_non_empty_line = search('\S', 'cnW', a:line2)
    let length = strlen(getline(first_non_empty_line))
    for line in getline(a:line1, a:line2)
        if strlen(line) != length && line !~# '^\s*$'
            return 0
        endif
    endfor
    return 1
endfu

fu myfuncs#op_toggle_alignment(type) abort
    if a:type is# 'vis'
        let [mark1, mark2] = ["'<", "'>"]
    else
        let [mark1, mark2] = ["'[", "']"]
    endif
    if s:is_right_aligned(line(mark1), line(mark2))
        exe mark1..','..mark2..'left'
        exe 'norm! '..mark1..'='..mark2
    else
        exe mark1..','..mark2..'right'
    endif
endfu
fu myfuncs#op_trim_ws(type) abort "{{{2
    if &l:binary || &ft is# 'diff'
        return
    endif
    if a:type is# 'vis'
        let range = line("'<")..','..line("'>")
    else
        let range = line("'[")..','..line("']")
    endif
    exe range..'TW'
endfu

" op_yank_matches {{{2

" `s:yank_where_match` is a boolean flag:
"
"     1 → yank the lines where a match is found
"     0 → yank the other lines
"
" `s:yank_comments` is another boolean flag:
"
"     1 → the pattern describes commented lines
"     0 → the pattern is simply @/

fu myfuncs#op_yank_matches_set_action(yank_where_match, yank_comments) abort
    let s:yank_matches_view = winsaveview()
    let s:yank_where_match = a:yank_where_match
    let s:yank_comments    = a:yank_comments
endfu

fu myfuncs#op_yank_matches(type) abort
    let reg_save = ['z', getreg('z'), getregtype('z')]
    try
        let @z = ''

        let mods  = 'keepj keepp'
        let range = (a:type is# 'char' || a:type is# 'line')
                \ ?     line("'[").','.line("']")
                \ :     line("'<").','.line("'>")

        let cmd = s:yank_where_match ? 'g' : 'v'
        let pat = s:yank_comments
              \ ?     '^\s*\C\V'..escape(matchstr(&l:cms, '\S*\ze\s*%s'), '\')
              \ :     @/

        exe mods..' '..range..cmd..'/'..pat..'/y Z'

        " Remove empty lines.
        " We can't use the pattern `\_^\s*\n` to describe an empty line, because
        " we aren't in a buffer:    `@z` is just a big string
        if !s:yank_where_match
            let @z = substitute(@z, '\n\%(\s*\n\)\+', '\n', 'g')
        endif

        " the first time we've appended a match to `@z`, it created a newline
        " we don't want this one; remove it
        let @z = substitute(@z, "^\n", '', '')

        call setreg('"', @z, 'l')
        if exists('s:yank_matches_view')
            call winrestview(s:yank_matches_view)
            unlet! s:yank_matches_view
        endif

    catch
        return lg#catch_error()

    finally
        call call('setreg', reg_save)
    endtry
endfu
" }}}1

fu myfuncs#align_with_beginning(type) abort "{{{1
    exe 'left '..indent(line('.')+s:align_with_beginning_dir)
endfu

fu myfuncs#align_with_end(type) abort
    " length of text to align on the current line
    let text_length = strchars(matchstr(getline('.'), '\S.*$'))
    " length of the previous/next line
    let neighbour_length = strchars(getline(line('.') + s:align_with_end_dir))
    exe 'left '..(neighbour_length - text_length)
endfu

fu myfuncs#align_with_beginning_save_dir(dir) abort
    let s:align_with_beginning_dir = a:dir
endfu

fu myfuncs#align_with_end_save_dir(dir) abort
    let s:align_with_end_dir = a:dir
endfu

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
fu myfuncs#box_create(_) abort
    try
        " draw `|` on the left of the paragraph
        exe "norm! _vip\<c-v>^I|"
        " draw `|` on the right of the paragraph
        norm! gv$A|

        " align all (*) the pipe characters (`|`) inside the current paragraph
        let range = line("'[").','.line("']")
        sil exe range..'EasyAlign *|'

        " If we wanted to center the text inside each cell, we would have to add
        " hit `CR CR` after `gaip`:
        "
        "     sil exe "norm gaip\<cr>\<cr>*|"

        " Capture all the column positions in the current line matching a `|`
        " character:
        let col_pos = []
        let i = 0
        for char in split(getline('.'), '\zs')
            let i += 1
            if char is# '|'
                let col_pos += [i]
            endif
        endfor

        if empty(col_pos)
            return
        endif

        " Draw the upper border of the box '┌────┐':
        call s:box_create_border('top', col_pos)

        " Draw the lower border of the box '└────┘':
        call s:box_create_border('bottom', col_pos)

        " Replace the remaining `|` with `│`:
        let first_line = line("'{") + 2
        let last_line  = line("'}") - 2
        for i in range(first_line, last_line)
            for j in col_pos
                exe 'norm! '..i..'G'..j..'|r│'
            endfor
        endfor

        call s:box_create_separations()
    catch
        return lg#catch_error()
    endtry
endfu

fu s:box_create_border(where, col_pos) abort
    let col_pos = a:col_pos

    if a:where is# 'top'
        " duplicate first line in the box
        norm! '{+yyP
        " replace all characters with `─`
        norm! v$r─
        " draw corners
        exe 'norm! '..col_pos[0]..'|r┌'..col_pos[-1]..'|r┐'
    else
        " duplicate the `┌────┐` border below the box
        t'}-
        " draw corners
        exe 'norm! '..col_pos[0]..'|r└'..col_pos[-1]..'|r┘'
    endif

    " draw the '┬' or '┴' characters:
    for pos in col_pos[1:-2]
        exe 'norm! '..pos..'|r'..(a:where is# 'top' ? '┬' : '┴')
    endfor
endfu

fu s:box_create_separations() abort
    " Create a separation line, such as:
    "
    "     |    |    |    |
    "
    " ... useful to make our table more readable.
    norm! '{++yyp
    sil keepj keepp s/[^│┼]/ /ge

    " Delete it in the `s` (s for space) register, so that it's stored inside
    " default register and we can paste it wherever we want.
    d s

    " Create a separation line, such as:
    "
    "     ├────┼────┼────┤
    "
    " ... and store it inside `x` register.
    " So that we can paste it wherever we want.
    let @x = getline(line("'{")+1)
    let @x = substitute(@x, '\S', '├', '')
    let @x = substitute(@x, '.*\zs\S', '┤', '')
    let @x = substitute(@x, '┬', '┼', 'g')

    " Make the contents of the register linewise, so we don't need to hit
    " `"x]p`, but simply `"xp`.
    call setreg('x', @x, 'V')
endfu

fu myfuncs#box_destroy(type) abort
    let [lnum1, lnum2] = [line("'{"), line("'}")]
    let range = lnum1..','..lnum2
    " remove box (except pretty bars: │)
    sil exe range..'s/[─┴┬├┤┼└┘┐┌]//ge'

    " replace pretty bars with regular bars
    " necessary, because we will need them to align the contents of the
    " paragraph later
    sil exe range..'s/│/|/ge'

    " remove the bars at the beginning and at the end of the lines
    " we don't want them, because they would mess up the creation of a box
    " later
    sil exe range..'s/|//e'
    sil exe range..'s/.*\zs|//e'

    " trim whitespace
    sil exe range..'TW'
    " remove empty lines
    sil exe range..'-g/^\s*$/d_'

    call append(lnum1-1, [''])

    " position the cursor on the upper left corner of the paragraph
    exe 'norm! '..lnum1..'Gj_'
endfu

fu myfuncs#diff_lines(bang, lnum1, lnum2, option) abort "{{{1
    if a:option is# '-h' || a:option is# '--help'
        let usage =<< trim END
            :DiffLines allows you to see and cycle through the differences between 2 lines

            usage:
                :5,10DiffLines    diff between lines 5 and 10
                :DiffLines        diff between current line and next one
                :DiffLines!       clear the match

            The differences are in the location list (press [l, ]l, [L, ]L to visit them)
        END
        echo join(usage, "\n")
        return
    endif

    if exists('w:xl_match')
        call matchdelete(w:xl_match)
        unlet w:xl_match
    endif

    if a:bang | return | endif

    " If `a:lnum1 == a:lnum2`, it means `:XorLines` was called without a range.
    if a:lnum1 == a:lnum2
        let [lnum1, lnum2] = [line('.'), line('.')+1]
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

            " FIXME: for some reason, we need to write a dot at the end of each
            " branch of the pattern, so we add 'v.' at the end instead of just 'v'.
            " The problem seems to come from :lvim and the g flag.
            "
            " MWE:
            " This adds 2 duplicate entries in the location list instead of one:
            "
            "     :lvim /\%1l\%2v/g %
            "
            " This adds 2 duplicate entries in the location list, 3 in total instead of two:
            "
            "     :lvim /\%1l\%2v\|\%1l\%3v/g %
            "
            " This adds 2 couple of duplicate entries in the location list, 4 in total instead of two.
            "
            "     :lvim /\%1l\%2v\|\%1l\%4v/g %
            "
            " It seems each time a `%{digit}v` anchor matches the beginning of a group
            " of consecutive characters, it adds 2 duplicate entries instead of one.

            let pat ..= (empty(pat) ? '' : '\|')..'\%'..lnum1..'l'..'\%'..(i+1)..'v.'
            let pat ..= (empty(pat) ? '' : '\|')..'\%'..lnum2..'l'..'\%'..(i+1)..'v.'
        endif
    endfor

    " If one of the lines is longer than the other, we have to add its end in the pattern.
    if len(chars1) > len(chars2)

        " Suppose that the shortest line has 50 characters:
        " it's better to write `\%>50v.` than `\%50v.*`.
        "
        " `\%>50v.` = any character after the 50th character:
        " This will add one entry in the loclist for *every* character.
        "
        " `\%50v.*` = the *whole* set of characters after the 50th:
        " This will add only *one* entry in the loclist.

        let pat ..= (!empty(pat) ? '\|' : '')..'\%'..lnum1..'l'..'\%>'..len(chars2)..'v.'

    elseif len(chars1) < len(chars2)
        let pat ..= (!empty(pat) ? '\|' : '')..'\%'..lnum2..'l'..'\%>'..len(chars1)..'v.'
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
        sil noa exe 'lvim /'..pat..'/g %'
        let w:xl_match = matchadd('SpellBad', pat, -1)
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
        let url = trim(a:url, '/')..'.wiki'
        let tempdir = substitute(tempname(), '.*/\zs.\{-}', '', '')
        sil call system('git clone '..shellescape(url)..' '..tempdir)
        let files = glob(tempdir..'/*', 0, 1)
        call map(files, {_,v -> substitute(v, '^\C\V'..tempdir..'/', '', '')})
        call filter(files, {_,v -> v !~# '\c_\=footer\%(\.md\)\=$'})

        mark x
        call append('.', files+[''])
        exe 'norm! '..(len(files)+1)..'j'
        mark y

        sil keepj keepp 'x+,'y-s/^/# /
        sil keepj keepp 'x+,'y-g/^./exe 'keepalt r '..tempdir..'/'..getline('.')[2:]
        sil keepj keepp 'x+,'y-g/^=\+\s*$/d_ | -s/^/## /
        sil keepj keepp 'x+,'y-g/^-\+\s*$/d_ | -s/^/### /
        sil keepj keepp 'x+,'y-s/^#.\{-}\n\zs\s*\n\ze##//

        sil keepj keepp 'x+,'y-g/^#\%(#\)\@!/call append(line('.')-1, '#')
        sil update

    catch
        return lg#catch_error()

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
    let s:LAUNCH_TERM  = 'urxvt -cd'
endfu

fu s:gtfo_error(s) abort
    echohl ErrorMsg | echom '[GTFO] '..a:s | echohl None
endfu

fu myfuncs#gtfo_open_gui(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif
    sil call system('xdg-open '..shellescape(a:dir)..' &')
endfu

fu s:gtfo_is_not_valid(dir) abort
    if !isdirectory(a:dir) "this happens if a directory was deleted outside of vim.
        call s:gtfo_error('invalid/missing directory: '..a:dir)
        return 1
    endif
endfu

fu myfuncs#gtfo_open_term(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif
    if s:IS_TMUX
        sil call system('tmux splitw -h -c '..shellescape(a:dir))
    elseif s:IS_X_RUNNING
        sil call system(s:LAUNCH_TERM..' '..shellescape(a:dir)..' &')
        redraw!
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
    if len(getbufline(fileA, 1, '$')) < len(getbufline(fileB, 1, '$'))
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
    sil let output = systemlist('diff -U $(wc -l < '..fileA..') '..fileA..' '..fileB.." | grep '^-' | sed 's/^-//g'")

    call map(output, {_,v -> {'text': v}})
    call setloclist(0, [], ' ', {'items': output, 'title': 'in  '..fileA..'  but not in  '..fileB})

    do <nomodeline> QuickFixCmdPost lopen
    call qf#set_matches('myfuncs#in_A_not_in_B', 'Conceal', 'double_bar')
    call qf#create_matches()
endfu

fu myfuncs#join_blocks(first_reverse) abort "{{{1
    let [line1, line2] = [line("'<"), line("'>")]

    if (line2 - line1 + 1) % 2 == 1
        echohl ErrorMsg
        echo ' Total number of lines must be even'
        echohl None
        return ''
    endif

    let end_first_block    = line1 + (line2 - line1 + 1)/2 - 1
    let range_first_block  = line1..','..end_first_block
    let range_second_block = (end_first_block + 1)..','..line2
    let mods               = 'keepj keepp '

    let [fen_save, winid, bufnr] = [&l:fen, win_getid(), bufnr('%')]
    let &l:fen = 0
    try
        if a:first_reverse
            sil exe range_first_block..'d'
            sil exe end_first_block..'put'
        endif

        sil exe mods..range_second_block.."s/^/\x01/e"
        sil exe mods..range_first_block..'g/^/'..(end_first_block + 1)..'m.|-j'

        sil *!column -s $'\x01' -t

    catch
        return lg#catch_error()
    finally
        if winbufnr(winid) == bufnr
            let [tabnr, winnr] = win_id2tabwin(winid)
            call settabwinvar(tabnr, winnr, '&fen', fen_save)
        endif
    endtry
endfu

fu myfuncs#long_data_join(type, ...) abort "{{{1
    " This function should do the following conversion:{{{
    "
    "     let list = [1,
    "     \ 2,
    "     \ 3,
    "     \ 4]
    " →
    "     let list = [1, 2, 3, 4]
    "}}}
    try
        if a:type is# 'char' || a:type is# 'line' || a:type is# 'block'
            let range = line("'[")..','..line("']")
        elseif a:type is# 'vis'
            let range = line("'<")..','..line("'>")
        else
            return
        endif

        let bullets = '[-*+]'
        let join_bulleted_list = getline('.') =~# '^\s*'..bullets

        if join_bulleted_list
            sil exe 'keepj keepp'..range..'s/^\s*\zs'..bullets..'\s*//'
            sil exe 'keepj keepp'..range..'-s/$/,/'
            sil exe range..'j'
        else
            sil exe 'keepj keepp '..range..'s/\n\s*\\//ge'
            call cursor(a:type is# 'vis' ? line("'<") : line("'["), 1)
            sil keepj keepp s/\m\zs\s*,\ze\s\=[\]}]//e
        endif
    catch
        return lg#catch_error()
    endtry
endfu

fu myfuncs#long_data_split(_) abort "{{{1
    let line = getline('.')

    let is_list_or_dict = match(line, '\m\[.*\]\|{.*}') > -1
    let has_comma = stridx(line, ',') > -1
    if is_list_or_dict
        let first_line_indent = repeat(' ', match(line, '\S'))
        " If the  first item in the  list/dictionary begins right after  the opening
        " symbol (`[` or `{`), add a space:
        sil keepj keepp s/\m[\[{]\s\@!\zs/ /e
        " Move the first item in the list on a dedicated line.
        sil keepj keepp s/\m[\[{]\zs/\="\n"..first_line_indent.."    \\"/e
        " split the data
        sil keepj keepp s/,\zs/\="\n"..first_line_indent..'    \'/ge
        " move the closing symbol on a dedicated line
        sil keepj keepp s/\m\zs\s\=\ze[\]}]/\=",\n"..first_line_indent.."    \\ "/e

    elseif has_comma
        " We use `strdisplaywidth()` because the indentation could contain tabs.
        let indent_lvl = strdisplaywidth(matchstr(line, '.\{-}\ze\S'))
        let indent_txt = repeat(' ', indent_lvl)
        sil keepj keepp s/\m\ze\S/- /e
        let pat = '\m\s*,\s*\%(et\|and\s\+\)\=\|\s*\<\%(et\|and\)\>\s*'
        let l:Rep = {-> "\n"..indent_txt..'- '}
        sil exe 'keepj keepp s/'..pat..'/\=l:Rep()/ge'
    endif
endfu

fu myfuncs#only_selection(lnum1,lnum2) abort "{{{1
    let lines = getline(a:lnum1,a:lnum2)
    keepj sil %d_
    call setline(1, lines)
endfu

fu myfuncs#plugin_install(url) abort "{{{1
    let pat = 'https\=://github.com/\(.\{-}\)/\(.*\)/\='
    if a:url !~# pat
        echo 'invalid url'
        return
    endif
    let rep = 'Plug ''\1/\2'''
    let plug_line  = substitute(a:url, pat, rep, '')
    let to_install = matchstr(plug_line, 'Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze''')

    let win_orig = win_getid()
    vnew | e ~/.vim/vimrc
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
        let plugin_on_current_line = matchstr(getline('.'), 'Plug ''.\{-}/\%(vim-\)\=\zs.\{-}\ze/\=''')
    endwhile

    call append(line('.')-1, plug_line)
    update
    " Why?{{{
    "
    " Saving  `vimrc`, and  triggering  its  resourcing, is  not  enough to  let
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

    " Before going back to the `vim-plug` window, we go back to the original
    " one. This way, once we are in `vim-plug`, the previous window will be
    " the original one, and we can go back there with `C-w w`.

    call win_gotoid(win_orig)
    call win_gotoid(win_plug)
    if has('nvim')
        UpdateRemotePlugins
    endif
endfu

fu myfuncs#plugin_global_variables(keyword) abort "{{{1
    if a:keyword is# ''
        let usage =<< trim END
        usage:

            :PluginGlobalVariables ulti
            display all global variables containing the keyword `ulti`
        END
        echo join(usage, "\n")
        return
    endif
    let variables = items(filter(deepcopy(g:),
        \ {k -> k =~# '\C\V'..escape(a:keyword, '\') && k !~# '\%(loaded\|did_plugin_\)'}))
    call map(variables, {_,v -> v[0]..' = '..string(v[1])})
    new
    setl bt=nofile nobl noswf nowrap
    call setline(1, variables)
endfu

fu myfuncs#remove_tabs(line1, line2) abort "{{{1
    let view = winsaveview()
    let mods = 'sil keepj keepp'
    let range = a:line1..','..a:line2
    " Why not simply `\t`?{{{
    "
    " We need  the cursor to be  positioned on the screen  position *before* the
    " tab,  because  that's  what  `strdisplaywidth()`  expects  as  its  second
    " argument.
    "
    " ---
    "
    " Couldn't you use the pattern `\t`, and `virtcol('.')-1`?
    "
    " No, because `virtcol()` returns the *last* screen position occupied by the
    " tab character;  for `virtcol('.')-1`  to work, we  would need  the *first*
    " screen position.
    "}}}
    " If you want to preserve a tab used to indent a line, use this pattern instead:
    "     let pat = '\%(^\s*\)\@!\&\(.\)\t'
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
    let l:Rep = {->
    \ match(map(synstack(line('.'), col('.')), {_,v -> synIDattr(v, 'name')}), 'heredoc') != -1
    \ ? submatch(0)
    \ : submatch(1)..repeat(' ', strdisplaywidth("\t", col('.') == 1 ? 0 : virtcol('.')))}
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
    for i in [1,2]
        exe mods..' '..range..'s/'..pat..'/\=l:Rep()/ge'
    endfor
    call winrestview(view)
endfu

fu myfuncs#search_todo(where) abort "{{{1
    try
        sil noa exe 'lvim /\CFIX'..'ME\|TO'..'DO/j '..(a:where is# 'buffer' ? '%' : './**/*')
    catch /^Vim\%((\a\+)\)\?:E480:/
        echom 'no TO'..'DO or FIX'..'ME'
        return
    catch
        return lg#catch_error()
    endtry

    " Because we've prefixed `:lvim` with `:noa`, our autocmd which opens a qf window
    " hasn't kicked in. We must manually open it.
    do <nomodeline> QuickFixCmdPost lwindow
    if &bt isnot# 'quickfix' | return | endif

    "                                        ┌ Tweak the text of each entry when there's a line
    "                                        │ with just `todo` or `fixme`;
    "                                        │ replace it with the text of the next non empty line instead
    "                                        │
    let items = map(getloclist(0), {_,v -> s:search_todo_text(v)})
    call setloclist(0, [], 'r', {'items': items, 'title': 'FIX'..'ME & TO'..'DO'})

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
    if dict.text =~# '\c\%(fixme\|todo\):\=\s*\%('..split(&l:fmr, ',')[0]..'\)\=\s*$'
        let bufnr = dict.bufnr
        " get the text of the next line, which is not empty (contains at least one keyword character)
        " Why using `readfile()` instead of `getbufline()`?{{{
        "
        " `getbufline()` works only if the buffer is listed.
        " If the buffer is NOT listed, it returns an empty list.
        " There's no guarantee that all buffers in which a fixme/todo is present
        " is currently listed.
        "}}}
        let lines = readfile(bufname(bufnr), 0, dict.lnum + 4)[-4:]
        let dict.text = get(filter(lines, {_,v -> v =~ '\k'}), 0, '')
    endif
    return dict
endfu

fu myfuncs#tab_toc() abort "{{{1
    if index(['help', 'man', 'markdown'], &ft) == -1
        return
    endif

    let patterns = {
        \ 'man'     : '\S\zs',
        \ 'markdown': '^\%(#\+\)\=\S.\zs',
        \ 'help'    : '\S\ze\*$\|^\s*\*\zs\S',
        \ }

    let syntaxes = {
        \ 'man'     : 'heading\|title',
        \ 'markdown': 'markdownH\d\+',
        \ 'help'    : 'helpHyperTextEntry\|helpStar',
        \ }

    let toc = []
    for lnum in range(1, line('$'))
        let col = match(getline(lnum), patterns[&ft])
        if col != -1 && synIDattr(synID(lnum, col, 1), 'name') =~? syntaxes[&ft]
            let text = substitute(getline(lnum), '\s\+', ' ', 'g')
            call add(toc, {'bufnr': bufnr('%'), 'lnum': lnum, 'text': text})
        endif
   endfor

    call setloclist(0, [], ' ', {'items': toc, 'title': 'TOC'})

    let is_help_file = &bt is# 'help'

    " The width of the current window is going to be reduced by the TOC window.
    " Long lines may be wrapped. I don't like wrapped lines.
    setl nowrap

    do <nomodeline> QuickFixCmdPost lwindow
    if &bt isnot# 'quickfix' | return | endif

    if is_help_file
        call qf#set_matches('myfuncs:tab_toc', 'Conceal', '\*')
        call qf#create_matches()
    endif
endfu

" trans {{{1

" Update:
" Have a look at this plugin:
" https://github.com/echuraev/translate-shell.vim

" TODO: add `| C-t` mapping, to replay last text

"                ┌ the function is called for the 1st time;
"                │ if the text is too long for `trans`, it will be
"                │ split into chunks, and the function will be called
"                │ several times
"                │
fu myfuncs#trans(first_time, ...) abort
    let s:trans_tempfile = tempname()

    if a:first_time
        let text = a:0 ? s:trans_grab_visual() : expand('<cword>')
        "          │
        "          └ visual mode

        let s:trans_chunks = split(text, '.\{100}\zs[.?!]')
        "                                    │
        "                                    └ split the text into chunks of around 100 characters
    endif

    " remove characters which cause issue during the translation
    let garbage = '["`*]'..(!empty(&l:cms) ? '\|'..matchstr(&l:cms, '\S*\ze\s*%s') : '')
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
    let opts = {
               \ 'out_io':    'file',
               \ 'out_name':  s:trans_tempfile,
               \ 'err_io':    'null',
               \ 'exit_cb':   function('s:trans_output'),
               \ }

    " send the first chunk in the list of chunks to `trans`
    "
    " We execute the command in a shell, otherwise the text seems to be split
    " at each whitespace before being sent to `trans`.
    " This makes the translation wrong (because no global context), and the
    " voice pauses after each word.
    " Besides, it's a good habit to invoke a shell so that our command is
    " properly parsed by the latter. Otherwise, I don't know how Vim parses
    " it.
    let s:trans_job = job_start([
        \ '/bin/bash',
        \ '-c',
        \
        \ 'trans -brief -speak'
        \ ..' -t '..get(s:, 'trans_target', 'fr')
        \ ..' -s '..get(s:, 'trans_source', 'en')
        \ ..' '..shellescape(chunk)]
        \ , opts)

    " remove it from the list of chunks
    call remove(s:trans_chunks, 0)
endfu

fu myfuncs#trans_cycle() abort
    let s:trans_target = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_target', 'fr')]
    let s:trans_source = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_source', 'en')]
    echo '[trans] '..s:trans_source..' → '..s:trans_target
endfu

fu s:trans_grab_visual() abort
    let [lnum1, lnum2] = [line("'<"), line("'>")]
    let [c1, c2] = [col("'<"),  col("'>)")]

    " single line visual selection
    if lnum1 == lnum2
        let text = matchstr(getline(lnum1), '\%'..c1..'c.*\%'..c2..'c.\=\ze.*$')
    else
        " multi lines
        let first  = matchstr(getline(lnum1), '\%'..c1..'c.*$')
        let last   = ' '..matchstr(getline(lnum2), '^.\{-}\%'..c2..'c.\=')
        let middle = (lnum2 - lnum1) > 1 ? ' '..join(getline(lnum1+1,lnum2-1), ' ') : ''

        let text = first..middle..last
    endif
    return text
endfu
" pyrolysis

fu s:trans_output(job,exit_status) abort
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

    echo join(readfile(s:trans_tempfile), ' ')
    if len(s:trans_chunks)
        call myfuncs#trans(0)
    endif
endfu

fu myfuncs#trans_stop() abort
    " FIXME: Start a new Vim instance and hit `!T` on a word:{{{
    "
    "     E121: Undefined variable: s:trans_job~
    "}}}
    call job_stop(s:trans_job)
endfu

" unicode_toggle {{{1

fu myfuncs#unicode_toggle(line1, line2) abort
    let view  = winsaveview()
    let range = a:line1..','..a:line2
    let mods  = 'keepj keepp '

    call cursor(a:line1, 1)
    " replace  '\u0041'  with  'A'
    " or       '...'     with  '\u2026'
    "
    " `char2nr(submatch(0))` =
    "         decimal  code point of a character who  is not in the extended ascii table.
    "
    " `printf('\u%x')` =
    "         string '\u1234'
    "         where `1234` is the conversion of the decimal code point into hexa
    let [pat, l:Rep] = search('\\u\x\+', 'nW', a:line2)
        \ ? ['\\u\x\+', {-> eval('"'.submatch(0).'"')}]
        \
        \ : ['[^\x00-\xff]',
        \       {-> printf(
        \               char2nr(submatch(0)) <= 65535
        \               ?    '\u%x'
        \               :    '\U%x',
        \               char2nr(submatch(0))
        \ )}]
    sil exe mods..range..'s/'..pat..'/\=l:Rep()/ge'
    call winrestview(view)
endfu

fu s:vim_parent() abort "{{{1
    "    ┌────────────────────────────┬─────────────────────────────────────┐
    "    │ :echo getpid()             │ print the PID of Vim                │
    "    ├────────────────────────────┼─────────────────────────────────────┤
    "    │ $ ps -p <Vim PID> -o ppid= │ print the PID of the parent of Vim  │
    "    ├────────────────────────────┼─────────────────────────────────────┤
    "    │ $ ps -p $(..^..) -o comm=  │ print the name of the parent of Vim │
    "    └────────────────────────────┴─────────────────────────────────────┘
    return expand('`ps -p $(ps -p '..getpid()..' -o ppid=) -o comm=`')
endfu

fu myfuncs#webpage_read(url) abort "{{{1
    if !executable('w3m')
        echo 'w3m is not installed'
        return
    endif
    let tempfile = tempname()..'/webpage'
    exe 'tabe '..tempfile
    " Alternative shell command:{{{
    "
    "     $ lynx -dump -width=1000 url
    "                         │
    "                         └ high nr to be sure that
    "                           `lynx` won't break long lines of code
    "}}}
    sil exe 'r !w3m -cols 100 '..shellescape(a:url, 1)
    setl bt=nofile nobl noswf nowrap
endfu

fu myfuncs#word_frequency(line1, line2, ...) abort "{{{1
    let flags  = {
        \  'min_length': matchstr(a:1, '-min_length\s\+\zs\d\+'),
        \  'weighted': stridx(a:1, '-weighted') != -1,
        \ }

    let words = split(join(getline(a:line1, a:line2), "\n"), '\%(\%(\k\@!\|\d\).\)\+')
    let min_length = !empty(flags.min_length) ? flags.min_length : 4

    " remove anything which is:
    "
    "    - shorter than `min_length` characters
    "
    "    - longer than 30 characters;
    "      probably not words;
    "      it  could be  for example  a long  sequence of  underscores used  to
    "      divide 2 sections of text
    "
    "    - not containing any letter

    call filter(words, {_,v -> strchars(v) >= min_length && strchars(v) <= 30 && v =~ '\a'})

    " put all of them in lowercase
    call map(words, {_,v -> tolower(v)})

    let freq = {}
    for word in words
        let freq[word] = get(freq, word, 0) + 1
    endfor

    if flags.weighted
        let weighted_freq = deepcopy(freq)
        " What's the ternary expression after the minus sign?{{{
        "
        " The length of an abbreviation we could create for a given word.
        " Its value depends on the word:
        "
        "   - if the word is 4 characters long, then the abbreviation should be
        "     2 characters long,
        "
        "   - if the word ends with an 's', and the same word without the ending
        "     's' is also present, then the abbreviation should be 4 characters
        "     long (because it's probably a plural),
        "
        "   - otherwise, by default, an abbreviation should be 3 characters long
        "}}}
        call map(weighted_freq, {k,v ->
        \ v * (strchars(k)
        \ -
        \ strchars(k) == 4
        \ ? 2
        \   : k[-1:-1] is# "s" && index(keys(freq), k[:strlen(k)-1]) >= 0
        \   ?     4
        \   :     3
        \ )})
        let weighted_freq = sort(items(weighted_freq), {a, b -> b[1] - a[1]})
    endif

    " put the result in a vertical viewport
    let tempfile = tempname()..'/WordFrequency'
    exe 'lefta '..(&columns/3)..'vnew '..tempfile
    setl bh=delete bt=nofile nobl noswf wfw nowrap pvw

    for item in flags.weighted ? weighted_freq : items(freq)
        call append('$', join(item))
    endfor

    " format output into aligned columns
    if executable('column') && executable('sort')
        sil %!column -t
        sil %!sort -rn -k2
        " We don't need to delete the first empty line, `column` doesn't return it.
        " Probably because there's nothing to align in it.
    endif

    exe 'vert res '..(max(map(getline(1, '$'), {_,v -> strchars(v, 1)}))+4)
    nno <buffer><expr><nowait><silent> q reg_recording() isnot# '' ? 'q' : ':<c-u>q<cr>'
    wincmd p
endfu

fu myfuncs#wf_complete(_a, _l, _p) abort
    return join(['-min_length', '-weighted'], "\n")
endfu

