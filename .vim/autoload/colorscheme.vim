vim9 noclear

# Init {{{1

import Termname from 'lg/term.vim'
import Derive from 'lg/syntax.vim'

# map greyscale colors from decimal to hexadecimal
const DEC2HEX = {
    232: '#080808',
    233: '#121212',
    234: '#1c1c1c',
    235: '#262626',
    236: '#303030',
    237: '#3a3a3a',
    238: '#444444',
    239: '#4e4e4e',
    240: '#585858',
    241: '#626262',
    242: '#6c6c6c',
    243: '#767676',
    244: '#808080',
    245: '#8a8a8a',
    246: '#949494',
    247: '#9e9e9e',
    248: '#a8a8a8',
    249: '#b2b2b2',
    250: '#bcbcbc',
    251: '#c6c6c6',
    252: '#d0d0d0',
    253: '#dadada',
    254: '#e4e4e4',
    255: '#eeeeee',
    }

# Interface {{{1
def colorscheme#set() #{{{2
    # Purpose:{{{
    #
    # If `g:seoul256_srgb` is set to 1, the color mapping is altered to suit the
    # way urxvt (and various other terminals) renders them.
    # That  way, the  colors  of the  terminal and  GUI  versions are  uniformly
    # colored on Linux.
    #
    # https://github.com/junegunn/seoul256.vim#alternate-256-xterm---srgb-mapping
    #}}}
    g:seoul256_srgb = 1
    # Purpose:{{{
    #
    # In  various locations  (this  function  + a  function  invoked by  `coC`),
    # we  need  to  choose  a  default  value for  the  level  of  lightness  of
    # seoul256-light.
    #
    # To be consistent, we need a *unique* variable to which we can refer anywhere.
    # Note that this variable is custom; it's only intended for our own purpose;
    # all the other `g:seoul256_` variables are set/used by seoul.
    #}}}
    g:seoul256_default_lightness = 253

    var seoul_bg = get(g:, 'last_color_scheme', g:seoul256_default_lightness)
    if seoul_bg >= 233 && seoul_bg <= 239
        # What's this `g:seoul256_background`?{{{
        #
        #    ┌─────────────────────────────┬──────────────────────────────────────────────────────────────────┐
        #    │ g:seoul256_current_bg       │ Current background color in ANSI code                            │
        #    │ g:seoul256_current_fg       │ Current foreground color in ANSI code                            │
        #    │                             │                                                                  │
        #    │                             │ ┌ dark             ┌ light                                       │
        #    │                             │ ├─────────┐        ├─────────┐                                   │
        #    │                             │ 233 ... 239        252 ... 256                                   │
        #    ├─────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        #    │ g:seoul256_background       │ value to be used the NEXT time we execute `:colo seoul256`       │
        #    │                             │                                                                  │
        #    │                             │         Valid values: 233 … 237 … 239                            │
        #    │                             │                       │     │     │                              │
        #    │                             │                       │     │     └ lightest                     │
        #    │                             │                       │     └ default                            │
        #    │                             │                       └ darkest                                  │
        #    ├─────────────────────────────┼──────────────────────────────────────────────────────────────────┤
        #    │ g:seoul256_light_background │ value to be used the NEXT time we execute `:colo seoul256-light` │
        #    │                             │                                                                  │
        #    │                             │         Valid values: 252 … 253 … 256                            │
        #    │                             │                       │     │     │                              │
        #    │                             │                       │     │     └ lightest                     │
        #    │                             │                       │     └ default                            │
        #    │                             │                       └ darkest                                  │
        #    └─────────────────────────────┴──────────────────────────────────────────────────────────────────┘
        #}}}
        g:seoul256_background = seoul_bg
        colo seoul256
    else
        g:seoul256_light_background = seoul_bg
        colo seoul256-light
    endif

    # Make sure Vim uses the ANSI colors of our terminal palette in a terminal buffer.
    # Necessary when `'tgc'` is set.
    # Could I use color names instead?{{{
    #
    # Yes, you can use a color name  as suggested at `:h gui-colors`, instead of
    # a  hex  color  code, but  it  would  make  Vim  choose the  color  in  its
    # builtin/fallback palette, which will be ugly/flashy.
    #}}}
    g:terminal_ansi_colors =<< trim END
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
enddef

