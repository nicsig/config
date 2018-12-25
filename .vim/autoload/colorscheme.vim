fu! colorscheme#customize() abort "{{{1
    " hide the EndOfBuffer char (~) by changing its ctermfg attribute (ctermfg=bg)
    " Why the `:try` conditional?{{{
    "
    " Some colorschemes don't set up the `Normal` HG.
    " So, the value `bg` may not exist for all colorschemes.
    " Example:
    "         :colo default
    "         →       Error detected while processing .../colors/my_customizations.vim:
    "                 E420: BG color unknown
    "}}}
    try
        if $DISPLAY is# ''
            hi EndOfBuffer ctermfg=bg
        else
            hi EndOfBuffer ctermfg=bg guifg=bg
        endif
    catch
        call lg#catch_error()
    endtry

    " the `SpecialKey` HG set by seoul256 is barely readable
    hi! link SpecialKey Special

    " the `VertSplit`  HG set  by seoul256  has a dark  background which  is too
    " visible in the light colorscheme, and not enough in the dark one
    hi! link VertSplit Normal

    " Why the delay?{{{
    "
    " gVim encounters some errors when trying to set up too early some of our custom
    " HGs defined in `~/.vim/colors/my/customizations.vim`:
    "
    "     E417: missing argument: guifg=
    "     E254: Cannot allocate color 95
    "     E254: Cannot allocate color 187
    "
    " The  issue seems  to be  that  the HGs  whose  attributes we  need to  inspect
    " ('StatusLine',  'TabLine',   ...),  are  not  (correctly)   defined  yet  when
    " `~/.vim/colors/my/customizations.vim` is sourced by gVim.
    "}}}
    if has('gui_running') && has('vim_starting')
        augroup delay_colorscheme_when_gvim_starts
            au!
            au VimEnter * call s:set_custom_hg()
        augroup END
    else
        call s:set_custom_hg()
    endif
endfu

fu! s:get_attributes(hg) abort "{{{1
    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    return map(attributes, {k,v -> synIDattr(synIDtrans(hlID(a:hg)), k)})
endfu

fu! colorscheme#save_last_version() abort "{{{1
    let line = 'let g:my_last_colorscheme = '.get(g:, 'seoul256_current_bg', 253)
    call writefile([line], $HOME.'/.vim/colors/my/last_version.vim')
endfu

fu! colorscheme#set() abort "{{{1
    let seoul_bg = get(g:, 'my_last_colorscheme', 253)

    if seoul_bg >= 233 && seoul_bg <= 239
        " What's this `g:seoul256_background`?{{{
        "
        " ┌─────────────────────────────────────┬──────────────────────────────────────────────────────────────────┐
        " │ g:seoul256_current_bg               │ Current background color in ANSI code                            │
        " │ g:seoul256_current_fg               │ Current foreground color in ANSI code                            │
        " │                                     │                                                                  │
        " │                                     │ ┌ dark             ┌ light                                       │
        " │                                     │ ├─────────┐        ├─────────┐                                   │
        " │                                     │ 233 ... 239        252 ... 256                                   │
        " ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        " │ g:seoul256_background               │ value to be used the NEXT time we execute `:colo seoul256`       │
        " │                                     │                                                                  │
        " │                                     │         Valid values: 233 … 237 … 239                            │
        " │                                     │                       │     │     │                              │
        " │                                     │                       │     │     └─ lightest                    │
        " │                                     │                       │     └─ default                           │
        " │                                     │                       └─ darkest                                 │
        " ├─────────────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        " │ g:seoul256_light_background         │ value to be used the NEXT time we execute `:colo seoul256-light` │
        " │                                     │                                                                  │
        " │                                     │         Valid values: 252 … 253 … 256                            │
        " │                                     │                       │     │     │                              │
        " │                                     │                       │     │     └─ lightest                    │
        " │                                     │                       │     └─ default                           │
        " │                                     │                       └─ darkest                                 │
        " └─────────────────────────────────────┴──────────────────────────────────────────────────────────────────┘
        "}}}
        let g:seoul256_background = seoul_bg
        colo seoul256
    else
        let g:seoul256_light_background = seoul_bg
        colo seoul256-light
    endif

    " If `let g:seoul256_srgb` is set to 1, the color mapping is altered to suit
    " the way  urxvt (and various  other terminals) renders them. That  way, the
    " colors of the terminal and GUI versions are uniformly colored on Linux.
    "
    "         https://github.com/junegunn/seoul256.vim#alternate-256-xterm---srgb-mapping

    let g:seoul256_srgb = 1
endfu

fu! s:set_custom_hg() abort "{{{1
    call s:user()
    call s:styled_comments()
    call s:tabline()

    " `Underlined` is meant to be used to highlight html links.{{{
    "
    " In a webbrowser, usually those are blue.
    " But in `seoul256`, `Underlined` is pink.
    " So, we reset the  HG with the `underline` style, and the  colors of the HG
    " `Conditional` (because this one is blue).
    "}}}
    exe 'hi Underlined term=underline cterm=underline gui=underline '
        \ . matchstr(execute('hi Conditional'), 'xxx\zs.*')
