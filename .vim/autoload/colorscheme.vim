" Init {{{1

" map greyscale colors from decimal to hexadecimal
const s:DEC2HEX = {
\ '232': '#080808',
\ '233': '#121212',
\ '234': '#1c1c1c',
\ '235': '#262626',
\ '236': '#303030',
\ '237': '#3a3a3a',
\ '238': '#444444',
\ '239': '#4e4e4e',
\ '240': '#585858',
\ '241': '#626262',
\ '242': '#6c6c6c',
\ '243': '#767676',
\ '244': '#808080',
\ '245': '#8a8a8a',
\ '246': '#949494',
\ '247': '#9e9e9e',
\ '248': '#a8a8a8',
\ '249': '#b2b2b2',
\ '250': '#bcbcbc',
\ '251': '#c6c6c6',
\ '252': '#d0d0d0',
\ '253': '#dadada',
\ '254': '#e4e4e4',
\ '255': '#eeeeee',
\ }

" Interface {{{1
fu colorscheme#set() abort "{{{2
    " Purpose:{{{
    "
    " If `g:seoul256_srgb` is set to 1, the color mapping is altered to suit the
    " way urxvt (and various other terminals) renders them.
    " That  way, the  colors  of the  terminal and  GUI  versions are  uniformly
    " colored on Linux.
    "
    "         https://github.com/junegunn/seoul256.vim#alternate-256-xterm---srgb-mapping
    "}}}
    let g:seoul256_srgb = 1

    let seoul_bg = get(g:, 'my_last_color_scheme', 253)
    if seoul_bg >= 233 && seoul_bg <= 239
        " What's this `g:seoul256_background`?{{{
        "
        "    ┌─────────────────────────────┬──────────────────────────────────────────────────────────────────┐
        "    │ g:seoul256_current_bg       │ Current background color in ANSI code                            │
        "    │ g:seoul256_current_fg       │ Current foreground color in ANSI code                            │
        "    │                             │                                                                  │
        "    │                             │ ┌ dark             ┌ light                                       │
        "    │                             │ ├─────────┐        ├─────────┐                                   │
        "    │                             │ 233 ... 239        252 ... 256                                   │
        "    ├─────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        "    │ g:seoul256_background       │ value to be used the NEXT time we execute `:colo seoul256`       │
        "    │                             │                                                                  │
        "    │                             │         Valid values: 233 … 237 … 239                            │
        "    │                             │                       │     │     │                              │
        "    │                             │                       │     │     └ lightest                     │
        "    │                             │                       │     └ default                            │
        "    │                             │                       └ darkest                                  │
        "    ├─────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        "    │ g:seoul256_light_background │ value to be used the NEXT time we execute `:colo seoul256-light` │
        "    │                             │                                                                  │
        "    │                             │         Valid values: 252 … 253 … 256                            │
        "    │                             │                       │     │     │                              │
        "    │                             │                       │     │     └ lightest                     │
        "    │                             │                       │     └ default                            │
        "    │                             │                       └ darkest                                  │
        "    └─────────────────────────────┴──────────────────────────────────────────────────────────────────┘
        "}}}
        let g:seoul256_background = seoul_bg
        colo seoul256
    else
        let g:seoul256_light_background = seoul_bg
        colo seoul256-light
    endif

    " Make Vim use the ANSI colors of our terminal palette in a terminal buffer.
    " Wait.  Why doesn't Vim use our terminal palette by default?{{{
    "
    " I think  it does, except when  you run gVim, or  when you run Vim  from an
    " unknown terminal and you've set `'tgc'`.
    " In that  case, Vim  seems to fall  back on weird  ANSI colors,  which look
    " flashy and ugly.
    "}}}
    "   What do you mean by{{{
    "}}}
    "     “unknown terminal”?{{{
    "
    " Vim only recognizes a few terminals (and their derivatives):
    "
    "    - gui
    "    - amiga
    "    - beos-ansi
    "    - ansi
    "    - pcansi
    "    - win32
    "    - vt320
    "    - vt52
    "    - xterm
    "    - iris-ansi
    "    - debug
    "    - dumb
    "
    " I found this list by running `$ xterm=foobar vim`.
    " You can also find it by looking at `:h vms-notes /unknown-terminal`.
    "
    " Basically, it seems  Vim doesn't know any terminal we  use, outside xterm,
    " and  terminals which  pretend to  be xterm  (i.e. all  terminals based  on
    " libvte, like xfce4-terminal, gnome-terminal, konsole, ...).
    "}}}
    "     “weird” colors?{{{
    "
    " Temporarily comment the `g:terminal_ansi_colors` assignment.
    " Next, start Vim like this (or start gVim):
    "
    "     $ TERM=ansi vim
    "
    " Then, open a terminal, and run `$ echo $TERM`; the output is `xterm`.
    " So, one would expect that Vim is using xterm's default palette.
    " And yet, if you run `palette`, and use  Gpick to get the hex color code of
    " the  color 11;  it's  `#ffff40`, which  I can't  find  in xterm's  default
    " palette:
    "
    " https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
    "
    " Update:
    " After reading this:
    " https://github.com/vim/vim/issues/2353#issuecomment-372451614
    "
    " ... I wonder whether these weird colors are defined in `src/libvterm/src/pen.c`.
    "}}}

    " What would happen if I removed this assignment?{{{
    "
    " Colors in  a terminal  buffer would  be wrong, when  Vim was  started from
    " urxvt, st, or tmux (and more generally from any shell whose `$TERM` is not
    " `xterm` or `xterm-256color`).
    "
    " This  also matters for  fzf buffers, which  are based on  terminal buffers
    " (where `:setf fzf` is run).
    "}}}
    " Could I use color names instead?{{{
    "
    " Yes, you can use a color name  as suggested at `:h gui-colors`, instead of
    " a  hex  color  code, but  it  would  make  Vim  choose the  color  in  its
    " builtin/fallback palette, which will be ugly/flashy.
    "}}}
    let g:terminal_ansi_colors =<< trim END
        #1d1f21
        #cc342b
        #198844
        #af8760
        #3971ed
        #a36ac7
        #3971ed
        #f5f5f5
        #989698
        #cc342b
        #198844
        #d8865f
        #3971ed
        #a36ac7
        #3971ed
        #ffffff
    END

    " Nvim needs the same kind of configuration.
    " Why do you run the previous code even in Nvim?{{{
    "
    " To avoid duplicating the hex color codes.
    "}}}
    if has('nvim')
        for i in range(0, 15)
            " See `:h terminal-configuration` for more info about these
            " `g:terminal_color_` variables.
            let g:terminal_color_{i} = g:terminal_ansi_colors[i]
        endfor
        unlet! g:terminal_ansi_colors
    endif
