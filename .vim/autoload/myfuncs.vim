fu! myfuncs#after_tmux_capture_pane() abort "{{{1
    " Purpose:{{{
    "
    " This function is called by a tmux key binding.
    "
    " It makes tmux copy the contents of the pane, from the start of the history
    " down to the end of the visible pane, in a tmux buffer.
    " Then, it makes Nvim read this tmux buffer.
    "
    " If you create a new tmux window and run `$ ls ~`, the tmux buffer contains
    " a lot of empty lines at the bottom; we don't want them.
    "
    " Besides, the tmux buffer contains a lot of trailing whitespace, because we
    " need to pass `-J` to `capture-pane`; we don't want them either.
    "
    " This function  tries to remove  all trailing whitespace, and  all trailing
    " empty lines at the end of the Nvim buffer.
    "
    " ---
    "
    " Also, it tries to  ease the process of copying text  in Nvim, then pasting
    " it in the shell; see the one-shot autocmd at the end.
    "}}}

    " do not syntax highlight as a conf file, if one of the first lines begins with `#`
    syn off
    " Unfold everything, otherwise the next `delete` command may delete too many lines.{{{
    "
    " To see the issue, without `norm! zR`, press `pfx /` after `$ cat ~/.zshrc`,
    " then press `u` in Nvim.
    "}}}
    norm! zR
    TW
    $
    call search('^\S', 'b')
    sil! keepj keepp .,$g/^\s*$/d_

    " We need the buffer to be saved into a file, for `:lvim /pat/ %` to work.
    let tempfile = tempname()
    sil exe 'sav '..tempfile

    let pat_cmd = '\m\C/MSG\s\+.\{-}XDCC\s\+SEND\s\+\d\+'
    " Format the buffer if it contains commands to downloads files via xdcc.{{{
    "
    " Remove noise.
    " Conceal xdcc commands.
    " Highlight filenames.
    " Install mappings to copy the xdcc command in the clipboard.
    "}}}
    " Why `!search('│')`?{{{
    "
    " The code will work  best after we have pressed our  WeeChat key binding to
    " get a bare display (`M-r` atm), where “noise” has been removed.
    " Indeed, with  noise, some xdcc commands  can't be copied in  one pass, but
    " only in two.
    " So,  if we're  not  in  a bare  window,  I don't  want  to  get the  false
    " impression that the buffer can be interacted with reliably.
    "}}}
    if search(pat_cmd) && !search('│')
        call s:format_xdcc_buffer(pat_cmd)
    elseif search('^٪.\+')
        call s:format_shell_buffer()
    endif

    " Why ?{{{
    "
    " We already have a similar autocmd in our vimrc.
    " I don't want it to interfere.
    " I don't want a race condition where the winning `xclip(1)` process is the last one.
    " It's probably unnecessary but better be safe than sorry.
    "}}}
    au! make_clipboard_persist_after_quitting_vim
    " Do *not* use the pattern `<buffer>`!{{{
    "
    " Atm, we open the qf window.
    " If you use `<buffer>`, the autocmd would be installed for the qf buffer.
    " But if we copy some text, it will probably be in the other buffer.
    " Anyway, no matter the buffer where we copy some text, we want it in xclip.
    "}}}
    au VimLeave * ++once
        \   if executable('xclip') && strlen(@+) != 0 && strlen(@+) <= 999
        \ |     sil call system('xclip -selection clipboard', @+)
        \ | endif
endfu

fu! s:format_shell_buffer() abort
    " we want to be able to repeat `]l` right from the start
    do <nomodeline> CursorHold
    let pat = '^٪.\+'
    " Why the priority 0?{{{
    "
    " To allow  a search to highlight  text even if it's  already highlighted by
    " this match.
    "}}}
    call matchadd('Statement', pat, 0)
    sil exe 'lvim /'..pat..'/j %'
    " the location list window is automatically opened by one of our autocmds;
    " conceal the location
    call qf#set_matches('after_tmux_capture_pane:format_shell_buffer', 'Conceal', 'location')
    call qf#create_matches()
endfu

