" FIXME: l'autoindentation (==) ne fonctionne pas toujours comme prévu{{{
"
"     foo bar,
"     baz|
"        ^
"         ==
"
"     →
"     foo bar,
"         baz
"
" Ce n'est pas dû à un plugin mais probablement à une règle d'indentation
" spécifique au type de fichier markdown.
" MWE:
"
"     vim -u NORC -N test.md
"
" Par défaut, il ne semble pas y avoir de règles d'indentation pour markdown.
" Je n'ai pas trouvé de fichier `markdown.vim` ou `md.vim` dans
" $VIMRUNTIME/indent/.
"
" De base le comportement de l'opérateur `==` est influencé par 5 options:
"
"     'equalprg'
"     'indentexpr'
"     'autoindent'
"     'smartindent'
"     'cindent'
"
" Dans un fichier markdown, seule 'autoindent' est activée, et le pb persiste
" même si je la désactive:
"
"    foo bar     →    foo bar
"    baz              baz         ✔ (`==` ne fait pas bouger baz)
"
"    foo bar,    →    foo bar,
"    baz                  baz     ✘ (`==`, fait bouger baz, pk?)
"
" Pour essayer de comprendre lire :h C-indenting et :h usr_30.txt
"}}}
fu! myfuncs#block_select_box() abort "{{{1
" this function selects an ascii box that we drew with our `draw-it` plugin
    let view = winsaveview()
    let guard = 0

    " find the upper-left corner of the box
    while guard < 99
        " search an underscore, to try and position the cursor on the first
        " line of the box
        call search('_', 'bW')
        " if we're on the first line of the box:
        "         __________
        "                  ^
        " … then `bhj` should position us on the first `|` character of the box
        "         __________
        "       >|
        norm! bhj
        " if that's the case, we've found the upper-left corner of the box
        " stop the loop
        if getline('.')[col('.') - 1] is# '|'
            norm! k
            break
        else
            " otherwise position the cursor back where it was:
            "         __________
            "        ^
            norm! k
            " and continue searching
        endif
        let guard += 1
    endwhile

    if guard ==# 99
        call winrestview(view)
        return
    endif

    " switch to visual block mode
    exe "norm! \<c-v>"
    let guard = 0
    " select the left border of the box
    while guard < 30
        norm! j
        if getline('.')[col('.') - 1] isnot# '|'
            norm! k
            break
        endif
        let guard += 1
    endwhile

    if guard = 30
        call winrestview(view)
        return
    endif

    " we've selected the left border of the box, now we have to select the
    " whole box: `el` should position the cursor on the lower-right corner
    norm! el

    " if the box we've selected doesn't contain the line where we were
    " originally, revert everything
    "
    "            ┌─ original line is before the box
    "            │
    if view.lnum < line("'<") || view.lnum > line("'>")
    "                                      │
    "                                      └─ original line is after the box
        exe "norm! \e"
        call winrestview(view)
    endif
endfu

" block_select_paragraph {{{1

" This function should try and select a box containing the current paragraph.
"
" It won't work as expected if we want to select a box around a block of text:
"
"     hello world    ✔
"     bye all
"
"     hello world    foo bar    ✘
"     bye all        baz qux
"
" It  will give  the value  `all`  to 'virtualedit',  but it  won't restore  its
" original value, because it would alter the selection.

fu! myfuncs#block_select_paragraph() abort
    let ve_save = &ve
    try
        set ve=all

        " search the beginning of the text in the current paragraph
        call search('\n\s*\n', 'bW')
        let [ start_line, start_col ] = searchpos('\S')
        " search the end of the text in the current paragraph
        let end_line = search('\n\s*\n', 'nW')
        let end_col = searchpos('.*\zs\S\s*' ,'nW')[1]

        " search the longest line in the paragraph;
        " iterate over the lines in the latter
        for line in range(start_line, end_line)
            +
            " if a line in the paragraph is longer than the previous value of
            " `end_col`, update the latter
            let end_col = searchpos('.*\zs\S\s*' ,'nW')[1] > end_col
            \?                searchpos('.*\zs\S\s*' ,'nW')[1]
            \:                end_col
        endfor

        " execute the command which will select a block containing the paragraph
        return (start_line - 2)."G".(start_col - 2)."|"
             \ ."\<c-v>"
             \ .(end_col + 2)."|".(end_line + 1)."G"

    catch
        return lg#catch_error()
    finally
        let &ve = ve_save
    endtry
endfu

" box_create / destroy {{{1

" TODO:
" We could improve these functions by reading:
" https://github.com/vimwiki/vimwiki/blob/dev/autoload/vimwiki/tbl.vim
"
" In particular, it could update an existing table.

fu! myfuncs#box_create() abort

    " draw `|` on the left of the paragraph
    exe "norm! _vip\<c-v>^I|"
    " draw `|` on the right of the paragraph
    norm! gv$A|

    " align all (*) the pipe characters (`|`) inside the current paragraph (`ip`),
    " using the `ga` operator provided by `vim-easy-align`,
    norm! _
    sil exe "norm gaip*|"

    " If we wanted to center the text inside each cell, we would have to add
    " hit `CR CR` after `gaip`:
    "
    "     sil exe "norm gaip\<cr>\<cr>*|"

    " Capture all the column positions in the current line matching a `|`
    " character:
    let col_pos = []
    let i       = 0
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
            exe 'norm! '.i.'G'.j."|r\u2502"
        endfor
    endfor

    call s:box_create_separations()
    sil! call repeat#set("\<plug>(myfuncs_box_create)")
endfu

fu! s:box_create_border(where, col_pos) abort
    let col_pos = a:col_pos

    if a:where is# 'top'
        " duplicate first line in the box
        norm! '{+yyP
        " replace all characters with `─`
        exe "norm! v$r\u2500"
        " draw corners
        exe 'norm! '.col_pos[0]."|r\u250c".col_pos[-1]."|r\u2510"
    else
        " duplicate the `┌────┐` border below the box
        t'}-
        " draw corners
        exe 'norm! '.col_pos[0]."|r\u2514".col_pos[-1]."|r\u2518"
    endif

    " draw the '┬' or '┴' characters:
    for pos in col_pos[1:-2]
        exe 'norm! '.pos.'|r'.(a:where is# 'top' ? "\u252c" : "\u2534")
    endfor
endfu

fu! s:box_create_separations() abort
    " Create a separation line, such as:
    "
    "     |    |    |    |
    "
    " … useful to make our table more readable.
    norm! '{++yyp
    keepj keepp sil! s/[^\u2502\u253c]/ /g

    " Delete it in the `s` (s for space) register, so that it's stored inside
    " default register and we can paste it wherever we want.
    delete s

    " Create a separation line, such as:
    "
    "     ├────┼────┼────┤
    "
    " … and store it inside `x` register.
    " So that we can paste it wherever we want.
    let @x = getline(line("'{")+1)
    let @x = substitute(@x, '\S', "\u251c", '')
    let @x = substitute(@x, '.*\zs\S', "\u2524", '')
    let @x = substitute(@x, "\u252c", "\u253c", 'g')

    " Make the contents of the register linewise, so we don't need to hit
    " `"x]p`, but simply `"xp`.
    call setreg('x', @x, 'V')
endfu