endfu

fu! s:styled_comments() abort "{{{1
    " How is this function called?{{{
    "
    " 1. `vimrc` installs:
    "
    "     au ColorScheme * call colorscheme#customize()
    "
    " 2. `colorscheme#customize()` calls `s:set_custom_hg()`
    "
    " 3. `s:set_custom_hg()` calls `s:styled_comments()`
    "}}}

    " Where did you find these color codes?{{{
    "
    " I chose a color from the terminal palette:
    "
    "     $ palette
    "
    " And to get the hex equivalent of the decimal code, I used `$ gpick`.
    "}}}
    let guibg = &bg is# 'light' ? '#bcbcbc' : '#626262'
    let ctermbg = &bg is# 'light' ? 250 : 241
    let comment_fg = s:get_attributes('Comment').fg
    let preproc_fg = s:get_attributes('PreProc').fg
    let repeat_fg = s:get_attributes('Repeat').fg

    " the only relevant attributes in GUI are `gui`, `guifg` and `guibg`
    if has('gui_running')
        exe 'hi markdownCodeSpan guibg=' . guibg
        exe 'hi markdownListCodeSpan guifg=' . repeat_fg . ' guibg=' . guibg
        exe 'hi markdownListItalic gui=italic guifg=' .repeat_fg
        exe 'hi markdownListBold gui=bold guifg=' . repeat_fg
        exe 'hi markdownListBoldItalic gui=bold,italic guifg=' . repeat_fg

        exe 'hi CommentCodeSpan guibg=' . guibg . ' guifg=' . comment_fg

        exe 'hi CommentItalic gui=italic guifg=' . comment_fg
        exe 'hi CommentBold gui=bold guifg=' . comment_fg
        exe 'hi CommentBoldItalic gui=bold,italic guifg=' . comment_fg

        exe 'hi CommentList guifg=' . repeat_fg
        exe 'hi CommentListCodeSpan guifg=' . repeat_fg . ' guibg=' . guibg
        exe 'hi CommentListItalic gui=italic guifg=' . repeat_fg
        exe 'hi CommentListBold gui=bold guifg=' . repeat_fg
        exe 'hi CommentListBoldItalic gui=bold,italic guifg=' . repeat_fg

        exe 'hi CommentBlockquote gui=italic guibg=' . guibg . ' guifg=' . preproc_fg
        exe 'hi CommentBlockquoteBold gui=italic,bold guibg=' . guibg . ' guifg=' . preproc_fg
        exe 'hi CommentBlockquoteCodeSpan guibg=' . guibg . ' guifg=' . preproc_fg

    " the only relevant attributes in a truecolor terminal are `cterm`, `guifg` and `guibg`
    elseif &tgc
        exe 'hi markdownCodeSpan guibg=' . guibg
        exe 'hi markdownListCodeSpan guifg=' . repeat_fg . ' guibg=' . ctermbg
        exe 'hi markdownListItalic cterm=italic guifg=' . repeat_fg
        exe 'hi markdownListBold cterm=bold guifg=' . repeat_fg
        exe 'hi markdownListBoldItalic cterm=bold,italic guifg=' . repeat_fg

        exe 'hi CommentCodeSpan guifg=' . comment_fg . ' guibg=' . guibg

        exe 'hi CommentItalic cterm=italic guifg=' . comment_fg
        exe 'hi CommentBold cterm=bold guifg=' . comment_fg
        exe 'hi CommentBoldItalic cterm=bold,italic guifg=' . comment_fg

        exe 'hi CommentList guifg=' . repeat_fg
        exe 'hi CommentListCodeSpan guifg=' . repeat_fg . ' guibg=' . ctermbg
        exe 'hi CommentListItalic cterm=italic cterm=italic guifg=' . repeat_fg
        exe 'hi CommentListBold cterm=bold cterm=bold guifg=' . repeat_fg
        exe 'hi CommentListBoldItalic cterm=bold,italic cterm=bold,italic guifg=' . repeat_fg

        exe 'hi CommentBlockquote gui=italic guifg=' . preproc_fg . ' guibg=' . guibg
        exe 'hi CommentBlockquoteCodeSpan guifg=' . preproc_fg . ' guibg=' . guibg
        exe 'hi CommentBlockquoteBold cterm=italic,bold guifg=' . preproc_fg . ' guibg=' . guibg

    " the only relevant attributes in a terminal are `term`, `cterm`, `ctermfg` and `ctermbg`
    else
        exe 'hi markdownCodeSpan ctermbg=' . ctermbg
        exe 'hi markdownListCodeSpan ctermfg=' . repeat_fg . ' ctermbg=' . ctermbg
        exe 'hi markdownListItalic cterm=italic ctermfg=' . repeat_fg
        exe 'hi markdownListBold term=bold cterm=bold ctermfg=' . repeat_fg
        exe 'hi markdownListBoldItalic term=bold,italic cterm=bold,italic ctermfg=' . repeat_fg

        exe 'hi CommentCodeSpan ctermfg=' . comment_fg . ' ctermbg=' . ctermbg

        exe 'hi CommentItalic term=italic cterm=italic ctermfg=' . comment_fg
        exe 'hi CommentBold term=bold cterm=bold ctermfg=' . comment_fg
        exe 'hi CommentBoldItalic term=bold,italic cterm=bold,italic ctermfg=' . comment_fg

        exe 'hi CommentList ctermfg=' . repeat_fg
        exe 'hi CommentListCodeSpan ctermfg=' . repeat_fg . ' ctermbg=' . ctermbg
        exe 'hi CommentListItalic term=italic cterm=italic ctermfg=' . repeat_fg
        exe 'hi CommentListBold term=bold cterm=bold ctermfg=' . repeat_fg
        exe 'hi CommentListBoldItalic term=bold,italic cterm=bold,italic ctermfg=' . repeat_fg

        exe 'hi CommentBlockquote term=italic cterm=italic ctermfg=' . preproc_fg
        exe 'hi CommentBlockquoteCodeSpan ctermfg=' . preproc_fg . ' ctermbg=' . ctermbg
        exe 'hi CommentBlockquoteBold term=italic,bold cterm=italic,bold ctermfg=' . preproc_fg
    endif
