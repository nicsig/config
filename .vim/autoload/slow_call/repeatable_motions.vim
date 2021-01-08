vim9 noclear

if exists('loaded') || stridx(&rtp, 'vim-lg-lib') == -1
    finish
endif
var loaded = true

import Catch from 'lg.vim'

const SFILE = expand('<sfile>:p')

# Define some motions {{{1
#       Why define them here? Why not in vimrc?{{{
#
# In the vimrc, we would need a guard:
#
#     if has('vim_starting')
#         ...
#     endif
#
# Without it, as  soon as we would  resource the vimrc, the  wrappers which make
# these motions repeatable  would be overwritten, and we would  lose the ability
# to repeat the motions.
#
# So, why not using the guard?
#
# We'll undoubtedly forget it sometimes, and then lose time wondering why one
# of our motion is not repeatable.
#}}}
#    g,  g; {{{2

nno g; g,zv
nno g, g;zv

#    gj  gk         vertical jump {{{2

# Alternative: https://github.com/haya14busa/vim-edgemotion
# TODO: We never use these mappings.  I don't find the motions intuitive.{{{
#
# The problem is that we've implemented them without a clear goal in mind.
# When you feel the need to jump vertically, try to refactor the code so that it
# better suits our needs.
#
# These mappings  *could* be useful  when we start  coding in python  which uses
# indentation to specify when a construct ends.
#}}}
noremap <expr> gk <sid>VerticalJumpRhs(v:false)
noremap <expr> gj <sid>VerticalJumpRhs()

def VerticalJumpRhs(is_fwd = true): string
    var mode = mode(1)

    if mode == "\<c-v>"
        mode = "\<c-v>\<c-v>"
    endif

    return printf("\<cmd>call %s(%d, %s)\<cr>",
        VerticalJumpGo, is_fwd ? 1 : 0, string(mode))
enddef

def VerticalJumpGo(is_fwd: bool, mode: string)
    if mode == 'n'
        norm! m'
    endif

    var n = GetJumpHeight(is_fwd)
    if n <= 0 | return | endif

    # temporarily disable folds before we move
    var fen_save: bool
    var winid: number
    var bufnr: number
    [fen_save, winid, bufnr] = [&l:fen, win_getid(), bufnr('%')]
    &l:fen = false
    try
        exe 'norm! ' .. (is_fwd ? n .. 'j' : n .. 'k')
    finally
        # restore folds
        if winbufnr(winid) == bufnr
            var tabnr: number
            var winnr: number
            [tabnr, winnr] = win_id2tabwin(winid)
            settabwinvar(tabnr, winnr, '&fen', fen_save)
        endif
    endtry

    # open just enough folds to see where we are
    if mode =~ "[nvV\<c-v>]"
        norm! zv
    endif
enddef

def GetJumpHeight(is_fwd: bool): number
    var vcol = '\%' .. virtcol('.') .. 'v'
    var flags = is_fwd ? 'nW' : 'bnW'

    # a line where there IS a character in the same column,
    # then one where there is NOT
    var lnum1 = search(vcol .. '.*\n\%(.*' .. vcol .. '.\)\@!', flags)

    # a line where there is NOT a character in the same column,
    # then one where there IS
    var lnum2 = search('^\%(.*' .. vcol .. '.\)\@!.*\n.*\zs' .. vcol, flags)

    var lnums = filter([lnum1, lnum2], (_, v) => v > 0)

    return is_fwd
        ?     min(lnums) - line('.')
        :     line('.') - max(lnums)
enddef

#    <t  >t         move tab pages {{{2

nno <t <cmd>call <sid>MoveTabpage('-1')<cr>
nno >t <cmd>call <sid>MoveTabpage('+1')<cr>

def MoveTabpage(where: string)
    try
        exe 'tabmove ' .. where
    catch /^Vim\%((\a\+)\)\=:E474:/
    catch
        Catch()
        return
    endtry
enddef
# }}}1
# Make `fx` motion, &friends, repeatable {{{1

# To make `)` repeatable, we just need to invoke `repmap#make#repeatable()`.
# So, why  do we need  extra mappings, and an  extra function, `Fts()`,  to make
# `fx` (&friends) repeatable?
# Answer:{{{
#
# When we press `)`, the last saved motion is `)`.
# When we press `fx`, the last saved motion is `f`, not `fx`.
#
# Why not `fx`?
# Because the saved motion is the lhs of the mapping, and `fx` is not the lhs of
# any mapping (`f` is).
# `x` is probably asked by `vim-sneak` via `getchar()`.
# But it doesn't explicitly belong to the lhs.
#
# So, there's an issue here.
# `f` is not a sufficient information to successfully repeat `fx`.
# 2 solutions:
#
#    1. save `x` to later repeat `fx`
#    2. repeat `fx` by pressing Vim's default `;` motion
#
# The 1st solution will work with `tx` and `Tx`, but only the 1st time.
# After that, the  cursor won't move, because  it will always be  stopped by the
# same `x`.
#
# So we must use the 2nd solution, and press `;`.
# But this introduces a special case:
#
#     we press `)` → `s:move()`        must press `)`
#     we press `;` → `s:move_again()`  must press `)`
#
#     we press `f`  → `s:move()`       must press `f`
#     we press `;`  → `s:move_again()` must press `;`
#                                                  │
#                                                  └ special case (because != f)
#
# We  need to  redefine the  `f`  motion with  the  output of  a function  which
# returns:
#
#     `f` when we press `f`
#     `;` when we press `;` to repeat a `f` motion
#
# So, this function must know whether we're repeating a `f` motion,
# and press different keys accordingly.
#
# We'll give this information to the function via:
#
#     repmap#make#is_repeating()
#}}}