def colorscheme#customize() #{{{2
    # We delay until `VimEnter` to avoid errors when starting gVim.{{{
    #
    #     E417: missing argument: guifg=~
    #     E254: Cannot allocate color 95~
    #     E254: Cannot allocate color 187~
    #
    # I think it depends on the Vim version you're using.
    # At one point in the past, we needed the delay, then not, then again...
    #
    # When the issue is  triggered it's because we are trying to  set up some of
    # our custom HGs too early.
    # Specifically,  we   need  to  inspect  some   default  HGs  (`StatusLine`,
    # `TabLine`, ...), but their attributes are not (correctly) defined yet.
    #}}}
    if has('vim_starting') && has('gui_running')
        au VimEnter * Override() | StyledComments() | Misc()
    else
        Override() | StyledComments() | Misc()
    endif

    # Why?{{{
    #
    # Without, we wouldn't  be able to switch to the  dark color scheme, neither
    # via `coC`, nor via `:colo seoul256`.
    #
    # ---
    #
    # When we  try to switch from  the light color  scheme to the dark  one, the
    # value of `g:seoul256_background`  is interpreted as the desire  to set the
    # light color scheme:
    #
    #     " ~/.vim/plugged/seoul256.vim/colors/seoul256.vim
    #     elseif s:seoul256_background >= 252 && s:seoul256_background <= 256
    #       let s:style = 'light'
    #
    # This is not what we want; we want the dark one.
    # We must  make sure  that –  if we're using  the light  color scheme  – the
    # variable is  set to a  value inside the range  `[233, 239]`; so that  if we
    # later decide to switch to the dark color scheme, we *can*.
    # We pick `237` because it's right in the middle, and is the default value.
    #
    # ---
    #
    # Do *not* delete `g:seoul256_background`.
    #
    # It could raise an error when you execute `:colo seoul256`.
    # Atm, I  can reproduce this  issue by starting  Vim with the  light scheme,
    # pressing `coC` to switch to the  dark one, then pressing `]ol` to increase
    # the lightness.
    #
    # The error comes from:
    #
    #     " ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim
    #     " /fu s:lightness(
    #     let level = g:seoul256_background - 233 + 1
    #                 ^-------------------^
    #                 must exist, otherwise an error is raised
    #}}}
    if &bg == 'light' | g:seoul256_background = 237 | endif

    colorscheme#cursorline(&bg == 'dark') # (re)set `'cul'`

    # the cursor does not seem to need any customization in the GUI;
    # seoul256 correctly sets its color depending on which version we're using (light vs dark)
    if has('gui_running') | return | endif

    # If we start Vim with a dark color scheme, the cursor must be visible.{{{
    #
    # We use a  light color scheme in  our terminal, and we  have configured our
    # terminal so that the cursor is visible on a light background.
    # However, if we use a dark color  scheme, the cursor color must be reset so
    # that we can see it on a dark background.
    #}}}
    if has('vim_starting') && &bg == 'dark'
        # Why the timer?{{{
        #
        # `s:Cursor()` needs to know the name of the terminal.
        # It does so by calling  `s:Termname()` which in turn calls `system()`.
        # `system()` is slow: we don't want to increase the startup time.
        #
        # ---
        #
        # A small  delay is acceptable, because  we only need to  set the cursor
        # color right from  the start for the dark color  scheme, which we don't
        # use often, and never right from the start of a new Vim session.
        #
        # ---
        #
        # In the future, if  you stop using the st terminal, or  if you patch it
        # to support  hexcode values or  rgb specifications, you  could probably
        # eliminate the timer.
        # Indeed, as long  as all your terminals support  hexcodes/rgb spec, you
        # don't need the terminal name anymore.
        #}}}
        timer_start(1000, () => Cursor())
    elseif !has('vim_starting')
        Cursor()
    endif
enddef

