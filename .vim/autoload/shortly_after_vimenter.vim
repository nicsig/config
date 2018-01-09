" TODO:
" Create mappings to be able to scroll in preview window with `j` and `k`, after
" an initial `J` or `K`.


" TODO:
" Create a submode to move half a screen with `d`, `u`:
"
"    call submode#enter_with('half-screen', 'n', '', '<c-d>', '<c-d>' )
"    call submode#enter_with('half-screen', 'n', '', '<c-u>', '<c-u>' )
"    call submode#map('half-screen', 'n', '', 'd', '<c-d>')
"    call submode#map('half-screen', 'n', '', 'u', '<c-u>')

" Issue1:
" Entering the submode with  `C-d` and `C-u` is annoying, if we  want to use the
" `d` operator  right after moving  the cursor.
" Besides, `hjkl` don't work right after `C-d`. Annoying.
" We should  use a special  key to enter the submode “half-screen”.
"
" Issue2:
" We should see the  submode in the command-line, because I  don't want to press
" `u` to move the cursor, and instead undo by accident.
" Tweak `submode#enter_with()` so that we can ask for the submode to be shown
" on a per-submode basis (i.e. for some of them nothing shown, for other yes).
" Currently, we don't see in which submode we are because we've disabled 'showmode'
" in vimrc.


" TODO:
" Do the same work for C-n, C-p, and C-h, j, k, l


" TODO:
" The installation of the following mappings  take too much time, several dozens
" of  ms.  So,  we delay  the sourcing  of this  script in  our vimrc. Look  for
" augroup `lazy_load_plugins`.
" But maybe  we should move all  these mappings in `vim-submode`,  and lazy-load
" the plugin with `vim-plug` (`{'on': []}`)?

" vim-sandwich {{{1
" Why here instead of `~/.vim/after/plugin/sandwich.vim`?{{{
"
" It causes several autoload/ files to be sourced. Too slow.
"}}}
" Why silently?{{{
"
" There's an error if we temporarily disable the plugin. Happens when debugging.
"}}}
" Why not test the existence of the function?{{{
"
" It's an autoloaded function. It doesn't exist prior to its first invocation.
"}}}
" Highlighting in the delete operator is often distracting.
sil! call operator#sandwich#set('delete', 'all', 'highlight', 0)

sil! let g:sandwich#recipes =  deepcopy(g:sandwich#default_recipes)
\                             + [ {'buns': ['“', '”'], 'input': ['u"'] } ]
\                             + [ {'buns': ['‘', '’'], 'input': ["u'"] } ]
"                                            │
"                                            └ used in man pages (ex: `man tmux`, search for ‘=’)

" Why?{{{
"
" `vim-sandwich` installs the following mappings:
"
"         ono  is  <plug>(textobj-sandwich-query-i)
"         ono  as  <plug>(textobj-sandwich-query-a)
"
" They  shadow  the  built-in  sentences  objects. But I  use  the  latter  less
" frequently than  the sandwich objects. So,  I won't remove  the mappings. But,
" instead, to restore the sentences objects, we install these mappings:
"}}}
ono  iS  is
ono  aS  as

" vim-submode {{{1
" schlepp {{{2

"                                        ┌─ recursive (remap {rhs})
"                                        │
call submode#enter_with('schlepp', 'x', 'r', 'H', '<plug>(schlepp_left)' )
call submode#enter_with('schlepp', 'x', 'r', 'J', '<plug>(schlepp_down)' )
call submode#enter_with('schlepp', 'x', 'r', 'K', '<plug>(schlepp_up)'   )
call submode#enter_with('schlepp', 'x', 'r', 'L', '<plug>(schlepp_right)')
call submode#map(  'schlepp', 'x', 'r', 'j', '<plug>(schlepp_down)' )
call submode#map(  'schlepp', 'x', 'r', 'k', '<plug>(schlepp_up)'   )
call submode#map(  'schlepp', 'x', 'r', 'h', '<plug>(schlepp_left)' )
call submode#map(  'schlepp', 'x', 'r', 'l', '<plug>(schlepp_right)')