# These  mappings  must  be  installed  *before*  `repmap#make#repeatable()`  is
# invoked to make the motions repeatable.

# Do *not* try to replace `<expr>` with `<cmd>`.{{{
#
#     $ vim -S <(cat <<'EOF'
#         vim9
#         ono <expr> <c-a> FuncA()
#         def g:FuncA(): string
#             feedkeys("\<plug>Sneak_f")
#             return ''
#         enddef
#         ono <c-b> <cmd>call FuncB()<cr>
#         def g:FuncB()
#             feedkeys("\<plug>Sneak_f")
#         enddef
#         var lines =<< trim END
#             some X text
#             some X text
#         END
#         setline(1, lines)
#     EOF
#     )
#
#     " press:  d C-a X
#     " expected:  "some X"  is deleted
#     " actual:    "some X"  is deleted
#     ✔
#
#     " press:  j d C-b X
#     " expected:  "some X"  is deleted
#     " actual:    cursor jumps on "X"
#     ✘
#}}}
noremap <expr> t  <sid>Fts('t')
noremap <expr> T  <sid>Fts('T')
noremap <expr> f  <sid>Fts('f')
noremap <expr> F  <sid>Fts('F')
noremap <expr> ss <sid>Fts('s')
noremap <expr> SS <sid>Fts('S')

def Fts(cmd: string): string
    # Why not `call feedkeys('zv', 'int')`?{{{
    #
    # The keys would be wrongly consumed by the commands (`f`, `ss`, ...).
    #}}}
    au CursorMoved * ++once norm! zv

    # What's the purpose of this `if` conditional?{{{
    #
    # This function can be called:
    #
    #    -   directly from a  [ftFT]  mapping
    #    - indirectly from a  [;,]    mapping
    #      │
    #      └ move_again()  →  move()  →  Fts()
    #
    # It needs to distinguish from where it was called.
    # Because in  the first  case, it  needs to  ask the  user for  a character,
    # before returning the keys to press.  In  the other, it doesn't need to ask
    # anything.
    #}}}
    if repmap#make#is_repeating()
        var move_fwd = cmd =~# '\C[fts]'
        #              └ When we press `;` after `fx`, how is `cmd` obtained?{{{
        #
        # Here's what happens approximately:
        #
        # we press `;`
        # |
        # +-  `move_again('fwd')` is invoked
        #     |
        #     +-  all info about the 'f' motion is saved in `motion`
        #     |
        #     |   Why 'f'?
        #     |   'f' was saved in `s:last_motion` when we pressed `fx` earlier
        #     |   and is now retrieved with `s:get_motion_info(s:last_motion)`
        #     |
        #     +-  a temporary ad-hoc mapping is installed
        #     |
        #     |     n  <Plug>(repeat-motion-tmp) * <SNR>123_fts('f')
        #     |                                                  |
        #     |                                                  +- obtained with `motion.fwd.lhs`
        #     |                                                     This is how `cmd` is obtained.
        #     |
        #     +-  the ad-hoc mapping is fed to the typeahead buffer
        #}}}
        feedkeys(move_fwd ? "\<plug>Sneak_;" : "\<plug>Sneak_,", 'i')
    else
        feedkeys("\<plug>Sneak_" .. cmd, 'i')
    endif
    return ''
enddef

repmap#make#repeatable({
    mode: '',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: 'F',  fwd: 'f' },
                 {bwd: 'SS', fwd: 'ss'},
                 {bwd: 'T',  fwd: 't' },
               ],
    })

# Make other motions repeatable {{{1

# Rule: For a motion to be made repeatable, it must ALREADY be defined.{{{
#
# Don't invoke `repmap#make#repeatable()`  for a custom motion  which you're not
# sure whether it has been defined, or will be later.
#
# Indeed, the function needs to save all the information relative to the
# original motion in a database.
#}}}
# Why making motions repeatable in this file?{{{
#
#    1. We source it *after* Vim has started, so all plugins have been
#       sourced and any custom motion has already been defined.
#       We can be sure we're respecting the previous rule.
#
#    2. The process can be slow.  This file lets us delay it until Vim
#       has started, and to keep a short startup time.
#}}}