def colorscheme#cursorline(enable: bool) #{{{2
    # Why is this function public?{{{
    #
    # We  need to  be able  to  call it  from `autoload/toggle_settings.vim`  to
    # implement the `]oL` and `[oL` mappings which toggle `'cul'`.
    #}}}

    # Warning: Enabling  `'cul'` can  be extremely  cpu-consuming when  you move
    # horizontally (j, k, w, b, e, ...) and `'showcmd'` is enabled.

    # `'cul'` only in the active window and not in insert mode.
    if enable && !&l:cul
        setl cul
        # What does this do?{{{
        #
        # When the cursor is on a long soft-wrapped line, and we enable `'cul'`,
        # we want  only the  current *screen*  line to  be highlighted,  not the
        # whole *text* line.
        #}}}
        culopt_save = &l:culopt
        &l:culopt = 'screenline'
        augroup MyCursorline | au!
            # Why `BufWinEnter` and `BufWinLeave`?{{{
            #
            # If you load  another buffer in the current  window, `WinLeave` and
            # `WinEnter` are not fired.
            # It may happen, for example, when  you move in the quickfix list by
            # pressing `]q`.
            #}}}
            au VimEnter,BufWinEnter,WinEnter * setl cul   | &l:culopt = 'screenline'
            au BufWinLeave,WinLeave          * setl nocul | &l:culopt = culopt_save
            au InsertEnter                   * setl nocul | &l:culopt = culopt_save
            au InsertLeave                   * setl cul   | &l:culopt = 'screenline'
        augroup END
    elseif !enable && &l:cul
        # When is this guard necessary?{{{
        #
        #     :setl cul
        #     " press `]oL`
        #}}}
        if exists('#MyCursorline')
            au! MyCursorline
            aug! MyCursorline
        endif
        setl nocul
        &l:culopt = culopt_save ?? &l:culopt
    endif
enddef
var culopt_save: string

def colorscheme#saveLastVersion() #{{{2
    var lines = ['vim9script', 'g:last_color_scheme = ' .. get(g:, 'seoul256_current_bg', 253)]
    writefile(lines, $HOME .. '/.vim/colors/my/last_version.vim')
enddef
# }}}1
# Core {{{1
def Override() #{{{2
    CursorLine()
    DiffChange()
    EndOfBuffer()
    LineNrAboveBelow()
    SpecialKey()
    StatuslineNC()
    TabLine()
    Title()
    Underlined() | CommentUnderlined()
    User()
    VertSplit()
enddef

# override default HGs {{{2
def CursorLine() #{{{3
    # Why changing `CursorLine`?{{{
    #
    # The attributes  set by our  color scheme  make the cursorline  not visible
    # enough.
    #}}}
    # Why `ctermbg=NONE` and `guibg=NONE`?{{{
    #
    # To make `CursorLine` transparent in case of a conflict between two HGs.
    # It happens  when `'cursorline'` is set,  and the *background* of  the text
    # under the cursor is highlighted by a syntax item.
    #}}}
    # It's not visible enough!{{{
    #
    # Add the bold value:
    #
    #     hi CursorLine term=bold,underline cterm=bold,underline gui=bold,underline ctermbg=NONE guibg=NONE
    #                        ^--^                 ^--^               ^--^
    #}}}
    hi CursorLine term=underline cterm=underline gui=underline ctermbg=NONE guibg=NONE
enddef

def DiffChange() #{{{3
    # Why do you clear `DiffChange`?{{{
    #
    # When  you compare  two  windows  in diff  mode,  `DiffChange`  is used  to
    # highlight the text which has *not* changed on a line which *has* changed.
    # I don't care about the text which didn't change.
    # It adds visual clutter.
    #}}}
    hi! link DiffChange NONE
    hi! clear DiffChange
enddef

def EndOfBuffer() #{{{3
    # hide the `EndOfBuffer` char (`~`) by changing its ctermfg attribute (`ctermfg=bg`)
    # Why this `:if` guard?{{{
    #
    # Some color schemes don't set up the `Normal` HG.
    # So, the value `bg` may not exist for all color schemes.
    #
    #     :colo elflord
    #     :hi EndOfBuffer ctermfg=bg
    #     E420: BG color unknown ~
    #}}}
    if execute('hi Normal') =~ 'ctermbg'
        if $DISPLAY == ''
            hi EndOfBuffer ctermfg=bg
        else
            hi EndOfBuffer ctermfg=bg guifg=bg
        endif
    endif
