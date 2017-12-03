" Let the functions at the top, they're called later.
" Functions {{{1
fu! s:set_backticks_hg() abort "{{{2
    let attributes = {
    \                  'fg'      : 0,
    \                  'bg'      : 0,
    \                  'bold'    : 0,
    \                  'reverse' : 0,
    \                }

    call map(attributes, 'synIDattr(synIDtrans(hlID("Comment")), v:key)')

    let cmd = has('gui_running')
    \?            'hi MyBackticks gui=bold guifg=%s'
    \:            'hi MyBackticks term=bold cterm=bold ctermfg=%s'

    exe printf(cmd, attributes.fg)
endfu

fu! s:set_user_hg() abort "{{{2
    " `ctermfg`, `ctermbg`, `guifg`, `guibg` are not attributes of the HG
    " `StatusLine`. They are arguments for the `:hi` command.
    " They allow us to set the real attributes (`fg` and `bg`) for Vim in
    " terminal or in GUI.
    let attributes = {
    \                  'fg'      : 0,
    \                  'bg'      : 0,
    \                  'bold'    : 0,
    \                  'reverse' : 0,
    \                }

    call map(attributes, 'synIDattr(synIDtrans(hlID("StatusLine")), v:key)')

    let todo_fg = synIDattr(synIDtrans(hlID('Todo')), 'fg')

    let cmd1 = has('gui_running')
    \?             'hi User1  gui=%s   guifg=%s   guibg=%s'
    \:             'hi User1  cterm=%s ctermfg=%s ctermbg=%s'
    "                                           │
    "                                           └ yes, you could use `%d`
    "                                             but you couldn't use `%d` for `guifg`
    "                                             nor `%x`
    "                                             nor `%X`
    "                                             only `%s`
    "                                             so, we use `%s` everywhere

    let cmd2 = has('gui_running')
    \?             'hi User2  gui=%s   guifg=%s   guibg=%s'
    \:             'hi User2  cterm=%s ctermfg=%s ctermbg=%s'


    " For some  colorschemes (default, darkblue,  …), some values used  in the
    " command which is  going to be executed may be  empty. If that happens, the
    " command will fail:
    "
    "         Error detected while processing function <SNR>18_set_user_hg:
    "         E421: Color name or number not recognized: ctermfg= ctermbg=
    if attributes.fg == '' || attributes.bg == ''
        return
    endif

    let style1 = (attributes.bold ? 'bold,' : '').(attributes.reverse ? '' : 'reverse')
    if style1 == '' | return | endif

    exe printf(cmd1, style1, attributes.fg, attributes.bg)

    let style2 = (attributes.bold ? 'bold,' : '').(attributes.reverse ? 'reverse' : '')
    if style2 == '' | return | endif

    exe printf(cmd2, style2, todo_fg, attributes.bg)
endfu

fu! s:set_tabline_hg() abort "{{{2
    " the purpose of this function is to remove the underline value from the HG
    " TabLine

    let attributes = {
    \                  'fg'      : 0,
    \                  'bg'      : 0,
    \                  'bold'    : 0,
    \                  'reverse' : 0,
    \                }

    call map(attributes, 'synIDattr(synIDtrans(hlID("Tabline")), v:key)')

    let cmd = has('gui_running')
    \?            'hi TabLine gui=none guifg=%s'
    \:            'hi TabLine term=none cterm=none ctermfg=%s'

    " For  some  values of  `g:seoul{_light}_background`,  the  fg attribute  of
    " Tabline doesn't have any value in gui. In this case, executing the command
    " will fail.
    if attributes.fg == ''
        return
    endif
    exe printf(cmd, attributes.fg)
endfu

" Custom HGs {{{1

" We're going to define 2 HGs: User1 and User2.
" We use them in the status line to customize the appearance of:
"
"     • the filename
"     • the modified flag
"
" We want the values of their attributes to be the same as the ones of the HG
" `StatusLine`, except for one:    `reverse` (boolean flag).
"
" `User1` and `StatusLine` should have opposite values for the `reverse` attribute.
" Also, we set the color of the background of `User2` as the same as the
" foreground color of `Todo`, so that the modified flag clearly stands out.

" OLD CODE:{{{
" We  don't need  this code  anymore, because  we don't  source the  colorscheme
" directly from the vimrc anymore, but from an autocmd listening to VimEnter.
" But I keep it commented in case it's useful again in the future.
"
"
" gVim starts slowly when we invoke one of the functions in this script, because
" of some errors:
"
"       E254: Cannot allocate color 95
"       E254: Cannot allocate color 187
"
" Indeed, for example, the value of:
"
"         synIDattr(hlID('StatusLine'), 'fg')
"
" … will be  a decimal number. Which is  good for the terminal,  but wrong for
" gVim. So, we slightly delay the 1st sourcing of this file, for gVim.
"
"         if has('gui_running') && has('vim_starting')
"             augroup gvim_delay_customize_colorscheme
"                 au!
"                 au VimEnter * exe 'so '.expand('<sfile>:p')
"                            \| exe 'au! gvim_delay_customize_colorscheme'
"                            \|      aug! gvim_delay_customize_colorscheme
"             augroup END
"             finish
"         endif
"}}}

call s:set_user_hg()
call s:set_backticks_hg()
call s:set_tabline_hg()

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
endtry

" QuickFixLine {{{2

" hide the current line in a qf window (the cursor and the cursor line should be enough)
hi! link QuickFixLine Normal
" │
" └─ :h E414

" Terminal {{{2

" I don't remember why I wrote this originally, but don't uncomment it.
" It seems to disable the color in the shell prompt of a terminal buffer.
"
"     hi link Terminal Normal