# cycle through help topics relevant for last errors
# we don't have a pair of motions to move in 2 directions,
# so I just repeat the same keys for 'bwd' and 'fwd'
repmap#make#repeatable({
    mode: 'n',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [{bwd: '!e', fwd: '!e'}]
    })

# move tabpage / rotate window
repmap#make#repeatable({
    mode: 'n',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: '<t', fwd: '>t'},
                 {bwd: '<c-w>R', fwd: '<c-w>r'},
             ]
    })

# built-in motions
repmap#make#repeatable({
    mode: '',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: "['", fwd: "]'"},
                 {bwd: '["', fwd: ']"'},
                 {bwd: '[#', fwd: ']#'},
                 {bwd: '[(', fwd: '])'},
                 {bwd: '[*', fwd: ']*'},
                 {bwd: '[/', fwd: ']/'},
                 {bwd: '[M', fwd: ']M'},
                 {bwd: '[S', fwd: ']S'},
                 {bwd: '[]', fwd: ']['},
                 {bwd: '[c', fwd: ']c'},
                 {bwd: '[m', fwd: ']m'},
                 {bwd: '[{', fwd: ']}'},
             ]
    })

# custom motions
repmap#make#repeatable({
    mode: 'n',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: '<l', fwd: '>l'},
                 {bwd: '<q', fwd: '>q'},
                 {bwd: '[<c-l>', fwd: ']<c-l>'},
                 {bwd: '[<c-q>', fwd: ']<c-q>'},
                 {bwd: '[a', fwd: ']a'},
                 {bwd: '[b', fwd: ']b'},
                 {bwd: '[e', fwd: ']e'},
                 {bwd: '[f', fwd: ']f'},
                 {bwd: '[l', fwd: ']l'},
                 {bwd: '[q', fwd: ']q'},
                 {bwd: '[s', fwd: ']s'},
                 {bwd: '[t', fwd: ']t'},
                 {bwd: '[;', fwd: '];'},
                 {bwd: 'g,', fwd: 'g;'},
             ]
    })

repmap#make#repeatable({
    mode: '',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: '[`', fwd: ']`'},
                 {bwd: '[h', fwd: ']h'},
                 {bwd: '[r', fwd: ']r'},
                 {bwd: '[u', fwd: ']u'},
                 {bwd: '[U', fwd: ']U'},
                 {bwd: '[z', fwd: ']z'},
                 {bwd: 'gk', fwd: 'gj'},
             ]
    })

# Why `nxo` for the mode?  Why not simply an empty string?{{{
#
# You can use `''` when the original motion is built-in or defined via `:[nore]map`.
# In the first case, repmap use `s:DEFAULT_MAPARG` whose `mode` key is a space.
# In the latter case, `maparg(motion, '', 0, 1).mode` is a space.
# In both cases, a space describes `nvo`.
#
# But  here,   `%`  is  not  built-in;   it's  a  custom  motion   installed  by
# `vim-matchup`.  And  it's not installed  via `:[nore]map`, but via  3 separate
# mapping commands; one for `n`, one for `x`, and one for `o`:
#
#     ~/.vim/plugged/vim-matchup/autoload/matchup.vim:179
#
# If  you pass  the mode  `''` to  our `repmap#`  function, it  will pass  it to
# `maparg()`, which won't return a space for the mode, but `o`:
#
#                       vv
#     :echo maparg('%', '', 0, 1).mode
#     o~
#
# As a result,  `%` and `g%` will  be broken in normal and  visual mode, because
# the database will only contain info for a motion in operator-pending mode.
#
# You can check this like so:
#
#    - comment the next function call
#    - start a new Vim instance
#    - run `:echo maparg('%', '', 0, 1).mode`; the output should be 'o'
#}}}
repmap#make#repeatable({
    mode: 'nxo',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: '[-', fwd: ']-'},
                 {bwd: 'g%', fwd: '%'},
             ]
    })

# toggle settings
repmap#make#repeatable({
    mode: 'n',
    buffer: 0,
    from: SFILE .. ':' .. expand('<slnum>'),
    motions: [
                 {bwd: '[oC', fwd: ']oC'},
                 {bwd: '[oD', fwd: ']oD'},
                 {bwd: '[oL', fwd: ']oL'},
                 {bwd: '[oS', fwd: ']oS'},
                 {bwd: '[oc', fwd: ']oc'},
                 {bwd: '[od', fwd: ']od'},
                 {bwd: '[oh', fwd: ']oh'},
                 {bwd: '[oi', fwd: ']oi'},
                 {bwd: '[ol', fwd: ']ol'},
                 {bwd: '[on', fwd: ']on'},
                 {bwd: '[op', fwd: ']op'},
                 {bwd: '[oq', fwd: ']oq'},
                 {bwd: '[os', fwd: ']os'},
                 {bwd: '[ot', fwd: ']ot'},
                 {bwd: '[ov', fwd: ']ov'},
                 {bwd: '[ow', fwd: ']ow'},
                 {bwd: '[oy', fwd: ']oy'},
                 {bwd: '[oz', fwd: ']oz'},
             ]
    })