enddef

def LineNrAboveBelow() #{{{3
    # useful when `'rnu'` is set (only available in Vim atm)
    hi! link LineNrAbove DiffDelete
    hi! link LineNrBelow DiffAdd
enddef

def SpecialKey() #{{{3
    # the `SpecialKey` HG set by seoul is barely readable
    hi! link SpecialKey Special
enddef

def StatuslineNC() #{{{3
    # the file path in the status line of a non-focused window is too visible; let's fix that
    # Why don't you use a hard-coded value?{{{
    #
    # It may not always look nice, depending on whether we use the dark or light
    # version of seoul, and depending on the level of lightness.
    # Instead, we compute it programmatically from another HG; `TabLine` seems a
    # good fit.
    #}}}
    # Why do you pass this extra `cterm` argument?{{{
    #
    # If we  are in  gui or in  a true color  terminal, then  `synIDattr()` will
    # return an hexadecimal number.  We can't easily make it less/more light.
    # We need  a decimal  number to which  we can apply  a simple  offset; later
    # we'll convert the result back in hexadecimal via `s:DEC2HEX`.
    #
    # To force `synIDattr()` to return a decimal  number, we nedd to pass it the
    # optional `{mode}` argument, to ask for  the value the attribute would have
    # if we were in an arbitrary mode (here `cterm`).
    #}}}
    var bg = GetAttributes('TabLine', 'cterm').bg->str2nr() + (&bg == 'light' ? -6 : 6)
    if has('gui_running') || &tgc
        # The value of `bg` may not be a key in the dictionary `s:DEC2HEX`.{{{
        #
        # That's  because there  is  no  guarantee that  the  `bg` attribute  of
        # `TabLine` is between 232 and 255.
        # For example, that's not the case with these color schemes:
        # default, delek, koehler, morning, peachpuff, shine, zellner.
        #}}}
        exe 'hi StatuslineNC guibg=' .. get(DEC2HEX, bg, '#808080')
    else
        exe 'hi StatuslineNC ctermbg=' .. bg
    endif
    # In a non-focused window, we highlight the file path with `User1`.  That's not the colors which are applied!{{{
    #
    # I think that's because of `:h 'stl /User`:
    #
    #    > The difference between User{N} and StatusLine  will be applied
    #    > to StatusLineNC for the statusline of non-current windows.
    #
    # Although, I  don't really understand  how that  explains how Vim  gets the
    # colors it uses to highlight the file path in a non-focused window...
    #}}}
    # The foreground and background colors are reversed!{{{
    #
    # I  think that's  because the original  HG  is defined  with the  `reverse`
    # attribute,  and  `:hi`  doesn't  reset  *all*  the  attributes;  only  the
    # attributes that you pass to it as arguments.
    #}}}
enddef

def TabLine() #{{{3
    # the purpose of this function is to remove the underline value from the HG `TabLine`

    var attributes = {
        fg: 0,
        bg: 0,
        bold: 0,
        reverse: 0,
        }

    map(attributes, (k) => hlID('Tabline')->synIDtrans()->synIDattr(k))

    var cmd: string
    if has('gui_running')
        cmd = 'hi TabLine gui=none guifg=%s'
    elseif &tgc
        cmd = 'hi TabLine term=none cterm=none guifg=%s'
    else
        cmd = 'hi TabLine term=none cterm=none gui=none ctermfg=%s'
    endif

    # For  some  values of  `g:seoul{_light}_background`,  the  fg attribute  of
    # Tabline  doesn't have  any  value in  gui.  In  this  case, executing  the
    # command will fail.
    if attributes.fg == 0 | return | endif
    exe printf(cmd, attributes.fg)
enddef