fu! s:format_xdcc_buffer(pat_cmd) abort
    " remove noise
    exe 'sil keepj keepp v@'..a:pat_cmd..'@d_'
    sil keepj keepp %s/^.\{-}\d\+)\s*//e
    sil update

    " highlight filenames
    let pat_file = '\d\+x\s*|\s*[0-9.KMG]*\s*|\s*\zs\S*'
    call matchadd('Underlined', pat_file)

    " conceal commands
    call matchadd('Conceal', a:pat_cmd..'\s*|\s*')
    setl cole=3 cocu=nc

    " make filenames interactive{{{
    "
    " You don't need  `"+y`.
    " `y` is enough, provided that the next one-shot autocmd is installed.
    "}}}
    nno <buffer><nowait><silent> <cr> :<c-u>call <sid>copy_cmd_to_get_file_via_xdcc()<cr>
    nmap <buffer><nowait><silent> ZZ <cr>

    " let us jump from one filename to another by pressing `n` or `N`
    let @/ = pat_file
endfu

fu! s:copy_cmd_to_get_file_via_xdcc() abort
    let line = getline('.')
    let msg = matchstr(line, '\m\C/MSG\s\+\zs.\{-}XDCC\s\+SEND\s\+\d\+')
    " What is this `moviegods_send_me_file`?{{{
    "
    " A WeeChat alias.
    " If it doesn't exist, you can install it by running in WeeChat:
    "
    "     /alias add moviegods_send_me_file /j #moviegods ; /msg
    "}}}
    "   Why do you use an alias?{{{
    "
    " I don't join `#moviegods` by default, because it adds too much network traffic.
    " And a `/msg ... xdcc send ...` command doesn't work if you haven't joined this channel.
    " IOW, we need to run 2 commands:
    "
    "     /j #moviegods
    "     /msg ... xdcc send ...
    "
    " But, in the end, we will only be able to write one in the clipboard.
    " To fix  this issue, we  need to build a  command-line which would  run two
    " commands.
    "
    " An alias allows you to use the `;` token which has the same meaning as in a shell.
    " With it, you can do:
    "
    "     cmd1 ; cmd2
    "}}}
    let cmd = '/moviegods_send_me_file '..msg
    let @+ = cmd
    q!
endfu

fu! myfuncs#align_with_beginning(type) abort "{{{1
    exe 'left '.indent(line('.')+s:align_with_beginning_dir)
endfu

fu! myfuncs#align_with_end(type) abort
    " length of text to align on the current line
    let text_length = strchars(matchstr(getline('.'), '\S.*$'))
    " length of the previous/next line
    let neighbour_length = strchars(getline(line('.') + s:align_with_end_dir))
    exe 'left ' . (neighbour_length - text_length)
endfu

fu! myfuncs#align_with_beginning_save_dir(dir) abort
    let s:align_with_beginning_dir = a:dir
endfu