endfu

fu colorscheme#customize() abort "{{{2
    " Why changing `CursorLine`?{{{
    "
    " The attributes  set by our  color scheme  make the cursorline  not visible
    " enough.
    "}}}
    " Why `ctermbg=NONE` and `guibg=NONE`?{{{
    "
    " To make `CursorLine` transparent in case of a conflict between two HGs.
    " It happens  when `'cursorline'` is set,  and the *background* of  the text
    " under the cursor is highlighted by a syntax item.
    "}}}
    " It's not visible enough!{{{
    "
    " Add the bold value:
    "
    "     hi CursorLine term=bold,underline cterm=bold,underline gui=bold,underline ctermbg=NONE guibg=NONE
    "                        ^^^^                 ^^^^               ^^^^
    "}}}
    hi CursorLine term=underline cterm=underline gui=underline ctermbg=NONE guibg=NONE

    " useful when `'rnu'` is set; only available in Vim atm
    hi! link LineNrAbove DiffDelete
    hi! link LineNrBelow DiffAdd

    " the `SpecialKey` HG set by seoul256 is barely readable
    hi! link SpecialKey Special

    " The `VertSplit` HG set by seoul256 is black by default.
    " When you split a window vertically, Vim  uses it to draw 2 vertical lines,
    " and in the middle it puts a white vertical line.
    " That's too much. I only need one black vertical line.
    " For some reason, linking VertSplit gets us the desired result.
    hi! link VertSplit Normal

    " hide the EndOfBuffer char (~) by changing its ctermfg attribute (ctermfg=bg)
    " Why this `:if` guard?{{{
    "
    " Some color schemes don't set up the `Normal` HG.
    " So, the value `bg` may not exist for all color schemes.
    "
    "     :colo elflord
    "     :hi EndOfBuffer ctermfg=bg
    "     E420: BG color unknown ~
    "}}}
    if execute('hi Normal') =~# 'ctermbg'
        if $DISPLAY is# ''
            hi EndOfBuffer ctermfg=bg
        else
            hi EndOfBuffer ctermfg=bg guifg=bg
        endif
    endif

    " `Underlined` is meant to be used to highlight html links.{{{
    "
    " In a webbrowser, usually those are blue.
    " But in `seoul256`, `Underlined` is pink.
    " So, we reset the  HG with the `underline` style, and the  colors of the HG
    " `Conditional` (because this one is blue).
    "}}}
    let cmd = 'hi Underlined term=underline cterm=underline gui=underline '
        \ ..substitute(split(execute('hi Conditional'), '\n')[0], '.*xxx\|links to.*', '', 'g')
        "              │{{{
        "              └ When we start Vim with `$ sudo vim`, the output of `execute('hi ...')`
        "                contains 2 lines instead of 1 (the second line contains `Last set from ...`).
        "}}}

    " Why this second substitution?{{{
    "
    " When starting Vim in debug mode `$ vim -D ...`, this error is raised:
    "
    "     E416: missing equal sign: line 123: hi Conditional~
    "
    " This is because, in this particular case, the value of `cmd` contains noise at the end:
    "
    "     hi Underlined term=underline cterm=underline gui=underline line 15: hi Conditional
    "                                                                ^^^^^^^^^^^^^^^^^^^^^^^
    "}}}
    let cmd = substitute(cmd, 'line\s\+\d\+:.*', '', '')
    exe cmd

    " define the `CommentUnderlined` HG (useful for urls in comments)
    " Why the `:\s\+hi\s\+` and the `line\s*\d\+`?{{{
    "
    " When we start with `-V15/tmp/log`, the output of `hi Comment` contains more noise.
    "}}}
    let comment_definition = substitute(execute('hi Comment'), '\n\|xxx\|:\s\+hi\s\+\|line\s*\d\+\|Last set from.*', '', 'g')
    let comment_underlined_definition = substitute(comment_definition, 'Comment', 'CommentUnderlined', '')
    let comment_underlined_definition =
        \ substitute(comment_underlined_definition, '\m\C\<\%(term\|cterm\|gui\)=\S*', '', 'g')
    let comment_underlined_definition =
        \ substitute(comment_underlined_definition, '$', ' term=underline cterm=underline gui=underline', '')
    exe 'hi '..comment_underlined_definition

    " Why the delay?{{{
    "
    " gVim encounters some errors when trying to set up too early some of our custom HGs:
    "
    "     E417: missing argument: guifg=~
    "     E254: Cannot allocate color 95~
    "     E254: Cannot allocate color 187~
    "
    " The issue  seems to be  that the HGs whose  attributes we need  to inspect
    " ('StatusLine', 'TabLine', ...), are not (correctly) defined yet.
    "}}}
    if has('gui_running') && has('vim_starting')
        augroup delay_color_scheme_when_gvim_starts
            au!
            au VimEnter * call s:customize()
        augroup END
    else
        call s:customize()
    endif