def Title() #{{{3
    # Purpose: We need some HGs to get the bold, italic, bold+italic styles in a markdown header.
    var title_fg = GetAttributes('Title').fg
    if has('gui_running')
        # In gVim, `seoul256` makes a markdown Title bold by default.
        # It prevents us from using the bold style.
        # So, we remove this attribute.
        hi clear Title
        exe 'hi Title guifg=' .. title_fg

        exe 'hi TitleItalic gui=italic guifg=' .. title_fg
        exe 'hi TitleBold gui=bold guifg=' .. title_fg
        exe 'hi TitleBoldItalic gui=bold,italic guifg=' .. title_fg

    elseif &tgc
        exe 'hi TitleItalic cterm=italic guifg=' .. title_fg
        exe 'hi TitleBold cterm=bold guifg=' .. title_fg
        exe 'hi TitleBoldItalic cterm=bold,italic guifg=' .. title_fg

    else
        exe 'hi TitleItalic term=italic cterm=italic ctermfg=' .. title_fg
        exe 'hi TitleBold term=bold cterm=bold ctermfg=' .. title_fg
        exe 'hi TitleBoldItalic term=bold,italic cterm=bold,italic ctermfg=' .. title_fg
    endif
enddef

def Underlined() #{{{3
    # Useful to highlight html links.{{{
    #
    # In a webbrowser, usually those are blue.
    # But in `seoul256`, `Underlined` is pink.
    # So, we reset the  HG with the `underline` style, and the  colors of the HG
    # `Conditional` (because this one is blue).
    #}}}
    sil! Derive('Underlined', 'Conditional', 'term=underline cterm=underline gui=underline')
enddef

def CommentUnderlined() #{{{3
    # define the `CommentUnderlined` HG (useful for urls in comments)
    sil! Derive('CommentUnderlined', 'Comment', 'term=underline cterm=underline gui=underline')
enddef

fu User() abort "{{{3
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
        \ 'fg': 0,
        \ 'bg': 0,
        \ 'bold': 0,
        \ 'reverse': 0,
        \ }

    call map(attributes, {k -> hlID('StatusLine')->synIDtrans()->synIDattr(k)})

    if has('gui_running')
        let cmd1 = 'hi User1 gui=%s guifg=%s guibg=%s'
        let cmd2 = 'hi User2 gui=%s guifg=%s guibg=%s'

    elseif &tgc
        let cmd1 = 'hi User1 cterm=%s guifg=%s guibg=%s'
        let cmd2 = 'hi User2 cterm=%s guifg=%s guibg=%s'

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
    if attributes.fg == '' || attributes.bg == ''
        return
    endif

    let style1 = (attributes.bold ? 'bold,' : '') .. (attributes.reverse ? '' : 'reverse')
    if style1 == '' | return | endif

    exe printf(cmd1, style1, attributes.fg, attributes.bg)

    let style2 = (attributes.bold ? 'bold,' : '') .. (attributes.reverse ? 'reverse' : '')
    if style2 == '' | return | endif

    let todo_fg = hlID('Todo')->synIDtrans()->synIDattr('fg')
    exe printf(cmd2, style2, todo_fg, attributes.bg)
endfu

def VertSplit() #{{{3
    # When  you split  a  window  vertically, Vim  uses  `VertSplit`  to draw  2
    # vertical lines, and in the middle it puts a white vertical line.
    # That's too much.  I only need one black vertical line.
    #
    # For some reason, linking `VertSplit` to `Normal` gets us the desired result.
    hi! link VertSplit Normal
