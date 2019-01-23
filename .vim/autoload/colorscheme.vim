" Interface {{{1
fu! colorscheme#set() abort "{{{2
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

    let seoul_bg = get(g:, 'my_last_colorscheme', 253)
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
        "    │                             │                       │     │     └─ lightest                    │
        "    │                             │                       │     └─ default                           │
        "    │                             │                       └─ darkest                                 │
        "    ├─────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        "    │ g:seoul256_light_background │ value to be used the NEXT time we execute `:colo seoul256-light` │
        "    │                             │                                                                  │
        "    │                             │         Valid values: 252 … 253 … 256                            │
        "    │                             │                       │     │     │                              │
        "    │                             │                       │     │     └─ lightest                    │
        "    │                             │                       │     └─ default                           │
        "    │                             │                       └─ darkest                                 │
        "    └─────────────────────────────┴──────────────────────────────────────────────────────────────────┘
        "}}}
        let g:seoul256_background = seoul_bg
        colo seoul256
    else
        let g:seoul256_light_background = seoul_bg
        colo seoul256-light
    endif
endfu

fu! colorscheme#customize() abort "{{{2
    " the `SpecialKey` HG set by seoul256 is barely readable
    hi! link SpecialKey Special

    " the `VertSplit`  HG set  by seoul256  has a dark  background which  is too
    " visible in the light colorscheme, and not enough in the dark one
    hi! link VertSplit Normal

    " `Underlined` is meant to be used to highlight html links.{{{
    "
    " In a webbrowser, usually those are blue.
    " But in `seoul256`, `Underlined` is pink.
    " So, we reset the  HG with the `underline` style, and the  colors of the HG
    " `Conditional` (because this one is blue).
    "}}}
    exe 'hi Underlined term=underline cterm=underline gui=underline '
        \ . substitute(matchstr(execute('hi Conditional'), 'xxx\zs.*'), '\n\|links to.*', ' ', 'g')
        "                                                                 │{{{
        " If the width of the current window is too small,                ┘
        " the output will be wrapped on several lines, which may break our code.
        "}}}

    " Why changing `CursorLine`?{{{
    "
    " The  attributes set  by our  colorscheme make  the cursorline  not visible
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

    " hide the EndOfBuffer char (~) by changing its ctermfg attribute (ctermfg=bg)
    " Why this `:if` guard?{{{
    "
    " Some colorschemes don't set up the `Normal` HG.
    " So, the value `bg` may not exist for all colorschemes.
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

    " Why the delay?{{{
    "
    " gVim encounters some errors when trying to set up too early some of our custom HGs:
    "
    "     E417: missing argument: guifg=
    "     E254: Cannot allocate color 95
    "     E254: Cannot allocate color 187
    "
    " The issue  seems to be  that the HGs whose  attributes we need  to inspect
    " ('StatusLine', 'TabLine', ...), are not (correctly) defined yet.
    "}}}
    if has('gui_running') && has('vim_starting')
        augroup delay_colorscheme_when_gvim_starts
            au!
            au VimEnter * call s:tabline() | call s:user() | call s:styled_comments()
        augroup END
    else
        call s:tabline() | call s:user() | call s:styled_comments()
    endif
endfu

fu! colorscheme#save_last_version() abort "{{{2
    let line = 'let g:my_last_colorscheme = '.get(g:, 'seoul256_current_bg', 253)
    call writefile([line], $HOME.'/.vim/colors/my/last_version.vim')
endfu
" }}}1
" Core {{{1
fu! s:user() abort "{{{2
    " We're going to define 2 HGs: User1 and User2.{{{
    "
    " We use them in the status line to customize the appearance of:
    "
    "     - the filename
    "     - the modified flag
    "
    " We want their  attributes to be the  same as the ones of  the HG `StatusLine`,
    " except for one: `reverse` (boolean flag).
    "
    " `User1` and `StatusLine` should have opposite values for the `reverse` attribute.
    " Also, we set the color of the background of `User2` as the same as the
    " foreground color of `Todo`, so that the modified flag clearly stands out.
    "}}}

    " `ctermfg`, `ctermbg`, `guifg`, `guibg` are not attributes of the HG
    " `StatusLine`.
    " They are arguments for the `:hi` command.
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
        "    - the style  of a HG with the argument  `cterm`   , not `gui`
        "    - the colors of a HG with the arguments `gui[fb]g`, not `cterm[fb]g`
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

    " For some  colorschemes (default, darkblue,  ...), some values used  in the
    " command which is going to be executed may be empty.
    " If that happens, the command will fail:
    "
    "     Error detected while processing function <SNR>18_set_user_hg:
    "     E421: Color name or number not recognized: ctermfg= ctermbg=
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

fu! s:tabline() abort "{{{2
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