fu! myfuncs#box_destroy() abort
    " remove box (except pretty bars: │)
    sil! '{,'}s/[\u2500\u2534\u252c\u251c\u2524\u253c\u2514\u2518\u2510\u250c]//g

    " replace pretty bars with regular bars
    " necessary, because we will need them to align the contents of the
    " paragraph later
    sil! '{,'}s/\u2502/|/g

    " remove the bars at the beginning and at the end of the lines
    " we don't want them, because they would mess up the creation of a box
    " later
    sil! '{,'}s/|//
    sil! '{,'}s/.*\zs|//

    " move the paragraphe one line up ([e), and one character left ([E)
    " why?
    " because when we create and destroy a box, the contents doesn't come back
    " where it was, it goes down one line, and right one character
    sil norm! vip
    sil norm [egv[E

    " trim whitespace
    sil! '{,'}TW

    " position the cursor on the upper left corner of the paragraph
    norm! {j_

    sil! call repeat#set("\<plug>(myfuncs_box_destroy)")
endfu

fu! myfuncs#check_myfuncs() abort "{{{1
    let s:my_vimrc = join(readfile($MYVIMRC), "\n")
    let s:tempfile = tempname()

    call writefile([ '    Warning: a function whose name appears here could be moved in the script-local scope,',
                   \ "    because it doesn't appear anywhere in your vimrc.",
                   \ '',
                   \ "    However, maybe it's called somewhere else, like in a ftplugin,",
                   \ "    so check with `ag` before doing anything:",
                   \ '',
                   \ "            cd ~; ag 'myfuncs#…'",
                   \ '', ''],
                   \
                   \ s:tempfile)

    g/\v^\s*fu%[nction]!\s+myfuncs#/call s:search_superfluous_myfuncs()

    exe 'tabe '.s:tempfile
    unlet! s:my_vimrc s:tempfile
endfu

fu! s:search_superfluous_myfuncs() abort
    let line      = getline('.')
    let func_name = matchstr(line, 'myfuncs#\k\+')
    if stridx(s:my_vimrc, func_name) ==# -1
        call writefile([func_name], s:tempfile, 'a')
    endif
endfu

fu! myfuncs#cloc(lnum1,lnum2,path) abort "{{{1
    if !empty(a:path)
        if a:path =~# '^http'
            let tempdir = tempname()
            let git_output = system('git clone '.a:path.' '.tempdir)
            let to_scan = tempdir
        else
            let to_scan = a:path
        endif
    else
        let file    = tempname()
        let to_scan = file.'.'.(empty(expand('%:e')) ? &ft : expand('%:e'))
        let lines   = getline(a:lnum1, a:lnum2)
        call writefile(lines, to_scan)

        " In a string, it seems that `.` can match anything including a newline.
        " Like `\_.`.

        " Warning: there seems to be a limit on the size of the shell's standard input.{{{
        "
        " We could use this code instead:
        "
        "     let lines = shellescape(join(getline(a:lnum1,a:lnum2), "\n"))
        "     echo system('echo '.lines.' | cloc --stdin-name=foo.'.&ft.' -')
        "
        " But because of the previous limit:
        "
        "     http://stackoverflow.com/a/19355351
        "
        " … the command would error out when send too much text.
        " The error would like like this:
        "
        "     E484: Can't open file /tmp/user/1000/vsgRgDU/97
        "
        " Currently, on my system, it seems to error out somewhere above 120KB.
        " In a file, to go the 120 000th byte, use the normal `go` command and hit
        " `120000go`. Or the Ex version:
        "
        "     :120000go
        "}}}
    endif

    " remove the header
    let output_cloc = matchstr(system('cloc '.to_scan), '\zs-\+.*')

    " Why do store the output in a variable, and echo it at the very end of
    " the function? Why don't we echo it directly?
    " Because, if the output is longer than the screen, and Vim uses its pager
    " to display it, and if we don't go down the output but cancel/exit, it
    " seems the rest of the code wouldn't be executed. We would have no
    " `g:cloc_results` variable.
    " We delay the display of the output to the very end of the function, to
    " be sure the code generating `g:cloc_results` is processed.

    let to_display = output_cloc

    " the 1st `split()` splits the string into a list, each item being a line
    " `filter()`        removes the lines which don't contain numbers
    " `map()`           replaces the lines with (sub)lists, each item being a number
    "                   (number of blank lines, lines of code, comments, files)

    " We ask `map()` to split all the lines in the output of `$ cloc`
    " using the pattern `\s\{2,}\ze\d`.
    " Why `\s\{2,}` and not simply `\s\+`?
    "
    " Because there are some programming languages which contain a number in
    " their name.
    " For example, in the source code of `$ cloc`, we find `Fortran 77` and
    " `Fortran 99`. With `\s\+`, we would split in the middle of the language.
    " With `\s\{2,}`, it shouldn't occur, unless some weird languages use
    " more than 2 consecutive spaces in their name…

    let output_cloc = map(filter(split(output_cloc, '\n'),
    \                            { i,v -> v =~# '\d\+' }),
    \                     { i,v -> split(v, '\s\{2,}\ze\d') })

    let g:cloc_results = {}
    let keys           = ['files', 'blank', 'comment', 'code']

    for values_on_line in output_cloc
        " `i`    is going to index the `keys` list
        " `dict` is going to store a dictionary containing the numbers
        "        of lines for a given language
        let i    = 0
        let dict = {}

        for value in values_on_line[1:]
            let dict[keys[i]] = eval(value)
            let i += 1
        endfor

        let g:cloc_results[values_on_line[0]] = dict
    endfor

    echo to_display
endfu

fu! myfuncs#current_word_toggle_highlight() abort "{{{1
    " Check if an autocmd watching the CursorHold event in the my_current_word
    " augroup exists.
    if exists('#my_current_word#CursorHold')
        " If it exists, we reset 'updatetime', remove the autocmd, the augroup
        " and the highlighting
        let &updatetime = s:update_time_save
        unlet! s:update_time_save
        au! my_current_word
        aug! my_current_word
        call s:current_word_delete_old_highlight()

    else
        let s:update_time_save = &updatetime
        set updatetime=100
        augroup my_current_word
            au!
            au CursorHold <buffer> call s:current_word_delete_old_highlight()
                                \| call s:current_word_highlight()
        augroup END
    endif
endfu

fu! s:current_word_highlight() abort
    if strcharpart(getline('.'), virtcol('.')-1, 1) =~ '\k'
        " The following line  is responsible for highlighting  the current word.
        " It highlights all the occurrences.  If we wanted to highlight only the
        " occurrence under the cursor:
        "
        "         exe 'match WordUnderCursor /\k*\%#\k*/'
        let w:my_current_word = matchadd('WildMenu', '\V\<'.escape(expand('<cword>'), '\').'\>', 10)
    endif
endfu

fu! s:current_word_delete_old_highlight() abort
    if exists('w:my_current_word')
        sil! call matchdelete(w:my_current_word)
        unlet! w:my_current_word
    endif
endfu

fu! myfuncs#dump_wiki(url) abort "{{{1
    if a:url[:3] isnot# 'http'
        return
    endif

    let [ x_save, y_save ] = [ getpos("'x"), getpos("'y") ]
    try
        let url = substitute(a:url, '/$', '', '').'.wiki'
        let tempdir = substitute(tempname(), '\v.*/\zs.{-}', '', '')
        call system('git clone '.shellescape(url).' '.tempdir)
        let files = glob(tempdir.'/*', 0, 1)
        call map(files, { i,v -> substitute(v, '^\V'.tempdir.'/', '', '') })
        call filter(files, { i,v -> v !~# '\v\c_?footer$' })

        mark x
        for file in files
            sil put =file
        endfor
        mark y

        sil 'x+,'ys/^/# /
        sil 'x+,'yg/^/exe 'keepalt r '.tempdir.'/'.getline('.')[2:]
        sil keepj keepp 'x+,'yg/^=\+\s*$/d_ | -s/^/## /
        sil keepj keepp 'x+,'yg/^-\+\s*$/d_ | -s/^/### /
        sil 'x+,'ys/\v^#.{-}\n\zs\s*\n\ze##//
        sil update

    catch
        return lg#catch_error()

    finally
        call setpos("'x", x_save)
        call setpos("'y", y_save)
    endtry
endfu

fu! myfuncs#fix_spell() abort "{{{1
    " don't break undo sequence:
    "     • it seems messed up (performs an undo then a redo which gets us in a weird state)
    "     • not necessary here, Vim already breaks the undo sequence

    " Alternative:
    "         let winview = winsaveview()
    "         norm! [S1z=
    "         norm! `^
    "         call winrestview(winview)

    let spell_save = &l:spell
    setl spell
    try
        let orig_line = getline('.')
        "                                                  ┌ don't eliminate a keyword nor a single quote
        "                                                  │ when you split the line
        "                                         ┌────────┤
        let words = reverse(split(orig_line, '\v%(%(\k|'')@!.)+'))

        let found_a_badword = 0
        for word in words
            let badword = get(spellbadword(word), 0, '')
            if empty(badword)
                continue
            endif
            let suggestion = get(spellsuggest(badword), 0, '')
            if empty(suggestion)
                continue
            else
                let found_a_badword = 1
                break
            endif
        endfor

        if found_a_badword
            let new_line = substitute(orig_line, '\<'.badword.'\>', suggestion, 'g')
            call timer_start(0, {-> setline(line('.'), new_line)})
        endif
    catch
        return lg#catch_error()
    finally
        let &l:spell = spell_save
    endtry
    " Break undo sequence before `setline()` edits the line, so that we can undo
    " if the fix is wrong.
    return "\<c-g>u"
endfu

" gtfo {{{1

fu! s:gtfo_init() abort
    let s:istmux       = !empty($TMUX)
    " terminal Vim running within a GUI environment
    let s:is_X_running = !empty($DISPLAY) && $TERM isnot# 'linux'
    let s:launch_term  = 'urxvt -cd'
endfu

fu! s:gtfo_error(s) abort
    echohl ErrorMsg | echom '[GTFO] '.a:s | echohl None
endfu

fu! myfuncs#gtfo_open_gui(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif
    sil call system('xdg-open '.shellescape(a:dir).' &')
endfu

fu! s:gtfo_is_not_valid(dir) abort
    if !isdirectory(a:dir) "this happens if a directory was deleted outside of vim.
        call s:gtfo_error('invalid/missing directory: '.a:dir)
        return 1
    endif
endfu

fu! myfuncs#gtfo_open_term(dir) abort
    if s:gtfo_is_not_valid(a:dir)
        return
    endif

    if s:istmux
        "                                   ┌─ splits vertically (by default tmux splits horizontally)
        "                                   │
        sil call system('tmux split-window -h -c '.string(a:dir))
        "                                      │
        "                                      └── start-directory
    elseif s:is_X_running
        sil call system(s:launch_term.' '.shellescape(a:dir).' &')
        redraw!
    else
        call s:gtfo_error('failed to open terminal')
    endif
endfu

if !exists('s:gtfo_has_been_init')
    let s:gtfo_has_been_init = 1
    call s:gtfo_init()
endif

fu! myfuncs#in_A_not_in_B(...) abort "{{{1
    let [fileA, fileB] = a:000
    if len(getbufline(fileA, 1, '$')) < len(getbufline(fileB, 1, '$'))
        let [fileA, fileB] = [fileB, fileA]
    endif

    " http://unix.stackexchange.com/a/28159
    let output = systemlist('diff -U $(wc -l < '.fileA.') '.fileA.' '.fileB." | grep '^-' | sed 's/^-//g'")
    call map(output, {i,v -> {'text': v}})
    call setloclist(0, output)
    call setloclist(0, [], 'a', {'title': 'in  '.fileA.'  but not in  '.fileB})
    doautocmd <nomodeline> QuickFixCmdPost lopen
    call qf#set_matches('myfuncs#in_A_not_in_B', 'Conceal', 'double_bar')
    call qf#create_matches()
endfu

fu! myfuncs#join_blocks(first_reverse) abort "{{{1
    let [ line1, line2 ] = [ line("'<"), line("'>") ]

    if (line2 - line1 + 1) % 2 ==# 1
        echohl ErrorMsg
        echo ' Total number of lines must be even'
        echohl None
        return ''
    endif

    let end_first_block    = line1 + (line2 - line1 + 1)/2 - 1
    let range_first_block  = line1.','.end_first_block
    let range_second_block = (end_first_block + 1).','.line2
    let mods               = 'keepj keepp '

    let fen_save = &l:fen
    try
        let &l:fen = 0

        if a:first_reverse
            sil exe range_first_block.'d'
            sil exe end_first_block.'put'
        endif

        sil exe mods.range_second_block."s/^/\<c-a>/e"
        sil exe mods.range_first_block .'g/^/'.(end_first_block + 1).'m.|-j'

        "              ┌─ align around the 1st occurrence of the delimiter
        "              │
        "              │        ┌─ the delimiter is a literal c-a
        "              │  ┌─────┤
        sil *EasyAlign 1 /\%u0001/ { 'left_margin': '',  'right_margin': ' ' }
        "                                           │                     │
        "                                           │                     └─ add a space after
        "                                           │
        "                                           └─ don't add anything before the delimiters
        sil exe mods."*s/\<c-a>//e"

    catch
        return lg#catch_error()
    finally
        let &l:fen = fen_save
    endtry
endfu

fu! myfuncs#keyword_custom(chars) abort "{{{1
    "   ┌─ the restoration will be done from an autocmd
    "   │  and an autocmd runs in the context of the script where it was installed
    "   │
    let s:isk_save = &l:isk

    try
        for char in split(a:chars, '\zs')
            exe 'setl isk+='.char2nr(char)
        endfor
        augroup keyword_custom
            au!
            au CompleteDone <buffer> let &l:isk = s:isk_save
                                  \| unlet! s:isk_save
                                  \| exe 'au! keyword_custom'
                                  \| aug! keyword_custom
        augroup END
    catch
        return lg#catch_error()
    " Do NOT add a finally clause to restore 'isk'.
    " It would be too soon. The completion function hasn't been invoked yet.
    endtry
    return ''
endfu

fu! myfuncs#long_listing_split() abort "{{{1
    let line = getline('.')
    if stridx(line, ',') ==# -1
        return
    endif

    let view          = winsaveview()
    let object_indent = repeat(' ', match(line, '\S'))

    sil keepj keepp s/\v\ze\S/- /e
    sil keepj keepp s/\v\s*,\s*%(et\s*)?|\s*<et>\s*/\="\n".object_indent.'- '/ge

    call winrestview(view)
    sil! call repeat#set("\<plug>(myfuncs_long_listing_split)")
endfu

" long_object_{split|join} {{{1

fu! myfuncs#long_object_split() abort
    let view = winsaveview()
    let line = getline('.')

    " If the line doesn't contain a list ([]), a dictionary ({}), don't do anything.

    if match(line, '\[.*\]\|{.*}') ==# -1
        return
    endif

    let object_indent = repeat(' ', match(line, '\[\|{\'))

    " If the first item in the list/dictionary begins right after the opening
    " symbol (`[` or `{`) add a space:
    sil keepj keepp s/\v[\[{]%(\s)@!\zs/ /e

    " Move the first item in the list on a dedicated line.
    sil keepj keepp s/\v[\[{]\zs/\="\n".object_indent."\\"/e

    " split the object
    sil keepj keepp s/,\zs/\="\n".object_indent.'\'/ge

    " move the closing symbol on a dedicated line
    sil keepj keepp s/\v\zs\s?\ze%([\]}])/\=",\n".object_indent."\\ "/e

    call winrestview(view)

    sil! call repeat#set("\<plug>(myfuncs_long_object_split)")
endfu

fu! myfuncs#long_object_join() abort
    let end_line = search('\]\|}', 'cW')
    let beg_line = search('\[\|{', 'bW')

    exe 'sil keepj keepp '.beg_line.','.end_line.'s/\n\s*\\//ge'
    call cursor(beg_line, 1)
    sil keepj keepp s/\zs\s*,\ze\s\?[\]}]//e

    sil! call repeat#set("\<plug>(myfuncs_long_object_join)")
endfu

fu! myfuncs#only_selection(lnum1,lnum2) abort "{{{1
    let lines = getline(a:lnum1,a:lnum2)
    keepj sil %d_
    sil put =lines
    keepj 1d_
endfu

" OPERATORS {{{1
" op_gq {{{2

" Don't need this code anymore, because since Vim 8.0.0179, 'formatprg' can be
" buffer-local. I keep the code for educational purpose.



" With the `gq` operator, we can format text.
" We would like to use different formatters for different type of buffers.
" Unfortunately, the option 'formatprg', read by `gq` to determine which
" formatter to call, is global and not buffer-local.
"
" To fix this, we wrap the `gq` operator inside the function `myfuncs#gq()`.
"
"         nno <silent> gq  :<c-u>set opfunc=myfuncs#op_gq<cr>g@
"         nno <silent> gqq :<c-u>set opfunc=myfuncs#op_gq<bar> exe 'norm! '.v:count1.'g@_'<cr>
"         xno <silent> gq  :<c-u>call myfuncs#op_gq('vis')<cr>



" This function checks whether the variable `b:formatprg` exists.
" If it does, `myfuncs#gq()` temporarily resets `&formatprg` with the value of
" `b:formatprg`.
" And when the formatting is done, myfuncs#gq() restores the old value of the
" option.
" Thanks to this, we can define a buffer-local formatter, by setting the
" variable `b:formatprg` in a filetype plugin.
" Usage example:
"
"     let b:formatprg = 'pandoc -f html -t html'
"
" Solution found here:
" http://vimcasts.org/episodes/using-external-filter-commands-to-reformat-html/
" https://gist.github.com/PeterRincker/9773667

"         fu! myfuncs#op_gq(type) abort
"             let cb_save  = &cb
"             let sel_save = &selection
"             let fp_save  = &formatprg
"             try
"                 set cb-=unnamed cb-=unnamedplus
"                 set inclusive
"                 let &formatprg = get(b:, 'formatprg', &formatprg)
"
"                 if a:type is# 'vis'
"                     norm! '<V'>gq
"                 else
"                     norm! '[gq']
"                 endif
"
"             catch
"                 return lg#catch_error()
"
"             finally
"                 let &cb        = cb_save
"                 let &sel       = sel_save
"                 let &formatprg = fp_save
"             endtry
"         endfu

fu! myfuncs#op_grep(type, ...) abort "{{{2
    let cb_save  = &cb
    let sel_save = &selection
    let sp_save  = &sp
    let reg_save = [ '"', getreg('"'), getregtype('"') ]

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

        " Old Code:{{{
        "
        " It was necessary in the past, because we used `:grep`.
        " But now we use `:cgetexpr`, for which this code doesn't work:
        " we use `filter()` instead. I keep it for educational purpose.
        "
        "
        " By default, the output of `:grep` includes errors (“permission denied“).
        " It's because of 'shellpipe' / 'sp', whose default value is `2>&1| tee`.
        "
        " When we're looking for a pattern in files, these errors are noise: remove them.
        " We do so by temporarily tweaking 'sp':
        "
        "         2>&1| tee  →  |tee
        "
        " let &l:sp = '| tee'
        "}}}

        if a:type is# 'Ex'
            let [ pat, is_loclist ] = [ a:1, a:2 ]

            " Why `:lgetexpr` instead of `:lgrep!`?{{{
            "
            " The latter shows us the output of the shell command (`$ ag …`).
            " This makes the screen “flash”, which is distracting.
            "
            " `:lgetexpr` executes the shell command silently.
            "}}}
            if is_loclist
                lgetexpr s:op_grep_get_qfl(pat)
                call setloclist(0, [], 'a', { 'title': &grepprg.' '.pat.' .' })
            else
                cgetexpr s:op_grep_get_qfl(pat)
                call setqflist([], 'a', { 'title': &grepprg.' '.pat.' .' })
            endif
        else
            " Old Interesting Alternative:{{{
            "
            "     sil! exe 'grep! '.shellescape(@").' .'
            "
            " Even though `:grep` is a Vim command, we really need to use `shellescape()`
            " and NOT `fnameescape()`. Check this:
            "
            "     let @" = 'foo;ls'
            "     let @" = "that's"
            "     let @" = 'foo%bar'
            "
            "                          ; is special             % is special
            "                          on shell's               on Vim's
            "                          command-line             command-line
            "     ┌───────────────────┬──────────┬─────────────┬────────────┐
            "     │      @" →         │  foo;ls  │  that's     │  foo%bar   │
            "     ├───────────────────┼──────────┼─────────────┼────────────┤
            "     │ fnameescape(@")   │  foo;ls  │  that\'s    │  foo\%bar  │
            "     ├───────────────────┼──────────┼─────────────┼────────────┤
            "     │ shellescape(@")   │ 'foo;ls' │ 'that'\''s' │ 'foo%bar'  │
            "     ├───────────────────┼──────────┼─────────────┼────────────┤
            "     │ shellescape(@",1) │ 'foo;ls' │ 'that'\''s' │ 'foo\%bar' │
            "     └───────────────────┴──────────┴─────────────┴────────────┘
            "
            " `fnameescape()` would not protect `;`. The shell would interpret the
            " semicolon as the end of the `$ grep` command, and would execute the rest
            " as another command. This can be dangerous:
            "
            "     foo;rm -rf
            "
            " Conclusion:
            " When you have a command whose arguments can contain special characters,
            " and you want to protect them from:
            "
            "       • Vim       use `fnameescape(…)`
            "       • the shell use `shellescape(…)`
            "       • both      use `shellescape(…, 1)`
            "                                       │
            "                                       └─ only needed after a `:!` command; not in `system(…)`
            "                                          `:!` is the only command to remove the backslashes
            "                                          added by the 2nd non-nul argument
            "
            "                                MWE:
            "                                :e /tmp/foo%bar
            "                                :call system('echo '.shellescape(expand('%')).' >>/tmp/file')
            "                                :call system('echo '.shellescape(expand('%'),1).' >>/tmp/file')
            "
            "                                          $ cat /tmp/foo%bar
            "                                              /tmp/foo%bar
            "                                              /tmp/foo\%bar
            "                                                      ^
            "}}}
            cgetexpr s:op_grep_get_qfl(@")
            call setqflist([], 'a', { 'title': &grepprg.' '.@".' .' })
        endif

    catch
        return lg#catch_error()
    finally
        let &cb  = cb_save
        let &sel = sel_save
        call call('setreg', reg_save)
    endtry
endfu

fu! s:op_grep_get_qfl(pat) abort
    return filter(systemlist(&grepprg.' '.shellescape(a:pat)), {i,v -> v !~# '^ERR: Skipping'})
endfu

fu! myfuncs#op_incremental_yank(type) abort "{{{2
    let cb_save  = &cb
    let sel_save = &selection
    try
        set cb-=unnamed cb-=unnamedplus
        set selection=inclusive

        if a:type is# 'char'
            norm! `[v`]y
        elseif a:type is# 'line'
            norm! '[V']y
        elseif a:type is# 'block'
            exe "norm! `[\<c-v>`]y"
        elseif a:type is# 'vis'
            norm! gvy
        else
            return
        endif

        " Append (flag 'a') what we just copied (unnamed register @")
        " inside register 'z',
        " and set its type to be the same as the one of the unnamed register
        call setreg('z', @".(a:type is# 'char' ? ' ' : ''), 'a'.getregtype('"'))

        " Copy the  'z' register  inside the  unnamed register,  so that  we can
        " paste it directly with p instead of "zp
        call setreg('"', @z, getregtype('z'))

    catch
        return lg#catch_error()
    finally
        let &cb  = cb_save
        let &sel = sel_save
    endtry
endfu

" op_replace_without_yank {{{2

" This function is called directly from our `dr` and `drr` mappings.
fu! myfuncs#set_reg(reg_name) abort
    " We save the name of the register which was called just before `dr` inside
    " a script-local variable, for the dot command to know which register we
    " used the first time.
    "
    " By default, it will be `"`.
    " Or `+` if we have prepended the value 'unnamedplus' in the 'clipboard'
    " option's value.

    let s:replace_reg_name = a:reg_name
endfu

fu! myfuncs#op_replace_without_yank(type) abort
    let sel_save = &selection
    try
        " save registers and types to restore later.
        call lg#reg#save(['"', s:replace_reg_name])

        let replace_reg_contents = getreg(s:replace_reg_name)
        let replace_reg_type     = getregtype(s:replace_reg_name)

        " build condition to check if we're replacing the current line

        let replace_current_line =     line("'[") ==# line("']")
        \                          &&  col("'[") ==# 1
        \                          && (col("']") ==# col('$')-1 || col('$') ==# 1)

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

        elseif a:type is# 'block'
            exe "keepj norm! `[\<c-v>`]\"".s:replace_reg_name.'p'

        elseif a:type is# 'char'
            " DWIM:
            "       DWIM = Do What I Mean.
            "
            "       If pasting linewise contents in a _characterwise_ motion, trim
            "       surrounding whitespace from the content to be pasted.
            "
            "       NOT the trailing whitespace on each line. JUST the leading
            "       whitespace of the first line, and the ending whitespace of the
            "       last.

            if replace_reg_type is# 'V'
                call setreg(s:replace_reg_name, s:trimws_ml(replace_reg_contents), 'v')
            endif

            exe 'keepj norm! `[v`]"'.s:replace_reg_name.'p'
        endif

    catch
        return lg#catch_error()
    finally
        let &sel = sel_save
        " Now, the unnamed register contains the old text over which we pasted the
        " new text.
        " We don't want that, we want it to contain its original contents.
        " Luckily, we saved at the beginning of the function.
        " We restore it.
        "
        " We do the same for the replacement register, because we may have trimmed it
        " in the process (type is# 'char' && replace_reg_type is# 'V').
        call lg#reg#restore(['"', s:replace_reg_name])
    endtry
endfu

" TRIM WhiteSpace Multi-Line
fu! s:trimws_ml(s) abort
    return substitute(a:s, '\v^\_s*(.{-})\_s*$', '\1', '')
endfu

" op_toggle_alignment {{{2

fu! s:is_right_aligned(line1, line2) abort
    let first_non_empty_line = search('\S', 'cnW', a:line2)
    let length               = strlen(getline(first_non_empty_line))
    for line in getline(a:line1, a:line2)
        if strlen(line) != length && line !~# '^\s*$'
            return 0
        endif
    endfor
    return 1
endfu

fu! myfuncs#op_toggle_alignment(type) abort
    if a:type is# 'vis'
        let [mark1, mark2] = ["'<", "'>"]
    else
        let [mark1, mark2] = ["'[", "']"]
    endif
    if s:is_right_aligned(line(mark1), line(mark2))
        exe mark1.','.mark2.'left'
        exe 'norm! ' . mark1 . '=' . mark2
    else
        exe mark1.','.mark2.'right'
    endif
endfu

fu! myfuncs#align_with_end(offset) abort

    " l:text_length is the length of text to align on the current line
    let l:text_length      = strchars(matchstr(getline('.'), '\S.*$'))

    " l:neighbour_length is the length of the previous/next line
    let l:neighbour_length = strchars(getline(line(".") + a:offset))

    exe 'left ' . (l:neighbour_length - l:text_length)
endfu

fu! myfuncs#op_trim_ws(type) abort "{{{2
    if &l:binary || &ft is# 'diff'
        return
    endif

    if a:type is# 'vis'
        sil! exe line("'<").','.line("'>").'TW'
    else
        sil! exe line("'[").','.line("']").'TW'
    endif
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

fu! myfuncs#op_yank_matches_set_action(yank_where_match, yank_comments) abort
    let s:yank_matches_view = winsaveview()
    let s:yank_where_match = a:yank_where_match
    let s:yank_comments    = a:yank_comments
endfu

fu! myfuncs#op_yank_matches(type) abort
    let @z = ''

    let mods  = 'keepj keepp'
    let range = (a:type is# 'char' || a:type is# 'line')
    \?               line("'[").','.line("']")
    \:               line("'<").','.line("'>")

    let cmd = s:yank_where_match ? 'g' : 'v'
    let pat = s:yank_comments
    \?            '^\s*\V'.escape(get(split(&l:cms, '\s*%s\s*'), 0, ''), '\')
    \:            @/

    exe mods.' '.range.cmd.'/'.pat.'/y Z'

    " Remove empty lines.
    " We can't use the pattern `\_^\s*\n` to describe an empty line, because
    " we aren't in a buffer:    `@z` is just a big string
    if !s:yank_where_match
        let @z = substitute(@z, '\v\n%(\s*\n)+', '\n', 'g')
    endif

    " the first time we've appended a match to `@z`, it created a newline
    " we don't want this one; remove it
    let @z = substitute(@z, "^\n", '', '')

    call setreg('"', @z, 'l')
    if exists('s:yank_matches_view')
        call winrestview(s:yank_matches_view)
        unlet! s:yank_matches_view
    endif
endfu

fu! myfuncs#open_gx(in_term) abort "{{{1
    let url = s:open_gx_get_url()
    if empty(url)
        return
    endif

    if match(url, '\v^%(https?|ftp|www)') ==# -1
        let ext = fnamemodify(url, ':e')
        let cmd = get({'pdf': 'zathura'}, ext, 'xdg-open')
        call system(cmd.' '.url)
    else
        if a:in_term
            " We could pass the shell command we want to execute directly to
            " `tmux split-window`, but the pane would be closed immediately.
            " Because by default, tmux closes a window/pane whose shell command
            " has completed:
            "         When the shell command completes, the window closes.
            "         See the remain-on-exit option to change this behaviour.
            "
            " For more info, see `man tmux`, and search:
            "
            "     new-window
            "     split-window
            "     respawn-pane
            "     set-remain-on-exit
            sil call system('tmux split-window -c '.$XDG_RUNTIME_DIR)
            " maximize the pane
            sil call system('tmux resize-pane -Z')
            " start `w3m`
            sil call system('tmux send-keys web \ '.shellescape(url).' Enter')
            "                                    │
            "                                    └─ without the backslash, `tmux` would think
            "                                    it's a space to separate the arguments of the
            "                                    `send-keys` command; therefore, it would remove it
            "                                    and type:
            "                                                weburl
            "                                    instead of:
            "                                                web url
            "
            "                                    The backslash is there to tell it's a semantic space.
        else
            exe 'sil !xdg-open '.shellescape(url, 1)
            redraw!
        endif
    endif
endfu

fu! s:open_gx_get_url() abort
    " https://github.com/junegunn/vim-plug/wiki/extra
    if &ft is# 'vim-plug'
        let line = getline('.')
        let sha  = matchstr(line, '^  \X*\zs\x\{7}\ze ')
        let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
        \ : getline(search('^- .*:$', 'bn'))[2:-2]
        let uri  = get(get(g:plugs, name, {}), 'uri', '')
        if uri !~ 'github.com'
            return
        endif
        let repo = matchstr(uri, '[^:/]*/'.name)
        let url  = empty(sha) ? 'https://github.com/'.repo
        \ : printf('https://github.com/%s/commit/%s', repo, sha)

    else
        let url = expand('<cWORD>')
        if url =~# 'http\|ftp\|www'
            " Which characters make a URL invalid?
            " https://stackoverflow.com/a/13500078

            " remove everything before the first `http`, `ftp` or `www`
            let url = substitute(url, '\v.{-}\ze%(http|ftp|www)', '', '')

            " remove everything after the first `⟩`, `>`, `)`, `]`, `}`
            let url = substitute(url, '\v.{-}\zs%(%u27e9|\>|\)|\]|\}).*', '', '')

            " remove everything after the last `"`
            let url = substitute(url, '\v".*', '', '')

        elseif url =~# '\[.\{-}\](.\{-})'
            " [text](path_to_local_file)
            let url = matchstr(url, '\[.\{-}\](\zs.\{-}\ze)')
            let url = substitute(url, '^\s*\.', expand('%:p:h'), '')
        else
            " garbage
            let url = ''
        endif
    endif
    return url
endfu

fu! myfuncs#patterns_count(line1, line2, ...) abort "{{{1
    let view = winsaveview()
    let counts = repeat([0], a:0)

    " Why do we copy a:000?
    "
    " When we will paste the patterns in the scratch buffer,
    " we will need to put a `c-a` character after each one of them.
    " Why?
    " To allow the `column` shell utility to properly format/align the counts.
    "
    " It means we  need to make `a:000`  mutate, which is not  possible.  So, we
    " make a copy.

    let patterns = copy(a:000)

    for i in range(0, a:0 - 1)
        call cursor(a:line1, 1)
        let matchline = search(patterns[i], 'cW', a:line2)
        while matchline && counts[i] <= 9999
            let counts[i] += 1
            let matchline  = search(patterns[i], 'W', a:line2)
        endwhile
    endfor

    vnew | exe 'vert resize '.(&columns/3)
    setl bh=wipe nobl bt=nofile ro noswf

    " Why do escape the double quotes?
    " Because, when we use :put ={expr}, we need to escape the double quotes
    " (and the pipe), otherwise they terminate the command prematurely.

    " put the patterns
    call map(patterns, { i,v -> v."\<c-a>" })
    "                             │
    "                             └─ add a literal C-a to be used as a delimiter by `column`;
    "                                we don't want to align around spaces, because `column` would
    "                                consider all of them, while we want it to only consider the 1st
    "                                one on a line
    "                                with a single C-a on each line, we can be sure `column` will only
    "                                consider the first occurrence of the delimiter
    sil 0put =patterns
    " put the counts right below
    sil exe a:0.'put =counts'

    " join each count with the corresponding pattern
    "
    "                               ┌ range of lines containing the patterns
    "                            ┌──┤
    sil! exe printf('keepj keepp 1,%sg/^/%sm.|-j!', a:0, a:0+1)
    "                                    └──┤
    "                                       └ take the first line below the patterns (first count)
    "                                         and move it below the line processed by `:g`;
    "                                         it contains a pattern, so we're moving a count below
    "                                         the corresponding pattern
    sil! $d_

    " align columns around the `c-a`
    " no need to remove `c-a`, `column` will do it automatically
    exe "sil! %!column -s '\<c-a>' -t"
    setl noma

    if !bufexists('Counts') | sil file Counts | endif
    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>
    exe winnr('#').'windo call winrestview(view)'
endfu

fu! myfuncs#patterns_favorite(arglead, _c, _p) abort
    " We could put inside the following list some patterns that we often use
    let pat = ['']
    return join(pat, "\n")
endfu

fu! myfuncs#plugin_install(url) abort "{{{1
    let pattern     =  '\vhttps?://github.com/(.{-})/(.*)/?'
    let replacement = 'Plug ''\1/\2'''
    let plug_line   = substitute(a:url, pattern, replacement, '')
    let to_install  = matchstr(plug_line, '\vPlug ''.{-}/(vim-)?\zs.{-}\ze''')

    let win_orig = win_getid()
    vnew | e $MYVIMRC
    let win_vimrc = win_getid()

    call cursor(1, 1)
    call search('^\s*Plug')
    " We should write `zR` to open all folds, so that the while loop can
    " search in closed folds (it seems it misses the plugins lines inside
    " folds). But I don't want the new line to pasted inside a fold. It's not
    " where it should be. It should be pasted just above the fold.
    " I don't know how to detect an open fold, and then how to move to the
    " first line.
    norm! zv
    let plugin_on_current_line = ''

    while to_install >? plugin_on_current_line && search('call plug#end()', 'nW')
        " test if there's still another 'Plug …' line afterwards, AND move the
        " cursor there, if there's one
        if !search('\v^\s*"?\s*Plug ''.{-}/.{-}/?''', 'W')
            break
        endif
        let plugin_on_current_line = matchstr(getline('.'), '\vPlug ''.{-}/(vim-)?\zs.{-}\ze/?''')
    endwhile

    -put =plug_line
    update
    PlugInstall
    let win_plug = win_getid()

    call win_gotoid(win_vimrc) | close

    " Before going back to the `vim-plug` window, we go back to the original
    " one. This way, once we are in `vim-plug`, the previous window will be
    " the original one, and we can go back there with `C-w w`.

    call win_gotoid(win_orig)
    call win_gotoid(win_plug)
endfu

fu! myfuncs#plugin_global_variables(keyword) abort "{{{1
    let condition = 'v:key =~ ''\V''.escape('''.a:keyword.''', ''\'') && v:key !~ ''\(loaded\|did_plugin_\)'''
    let options   = items(filter(deepcopy(g:), condition))

    let msg = ''
    for option in options
        let msg .=  option[0]
                 \ .' = '
                 \ .string(option[1])
                 \ .(index(options, option) !=# len(options) - 1 ? "\n\n" : '')
    endfor

    echo msg
endfu

fu! myfuncs#plugin_symbols() abort "{{{1
    let functions = s:get_matches('\v^\s*fu%[nction]!\s.*')
    let mappings  = s:get_matches('\v^\s*%(n|i|v|x|o|c)?%(%(nore)?map|no)>.*')
    let commands  = s:get_matches('\v^\s*com%[mand]!\s.*')

    " We build the dictionary `sizes` to store the number of lines of each function.
    " The keys are the names of the functions, the values are the numbers of lines.
    let sizes = {}
    let view  = winsaveview()
    for function in functions
        let startline       = search(function, 'c')
        let indent          = matchstr(getline('.'), '^\s*')
        let sizes[function] = search(indent.'endf\%[unction]$', 'W') - startline - 1
    endfor
    call winrestview(view)

    vnew
    setl bt=nofile bh=wipe nobl nowrap
    if !bufexists('Plugin Symbols') | sil file Plugin\ Symbols | endif

    " We paste each key-value pair of `sizes`.
    "
    " Each pair is returned in a list of 2 items (thanks to items()).
    " Each time we paste a pair, we reverse it and join the function name and
    " its length, with a control character ^A in the middle.
    "
    " Why do we reverse each pair ?
    " So that the number comes first on a line, and we can sort them with `sort n`.
    "
    " Why do we join them ?
    " So that the sorting affects the numbers and the names at the same time.
    " Otherwise we would just sort the numbers.
    " Why ^A in the middle ?
    " So that we know where the number ends and where the function name begins.
    " With this info, we can break a line containing a number and a function
    " name on 2 lines again (with a substitution).
    for item in items(sizes)
        sil! put =join(reverse(item), \"\<c-a>\")
    endfor
    sort n
    sil %s/\v(\d+)%u0001(.*)/\2\r    \1/e

    " Hide the keywords `function!`, `abort` and `range` with conceal feature.
    " Why not deleting them?
    " Because when we hit Enter on a function name, our mapping looks for the
    " contents of the current line.
    " If `function!`, `abort` and `range` are missing, the cursor may be
    " positioned on a line where the function is called, whereas we want to go
    " to its definition.
    let pat = '\v^\s*fu%[nction]!\s+|%(\s+%(abort|range)){1,2}|\s+"\{\{\{\d+$'
    call qf#set_matches('myfuncs:plugin_symbols', 'Conceal', pat)
    call qf#create_matches()

    sil! 0put =['FUNCTIONS']
    sil! $put =['', 'MAPPINGS', ''] + mappings
    sil! $put =['', 'COMMANDS', ''] + commands
    g/^\v%(FUNCTIONS|COMMANDS|MAPPINGS)$/center
    setl noma ro
    nno  <buffer><nowait><silent>  <cr>  :<c-u>call <SID>plugin_symbols_clickable_toc()<cr>
    nno  <buffer><nowait><silent>  q     :<c-u>close<cr>
endfu

fu! s:plugin_symbols_clickable_toc() abort
    let line = getline('.')
    if line =~# '^\v\s*%(FUNCTIONS|COMMANDS|MAPPINGS|\d+)?\s*$'
        return
    endif
    wincmd p
    call search(line, 'c')
    norm! zv
endfu

fu! s:get_matches(pattern)
    let guard     = 0
    let list      = []
    let view      = winsaveview()
    call cursor(1, 1)
    let matchline = search(a:pattern, 'cW')

    while matchline && guard <= 1000
        let guard    += 1
        let list     += [matchstr(getline('.'), '\%' . col('.') . 'c' . a:pattern)]
        let matchline = search(a:pattern, 'W')
    endwhile

    call winrestview(view)
    return list
endfu

fu! myfuncs#populate_list(list, cmd) abort "{{{1
    if a:list is# 'quickfix'
        " The output of the shell command passed to `:PQ` must be recognized by Vim.
        " It must match a value in 'grepformat'.
        " Example:
        "         :PQ find /etc -name '*.conf'                    ✘
        "         :PQ grep -IRn foobar ~/.vim | grep -v backup    ✔
        cgetexpr systemlist(a:cmd)

        call setqflist([], 'a', { 'title': a:cmd })

    elseif a:list is# 'arglist'
        exe 'tab args '.join(map(filter(systemlist(a:cmd),
        \                        { i,v -> filereadable(v) }),
        \                    { i,v -> fnameescape(v) }))
        " enable item indicator in the statusline
        let g:my_stl_list_position = 1
    endif
    return ''
endfu

fu! myfuncs#remove_duplicate_lines(line1, line2, bang) abort "{{{1
    if !a:bang
        return 'echoer "Add a bang"'
    endif

    let view = winsaveview()

    " Iterate over the lines in the range, from the last one up to the first
    " one (to avoid having to take into account a change of address when a line
    " is deleted).
    " The goal of each iteration is to determine whether the line is unique,
    " and delete it when it's not.
    let p = a:line2
    while p > a:line1
        " Iterate over the lines from the first in the range, up to line `p`.
        " The goal of each iteration is to compare line `p` to a previous line.
        let q = a:line1
        while q < p
            if getline(p) is# getline(q)
                exe p.'d_' | break
            endif
            let q += 1
        endwhile
        let p -= 1
    endwhile

    call winrestview(view)
    return ''
endfu

fu! myfuncs#remove_tabs(line1, line2) abort "{{{1
    let view = winsaveview()
    call cursor(a:line1, 1)
    while search("\t", 'cW', a:line2)
        "              Why col('.')-1 and not col('.')?                                      ┐
        "              We want to know how many cells a tab would occupy if it was displayed │
        "              after the character which is BEFORE the cursor:     col('.')-1        │
        "              Not after the character which is AFTER the cursor:  col('.')          │
        "                                                                                    ├────────┐
        exe 'sil keepj keepp '.a:line1.','.a:line2.'s/\t/\=repeat(" ", strdisplaywidth("\t", col(".")-1))/e'
        "                                                                                                 │
        "                                                                               We can't use `g`. ┘
        "
        "                     Suppose there're several tabs on a line.
        "                     `strdisplaywidth()` will return the right number of cells for the
        "                     1st tab, but not for the next one.
        "                     Indeed, the width of the 2nd tab depends on the number of cells occupied
        "                     by the previous one. But the 1st substitution changed that number.
        "                     The solution is to never perform more than one substitution on any given line.
        "                     And repeat the substitution as many times as necessary.

        call cursor(a:line1, 1)
    endwhile
    call winrestview(view)
endfu

" repeat {{{1

" fu! myfuncs#repeat_set(sequence,...)
"     let g:repeat_sequence = a:sequence
"     let g:repeat_count = a:0 ? a:1 : v:count
"     let g:repeat_tick = b:changedtick
" endfu

" fu! myfuncs#repeat_dot(cnt)
"     try
"         if g:repeat_tick ==# b:changedtick
"             let c = g:repeat_count
"             let cnt = (a:cnt ? a:cnt : (c ? c : ''))
"             " No n flag, otherwise "\<plug>(...)" won't be interpreted as the
"             " {rhs} of the mapping (typed literally)
"             " FIXME: why the i flag?
"             " maybe in case there are commands after the one calling
"             " this function ; we want the "\<plug>(...)" to be typed immediately
"             " not after the remaining commands from the mapping
"             " still, hard time figuring out such a case...
"             call feedkeys(g:repeat_sequence, 'i')
"             " FIXME: why the n flag?
"             call feedkeys(cnt, 'ni')
"         else
"             " dot has been remapped as a call to this function
"             " but here it must be typed literally, not remapped to this
"             " function, otherwise we're stuck in a loop
"             " so we need the n flag
"             call feedkeys((a:cnt ? a:cnt : '') . '.', 'ni')
"         endif
"     catch /^Vim(normal):/
"         " It seems v:errmsg is not accessible from a function (undefined
"         " variable), so return 'echoerr ' . v:errmsg is not possible
"         return 'echoerr v:errmsg'
"     endtry
"     return ''
" endfu

" fu! myfuncs#repeat_wrap(command)
"     let sync_test = (g:repeat_tick ==# b:changedtick)
"     try
"         exe 'norm! ' . a:command . 'zv'
"     catch /.*/
"         return "echoerr 'E21: Cannot make changes, modifiable is off'"
"     endtry
"     if sync_test
"         let g:repeat_tick = b:changedtick
"     endif
"     return ''
" endfu

" let g:repeat_tick = -1
" augroup repeatPlugin
"     autocmd!
"     autocmd BufLeave,BufWritePre,BufReadPre * let g:repeat_tick = (g:repeat_tick ==# b:changedtick || g:repeat_tick ==# 0) ? 0 : -1
"     autocmd BufEnter,BufWritePost * if g:repeat_tick ==# 0|let g:repeat_tick = b:changedtick|endif
" augroup END

" nmap  .      <plug>(myfuncs_repeat_dot)
" nmap  u      <plug>(myfuncs_repeat_undo)
" nmap  U      <plug>(myfuncs_repeat_undo_line)
" nmap  <c-r>  <plug>(myfuncs_repeat_redo)

" nno  <silent>  <plug>(myfuncs_repeat_dot)        :<c-u>exe myfuncs#repeat_dot(v:count)<cr>
" nno  <silent>  <plug>(myfuncs_repeat_undo)       :<c-u>exe myfuncs#repeat_wrap('u')<cr>
" nno  <silent>  <plug>(myfuncs_repeat_undo_line)  :<c-u>exe myfuncs#repeat_wrap('U')<cr>
" nno  <silent>  <plug>(myfuncs_repeat_redo)       :<c-u>exe myfuncs#repeat_wrap("\<Lt>C-R>")<cr>

" retab {{{1

" Why do we need an :execute command in the 2nd case (spaces → tabs)?
" To ask for the evaluation of &ts before the substitution command is built.
" Why don't we need to put &ts outside of the string in the replacement part?
" Because it's inside an expression (\=), so Vim already knows it has to
" evaluate it, as well as len(submatch(0)).

fu! myfuncs#retab(line1, line2, bang) abort
    let view = winsaveview()
    if !a:bang
        exe 'sil keepj keepp '.a:line1.','.a:line2.'s:^\t\+:\=repeat(" ", &ts * len(submatch(0))):e'
    else
        exe 'sil keepj keepp '.a:line1.','.a:line2.'s:\v^( {'.&ts.'})+:\=repeat("\t", len(submatch(0))/&ts):e'
    endif
    call winrestview(view)
endfu

fu! myfuncs#search_internal_variables() abort "{{{1
    let view = winsaveview()

    let help_file = readfile($VIMRUNTIME.'/doc/eval.txt')
    call filter(help_file, { i,v -> v =~ '^\s*v:\S\+' })
    call map(help_file, { i,v -> matchstr(v, 'v:\zs\S\+') })
    call uniq(sort(help_file))

    call cursor(1,1)
    for var in help_file
        if search('let\s\+'.var.'\s', 'cnW')
            let addr = search('let\s\+'.var.'\s', 'cW')
            echom 'line '.addr
            echom var. ' is an internal variable'
            return
        endif
    endfor

    call winrestview(view)
endfu

fu! myfuncs#search_todo() abort "{{{1
    try
        sil exe 'lvim /\CFIX'.'ME\|TO'.'DO/j %'
        sil! call lg#motion#repeatable#make#set_last_used(']l', {'bwd': ',', 'fwd': ';'})
    catch
        echo 'no TO'.'DO or FIX'.'ME'
        return
    endtry

    "                                              ┌ Tweak the text of each entry when there's a line
    "                                              │ with just `todo` or `fixme`;
    "                                              │ replace it with the text of the next non empty line instead
    "                                              │
    call setloclist(0, map(getloclist(0), { i,v -> s:search_todo_text(v) }), 'r')
    call setloclist(0, [], 'a', { 'title': 'FIXME & TODO' })

    if &bt isnot# 'quickfix'
        return
    endif

    call qf#set_matches('myfuncs:search_todo', 'Conceal', 'location')
    call qf#set_matches('myfuncs:search_todo', 'Todo', '\cfixme\|todo')
    call qf#create_matches()
endfu

fu! s:search_todo_text(dict) abort
    let dict = a:dict
    " if the text only contains `fixme` or `todo`
    if dict.text =~? '\v\c%(fixme|todo):?\s*%(\{\{'.'\{)?\s*$'
        " get the text of the next line, which is not empty:
        "
        "     ^\s*$
        "
        " … and which doesn't contain only the comment character:
        "
        "     ^\s*#\s*$    (example in a bash buffer)
        let pat = '^\s*\V'.escape(get(split(getbufvar('#', '&l:cms', ''),
        \                                   '%s'),
        \                             0, ''),
        \                         '\')
        \                 .'\v\s*$|^\s*$'
        let dict.text = get(filter(
        \                          getbufline(bufnr('#'), dict.lnum + 1, dict.lnum + 3),
        \                          { i,v -> v !~ pat }
        \                  ), 0, '')
    endif
    return dict
endfu

fu! myfuncs#set_indent(indent) abort range "{{{1

    " When a function is called and a range is explicitly passed to it, the cursor
    " is automatically positioned before the first character of a:firstline.
    " So, we don't need to write:    call cursor(a:firstline, 1)

    " Initiate a loop. Each iteration processes a block of lines.
    " A block ends when we find a line which doesn't begin with at least 5 spaces.
    " The loop continues as long as there's a next line to process, and it's
    " before a:lastline.
    "
    " We use the 'c' flag because we could already be on a line to process.
    " When we'll come back here for the 2nd iteration, even though the 'c'
    " flag is there, and the current line will begin with at least 5 spaces
    " (since it was the last line to be processed during 1st iteration),
    " search() won't find the current line, because the cursor will be at the
    " end of the spaces, not at the beginning of the line.
    " search() will find the next line to process as expected.
    while search('^\s\{5}', 'cW') && line('.') <= a:lastline

        let offset                  = a:indent - strlen(matchstr(getline('.'), '^\s*'))
        let last_line_current_block = search('^\v(\s{5}|$)@!', 'nW') - 1
        let last_line_to_process    = min([last_line_current_block, a:lastline])

        exe 'keepj keepp .,'.last_line_to_process.'s/^\s\+/\=repeat(" ", strlen(submatch(0)) + '.offset.')/'

    endwhile

    call cursor(a:firstline, 1)
endfu

fu! myfuncs#show_me_snippets() abort "{{{1
    call UltiSnips#SnippetsInCurrentScope(1)
    if empty(g:current_ulti_dict)
        return
    endif
    new | exe 'resize '.(&columns/3)
    setl bh=wipe bt=nofile nobl nowrap noswf

    if !bufexists('snip cheat') | sil file snip\ cheat | endif

    sil 0put =map(sort(deepcopy(keys(g:current_ulti_dict))), { i,v -> v.' : '.g:current_ulti_dict[v] })
    sil $d_
    sil %EasyAlign 1 : { 'left_margin': '',  'right_margin': ' ' }
    sil %s/:/

    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>
    setl noma ro
    call matchadd('Identifier', '^\S\+\ze\s*', 0, -1)
endfu

" tmux_{current|last}_command {{{1

fu! myfuncs#tmux_current_command() abort
    if exists('s:pane_id')
        " When we  close the tmux  pane, `s:pane_id`  is not deleted  therefore, the
        " next time we invoke the function,  it won't split the window, thinking the
        " pane is still there.
        " We must make sure it's still open before going further.
        "                                                           ┌ eliminate trailing newline
        "                                                       ┌───┤
        let open_panes = split(system("tmux list-panes -F '#D'")[:-2])
        "                                               │   │
        "                                               │   └─ unique pane ID
        "                                               └─ format the output according to the following string
        let is_pane_still_open = index(open_panes, s:pane_id) >= 0
        if !is_pane_still_open
            sil call system('tmux kill-pane -t %'.s:pane_id)
            unlet! s:pane_id
        endif
    endif

    if !exists('s:pane_id')
        let s:pane_id = systemlist(
        \                           'tmux split-window -c $XDG_RUNTIME_DIR -d -p 25 -PF "#D"'
        \                         )[0]
    endif

    " The `-d`  in `tmux  split-window …`  means “do  NOT give  focus“, so
    " don't try to use `tmux last-pane`, there's no last pane.
    call system('tmux send-keys -t '.s:pane_id.' '.escape(getline('.'), ' |').' Enter;')
endfu

fu! myfuncs#tmux_last_command() abort
    update

    let cmds = [
    \            'last-pane',
    \            'send-keys C-l Up Enter',
    \            'last-pane',
    \          ]
    call system(join(map(cmds, { i,v -> 'tmux '.v.';' })))
endfu

" tmux-navigator {{{1

" OLD CODE:
" I don't like this code anymore. I frequently press `c-j` to go the next
" horizontal viewport, and this code made me go to a tmux pane instead.
" I don't know what was the idea/intention behind this code.
" Everything related to tmux is a mess anyway.
"
" TODO: Review these tmux-navigator functions.

" echo system('tmux -S /tmp/tmux-1000/default display-message -p "#{pane_current_command}"')

" fu! myfuncs#navigate(dir) abort
"     if !empty($TMUX)
"         call s:tmux_navigate(a:dir)
"     else
"         call s:vim_navigate(a:dir)
"     endif
" endfu

" fu! s:tmux_navigate(dir) abort
"     let x = winnr()
"     call s:vim_navigate(a:dir)
"     if winnr() ==# x
"         "                                       ┌ path to tmux socket
"         "                    ┌──────────────────┤
"         let cmd = 'tmux -S '.split($TMUX, ',')[0].' '.
"                     \ 'select-pane -' . tr(a:dir, 'hjkl', 'LDUR')
"         sil! call system(cmd)
"     endif
" endfu

" fu! s:vim_navigate(dir) abort
"     try
"         exe 'wincmd '.a:dir
"     catch
"         echohl ErrorMsg
"         echo 'E11: Invalid in command-line window; <cr> executes, CTRL-C quits: wincmd ' . a:dir
"         echohl None
"     endtry
" endfu

fu! myfuncs#tab_toc() abort "{{{1
    if index(['help', 'man', 'markdown'], &ft) ==# -1
        return
    endif

    let patterns = {
    \                'man'      : '\S\zs',
    \                'markdown' : '\v^%(#+)?\S.\zs',
    \                'help'     : '\S\ze\*$\|^\s*\*\zs\S',
    \              }

    let syntaxes = {
    \                'man'      : 'heading\|title',
    \                'markdown' : 'markdownH\d\+',
    \                'help'     : 'helpHyperTextEntry\|helpStar',
    \              }

    let toc = []
    for l:lnum in range(1, line('$'))
        let col = match(getline(l:lnum), patterns[&ft])
        if col != -1 && synIDattr(synID(l:lnum, col, 0), 'name') =~? syntaxes[&ft]
            let text = substitute(getline(l:lnum), '\s\+', ' ', 'g')
            call add(toc, {'bufnr': bufnr('%'), 'lnum': l:lnum, 'text': text})
        endif
   endfor

    " Why do we call `setloclist()` 2 times? {{{

    " To set the title of the location window, we must pass the dictionary
    " `{'title': 'TOC' }` as a fourth argument to `setloclist()`.
    " But when we pass a fourth argument, the list passed as a 2nd argument is
    " ignored. No item in this list will populate the location list.
    "
    " So, the purpose of the first call to `setloclist()` is to populate the
    " location list.
    " The purpose of the second call is to set the title of the location
    " window.
    "
    " In the 2nd call, the empty list and the `a` flag are not important.
    " We could replace them with resp. any list and the `r` flag, for example.
    " But we choose the empty list `[]` and the `a` flag, because it makes the
    " code more readable. Indeed, since we only set the title of the window,
    " and nothing in the list changes, it's as if we were adding/appending an
    " empty list.
    "
    "}}}
    call setloclist(0, toc)
    call setloclist(0, [], 'a', { 'title': 'TOC' })

    let is_help_file = &bt is# 'help'

    " The width of the current window is going to be reduced by the TOC window.
    " Long lines may be wrapped. I don't like wrapped lines.
    setl nowrap
    doautocmd <nomodeline> QuickFixCmdPost lgrep

    if &bt isnot# 'quickfix'
        return
    endif

    if is_help_file
        call qf#set_matches('myfuncs:tab_toc', 'Conceal', '\*')
        call qf#create_matches()
    endif
endfu

" trans {{{1

" TODO:
" add `| C-t` mapping, to replay last text

"                 ┌─ the function is called for the 1st time;
"                 │  if the text is too long for `trans`, it will be
"                 │  split into chunks, and the function will be called
"                 │  several times
"                 │
fu! myfuncs#trans(first_time, ...) abort
    let s:trans_tempfile = tempname()

    if a:first_time
        let text = a:0 ? s:trans_grab_visual() : expand('<cword>')
        "          │
        "          └─ visual mode

        let s:trans_chunks = split(text, '\v.{100}\zs[.?!]')
        "                                     │
        "                                     └─ split the text into chunks of around 100 characters
    endif

    " remove characters which cause issue during the translation
    let garbage = '\v"|`|*'.(!empty(&l:cms) ? '|'.split(&l:cms, '%s')[0] : '')
    let chunk   = substitute(s:trans_chunks[0], garbage, '', 'g')

    " reduce excessive whitespace
    let chunk   = substitute(chunk, '\s\+', ' ', 'g')

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
    \                             '/bin/bash',
    \                             '-c',
    \
    \                             'trans -brief -speak'
    \                                 .' -t '.get(s:, 'trans_target', 'fr')
    \                                 .' -s '.get(s:, 'trans_source', 'en')
    \                                 .' '.shellescape(chunk),
    \                           ]
    \                             , opts)

    " remove it from the list of chunks
    call remove(s:trans_chunks, 0)
endfu

fu! s:trans_buffer(cmd) abort
    let view = winsaveview()

    belowright 10split
    setl bh=wipe bt=nofile
    setl nobl noma noswf nowrap ro
    if !bufexists('translation') | sil file translation | else | return -1 | endif

    exe winnr('#').'windo call winrestview(view)'
    nno  <buffer><nowait><silent>  <c-c>  :<c-u>call myfuncs#trans_stop()<cr>
    let bufnum = bufnr('%')
    wincmd p
    return bufnum
endfu

fu! myfuncs#trans_cycle() abort
    let s:trans_target = { 'fr' : 'en', 'en' : 'fr' }[get(s:, 'trans_target', 'fr')]
    let s:trans_source = { 'fr' : 'en', 'en' : 'fr' }[get(s:, 'trans_source', 'en')]
    echo '[trans] '.s:trans_source." \u2192 ".s:trans_target
endfu

fu! s:trans_grab_visual() abort
    let [ l1, l2 ] = [ line("'<"), line("'>") ]
    let [ c1, c2 ] = [ col("'<"),  col("'>)") ]

    " single line visual selection
    if l1 ==# l2
        let text = matchstr(getline(l1), '\v%'.c1.'c.*%'.c2.'c.?\ze.*$')
    else
        " multi lines
        let first  = matchstr(getline(l1), '\v%'.c1.'c.*$')
        let last   = ' '.matchstr(getline(l2), '\v^.{-}%'.c2.'c.?')
        let middle = (l2 - l1) > 1 ? ' '.join(getline(l1+1,l2-1), ' ') : ''

        let text = first.middle.last
    endif
    return text
endfu
" pyrolysis

fu! s:trans_output(job,exit_status) abort
    if a:exit_status ==# -1
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

fu! myfuncs#trans_stop() abort
    " FIXME:
    " Start a new Vim instance and hit `!T` on a word:
    "         E121: Undefined variable: s:trans_job
    call job_stop(s:trans_job)
endfu

fu! myfuncs#unicode_table() abort "{{{1
    UnicodeTable
    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>
endfu

" unicode_toggle {{{1

fu! myfuncs#unicode_toggle(line1, line2) abort
    let view  = winsaveview()
    let range = a:line1.','.a:line2
    let mods  = 'keepj keepp '

    call cursor(a:line1, 1)
    " replace  '\u0041'  with  'A'
    " or       '…'       with  '\u2026'
    "
    " `char2nr(submatch(0))` =
    "         decimal  code point of a character who  is not in the extended ascii table.
    "
    " `printf('\u%x')` =
    "         string '\u1234'
    "         where `1234` is the conversion of the decimal code point into hexa
    let [ pat, l:Rep ] = search('\\u\x\+', 'nW', a:line2)
    \?                       [ '\\u\x\+'      , { -> eval('"'.submatch(0).'"') } ]
    \
    \:                       [ '[^\x00-\xff]' ,
    \                          { -> printf(
    \                                      char2nr(submatch(0)) <= 65535
    \                                      ?    '\u%x'
    \                                      :    '\U%x',
    \                                      char2nr(submatch(0))
    \                                     )
    \                          }
    \                        ]
    sil exe mods.range.'s/'.pat.'/\=l:Rep()/ge'
    call winrestview(view)
endfu

fu! s:vim_parent() abort "{{{1
    " getpid()
    "
    "     return the PID of Vim
    "
    " ps -p <Vim PID> -o ppid=
    "
    "     display the PID of the parent of Vim
    "
    " ps -p $(…) -o comm=
    "
    "     display the name of the parent of Vim

    return expand('`ps -p $(ps -p '.getpid().' -o ppid=) -o comm=`')
endfu

fu! myfuncs#webpage_read(url) abort "{{{1
    let tempfile = tempname()
    exe 'tabe '.tempfile
    sil! exe 'read !w3m -cols 100 '.shellescape(a:url, 1)
    setl bh=wipe nobl bt=nofile noswf nowrap
endfu

fu! myfuncs#word_frequency(line1, line2, ...) abort "{{{1
    let flags  = {
    \              'min_length' : matchstr(a:1, '-min_length\s\+\zs\d\+'),
    \              'weighted'   : stridx(a:1, '-weighted') != -1,
    \            }

    let view       = winsaveview()
    let words      = split(join(getline(a:line1, a:line2), "\n"), '\v%(%(\k@!|\d).)+')
    let min_length = !empty(flags.min_length) ? flags.min_length : 4

    " remove anything which is:
    "
    "     • shorter than `min_length` characters
    "
    "     • longer than 30 characters;
    "       probably not words;
    "       it  could be  for example  a long  sequence of  underscores used  to
    "       divide 2 sections of text
    "
    "     • not containing any letter

    call filter(words, { i,v -> strchars(v) >= min_length && strchars(v) <= 30 && v =~ '\a' })

    " put all of them in lowercase
    call map(words, { i,v -> tolower(v) })

    let freq = {}
    for word in words
        let freq[word] = get(freq, word, 0) + 1
    endfor

    if flags.weighted

        " `abbrev_length` is the length of an abbreviation we could create for
        " a given word. Its value depends on the word:
        "
        "   • if the word is 4 characters long, then the abbreviation should be
        "     2 characters long,
        "
        "   • if the word ends with an 's', and the same word, without the ending
        "     's', is also present, then the abbreviation should be 4 characters
        "     long (because it's probably a plural),
        "
        "   • otherwise, by default, an abbreviation should be 3 characters long

        let abbrev_length = '(
        \                        strchars(v:key) ==# 4
        \                      ?     2
        \                      : v:key[-1:-1] is# "s" && index(keys(freq), v:key[:strlen(v:key)-1]) >= 0
        \                      ?     4
        \                      :     3
        \                    )'

        let weighted_freq = deepcopy(freq)
        call map(weighted_freq, { k,v -> v * (strchars(k) - abbrev_length) })
        let weighted_freq = sort(items(weighted_freq), {a, b -> b[1] - a[1]})
    endif

    " put the result in a vertical viewport
    vnew
    setl bh=wipe nobl bt=nofile noswf

    " for item in items(freq)
    for item in flags.weighted ? weighted_freq : items(freq)
        call append('$', join(item))
    endfor

    if !bufexists('WordFrequency') | sil file WordFrequency | endif
    " format output into aligned columns
    " We don't need to delete the first empty line, `column` doesn't return it.
    " Probably because there's nothing to align in it.
    sil! %!column -t
    sil! %!sort -rn -k2

    exe 'vert res '.(max(map(getline(1, '$'), { i,v -> strchars(v) }))+4)

    nno  <buffer><nowait><silent>  q  :<c-u>close<cr>
    setl noma ro
    exe winnr('#').'windo call winrestview(view)'
endfu

fu! myfuncs#wf_complete(arglead, _c, _p) abort
    " Why not filtering the candidates?{{{
    "
    " We don't need to, because the command invoking this completion function is
    " defined with the attribute `-complete=custom`, not `-complete=customlist`,
    " which means Vim performs a basic filtering automatically:
    "
    "     • each event must begin with `a:arglead`
    "     • the comparison respects 'ic' and 'scs'
    " }}}
    return join(['-min_length', '-weighted'], "\n")
endfu

fu! myfuncs#xor_lines(bang) abort range "{{{1
    if exists('w:xl_match')
        call matchdelete(w:xl_match)
        unlet w:xl_match
    endif

    if a:bang
        return
    endif

    " Get some info: ln1/ln2       = line numbers
    "                l1/l2         = lines
    "                chars1/chars2 = lists of characters
    "
    " If a:firstline = a:lastline, it means :XorLines was called without a range
    if a:firstline ==# a:lastline
        let [ln1, ln2] = [line('.'), line('.')+1]
    else
        let [ln1, ln2] = [a:firstline, a:lastline]
    endif
    let [l1, l2] = [getline(ln1), getline(ln2)]
    let [chars1, chars2] = [split(l1, '\zs'), split(l2, '\zs')]
    let min_chars = min([len(chars1), len(chars2)])

    " Build a pattern matching the characters which are different
    let pattern = ''
    for i in range(min_chars)
        if chars1[i] isnot# chars2[i]

            " FIXME: for some reason, we need to write a dot at the end of each
            " branch of the pattern, so we add 'v.' at the end instead of just 'v'.
            " The problem seems to come from :lvim and the g flag.
            "
            " MWE:    :lvim /\v%1l%2v/g %
            " … adds 2 duplicate entries in the location list instead of one.
            "
            "               :lvim /\v%1l%2v|%1l%3v/g %
            " … adds 2 duplicate entries in the location list, 3 in total instead of two.
            "
            "               :lvim /\v%1l%2v|%1l%4v/g %
            " … adds 2 couple of duplicate entries in the location list, 4 in total instead of two.
            " It seems each time a `%{digit}v` anchor matches the beginning of a group
            " of consecutive characters, it adds 2 duplicate entries instead of one.

            let pattern .= (empty(pattern) ? '' : '\|').'\%'.ln1.'l'.'\%'.(i+1).'v.'
            let pattern .= (empty(pattern) ? '' : '\|').'\%'.ln2.'l'.'\%'.(i+1).'v.'
        endif
    endfor

    " If one of the lines is longer than the other, we have to add its end in
    " the pattern.
    if len(chars1) > len(chars2)

        " Suppose that the shortest line has 50 characters:
        " it's better to write `\%>50v.` than `\%50v.*`.
        "
        " `\%>50v.` = any character after the 50th character:
        "             this will add one entry in the loclist for EVERY character
        "
        " `\%50v.*` = the WHOLE set of characters after the 50th:
        "             this will add only ONE entry in the loclist

        let pattern .= (!empty(pattern) ? '\|' : '').'\%'.ln1.'l'.'\%>'.len(chars2).'v.'

    elseif len(chars1) < len(chars2)
        let pattern .= (!empty(pattern) ? '\|' : '').'\%'.ln2.'l'.'\%>'.len(chars1).'v.'
    endif

    " Give the result
    if !empty(pattern)
        exe 'lvim /'.pattern.'/g %'
        let w:xl_match = matchadd('SpellBad', pattern, -1)
    else
        echohl WarningMsg
        echom 'Lines are identical'
        echohl None
    endif
endfu