enddef
#}}}2
def StyledComments() #{{{2
    # Need this to be able to make a distinction between comments and code highlighted by `PreProc`.{{{
    #
    # By default, `PreProc` can be used to highlight both comment and code.
    # As an  example, it  highlights comment  titles in  Vim, and  some variable
    # references in shell.
    #
    # This causes an issue when we enter goyo mode.
    # In this mode, we're only interested in code, not comments.
    # So, we want to ignore a *comment* highlighted by `PreProc` (`:hi link xFoo Ignore`),
    # but not the *code* highlighted by `PreProc`.
    #
    # We can't blindly ignore any text highlighted by `PreProc`.
    # We need a way to distinguish between comment and code.
    # To achieve this, we install this `CommentPreProc` HG.
    # In `~/plugged/vim-lg-lib/autoload/lg/styled_comment.vim`, we use it
    # to highlight comment titles and outputs of commands.
    #
    # This way,  we retain  the same  highlighting (because  `CommentPreProc` is
    # linked to `PreProc`), but we can  ignore it in goyo mode without affecting
    # the code highlighted by `PreProc`.
    #}}}
    hi link CommentPreProc PreProc

    # Why `Underlined`?{{{
    #
    # From `:h group-name`:
    #
    #    > *Underlined       text that stands out, HTML links
    #
    # Also, that's what the default markdown syntax plugin uses to highlight the
    # text of a link.
    #}}}
    hi link markdownLinkText   Underlined
    # Why `Float`?{{{
    #
    # That's what the default markdown syntax plugin uses to highlight a url.
    #}}}
    hi link markdownUrl        Float
    # Why `Type`?{{{
    #
    # That's what the help syntax plugin uses.
    #}}}
    hi link markdownOption     Type
    # Why `Delimiter`?{{{
    #
    # It seems to be the most meaningful choice.
    # From `:h group-name`:
    #
    #    > Delimiter character that needs attention
    #}}}
    hi link markdownPointer    Delimiter
    hi link markdownTable      Structure
    hi link markdownKey        Special
    hi link markdownRule       Delimiter
    # Why `Typedef`?{{{
    #
    # That's what the default markdown syntax plugin uses to highlight the id of
    # a reference link.
    #}}}
    hi link markdownIdDeclaration  Typedef

    hi link markdownCodeBlock           Comment
    hi link markdownListItemCodeBlock   markdownCodeBlock
    hi link markdownFencedCodeBlock     markdownCodeBlock
    hi link CommentListItemCodeSpan     markdownListItemCodeSpan

    hi link markdownListItemBlockquote  markdownBlockquote

    var nbg: number = GetAttributes('TabLine', 'cterm').bg->str2nr()
        + (&bg == 'light' ?  2 : -2)
    var bg: string
    if has('gui_running') || &tgc
        bg = get(DEC2HEX, nbg, '#808080')
    else
        bg = string(nbg)
    endif
    var comment_fg = GetAttributes('Comment').fg
    var statement_fg = GetAttributes('Statement').fg
    var repeat_fg = GetAttributes('Repeat').fg

    # the only relevant attributes in GUI are `gui`, `guifg` and `guibg`
    if has('gui_running')
        exe 'hi CommentCodeSpan guifg=' .. comment_fg .. ' guibg=' .. bg
        exe 'hi markdownCodeSpan guibg=' .. bg

        exe 'hi CommentBold gui=bold guifg=' .. comment_fg
        exe 'hi CommentBoldItalic gui=bold,italic guifg=' .. comment_fg
        exe 'hi CommentItalic gui=italic guifg=' .. comment_fg

        exe 'hi markdownListItem guifg=' .. repeat_fg
        exe 'hi markdownListItemBold gui=bold guifg=' .. repeat_fg
        exe 'hi markdownListItemBoldItalic gui=bold,italic guifg=' .. repeat_fg
        exe 'hi markdownListItemCodeSpan guifg=' .. repeat_fg .. ' guibg=' .. bg
        exe 'hi markdownListItemItalic gui=italic guifg=' .. repeat_fg

        exe 'hi markdownBlockquote guifg=' .. statement_fg
        exe 'hi markdownBlockquoteBold gui=bold guifg=' .. statement_fg
        exe 'hi markdownBlockquoteBoldItalic gui=bold,italic guifg=' .. statement_fg
        exe 'hi markdownBlockquoteCodeSpan guibg=' .. bg .. ' guifg=' .. statement_fg
        exe 'hi markdownBlockquoteItalic gui=italic guifg=' .. statement_fg

    # the only relevant attributes in a truecolor terminal are `guifg`, `guibg`, and `cterm`
    elseif &tgc
        exe 'hi CommentCodeSpan guifg=' .. comment_fg .. ' guibg=' .. bg
        exe 'hi markdownCodeSpan guibg=' .. bg

        exe 'hi CommentBold cterm=bold guifg=' .. comment_fg
        exe 'hi CommentBoldItalic cterm=bold,italic guifg=' .. comment_fg
        exe 'hi CommentItalic cterm=italic guifg=' .. comment_fg

        exe 'hi markdownListItem guifg=' .. repeat_fg
        exe 'hi markdownListItemBold cterm=bold guifg=' .. repeat_fg
        exe 'hi markdownListItemBoldItalic cterm=bold,italic guifg=' .. repeat_fg
        exe 'hi markdownListItemCodeSpan guifg=' .. repeat_fg .. ' guibg=' .. bg
        exe 'hi markdownListItemItalic cterm=italic guifg=' .. repeat_fg

        exe 'hi markdownBlockquote guifg=' .. statement_fg
        exe 'hi markdownBlockquoteBold cterm=bold guifg=' .. statement_fg
        exe 'hi markdownBlockquoteBoldItalic cterm=bold,italic guifg=' .. statement_fg
        exe 'hi markdownBlockquoteCodeSpan guifg=' .. statement_fg .. ' guibg=' .. bg
        exe 'hi markdownBlockquoteItalic cterm=italic guifg=' .. statement_fg

    # the only relevant attributes in a non-truecolor terminal are `term`, `cterm`, `ctermfg` and `ctermbg`
    else
        exe 'hi CommentCodeSpan ctermfg=' .. comment_fg .. ' ctermbg=' .. bg
        exe 'hi markdownCodeSpan ctermbg=' .. bg

        exe 'hi CommentBold term=bold cterm=bold ctermfg=' .. comment_fg
        exe 'hi CommentBoldItalic term=bold,italic cterm=bold,italic ctermfg=' .. comment_fg
        exe 'hi CommentItalic term=italic cterm=italic ctermfg=' .. comment_fg

        exe 'hi markdownListItem ctermfg=' .. repeat_fg
        exe 'hi markdownListItemBold term=bold cterm=bold ctermfg=' .. repeat_fg
        exe 'hi markdownListItemBoldItalic term=bold,italic cterm=bold,italic ctermfg=' .. repeat_fg
        exe 'hi markdownListItemCodeSpan ctermfg=' .. repeat_fg .. ' ctermbg=' .. bg
        exe 'hi markdownListItemItalic term=italic cterm=italic ctermfg=' .. repeat_fg

        exe 'hi markdownBlockquote ctermfg=' .. statement_fg
        exe 'hi markdownBlockquoteBold term=bold cterm=bold ctermfg=' .. statement_fg
        exe 'hi markdownBlockquoteBoldItalic term=bold,italic cterm=bold,italic ctermfg=' .. statement_fg
        exe 'hi markdownBlockquoteCodeSpan ctermfg=' .. statement_fg .. ' ctermbg=' .. bg
        exe 'hi markdownBlockquoteItalic term=italic cterm=italic ctermfg=' .. statement_fg
    endif
