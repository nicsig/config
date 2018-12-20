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
"         →       Error detected while processing .../colors/my_customizations.vim:
"                 E420: BG color unknown
try
    if $DISPLAY is# ''
        hi EndOfBuffer ctermfg=bg
    else
        hi EndOfBuffer ctermfg=bg guifg=bg
    endif
catch
    call lg#catch_error()
endtry

" QuickFixLine {{{2

" hide the current line in a qf window (the cursor and the cursor line should be enough)
"     hi link QuickFixLine Search

" Update:
" Commented, because now I  find that seeing the current entry  is nice when you
" move quickly in a qf buffer.

" SpecialKey {{{2

" The `SpecialKey` HG installed by seoul-256 is barely readable.
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
" The global 'hl' option can be used  to configure the style of various elements
" in the UI.
" It contains a comma separated list of values.
"
" Each value follows one the following syntax:

"       ┌ character standing for which element of the UI we want to configure
"       │         ┌ character standing for which style we want to apply
"       ├────────┐├────┐
"       {occasion}{mode}

"       {occasion}:{HG}
"                   │
"                   └ highlight group to color the element of the UI

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
" }}}1
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
        au VimEnter * call colorscheme#set_custom_hg()
    augroup END
else
    call colorscheme#set_custom_hg()
endif

