vim9script noclear

if exists('loaded') || stridx(&rtp, 'vim-submode') == -1
    finish
endif
var loaded = true

# Normal mode {{{1
# C-w g[hjkl]    tradewinds {{{2

submode#enter('tradewinds', 'n', 'r', '<c-w>gh', '<plug>(tradewinds-h)')
submode#enter('tradewinds', 'n', 'r', '<c-w>gj', '<plug>(tradewinds-j)')
submode#enter('tradewinds', 'n', 'r', '<c-w>gk', '<plug>(tradewinds-k)')
submode#enter('tradewinds', 'n', 'r', '<c-w>gl', '<plug>(tradewinds-l)')

# z C-[hjkl]     resize windows {{{2

submode#enter('resize-window', 'n', 'r', 'z<c-h>', '<plug>(window-resize-h)')
submode#enter('resize-window', 'n', 'r', 'z<c-j>', '<plug>(window-resize-j)')
submode#enter('resize-window', 'n', 'r', 'z<c-k>', '<plug>(window-resize-k)')
submode#enter('resize-window', 'n', 'r', 'z<c-l>', '<plug>(window-resize-l)')
#}}}1
# Insert mode {{{1
# C-g [<>]       indent {{{2

# We lost the ability to change the level of indentation on the line.
# Because we prefer to use `C-d` and `C-t` with their readline meanings.
# So, we remap the Vim default `C-d` and `C-t`, to `C-g <` and `C-g >`.
# Besides, these key sequences make much more sense, imho.
#
# Also, make the mappings repeatable without the prefix `C-g`.

submode#enter('change-indent', 'i', '', '<c-g>>', '<c-t>')
submode#enter('change-indent', 'i', '', '<c-g><', '<c-d>')

# C-x [jk]       duplicate char below/above {{{2
# Why these mappings? {{{
#
# They are more consistent and more powerful than the default ones.
#}}}
# What's the issue with the default ones ?{{{
#
# By default, Vim uses `C-e` and `C-y` in inconsistent ways:
#
#    i^e:            duplicate char below, or exit completion menu
#                    ✘ 2 unrelated functionalities
#                    ✘ shadows `end-of-line` in `vim-readline`
#
#    i^y:            duplicate char above
#                    ✘ hard to remember;
#                      it would be easier if Vim used `k` prefixed with some key
#
#    i^x^e  i^x^y:   scroll window
#                    ✘ ^x is usually used to complete text
#
#                    ✘ usually Vim uses `j` and `k` in mappings which must interact
#                      with a line below/above (example: gj, gk)
#
#                    ✘ i^x^e doesn't conflict with our custom c^x^e, but still
#                      it's a little confusing
#}}}

submode#enter('char-around', 'i', 'r', '<c-x>j', '<plug>(duplicate-char-below)' )
submode#enter('char-around', 'i', 'r', '<c-x>k', '<plug>(duplicate-char-above)' )

# Don't remove `<silent>`.{{{
#
# Sometimes, the rhs may be briefly displayed.
# Right now, it happens  when we smash the keys in  `myfuncs.vim` while the file
# is displayed in two tab pages, and we're focusing the second one.
#}}}
ino <silent> <plug>(duplicate-char-below) <c-r>=<sid>DuplicateCharAround(v:false)<cr>
ino <silent> <plug>(duplicate-char-above) <c-r>=<sid>DuplicateCharAround(v:true)<cr>

def DuplicateCharAround(above: bool): string
# This function reimplements `c-y` (and `c-e`) in a more powerful way.{{{
#
# By default, `c-y` only duplicate the character right above.
# If there's nothing, but there IS a character on the 2nd line above,
# `c-y` ignores it.
#}}}

    var col: number = col('.')
    var vcol: number = virtcol('.')

    # Don't do anything fancy, unless it's really necessary.{{{
    #
    # If  the neighboring  line has  a  character on  the same  column where  we
    # currently are, then we can leverage the builtin `C-e` and `C-y` commands.
    #}}}
    # Need  to use  `vcol`  and not  `col`;  useful, for  example,  if the  line
    # contains multicell characters, like tabs.
    if above && getline(line('.') - 1) =~ '\%' .. vcol .. 'v.*\S'
        return "\<c-y>"
    elseif !above && getline(line('.') + 1) =~ '\%' .. vcol .. 'v.*\S'
        return "\<c-e>"
    endif

    var line: number = search('\%' .. col .. 'c.*\S', (above ? 'b' : '') .. 'nW')
    var char: string = getline(line)->strpart(col - 1)[0]
    return char
enddef