endfu

fu s:customize() abort
    call s:diff()
    call s:styled_comments()
    call s:StatuslineNC()
    call s:TabLine()
    call s:Title()
    call s:User()
endfu

fu colorscheme#save_last_version() abort "{{{2
    let line = 'let g:my_last_color_scheme = '..get(g:, 'seoul256_current_bg', 253)
    call writefile([line], $HOME..'/.vim/colors/my/last_version.vim')
endfu
" }}}1
" Core {{{1
fu s:diff() abort "{{{2
    " Why do you clear `DiffChange`?{{{
    "
    " When  you compare  two  windows  in diff  mode,  `DiffChange`  is used  to
    " highlight the text which has *not* changed on a line which *has* changed.
    " I don't care about the text which didn't change.
    " It adds visual clutter.
    "}}}
    hi! link DiffChange NONE
    hi! clear DiffChange
endfu

fu s:styled_comments() abort "{{{2
    " Need this to be able to make a distinction between comments and code highlighted by `PreProc`.{{{
    "
    " By default, `PreProc` can be used to highlight both comment and code.
    " As an  example, it  highlights comment  titles in  Vim, and  some variable
    " references in shell.
    "
    " This causes an issue when we enter goyo mode.
    " In this mode, we're only interested in code, not comments.
    " So, we want to ignore a *comment* highlighted by `PreProc` (`:hi link xFoo Ignore`),
    " but not the *code* highlighted by `PreProc`.
    "
    " We can't blindly ignore any text highlighted by `PreProc`.
    " We need a way to distinguish between comment and code.
    " To achieve this, we install this `CommentPreProc` HG.
    " In `~/plugged/vim-lg-lib/autoload/lg/styled_comment.vim`, we use it
    " to highlight comment titles and outputs of commands.
    "
    " This way,  we retain  the same  highlighting (because  `CommentPreProc` is
    " linked to `PreProc`), but we can  ignore it in goyo mode without affecting
    " the code highlighted by `PreProc`.
    "}}}
    hi link CommentPreProc PreProc

    " Why `Underlined`?{{{
    "
    " From `:h group-name`:
    "
    " > *Underlined       text that stands out, HTML links
    "
    " Also, that's what the default markdown syntax plugin uses to highlight the
    " text of a link.
    "}}}
    hi link markdownLinkText   Underlined
    " Why `Float`?{{{
    "
    " That's what the default markdown syntax plugin uses to highlight a url.
    "}}}
    hi link markdownUrl        Float
    " Why `Type`?{{{
    "
    " That's what the help syntax plugin uses.
    "}}}
    hi link markdownOption     Type
    " Why `Delimiter`?{{{
    "
    " It seems to be the most meaningful choice.
    " From `:h group-name`:
    "
    " >     Delimiter character that needs attention
    "}}}
    hi link markdownPointer    Delimiter
    hi link markdownTable      Structure
    hi link markdownKey        Special
    hi link markdownRule       Delimiter
    " Why `Typedef`?{{{
    "
    " That's what the default markdown syntax plugin uses to highlight the id of
    " a reference link.
    "}}}
    hi link markdownIdDeclaration  Typedef

    hi link markdownCodeBlock           Comment
    hi link markdownListItemCodeBlock   markdownCodeBlock
    hi link markdownFencedCodeBlock     markdownCodeBlock
    hi link CommentListItemCodeSpan     markdownListItemCodeSpan

    hi link markdownListItemBlockquote  markdownBlockquote

    let bg = s:get_attributes('TabLine', 'cterm').bg + (&bg is# 'light' ?  2 : -2)
    if has('gui_running') || &tgc
        let bg = get(s:DEC2HEX, bg, '#808080')
    endif
    let comment_fg = s:get_attributes('Comment').fg
    let statement_fg = s:get_attributes('Statement').fg
    let repeat_fg = s:get_attributes('Repeat').fg

    " the only relevant attributes in GUI are `gui`, `guifg` and `guibg`
    if has('gui_running')
        exe 'hi CommentCodeSpan guifg='..comment_fg..' guibg='..bg
        exe 'hi markdownCodeSpan guibg='..bg

        exe 'hi CommentBold gui=bold guifg='..comment_fg
        exe 'hi CommentBoldItalic gui=bold,italic guifg='..comment_fg
        exe 'hi CommentItalic gui=italic guifg='..comment_fg

        exe 'hi markdownListItem guifg='..repeat_fg
        exe 'hi markdownListItemBold gui=bold guifg='..repeat_fg
        exe 'hi markdownListItemBoldItalic gui=bold,italic guifg='..repeat_fg
        exe 'hi markdownListItemCodeSpan guifg='..repeat_fg..' guibg='..bg
        exe 'hi markdownListItemItalic gui=italic guifg='..repeat_fg

        exe 'hi markdownBlockquote guifg='..statement_fg
        exe 'hi markdownBlockquoteBold gui=bold guifg='..statement_fg
        exe 'hi markdownBlockquoteBoldItalic gui=bold,italic guifg='..statement_fg
        exe 'hi markdownBlockquoteCodeSpan guibg='..bg..' guifg='..statement_fg
        exe 'hi markdownBlockquoteItalic gui=italic guifg='..statement_fg

    " the only relevant attributes in a truecolor terminal are `guifg`, `guibg`,
    " and `cterm` (Vim) or `gui` (Neovim)
    elseif &tgc
        exe 'hi CommentCodeSpan guifg='..comment_fg..' guibg='..bg
        exe 'hi markdownCodeSpan guibg='..bg

        let attr = has('nvim') ? 'gui' : 'cterm'
        exe 'hi CommentBold '..attr..'=bold guifg='..comment_fg
        exe 'hi CommentBoldItalic '..attr..'=bold,italic guifg='..comment_fg
        exe 'hi CommentItalic '..attr..'=italic guifg='..comment_fg

        exe 'hi markdownListItem guifg='..repeat_fg
        exe 'hi markdownListItemBold '..attr..'=bold guifg='..repeat_fg
        exe 'hi markdownListItemBoldItalic '..attr..'=bold,italic guifg='..repeat_fg
        exe 'hi markdownListItemCodeSpan guifg='..repeat_fg..' guibg='..bg
        exe 'hi markdownListItemItalic '..attr..'=italic guifg='..repeat_fg

        exe 'hi markdownBlockquote guifg='..statement_fg
        exe 'hi markdownBlockquoteBold '..attr..'=bold guifg='..statement_fg
        exe 'hi markdownBlockquoteBoldItalic '..attr..'=bold,italic guifg='..statement_fg
        exe 'hi markdownBlockquoteCodeSpan guifg='..statement_fg..' guibg='..bg
        exe 'hi markdownBlockquoteItalic '..attr..'=italic guifg='..statement_fg

    " the only relevant attributes in a non-truecolor terminal are `term`, `cterm`, `ctermfg` and `ctermbg`
    else
        exe 'hi CommentCodeSpan ctermfg='..comment_fg..' ctermbg='..bg
        exe 'hi markdownCodeSpan ctermbg='..bg

        exe 'hi CommentBold term=bold cterm=bold ctermfg='..comment_fg
        exe 'hi CommentBoldItalic term=bold,italic cterm=bold,italic ctermfg='..comment_fg
        exe 'hi CommentItalic term=italic cterm=italic ctermfg='..comment_fg

        exe 'hi markdownListItem ctermfg='..repeat_fg
        exe 'hi markdownListItemBold term=bold cterm=bold ctermfg='..repeat_fg
        exe 'hi markdownListItemBoldItalic term=bold,italic cterm=bold,italic ctermfg='..repeat_fg
        exe 'hi markdownListItemCodeSpan ctermfg='..repeat_fg..' ctermbg='..bg
        exe 'hi markdownListItemItalic term=italic cterm=italic ctermfg='..repeat_fg

        exe 'hi markdownBlockquote ctermfg='..statement_fg
        exe 'hi markdownBlockquoteBold term=bold cterm=bold ctermfg='..statement_fg
        exe 'hi markdownBlockquoteBoldItalic term=bold,italic cterm=bold,italic ctermfg='..statement_fg
        exe 'hi markdownBlockquoteCodeSpan ctermfg='..statement_fg..' ctermbg='..bg
        exe 'hi markdownBlockquoteItalic term=italic cterm=italic ctermfg='..statement_fg
    endif
endfu

fu s:StatuslineNC() abort "{{{2
    " the file path in the status line of a non-focused window is too visible; let's fix that
    " Why don't you use a hard-coded value?{{{
    "
    " It may not always look nice, depending on whether we use the dark or light
    " version of seoul, and depending on the level of lightness.
    " Instead, we compute it programmatically from another HG; `TabLine` seems a
    " good fit.
    "}}}
    " Why do you pass this extra `cterm` argument?{{{
    "
    " If we  are in  gui or in  a true color  terminal, then  `synIDattr()` will
    " return an hexadecimal number. We can't easily make it less/more light.
    " We need  a decimal  number to which  we can apply  a simple  offset; later
    " we'll convert the result back in hexadecimal via `s:DEC2HEX`.
    "
    " To force  `synIDattr()` to  return a  decimal number, we  can pass  it the
    " optional `{mode}` argument, to ask for  the value the attribute would have
    " if we were in an arbitrary mode (here `cterm`).
    "}}}
    let bg = s:get_attributes('TabLine', 'cterm').bg + (&bg is 'light' ? -5 : 5)
    if has('gui_running') || &tgc
        " The value of `bg` may not be a key in the dictionary `s:DEC2HEX`.{{{
        "
        " That's  because there  is  no  guarantee that  the  `bg` attribute  of
        " `TabLine` is between 232 and 255.
        " For example, that's not the case with these color schemes:
        " default, delek, koehler, morning, peachpuff, shine, zellner.
        "}}}
        let bg = get(s:DEC2HEX, bg, '#808080')
        exe 'hi StatuslineNC guibg='..bg
    else
        exe 'hi StatuslineNC ctermbg='..bg
    endif
    " In a non-focused window, we highlight the file path with `User1`.  That's not the colors which are applied!{{{
    "
    " I think that's because of `:h 'stl /User`:
    "
    " > The difference between User{N} and StatusLine  will be applied
    " > to StatusLineNC for the statusline of non-current windows.
    "
    " Although, I  don't really understand  how that  explains how Vim  gets the
    " colors it uses to highlight the file path in a non-focused window...
    "}}}
    " The foreground and background colors are reversed!{{{
    "
    " I  think that's  because the original  HG  is defined  with the  `reverse`
    " attribute,  and  `:hi`  doesn't  reset  *all*  the  attributes;  only  the
    " attributes that you pass to it as arguments.
    "}}}
endfu

fu s:TabLine() abort "{{{2
    " the purpose of this function is to remove the underline value from the HG `TabLine`

    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    call map(attributes, {k -> synIDattr(synIDtrans(hlID('Tabline')), k)})

    if has('gui_running')
        let cmd = 'hi TabLine gui=none guifg=%s'
    elseif &tgc
        let attr = has('nvim') ? 'gui' : 'cterm'
        let cmd = 'hi TabLine term=none '..attr..'=none guifg=%s'
    else
        let cmd = 'hi TabLine term=none cterm=none gui=none ctermfg=%s'
    endif

    " For  some  values of  `g:seoul{_light}_background`,  the  fg attribute  of
    " Tabline doesn't have any value in gui. In this case, executing the command
    " will fail.
    if attributes.fg is# '' | return | endif
    exe printf(cmd, attributes.fg)
endfu

fu s:Title() abort "{{{2
    " Purpose: We need some HGs to get the bold, italic, bold+italic styles in a markdown header.
    let title_fg = s:get_attributes('Title').fg
    if has('gui_running')
        " In gVim, `seoul256` makes a markdown Title bold by default.
        " It prevents us from using the bold style.
        " So, we remove this attribute.
        hi clear Title
        exe 'hi Title guifg='..title_fg

        exe 'hi TitleItalic gui=italic guifg='..title_fg
        exe 'hi TitleBold gui=bold guifg='..title_fg
        exe 'hi TitleBoldItalic gui=bold,italic guifg='..title_fg

    elseif &tgc
        let attr = has('nvim') ? 'gui' : 'cterm'
        exe 'hi TitleItalic '..attr..'=italic guifg='..title_fg
        exe 'hi TitleBold '..attr..'=bold guifg='..title_fg
        exe 'hi TitleBoldItalic '..attr..'=bold,italic guifg='..title_fg

    else
        exe 'hi TitleItalic term=italic cterm=italic ctermfg='..title_fg
        exe 'hi TitleBold term=bold cterm=bold ctermfg='..title_fg
        exe 'hi TitleBoldItalic term=bold,italic cterm=bold,italic ctermfg='..title_fg
    endif
endfu

fu s:User() abort "{{{2
    " We're going to define 2 HGs: User1 and User2.{{{
    "
    " We use them in the status line to customize the appearance of:
    "
    "    - the filename
    "    - the modified flag
    "
    " We want their  attributes to be the  same as the ones of  the HG `StatusLine`,
    " except for one: `reverse` (boolean flag).
    "
    " `User1` and `StatusLine` should have opposite values for the `reverse` attribute.
    " Also, we set the color of the background of `User2` as the same as the
    " foreground color of `Todo`, so that the modified flag clearly stands out.
    "}}}

    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    call map(attributes, {k -> synIDattr(synIDtrans(hlID('StatusLine')), k)})

    if has('gui_running')
        let cmd1 = 'hi User1 gui=%s guifg=%s guibg=%s'
        let cmd2 = 'hi User2 gui=%s guifg=%s guibg=%s'

    elseif &tgc
        let attr = has('nvim') ? 'gui' : 'cterm'
        let cmd1 = 'hi User1 '..attr..'=%s guifg=%s guibg=%s'
        let cmd2 = 'hi User2 '..attr..'=%s guifg=%s guibg=%s'

    else
        let cmd1 = 'hi User1 cterm=%s ctermfg=%s ctermbg=%s'
        let cmd2 = 'hi User2 cterm=%s ctermfg=%s ctermbg=%s'
        "                                      │
        "                                      └ yes, you could use `%d`
        "                                        but you couldn't use `%d` for `guifg`
        "                                        nor `%x`
        "                                        nor `%X`
        "                                        only `%s`
        "                                        so, we use `%s` everywhere
    endif

    " For some color  schemes (default, darkblue, ...), some values  used in the
    " command which is going to be executed may be empty.
    " If that happens, the command will fail:
    "
    "     Error detected while processing function <SNR>18_set_user_hg:~
    "     E421: Color name or number not recognized: ctermfg= ctermbg=~
    if attributes.fg is# '' || attributes.bg is# ''
        return
    endif

    let style1 = (attributes.bold ? 'bold,' : '')..(attributes.reverse ? '' : 'reverse')
    if style1 is# '' | return | endif

    exe printf(cmd1, style1, attributes.fg, attributes.bg)

    let style2 = (attributes.bold ? 'bold,' : '')..(attributes.reverse ? 'reverse' : '')
    if style2 is# '' | return | endif

    let todo_fg = synIDattr(synIDtrans(hlID('Todo')), 'fg')
    exe printf(cmd2, style2, todo_fg, attributes.bg)
endfu
" }}}1
" Utilities {{{1
fu s:get_attributes(hg, ...) abort "{{{2
    let mode = a:0 ? [a:1] : []
    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }
    return map(attributes, {k -> call('synIDattr', [synIDtrans(hlID(a:hg)), k] + mode)})
endfu