fu! myfuncs#align_with_end_save_dir(dir) abort
    let s:align_with_end_dir = a:dir
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
    let reg_save = ['z', getreg('z'), getregtype('z')]
    try
        let @z = ''

        let mods  = 'keepj keepp'
        let range = (a:type is# 'char' || a:type is# 'line')
                \ ?     line("'[").','.line("']")
                \ :     line("'<").','.line("'>")

        let cmd = s:yank_where_match ? 'g' : 'v'
        let pat = s:yank_comments
              \ ?     '^\s*\C\V'.escape(get(split(&l:cms, '\s*%s\s*'), 0, ''), '\')
              \ :     @/

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

    catch
        return lg#catch_error()

    finally
        call call('setreg', reg_save)
    endtry
endfu

fu! myfuncs#block_select_box() abort "{{{1
" this function selects an ascii box that we drew with our `draw-it` plugin
    let view = winsaveview()
    let guard = 0

    " find the upper-left corner of the box
    while guard < 99
        " search an underscore, to try to position the cursor on the first
        " line of the box
        call search('_', 'bW')
        " if we're on the first line of the box:
        "         __________
        "                  ^
        " ... then `bhj` should position us on the first `|` character of the box
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
    "            ┌ original line is before the box
    "            │
    if view.lnum < line("'<") || view.lnum > line("'>")
    "                                      │
    "                                      └ original line is after the box
        exe "norm! \e"
        call winrestview(view)
    endif
endfu

" block_select_paragraph {{{1

" This function should try to select a box containing the current paragraph.
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
        let [firstline, firstcol] = searchpos('\S')
        " search the end of the text in the current paragraph
        let lastline = search('\n\s*\n', 'nW')
        let lastcol = searchpos('.*\zs\S\s*' ,'nW')[1]

        " search the longest line in the paragraph;
        " iterate over the lines in the latter
        for line in range(firstline, lastline)
            +
            " if a line in the paragraph is longer than the previous value of
            " `lastcol`, update the latter
            let lastcol = searchpos('.*\zs\S\s*' ,'nW')[1] > lastcol
                      \ ?     searchpos('.*\zs\S\s*' ,'nW')[1]
                      \ :     lastcol
        endfor

        " execute the command which will select a block containing the paragraph
        return (firstline - 2)."G".(firstcol - 2)."|"
             \ ."\<c-v>"
             \ .(lastcol + 2)."|".(lastline + 1)."G"

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
fu! myfuncs#box_create(type, ...) abort
    try
        " draw `|` on the left of the paragraph
        exe "norm! _vip\<c-v>^I|"
        " draw `|` on the right of the paragraph
        norm! gv$A|

        " align all (*) the pipe characters (`|`) inside the current paragraph
        let range = line("'[").','.line("']")
        sil exe range.'EasyAlign *|'

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
                exe 'norm! '.i.'G'.j.'|r│'
            endfor
        endfor

        call s:box_create_separations()
    catch
        return lg#catch_error()
    endtry
endfu

fu! s:box_create_border(where, col_pos) abort
    let col_pos = a:col_pos

    if a:where is# 'top'
        " duplicate first line in the box
        norm! '{+yyP
        " replace all characters with `─`
        exe 'norm! v$r─'
        " draw corners
        exe 'norm! '.col_pos[0].'|r┌'.col_pos[-1].'|r┐'
    else
        " duplicate the `┌────┐` border below the box
        t'}-
        " draw corners
        exe 'norm! '.col_pos[0].'|r└'.col_pos[-1].'|r┘'
    endif

    " draw the '┬' or '┴' characters:
    for pos in col_pos[1:-2]
        exe 'norm! '.pos.'|r'.(a:where is# 'top' ? '┬' : '┴')
    endfor
endfu

fu! s:box_create_separations() abort
    " Create a separation line, such as:
    "
    "     |    |    |    |
    "
    " ... useful to make our table more readable.
    norm! '{++yyp
    keepj keepp sil! s/[^│┼]/ /g

    " Delete it in the `s` (s for space) register, so that it's stored inside
    " default register and we can paste it wherever we want.
    delete s

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

fu! myfuncs#box_destroy(type) abort
    let [lnum1, lnum2] = [line("'{"), line("'}")]
    let range = lnum1.','.lnum2
    " remove box (except pretty bars: │)
    sil exe range.'s/[─┴┬├┤┼└┘┐┌]//ge'

    " replace pretty bars with regular bars
    " necessary, because we will need them to align the contents of the
    " paragraph later
    sil exe range.'s/│/|/ge'

    " remove the bars at the beginning and at the end of the lines
    " we don't want them, because they would mess up the creation of a box
    " later
    sil exe range.'s/|//e'
    sil exe range.'s/.*\zs|//e'

    " trim whitespace
    sil! exe range.'TW'
    " remove empty lines
    sil! exe range.'-g/^\s*$/d_'

    call append(lnum1-1, [''])

    " position the cursor on the upper left corner of the paragraph
    exe 'norm! '.lnum1.'Gj_'
endfu

fu! myfuncs#diff_lines(bang, line1, line2, option) abort "{{{1
    if a:option is# '-h' || a:option is# '--help'
        echo printf("%s\n\nusage:\n    %s\n    %s\n    %s\n\n%s",
        \ ':DiffLines allows you to see and cycle through the differences between 2 lines',
        \ ':5,10DiffLines    diff between lines 5 and 10',
        \ ':DiffLines        diff between current line and next one',
        \ ':DiffLines!       clear the match',
        \ 'The differences are in the location list (press [l, ]l, [L, ]L to visit them)',
        \ )
        return
    endif

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
    " If a:line1 = a:line2, it means :XorLines was called without a range
    if a:line1 ==# a:line2
        let [ln1, ln2] = [line('.'), line('.')+1]
    else
        let [ln1, ln2] = [a:line1, a:line2]
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
            " ... adds 2 duplicate entries in the location list instead of one.
            "
            "               :lvim /\v%1l%2v|%1l%3v/g %
            " ... adds 2 duplicate entries in the location list, 3 in total instead of two.
            "
            "               :lvim /\v%1l%2v|%1l%4v/g %
            " ... adds 2 couple of duplicate entries in the location list, 4 in total instead of two.
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
        " Why silent?{{{
        "
        " If the  lines are long, `:lvim`  will print a long  message which will
        " cause a hit-enter prompt:
        "
        "     (1 of 123): ...
        "}}}
        sil noa exe 'lvim /'.pattern.'/g %'
        " d_opts = [{'on_stderr': function('<SNR>129_system_handler')}, {'stderr': '', 'on_exit': function('<SNR>129_system_handler'), 'on_stdout': function('<SNR>129_system_handler'), 'exit_code': 0, 'stdout': '', 'on_stderr': function('<SNR>129_system_handler')}]
        " d_opts = [{'on_stderr': function('<SNR>129_system_handler')}]
        let w:xl_match = matchadd('SpellBad', pattern, -1)
    else
        echohl WarningMsg
        echom 'Lines are identical'
        echohl None
    endif
endfu

fu! myfuncs#dump_wiki(url) abort "{{{1
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
        let url = substitute(a:url, '/$', '', '').'.wiki'
        let tempdir = substitute(tempname(), '\v.*/\zs.{-}', '', '')
        sil call system('git clone '.shellescape(url).' '.tempdir)
        let files = glob(tempdir.'/*', 0, 1)
        call map(files, {_,v -> substitute(v, '^\C\V'.tempdir.'/', '', '')})
        call filter(files, {_,v -> v !~# '\v\c_?footer%(.md)?$'})

        mark x
        call append('.', files+[''])
        exe 'norm! '.(len(files)+1).'j'
        mark y

        sil keepj keepp 'x+,'y-s/^/# /
        sil keepj keepp 'x+,'y-g/^./exe 'keepalt r '.tempdir.'/'.getline('.')[2:]
        sil keepj keepp 'x+,'y-g/^=\+\s*$/d_ | -s/^/## /
        sil keepj keepp 'x+,'y-g/^-\+\s*$/d_ | -s/^/### /
        sil keepj keepp 'x+,'y-s/\v^#.{-}\n\zs\s*\n\ze##//

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

fu! s:gtfo_init() abort
    let s:IS_TMUX = !empty($TMUX)
    " terminal Vim running within a GUI environment
    let s:IS_X_RUNNING = !empty($DISPLAY) && $TERM isnot# 'linux'
    let s:LAUNCH_TERM  = 'urxvt -cd'
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
    if s:IS_TMUX
        sil call system('tmux splitw -h -c '.string(a:dir))
    elseif s:IS_X_RUNNING
        sil call system(s:LAUNCH_TERM.' '.shellescape(a:dir).' &')
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
    sil let output = systemlist('diff -U $(wc -l < '.fileA.') '.fileA.' '.fileB." | grep '^-' | sed 's/^-//g'")

    call map(output, {_,v -> {'text': v}})
    call setloclist(0, output)
    call setloclist(0, [], 'a', {'title': 'in  '.fileA.'  but not in  '.fileB})

    do <nomodeline> QuickFixCmdPost lopen
    call qf#set_matches('myfuncs#in_A_not_in_B', 'Conceal', 'double_bar')
    call qf#create_matches()
endfu

fu! myfuncs#join_blocks(first_reverse) abort "{{{1
    let [line1, line2] = [line("'<"), line("'>")]

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

        sil exe mods . range_second_block . "s/^/\<c-a>/e"
        sil exe mods . range_first_block  . 'g/^/' . (end_first_block + 1) . 'm.|-j'

        sil exe "*!column -s '\<c-a>' -t"

    catch
        return lg#catch_error()
    finally
        let &l:fen = fen_save
    endtry
endfu

fu! myfuncs#long_data_join(type, ...) abort "{{{1
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
            let range = line("'[").','.line("']")
        elseif a:type is# 'vis'
            let range = line("'<").','.line("'>")
        else
            return
        endif

        let bullets = '[-*+]'
        let join_bulleted_list = getline('.') =~# '^\s*'.bullets

        if join_bulleted_list
            sil exe 'keepj keepp'.range.'s/^\s*\zs'.bullets.'\s*//'
            sil exe 'keepj keepp'.range.'-s/$/,/'
            sil exe range.'j'
        else
            sil exe 'keepj keepp '.range.'s/\n\s*\\//ge'
            call cursor(a:type is# 'vis' ? line("'<") : line("'["), 1)
            sil keepj keepp s/\m\zs\s*,\ze\s\=[\]}]//e
        endif
    catch
        return lg#catch_error()
    endtry
endfu

fu! myfuncs#long_data_split(type, ...) abort "{{{1
    let line = getline('.')

    let is_list_or_dict = match(line, '\m\[.*\]\|{.*}') > -1
    let has_comma = stridx(line, ',') > -1
    if is_list_or_dict
        let data_indent = repeat(' ', match(line, '\m[[{].*[\]}]$'))
        " If the  first item in the  list/dictionary begins right after  the opening
        " symbol (`[` or `{`), add a space:
        sil keepj keepp s/\m[\[{]\s\@!\zs/ /e
        " Move the first item in the list on a dedicated line.
        sil keepj keepp s/\m[\[{]\zs/\="\n".data_indent."\\"/e
        " split the data
        sil keepj keepp s/,\zs/\="\n".data_indent.'\'/ge
        " move the closing symbol on a dedicated line
        sil keepj keepp s/\m\zs\s\=\ze[\]}]/\=",\n".data_indent."\\ "/e

    elseif has_comma
        " We use `strdisplaywidth()` because the indentation could contain tabs.
        let indent_lvl = strdisplaywidth(matchstr(line, '.\{-}\ze\S'))
        let indent_txt = repeat(' ', indent_lvl)
        sil keepj keepp s/\m\ze\S/- /e
        let pat = '\m\s*,\s*\%(et\|and\s\+\)\=\|\s*\<\%(et\|and\)\>\s*'
        let l:Rep = {-> "\n".indent_txt.'- '}
        sil exe 'keepj keepp s/'.pat.'/\=l:Rep()/ge'
    endif
endfu

fu! myfuncs#only_selection(lnum1,lnum2) abort "{{{1
    let lines = getline(a:lnum1,a:lnum2)
    keepj sil %d_
    call setline(1, lines)
endfu

" OPERATORS {{{1
fu! myfuncs#op_grep(type, ...) abort "{{{2
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

        let cmd = 'rg 2>/dev/null --vimgrep -i -L ' . (a:0 ? a:1 : @")
        let use_loclist = a:0 ? a:2 : 0
        if a:type is# 'Ex' && use_loclist
            " Why `:lgetexpr` instead of `:lgrep!`?{{{
            "
            " The latter shows us the output of the shell command (`$ ag ...`).
            " This makes the screen “flash”, which is distracting.
            "
            " `:lgetexpr` executes the shell command silently.
            "}}}
            sil lgetexpr system(cmd)
            call setloclist(0, [], 'a', {'title': cmd})
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
            "                         ; is special             % is special
            "                         on shell's               on Vim's
            "                         command-line             command-line
            "    ┌───────────────────┬──────────┬─────────────┬────────────┐
            "    │         @"        │  foo;ls  │  that's     │  foo%bar   │
            "    ├───────────────────┼──────────┼─────────────┼────────────┤
            "    │ fnameescape(@")   │  foo;ls  │  that\'s    │  foo\%bar  │
            "    ├───────────────────┼──────────┼─────────────┼────────────┤
            "    │ shellescape(@")   │ 'foo;ls' │ 'that'\''s' │ 'foo%bar'  │
            "    ├───────────────────┼──────────┼─────────────┼────────────┤
            "    │ shellescape(@",1) │ 'foo;ls' │ 'that'\''s' │ 'foo\%bar' │
            "    └───────────────────┴──────────┴─────────────┴────────────┘
            "
            " `fnameescape()` would not protect `;`.
            " The  shell  would  interpret  the  semicolon as  the  end  of  the
            " `grep(1)` command, and would execute the rest as another command.
            " This can be dangerous:
            "
            "     foo;rm -rf
            "
            " Conclusion:
            " When you have a command whose arguments can contain special characters,
            " and you want to protect them from:
            "
            "    - Vim       use `fnameescape(...)`
            "    - the shell use `shellescape(...)`
            "    - both      use `shellescape(..., 1)`
            "                                     │
            "                                     └ only needed after a `:!` command; not in `system(...)`
            "                                       `:!` is the only command to remove the backslashes
            "                                       added by the 2nd non-nul argument
            "
            "                             MWE:
            "                             :sp /tmp/foo\%bar
            "                             :sil call system('echo '.shellescape(expand('%')).' >>/tmp/log')
            "                             :sil call system('echo '.shellescape(expand('%'),1).' >>/tmp/log')
            "
            "                                       $ cat /tmp/log
            "                                           /tmp/foo%bar
            "                                           /tmp/foo\%bar
            "                                                   ^
            "
            " ---
            "
            " Update:
            " If the argument  which can contain special characters  is the name
            " of  the current  file,  you  can use  the  filename modifier  `:S`
            " instead of `shellescape(..., 1)`.
            " It's less verbose.
            " `:S` must be the last modifier, and it can work with other special
            " characters such as `#` or `<cfile>`.
            "}}}
            sil cgetexpr system(cmd)
            call setqflist([], 'a', {'title': cmd})
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
fu! s:trimws_ml(s) abort
    return substitute(a:s, '\v^\_s*(.{-})\_s*$', '\1', '')
endfu

" op_toggle_alignment {{{2

fu! s:is_right_aligned(line1, line2) abort
    let first_non_empty_line = search('\S', 'cnW', a:line2)
    let length               = strlen(getline(first_non_empty_line))
    for line in getline(a:line1, a:line2)
        if strlen(line) !=# length && line !~# '^\s*$'
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
" }}}1
fu! myfuncs#plugin_install(url) abort "{{{1
    let pattern =  '\vhttps?://github.com/(.{-})/(.*)/?'
    if a:url !~# pattern
        echo 'invalid url'
        return
    endif
    let replacement = 'Plug ''\1/\2'''
    let plug_line   = substitute(a:url, pattern, replacement, '')
    let to_install  = matchstr(plug_line, '\vPlug ''.{-}/(vim-)?\zs.{-}\ze''')

    let win_orig = win_getid()
    vnew | e $MYVIMRC
    let win_vimrc = win_getid()

    call cursor(1, 1)
    call search('^\s*Plug')
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
        if !search('\v^\s*"?\s*Plug ''.{-}/.{-}/?''', 'W')
            break
        endif
        let plugin_on_current_line = matchstr(getline('.'), '\vPlug ''.{-}/(vim-)?\zs.{-}\ze/?''')
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

fu! myfuncs#plugin_global_variables(keyword) abort "{{{1
    let condition = 'v:key =~ ''\C\V''.escape('''.a:keyword.''', ''\'') && v:key !~ ''\(loaded\|did_plugin_\)'''
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

fu! myfuncs#populate_list(list, cmd) abort "{{{1
    if a:list is# 'quickfix'
        " The output of the shell command passed to `:PQ` must be recognized by Vim.
        " And it must match a value in `'efm'`.
        " Examples:
        "         :PQ find /etc -name '*.conf'                    ✘
        "         :PQ grep -IRn foobar ~/.vim | grep -v backup    ✔

        " Why `:cgetfile` and not `:cexpr`?{{{
        "
        " It suffers from an issue regarding a possible pipe in the shell command.
        " You  have to  escape  it, which  is  inconsistent with  how  a bar  is
        " interpreted by Vim in other contexts.
        "
        " I don't want to remember this quirk.
        "}}}
        sil call system(a:cmd.' >/tmp/my_cfile')
        cgetfile /tmp/my_cfile
        call setqflist([], 'a', {'title': a:cmd})

    elseif a:list is# 'arglist'
        sil exe 'tab args '.join(map(filter(systemlist(a:cmd),
            \     {_,v -> filereadable(v)}),
            \ {_,v -> fnameescape(v)}))
        " enable item indicator in the statusline
        let g:my_stl_list_position = 2
    endif
    return ''
endfu

fu! myfuncs#remove_tabs(line1, line2) abort "{{{1
    let view = winsaveview()
    let mods = 'sil keepj keepp'
    let range = a:line1 . ',' . a:line2
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
    let l:Rep = {-> submatch(1) . repeat(' ', strdisplaywidth("\t", col('.') == 1 ? 0 : virtcol('.') ))}
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
        exe mods . ' ' . range .'s/' . pat . '/\=l:Rep()/ge'
    endfor
    call winrestview(view)
endfu

fu! myfuncs#search_internal_variables() abort "{{{1
    let view = winsaveview()

    let help_file = readfile($VIMRUNTIME.'/doc/eval.txt')
    call filter(help_file, {_,v -> v =~ '^\s*v:\S\+'})
    call map(help_file, {_,v -> matchstr(v, 'v:\zs\S\+')})
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

fu! myfuncs#search_todo(where) abort "{{{1
    try
        sil noa exe 'lvim /\CFIX'.'ME\|TO'.'DO/j '.(a:where is# 'buffer' ? '%' : './**/*')
        sil! call lg#motion#repeatable#make#set_last_used(']l')
    catch /^Vim\%((\a\+)\)\?:E480:/
        echom 'no TO'.'DO or FIX'.'ME'
        return
    catch
        return lg#catch_error()
    endtry

    " Because we've prefixed `:lvim` with `:noa`, our autocmd which opens a qf window
    " hasn't kicked in. We must manually open it.
    do <nomodeline> QuickFixCmdPost lwindow
    if &bt isnot# 'quickfix'
        return
    endif

    "                                             ┌ Tweak the text of each entry when there's a line
    "                                             │ with just `todo` or `fixme`;
    "                                             │ replace it with the text of the next non empty line instead
    "                                             │
    call setloclist(0, map(getloclist(0), {_,v -> s:search_todo_text(v)}), 'r')
    call setloclist(0, [], 'a', {'title': 'FIX'.'ME & TO'.'DO'})

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
    if dict.text =~# '\v\c%(fixme|todo):?\s*%(\{\{'.'\{)?\s*$'
        let bufnr = dict.bufnr
        " get the text of the next line, which is not empty:
        "
        "     ^\s*$
        "
        " ... and which doesn't contain only the comment character:
        "
        "     ^\s*#\s*$    (example in a bash buffer)
        let pat = '^\s*\C\V'.escape(get(split(getbufvar(bufnr, '&cms', ''),
        \                                     '%s'),
        \                               0, ''),
        \                           '\')
        \                   .'\v\s*$|^\s*$'

        " Why using `readfile()` instead of `getbufline()`?{{{
        "
        " `getbufline()` works only if the buffer is listed.
        " If the buffer is NOT listed, it returns an empty list.
        " There's no guarantee that all buffers in which a fixme/todo is present
        " is currently listed.
        "}}}
        let lines = readfile(bufname(bufnr), 0, dict.lnum + 4)[-4:]
        let dict.text = get(filter(lines, {_,v -> v !~ pat}), 0, '')
    endif
    return dict
endfu

fu! myfuncs#tab_toc() abort "{{{1
    if index(['help', 'man', 'markdown'], &ft) ==# -1
        return
    endif

    let patterns = {
        \ 'man'     : '\S\zs',
        \ 'markdown': '\v^%(#+)?\S.\zs',
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
        if col !=# -1 && synIDattr(synID(lnum, col, 0), 'name') =~? syntaxes[&ft]
            let text = substitute(getline(lnum), '\s\+', ' ', 'g')
            call add(toc, {'bufnr': bufnr('%'), 'lnum': lnum, 'text': text})
        endif
   endfor

    " Why do we call `setloclist()` 2 times? {{{

    " To set the title of the location window, we must pass the dictionary
    " `{'title': 'TOC'}` as a fourth argument to `setloclist()`.
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
    call setloclist(0, [], 'a', {'title': 'TOC'})

    let is_help_file = &bt is# 'help'

    " The width of the current window is going to be reduced by the TOC window.
    " Long lines may be wrapped. I don't like wrapped lines.
    setl nowrap

    do <nomodeline> QuickFixCmdPost lwindow
    if &bt isnot# 'quickfix'
        return
    endif

    if is_help_file
        call qf#set_matches('myfuncs:tab_toc', 'Conceal', '\*')
        call qf#create_matches()
    endif
endfu

" tmux-navigator {{{1

" OLD CODE:
" I don't like this code anymore. I frequently press `c-j` to go the next
" horizontal viewport, and this code made me go to a tmux pane instead.
" I don't know what was the idea/intention behind this code.
" Everything related to tmux is a mess anyway.
"
" TODO: Review these tmux-navigator functions.

"     echo system('tmux -S /tmp/tmux-1000/default display -p "#{pane_current_command}"')

"     fu! myfuncs#navigate(dir) abort
"         if !empty($TMUX)
"             call s:tmux_navigate(a:dir)
"         else
"             call s:vim_navigate(a:dir)
"         endif
"     endfu

"     fu! s:tmux_navigate(dir) abort
"         let x = winnr()
"         call s:vim_navigate(a:dir)
"         if winnr() ==# x
"             "                                       ┌ path to tmux socket
"             "                    ┌──────────────────┤
"             let cmd = 'tmux -S '.split($TMUX, ',')[0].' '.
"                         \ 'select-pane -' . tr(a:dir, 'hjkl', 'LDUR')
"             sil! call system(cmd)
"         endif
"     endfu

"     fu! s:vim_navigate(dir) abort
"         try
"             exe 'wincmd '.a:dir
"         catch
"             echohl ErrorMsg
"             echo 'E11: Invalid in command-line window; <cr> executes, CTRL-C quits: wincmd ' . a:dir
"             echohl None
"         endtry
"     endfu

" trans {{{1

" Update:
" Have a look at this plugin:
"     https://github.com/echuraev/translate-shell.vim

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
        \ '/bin/bash',
        \ '-c',
        \
        \ 'trans -brief -speak'
        \     .' -t '.get(s:, 'trans_target', 'fr')
        \     .' -s '.get(s:, 'trans_source', 'en')
        \     .' '.shellescape(chunk)]
        \ , opts)

    " remove it from the list of chunks
    call remove(s:trans_chunks, 0)
endfu

fu! myfuncs#trans_cycle() abort
    let s:trans_target = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_target', 'fr')]
    let s:trans_source = {'fr': 'en', 'en': 'fr'}[get(s:, 'trans_source', 'en')]
    echo '[trans] '.s:trans_source.' → '.s:trans_target
endfu

fu! s:trans_grab_visual() abort
    let [l1, l2] = [line("'<"), line("'>")]
    let [c1, c2] = [col("'<"),  col("'>)")]

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

" unicode_toggle {{{1

fu! myfuncs#unicode_toggle(line1, line2) abort
    let view  = winsaveview()
    let range = a:line1.','.a:line2
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
    sil exe mods.range.'s/'.pat.'/\=l:Rep()/ge'
    call winrestview(view)
endfu

fu! s:vim_parent() abort "{{{1
    " ┌────────────────────────────┬─────────────────────────────────────┐
    " │ :echo getpid()             │ print the PID of Vim                │
    " ├────────────────────────────┼─────────────────────────────────────┤
    " │ $ ps -p <Vim PID> -o ppid= │ print the PID of the parent of Vim  │
    " ├────────────────────────────┼─────────────────────────────────────┤
    " │ $ ps -p $(..^..) -o comm=  │ print the name of the parent of Vim │
    " └────────────────────────────┴─────────────────────────────────────┘
    return expand('`ps -p $(ps -p '.getpid().' -o ppid=) -o comm=`')
endfu

fu! myfuncs#webpage_read(url) abort "{{{1
    let tempfile = tempname().'/webpage'
    exe 'tabe '.tempfile
    " Alternative shell command:{{{
    "
    "     $ lynx -dump -width=1000 url
    "                         │
    "                         └─ high nr to be sure that
    "                         `lynx` won't break long lines of code
    "}}}
    sil! exe 'r !w3m -cols 100 '.shellescape(a:url, 1)
    setl bt=nofile nobl noswf nowrap
endfu

fu! myfuncs#word_frequency(line1, line2, ...) abort "{{{1
    let flags  = {
        \  'min_length': matchstr(a:1, '-min_length\s\+\zs\d\+'),
        \  'weighted': stridx(a:1, '-weighted') !=# -1,
        \ }

    let view       = winsaveview()
    let words      = split(join(getline(a:line1, a:line2), "\n"), '\v%(%(\k@!|\d).)+')
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

        " `abbrev_length` is the length of an abbreviation we could create for
        " a given word. Its value depends on the word:
        "
        "   - if the word is 4 characters long, then the abbreviation should be
        "     2 characters long,
        "
        "   - if the word ends with an 's', and the same word, without the ending
        "     's', is also present, then the abbreviation should be 4 characters
        "     long (because it's probably a plural),
        "
        "   - otherwise, by default, an abbreviation should be 3 characters long

        let abbrev_length = '(
            \     strchars(v:key) ==# 4
            \   ?     2
            \   : v:key[-1:-1] is# "s" && index(keys(freq), v:key[:strlen(v:key)-1]) >= 0
            \   ?     4
            \   :     3
            \ )'

        let weighted_freq = deepcopy(freq)
        call map(weighted_freq, {k,v -> v * (strchars(k) - abbrev_length)})
        let weighted_freq = sort(items(weighted_freq), {a, b -> b[1] - a[1]})
    endif

    " put the result in a vertical viewport
    let tempfile = tempname().'/WordFrequency'
    exe 'lefta '.(&columns/3).'vnew '.tempfile
    setl bh=delete bt=nofile nobl noswf wfw nowrap

    " for item in items(freq)
    for item in flags.weighted ? weighted_freq : items(freq)
        call append('$', join(item))
    endfor

    " format output into aligned columns
    " We don't need to delete the first empty line, `column` doesn't return it.
    " Probably because there's nothing to align in it.
    sil! %!column -t
    sil! %!sort -rn -k2

    exe 'vert res '.(max(map(getline(1, '$'), {_,v -> strchars(v, 1)}))+4)

    nno <buffer><expr><nowait><silent> q reg_recording() isnot# '' ? 'q' : ':<c-u>q<cr>'
    exe winnr('#').'windo call winrestview(view)'
endfu

fu! myfuncs#wf_complete(arglead, _cmdline, _pos) abort
    return join(['-min_length', '-weighted'], "\n")
endfu