" FIXME: which arguments to pass to `submode#leave_with()` to quit the submode +
" to quit visual mode? Would be useful to quit to normal mode and undo with UU.
" Tweak the code of the functions directly if necessary.
"
"         ✘
"         call submode#leave_with('schlepp', 'x', '', 'U')

" call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
" call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
" call submode#leave_with('undo/redo', 'n', '', '<Esc>')
" call submode#map('undo/redo', 'n', '', '-', 'g-')
" call submode#map('undo/redo', 'n', '', '+', 'g+')

" <  > {{{2

" We lost the ability to change the level of indentation on the line.
" Because we prefer to use `C-d` and `C-t` with their readline meanings.
" So, we remap the Vim default `C-d` and `C-t`, to `C-g <` and `C-g >`.
" Besides, these key sequences make much more sense, imho.
"
" Also, make the mappings repeatable without the prefix `C-g`.

call submode#enter_with('change-indent', 'i', '', '<c-g>>', '<c-t>' )
call submode#enter_with('change-indent', 'i', '', '<c-g><', '<c-d>' )
call submode#map('change-indent', 'i', '', '>', '<c-t>')
call submode#map('change-indent', 'i', '', '<', '<c-d>')

" j  k   duplicate char below/above {{{2
" Why these mappings? {{{
"
" • They are more consistent than the default ones.
" • They are easier to repeat (via `vim-submode`).

"}}}
" What's the issue with the default ones ?{{{
"
" By default, Vim uses `C-e` and `C-y` in inconsistent ways:
"
"    i^e:            duplicate char below, or exit completion menu
"                    ✘ 2 unrelated functionalities
"                    ✘ shadows `end-of-line` in `vim-readline`
"
"    i^y:            duplicate char above
"                    ✘ hard to remember;
"                      it would be easier if Vim used `k` prefixed with some key
"
"    i^x^e  i^x^y:   scroll window
"                    ✘ ^x is usually used to complete text
"
"                    ✘ usually Vim uses `j` and `k` in mappings which must interact
"                      with a line below/above (example: gj, gk)
"
"                    ✘ i^x^e doesn't conflict with our custom c^x^e, but still
"                      it's a little confusing
"}}}

call submode#enter_with('char-around', 'i', 'r', '<c-x>j', '<plug>(duplicate-char-below)' )
call submode#map('char-around', 'i', 'r', 'j', '<plug>(duplicate-char-below)')
ino  <expr>  <plug>(duplicate-char-below)  <sid>duplicate_char_around(0)

call submode#enter_with('char-around', 'i', 'r', '<c-x>k', '<plug>(duplicate-char-above)' )
call submode#map('char-around', 'i', 'r', 'k', '<plug>(duplicate-char-above)')
ino  <expr>  <plug>(duplicate-char-above)  <sid>duplicate_char_around(1)

fu! s:duplicate_char_around(above) abort
    " By default, `c-y` only duplicate the character right above.
    " If there's nothing, but there IS a character on the 2nd line above,
    " `c-y` ignores it.
    "
    " We use this function to reimplement `c-y` (and `c-e`) in a more powerful way.

    let pos  = virtcol('.')
    let line = search('\v%'.pos.'v.*\S', (a:above ? 'b' : '').'nW')
    let char = matchstr(getline(line), '\v%'.pos.'v.')
    return char
endfu

" j  k   scroll window {{{2

" Make `i^gj` and `i^gk` repeatable with `j` and `k`.

call submode#enter_with('scroll-window', 'n', 'r', '<c-g>j', '<plug>(scroll-window-down)' )
call submode#map('scroll-window', 'n', 'r', 'j', '<plug>(scroll-window-down)')
nno  <silent>  <plug>(scroll-window-down)  <c-e>:redraw<cr>
"                                               │
"                                               └ needed because of 'lz'