fu! s:styled_comments() abort "{{{2
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
    hi link markdownListItemCodeBlock   Comment
    hi link CommentListItemCodeSpan     markdownListItemCodeSpan

    hi link markdownListItemBlockquote  markdownBlockquote

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
    let statement_fg = s:get_attributes('Statement').fg
    let repeat_fg = s:get_attributes('Repeat').fg

    " the only relevant attributes in GUI are `gui`, `guifg` and `guibg`
    if has('gui_running')
        exe 'hi CommentCodeSpan guibg='.guibg.' guifg='.comment_fg
        exe 'hi markdownCodeSpan guibg='.guibg

        exe 'hi CommentBold gui=bold guifg='.comment_fg
        exe 'hi CommentBoldItalic gui=bold,italic guifg='.comment_fg
        exe 'hi CommentItalic gui=italic guifg='.comment_fg

        exe 'hi markdownListItem guifg='.repeat_fg
        exe 'hi markdownListItemBold gui=bold guifg='.repeat_fg
        exe 'hi markdownListItemBoldItalic gui=bold,italic guifg='.repeat_fg
        exe 'hi markdownListItemCodeSpan guifg='.repeat_fg.' guibg='.guibg
        exe 'hi markdownListItemItalic gui=italic guifg='.repeat_fg

        exe 'hi markdownBlockquote guifg='.statement_fg
        exe 'hi markdownBlockquoteBold gui=bold guifg='.statement_fg
        exe 'hi markdownBlockquoteBoldItalic gui=bold,italic guifg='.statement_fg
        exe 'hi markdownBlockquoteCodeSpan guibg='.guibg.' guifg='.statement_fg
        exe 'hi markdownBlockquoteItalic gui=italic guifg='.statement_fg

    " the only relevant attributes in a truecolor terminal are `cterm`, `guifg` and `guibg`
    elseif &tgc
        exe 'hi CommentCodeSpan guifg='.comment_fg.' guibg='.guibg
        exe 'hi markdownCodeSpan guibg='.guibg

        exe 'hi CommentBold cterm=bold guifg='.comment_fg
        exe 'hi CommentBoldItalic cterm=bold,italic guifg='.comment_fg
        exe 'hi CommentItalic cterm=italic guifg='.comment_fg

        exe 'hi markdownListItem guifg='.repeat_fg
        exe 'hi markdownListItemBold cterm=bold guifg='.repeat_fg
        exe 'hi markdownListItemBoldItalic cterm=bold,italic guifg='.repeat_fg
        exe 'hi markdownListItemCodeSpan guifg='.repeat_fg.' guibg='.guibg
        exe 'hi markdownListItemItalic cterm=italic guifg='.repeat_fg

        exe 'hi markdownBlockquote guifg='.statement_fg
        exe 'hi markdownBlockquoteBold cterm=bold guifg='.statement_fg
        exe 'hi markdownBlockquoteBoldItalic cterm=bold,italic guifg='.statement_fg
        exe 'hi markdownBlockquoteCodeSpan guifg='.statement_fg.' guibg='.guibg
        exe 'hi markdownBlockquoteItalic cterm=italic guifg='.statement_fg

    " the only relevant attributes in a terminal are `term`, `cterm`, `ctermfg` and `ctermbg`
    else
        exe 'hi CommentCodeSpan ctermfg='.comment_fg.' ctermbg='.ctermbg
        exe 'hi markdownCodeSpan ctermbg='.ctermbg

        exe 'hi CommentBold term=bold cterm=bold ctermfg='.comment_fg
        exe 'hi CommentBoldItalic term=bold,italic cterm=bold,italic ctermfg='.comment_fg
        exe 'hi CommentItalic term=italic cterm=italic ctermfg='.comment_fg

        exe 'hi markdownListItem ctermfg='.repeat_fg
        exe 'hi markdownListItemBold term=bold cterm=bold ctermfg='.repeat_fg
        exe 'hi markdownListItemBoldItalic term=bold,italic cterm=bold,italic ctermfg='.repeat_fg
        exe 'hi markdownListItemCodeSpan ctermfg='.repeat_fg.' ctermbg='.ctermbg
        exe 'hi markdownListItemItalic term=italic cterm=italic ctermfg='.repeat_fg

        exe 'hi markdownBlockquote ctermfg='.statement_fg
        exe 'hi markdownBlockquoteBold term=bold cterm=bold ctermfg='.statement_fg
        exe 'hi markdownBlockquoteBoldItalic term=bold,italic cterm=bold,italic ctermfg='.statement_fg
        exe 'hi markdownBlockquoteCodeSpan ctermfg='.statement_fg.' ctermbg='.ctermbg
        exe 'hi markdownBlockquoteItalic term=italic cterm=italic ctermfg='.statement_fg
    endif
endfu
" }}}1
" Utilities {{{1
fu! s:get_attributes(hg) abort "{{{2
    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }
    return map(attributes, {k,v -> synIDattr(synIDtrans(hlID(a:hg)), k)})
endfu