enddef

def Misc() #{{{2
    # We need a HG to draw signs in a popup window.{{{
    #
    # `WarningMsg` is a good fit for that, but there's one issue.
    # If  we  use  `WarningMsg`  to  define  a  sign  via  `sign_define()`,  Vim
    # highlights the  foreground of the  screen cells with `WarningMsg`  but the
    # background with `Pmenu`, because our color scheme only sets the foreground
    # color of `WarningMsg`.
    #
    # This is a bit jarring because:
    #
    #    - in a popup window, the sign column is highlighted by `SignColumn`
    #    - the background of `SignColumn` is identical to `Normal`
    #
    # So, the background of the sign column is highlighted like `Normal`, except
    # where there are signs; in those locations, `Pmenu` is used.
    #
    # To solve this, we build `PopupSign`  with the same attributes as `Normal`,
    # except the background color which is like `Normal`.
    #}}}
    # create `PopupSign` from `WarningMsg`
    # override the `guibg` or `ctermbg` attribute, using the colors of the `Normal` HG
    sil! Derive('PopupSign', 'WarningMsg', {bg: 'Normal'})
    # It is not always easy to read the selected entry in a popup menu (created with `popup_menu()`).{{{
    #
    # Especially  when  the  text  is   already  highlighted  (either  via  text
    # properties, or via `win_execute(id, 'set syntax=foo')`).
    #
    # Indeed,  the default  color is  set  by `PmenuSel`  which is  ok when  the
    # surrounding  background  is  highlighted  by  `Pmenu`;  but  there  is  no
    # guarantee that  `Pmenu` will be  used. It can  be overridden in  any given
    # popup with the `highlight` key; often, it's overridden with `Normal`.
    # And `PmenuSel` on `Normal` doesn't look great.  OTOH, `Visual` should look
    # better.
    #}}}
    hi! link PopupSelected Visual