call submode#enter_with('scroll-window', 'n', 'r', '<c-g>k', '<plug>(scroll-window-up)' )
call submode#map('scroll-window', 'n', 'r', 'k', '<plug>(scroll-window-up)')
nno  <silent>  <plug>(scroll-window-up)  <c-y>:redraw<cr>

" Do the same for insert mode.
call submode#enter_with('scroll-window', 'i', 'r', '<c-g>j', '<plug>(scroll-window-down)' )
call submode#map('scroll-window', 'i', 'r', 'j', '<plug>(scroll-window-down)')
ino  <plug>(scroll-window-down)  <c-x><c-e>

call submode#enter_with('scroll-window', 'i', 'r', '<c-g>k', '<plug>(scroll-window-up)' )
call submode#map('scroll-window', 'i', 'r', 'k', '<plug>(scroll-window-up)')
ino  <plug>(scroll-window-up)  <c-x><c-y>

"        repeatable_motions {{{2
" z, z; {{{3

" Why no visual mode?
" It doesn't makes sense to create a submode in visual mode when we move across files.

call submode#enter_with('repeat-motion-2', 'n', 'r', 'z;', '<plug>(z_semicolon)')
call submode#enter_with('repeat-motion-2', 'n', 'r', 'z,', '<plug>(z_comma)')
call submode#map(       'repeat-motion-2', 'n', 'r',  ';', '<plug>(z_semicolon)')
call submode#map(       'repeat-motion-2', 'n', 'r',  ',', '<plug>(z_comma)')
" We may be in the submode, but think we aren't anymore, and thus press `z;`.
" If that's the case, we want `z;` to keep its original meaning (the one outside the submode).
call submode#map(       'repeat-motion-2', 'n', 'r', 'z;', '<plug>(z_semicolon)')
call submode#map(       'repeat-motion-2', 'n', 'r', 'z,', '<plug>(z_comma)')

" +, +; {{{3

call submode#enter_with('repeat-motion-3', 'n', 'r', '+;', '<plug>(plus_semicolon)')
call submode#enter_with('repeat-motion-3', 'n', 'r', '+,', '<plug>(plus_comma)')
call submode#map(       'repeat-motion-3', 'n', 'r',  ';', '<plug>(plus_semicolon)')
call submode#map(       'repeat-motion-3', 'n', 'r',  ',', '<plug>(plus_comma)')
call submode#map(       'repeat-motion-3', 'n', 'r', '+;', '<plug>(plus_semicolon)')
call submode#map(       'repeat-motion-3', 'n', 'r', '+,', '<plug>(plus_comma)')

call submode#enter_with('repeat-motion-3', 'x', 'r', '+;', '<plug>(plus_semicolon)')
call submode#enter_with('repeat-motion-3', 'x', 'r', '+,', '<plug>(plus_comma)')
call submode#map(       'repeat-motion-3', 'x', 'r',  ';', '<plug>(plus_semicolon)')
call submode#map(       'repeat-motion-3', 'x', 'r',  ',', '<plug>(plus_comma)')
call submode#map(       'repeat-motion-3', 'x', 'r', '+;', '<plug>(plus_semicolon)')
call submode#map(       'repeat-motion-3', 'x', 'r', '+,', '<plug>(plus_comma)')

" co, co; {{{3

" Why no visual mode?
" It doesn't makes sense to create a submode in visual mode to cycle through options values.

call submode#enter_with('repeat-motion-4', 'n', 'r', 'co;', '<plug>(co_semicolon)')
call submode#enter_with('repeat-motion-4', 'n', 'r', 'co,', '<plug>(co_comma)')
call submode#map(       'repeat-motion-4', 'n', 'r',   ';', '<plug>(co_semicolon)')
call submode#map(       'repeat-motion-4', 'n', 'r',   ',', '<plug>(co_comma)')
call submode#map(       'repeat-motion-4', 'n', 'r', 'co;', '<plug>(co_semicolon)')
call submode#map(       'repeat-motion-4', 'n', 'r', 'co,', '<plug>(co_comma)')
