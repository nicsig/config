" Existing HGs {{{1
" Completion menu {{{2

" If you want to change the colors in the completion menu, read `:h popupmenu-keys`.
"
"         The colors of the menu can be changed with these highlight groups:
"         Pmenu         normal item             |hl-Pmenu|
"         PmenuSel      selected item           |hl-PmenuSel|
"         PmenuSbar     scrollbar               |hl-PmenuSbar|
"         PmenuThumb	thumb of the scrollbar  |hl-PmenuThumb|

" EndOfBuffer {{{2

" hide the EndOfBuffer char (~) by changing its ctermfg attribute (ctermfg=bg)

" Some colorschemes don't set up the `Normal` HG.
" So, the value `bg` may not exist for all colorschemes.
" Example:
"         :colo default
"         →       Error detected while processing …/colors/my_customizations.vim:
"                 E420: BG color unknown
try
    hi EndOfBuffer ctermfg=bg guifg=bg
catch
    call lg#catch_error()
endtry

" QuickFixLine {{{2

" hide the current line in a qf window (the cursor and the cursor line should be enough)
" hi! link QuickFixLine Search
" │
" └─ :h E414

" Update:
" Commented, because now I  find that seeing the current entry  is nice when you
" move quickly in a qf buffer.

" SpecialKey {{{2

hi! link SpecialKey Special

" Terminal {{{2

" I don't remember why I wrote this originally, but don't uncomment it.
" It seems to disable the color in the shell prompt of a terminal buffer.
"
"     hi link Terminal Normal

" VertSplit {{{2

hi! link VertSplit Normal

" Is there an alternative?{{{
"
" Yes, you can configure the 'hl' option in Vim.
"}}}
" Can it be used for other HGs?{{{
"
" Yes among others, there is `SpecialKey`.
"}}}
" How to configure 'hl' to achieve the same result?{{{

" " We must reset the option so that we can change the configuration, resource
" " our vimrc, and immediately see the result.
" set hl&vim
"
" "       ┌─ column used to separate vertically split windows
" "       │
" set hl-=c:VertSplit hl+=c:StatusLine
" "         │               │
" "         │               └─ new HG
" "         └─ default HG
"
" "       ┌─ Meta and special keys listed with ":map"
" "       │
" set hl-=8:SpecialKey hl+=8:Special
"}}}
" How does it work?{{{
"
" The global 'highlight' / 'hl' option can be used to configure the style of
" various elements in the UI. It contains a comma separated list of values.
"
" Each value follows one the following syntax:

"                ┌ character standing for which element of the UI we want to configure
"       ┌────────┤
"       {occasion}{mode}
"                 └────┤
"                      └ character standing for which style we want to apply

"       {occasion}:{HG}
"                   │
"                   └─ highlight group to color the element of the UI

" The default values all use the 2nd syntax. They all use a HG.
" But you could also use a mode:
"
"         r  reverse
"         i  italic
"         b  bold
"         s  standout
"         u  underline
"         c  undercurl
"         n  no highlighting
"}}}
" Why don't you use it anymore?{{{
"
" It's deprecated in Neovim.
" It feels useless, since we don't need this option to configure any HG.
"}}}
" Custom HGs {{{1

" We're going to define 2 HGs: User1 and User2.
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

call colorscheme#set_custom_hg()
" Why?{{{
"
"     $ cat /tmp/md.md
"     hello *world*
"
"     $ vim /tmp/md.md
"
" `world` is not in italic (✘).
"
" The issue comes from the `htmlitalic` HG which is cleared.
" This wouldn't happen if we didn't  delay the sourcing of the colorscheme until
" VimEnter.
" But delaying the colorscheme presents too many benefits.
" Besides, even if we didn't delay it, the issue would still occur every time
" we change the version of the colorscheme (light vs dark, lightness).
"
" If  you reload  the buffer,  or execute  `:do syntax`,  the issue  disappears,
" because the HG is re-installed.
"
" The HG was cleared because of `:hi clear`:
"
"     ~/.vim/plugged/seoul256.vim/colors/seoul256.vim:201
"
" There're probably other HGs  which suffer from the same issue,  so we create a
" function whose purpose will be to restore as many as possible.
"}}}
call colorscheme#restore_cleared_hg()