endfu

fu! s:tabline() abort "{{{1
    " the purpose of this function is to remove the underline value from the HG
    " TabLine

    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    call map(attributes, {k,v -> synIDattr(synIDtrans(hlID('Tabline')), k)})

    let cmd = has('gui_running')
          \ ?     'hi TabLine gui=none guifg=%s'
          \ : &tgc
          \ ?     'hi TabLine term=none cterm=none guifg=%s'
          \ :     'hi TabLine term=none cterm=none ctermfg=%s'

    " For  some  values of  `g:seoul{_light}_background`,  the  fg attribute  of
    " Tabline doesn't have any value in gui. In this case, executing the command
    " will fail.
    if attributes.fg is# ''
        return
    endif
    exe printf(cmd, attributes.fg)
endfu

fu! s:user() abort "{{{1
    " We're going to define 2 HGs: User1 and User2.{{{
    "
    " We use them in the status line to customize the appearance of:
    "
    "     • the filename
    "     • the modified flag
    "
    " We want their  attributes to be the  same as the ones of  the HG `StatusLine`,
    " except for one: `reverse` (boolean flag).
    "
    " `User1` and `StatusLine` should have opposite values for the `reverse` attribute.
    " Also, we set the color of the background of `User2` as the same as the
    " foreground color of `Todo`, so that the modified flag clearly stands out.
    "}}}

    " `ctermfg`, `ctermbg`, `guifg`, `guibg` are not attributes of the HG
    " `StatusLine`. They are arguments for the `:hi` command.
    " They allow us to set the real attributes (`fg` and `bg`) for Vim in
    " terminal or in GUI.
    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    call map(attributes, {k,v -> synIDattr(synIDtrans(hlID('StatusLine')), k)})

    if has('gui_running')
        " When 'termguicolors' is set, you set up:
        "
        "     • the style  of a HG with the argument  `cterm`   , not `gui`
        "     • the colors of a HG with the arguments `gui[fb]g`, not `cterm[fb]g`
        "
        " IOW, 'tgc' has an effect on how you set up the COLORS of a HG, but not
        " its STYLE.
        let cmd1 = 'hi User1  gui=%s  guifg=%s  guibg=%s'
        let cmd2 = 'hi User2  gui=%s  guifg=%s  guibg=%s'

    elseif &tgc
        let cmd1 = 'hi User1  cterm=%s  guifg=%s  guibg=%s'
        let cmd2 = 'hi User2  cterm=%s  guifg=%s  guibg=%s'

    else
        let cmd1 = 'hi User1  cterm=%s ctermfg=%s ctermbg=%s'
        let cmd2 = 'hi User2  cterm=%s ctermfg=%s ctermbg=%s'
        "                                       │
        "                                       └ yes, you could use `%d`
        "                                         but you couldn't use `%d` for `guifg`
        "                                         nor `%x`
        "                                         nor `%X`
        "                                         only `%s`
        "                                         so, we use `%s` everywhere
    endif

    " For some  colorschemes (default, darkblue,  …), some values used  in the
    " command which is  going to be executed may be  empty. If that happens, the
    " command will fail:
    "
    "         Error detected while processing function <SNR>18_set_user_hg:
    "         E421: Color name or number not recognized: ctermfg= ctermbg=
    if attributes.fg is# '' || attributes.bg is# ''
        return
    endif

    let style1 = (attributes.bold ? 'bold,' : '').(attributes.reverse ? '' : 'reverse')
    if style1 is# '' | return | endif

    exe printf(cmd1, style1, attributes.fg, attributes.bg)

    let style2 = (attributes.bold ? 'bold,' : '').(attributes.reverse ? 'reverse' : '')
    if style2 is# '' | return | endif

    let todo_fg = synIDattr(synIDtrans(hlID('Todo')), 'fg')
    exe printf(cmd2, style2, todo_fg, attributes.bg)
endfu