enddef

fu Cursor() abort "{{{2
    " How can I change the color of the cursor in Vim?{{{
    "
    " There is no builtin way to do it:
    " https://unix.stackexchange.com/a/72800/289772
    "
    " So, you have to do it at the terminal level, using an `OSC 12` sequence:
    "
    "     " open xterm
    "     $ printf '\033]12;#9a7372\007'
    "
    " See: `OSC Ps ; Pt BEL/;/Ps = 1 2`
    "
    " To send this sequence to the terminal, you can:
    "
    "    - invoke `echoraw(seq)`
    "    - execute `:!printf 'seq'`
    "    - append it to `&t_ti` (or `&t_SI`, but the effect would be delayed until you quit insert mode)
    "}}}

    " `s:Termname()` is a bit slow (it invokes `system()`); let's save its output
    if !exists('g:termname')
        " in case `vim-lg` is not enabled
        try
            " never write a *global* constant in uppercase; it could raise `E741` if you include `!` in `'vi'`
            const g:termname = s:Termname()
        catch
            const g:termname = 'st'
        endtry
    endif

    " What's the use of this dictionary?{{{
    "
    " Use it whenever you need to change the color of the cursor in Vim.
    " We want consistent colors, no matter from which function/script we set it;
    " so we need a *unique* variable to which we can refer anywhere.
    "}}}
    " Why decimal values for st?{{{
    "
    " st doesn't  support hexcodes;  even after patching  it to  support the
    " OSC12 sequence; it *does* support a decimal code though.
    "}}}
    " Which kinds of values does xterm support?{{{
    "
    " Our current xterm doesn't support  decimal codes, only hexcodes or rgb
    " specifications (e.g. `rgb:12/34/56`).
    " I prefer  a `rgb` specification  because it doesn't contain  `#` which
    " needs to be escaped in a `:!` command.
    "}}}
    " Why `rgb:37/3b/41`?{{{
    "
    " That's the value we use in xterm:
    "
    "     :sp ~/.Xresources
    "     /cursorColor
    "}}}
    if !exists('g:cursor_color')
        const g:cursor_color = {
            \ 'light': {'st': '0', 'other': 'rgb:37/3b/41'},
            \ 'dark': {'st': '13', 'other': 'rgb:9a/73/72'},
            \ }
    endif
    " TODO: Make sure that `0` in st is equivalent to `rgb:37/3b/41` in xterm.{{{
    "
    " And that `13` in st is equivalent to `rgb:9a/73/72` in xterm.
    "
    " ---
    "
    " Make  sure that  the current  values for  the light  colors match  the
    " default color of the cursor in the terminal.
    "
    " ---
    "
    " Find a way to get the ligth colors programmatically.
    " Query the terminal, parse `~/.Xresources`, ...
    "}}}

    " FIXME: In st (but not in xterm), the cursor color is changed for all tmux panes.{{{
    "
    " It should only affect the current tmux pane.
    "}}}
    let color = g:cursor_color[&bg][g:termname is# 'st-256color' ? 'st' : 'other']
    let seq = "\033]12;" .. color .. "\007"
    call echoraw(seq)

    " When we  quit Vim, we  want to restore the  cursor color so  that it's
    " visible on a light background, because  we use a light color scheme in
    " the terminal.
    au VimLeavePre * ++once if &bg is# 'dark' | call s:RestoreCursorColor() | endif
endfu

def RestoreCursorColor() #{{{2
    var seq = get(g:cursor_color.light, get(g:, 'termname', '') == 'st-256color' ? 'st' : 'other')
    seq = "\e]12;" .. seq .. "\x07"
    &t_te ..= seq
enddef
# }}}1
# Utilities {{{1
def GetAttributes(hg: string, amode = ''): dict<string> #{{{2
    var attributes = {
        fg: 0,
        bg: 0,
        bold: 0,
        reverse: 0,
        }
    var mode = amode == '' ? [] : [amode]
    return map(attributes, (k) =>
        call('synIDattr', [hlID(hg)->synIDtrans(), k] + mode))
enddef

