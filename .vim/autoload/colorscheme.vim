fu! colorscheme#save_last_version() abort "{{{1
    let line = 'let g:my_last_colorscheme = '.get(g:, 'seoul256_current_bg', 253)
    call writefile([line], $HOME.'/.vim/colors/my/last_version.vim')
endfu

fu! colorscheme#set() abort "{{{1
    let seoul_bg = get(g:, 'my_last_colorscheme', 253)

    if seoul_bg >= 233 && seoul_bg <= 239
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

fu! colorscheme#set_custom_hg() abort "{{{1
    call s:user()
    call s:styled_comments()
    call s:tabline()
endfu

fu! s:styled_comments() abort "{{{1
    let attributes = {
        \ 'fg'      : 0,
        \ 'bg'      : 0,
        \ 'bold'    : 0,
        \ 'reverse' : 0,
        \ }

    call map(attributes, {k,v -> synIDattr(synIDtrans(hlID('Comment')), k)})

    for [attribute, hg] in items({'bold': 'CommentStrong', 'italic': 'CommentEmphasis'})
        let cmd = has('gui_running')
              \ ?     'hi '.hg.' gui='.attribute.' guifg=%s'
              \ : &tgc
              \ ?     'hi '.hg.' term='.attribute.' cterm='.attribute.' guifg=%s'
              \ :     'hi '.hg.' term='.attribute.' cterm='.attribute.' ctermfg=%s'
        exe printf(cmd, attributes.fg)
    endfor

    " if &background is# 'light'
    "     exe 'hi CommentCodeSpan '.(has('gui_running') || &tgc ? 'guifg' : 'ctermfg').'=235'
    " else
    "     exe 'hi CommentCodeSpan '.(has('gui_running') || &tgc ? 'guifg' : 'ctermfg').'=255'
    " endif

    " TODO: maybe find better color for blockquotes, codespans and codeblocks
    " TODO: make sure that the colors are readable no matter the lightness,
    " and even when we use the dark colorscheme (and even in GUI)
    if has('gui_running') || &tgc
        exe 'hi CodeSpan guibg=#bcbcbc'
        exe 'hi CommentCodeSpan guibg=#bcbcbc guifg=' . attributes.fg
        exe 'hi CommentBlockQuote gui=italic guibg=#bcbcbc guifg=' . attributes.fg
    else
        exe 'hi CodeSpan ctermbg=250'
        exe 'hi CommentCodeSpan ctermbg=250 ctermfg=' . attributes.fg
        exe 'hi CommentBlockQuote term=italic cterm=italic ctermfg=' . attributes.fg
    endif

    " if has('gui_running') || &tgc
    "     exe 'hi CommentCodeSpan guifg=#9A7372'
    " else
    "     exe 'hi CommentCodeSpan ctermfg=95'
    " endif

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

