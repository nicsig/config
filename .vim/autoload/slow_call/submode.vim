if stridx(&rtp, 'vim-submode') == -1
    finish
endif

" Usage example:
"
"     call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
"     call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
"     call submode#map(       'undo/redo', 'n', '',  '-', 'g-')
"     call submode#map(       'undo/redo', 'n', '',  '+', 'g+')
"     call submode#leave_with('undo/redo', 'n', '', '<Esc>')


" TODO:
" Create a submode to move half a screen with `d`, `u`:
"
"    call submode#enter_with('half-screen', 'n', '', '<c-d>', '<c-d>' )
"    call submode#enter_with('half-screen', 'n', '', '<c-u>', '<c-u>' )
"    call submode#map('half-screen', 'n', '', 'd', '<c-d>')
"    call submode#map('half-screen', 'n', '', 'u', '<c-u>')

" Issue:
" Entering the submode with `C-d` and `C-u`  is dangerous, we could press `d` or
" `u` outside the submode and delete/undo instead of simply moving the cursor.
" Maybe, we should  use a special  key to enter the submode “half-screen”.
"
" Issue2:
" We should see the  submode in the command-line.
" Tweak `submode#enter_with()` so that we can ask for the submode to be shown
" on a per-submode basis (i.e. for some of them nothing shown, for other yes).
" Currently, we don't see in which submode we are because we've disabled 'showmode'
" in vimrc.
"
" Note:
" Even if you enable 'showmode' in vimrc, you won't always see the submode.
" If the submode is a submode of insert mode, `INSERT` would shadow the message.
" Is this issue present in the original plugin?
" Anyway, the solution would be to remove `s:smd_save` everywhere, and to reset
" 'showmode', so that Vim doesn't interfere with its own message.
" It works, but I'm not sure whether there would be undesired effect down the road.
"
" Why does the original plugin care about 'showmode'?
" You may want to hide default modes because you use them frequently:
" you don't need to see `INSERT` every time you enter insert mode.
" But at the same time, you may want to see the names of the submodes, because
" you use them infrequently. And because leaving them is sometimes tricky, so
" you want to be sure where you are (inside/outside the submode).


" TODO:
" Do the same work for C-n, C-p, and C-h, j, k, l


" schlepp {{{1

"                                        ┌─ recursive (remap {rhs})
"                                        │
call submode#enter_with('schlepp', 'x', 'r', 'H', '<plug>(schlepp_left)' )
call submode#enter_with('schlepp', 'x', 'r', 'J', '<plug>(schlepp_down)' )
call submode#enter_with('schlepp', 'x', 'r', 'K', '<plug>(schlepp_up)'   )
call submode#enter_with('schlepp', 'x', 'r', 'L', '<plug>(schlepp_right)')
call submode#map(       'schlepp', 'x', 'r', 'j', '<plug>(schlepp_down)' )
call submode#map(       'schlepp', 'x', 'r', 'k', '<plug>(schlepp_up)'   )
call submode#map(       'schlepp', 'x', 'r', 'h', '<plug>(schlepp_left)' )
call submode#map(       'schlepp', 'x', 'r', 'l', '<plug>(schlepp_right)')

" FIXME: which arguments to pass to `submode#leave_with()` to quit the submode +
" to quit visual mode? Would be useful to quit to normal mode and undo with UU.
" Tweak the code of the functions directly if necessary.
"
"         ✘
"         call submode#leave_with('schlepp', 'x', '', 'U')
"
" Update:
" For the moment, we don't need this  anymore, because we've tweaked the code of
" `vim-submode`. Basically, it's as if we had  set this variable in the original
" plugin:
"
"     let g:submode_keep_leaving_key = 1
"
" With this setting,  we can press `UU`  from visual mode; it will  make us quit
" the submode,  then `UU` will  be processed (from Visual  mode: we also  have a
" custom mapping in visual mode; x_UU).

" FIXME:
" Try to make Esc quit the schlepp submode AND visual mode at the same time.
" It's tiring to press Esc twice all the time.
" Implement this as a feature by refactoring `vim-submode` if needed.

" <  > {{{1

" We lost the ability to change the level of indentation on the line.
" Because we prefer to use `C-d` and `C-t` with their readline meanings.
" So, we remap the Vim default `C-d` and `C-t`, to `C-g <` and `C-g >`.
" Besides, these key sequences make much more sense, imho.
"
" Also, make the mappings repeatable without the prefix `C-g`.

call submode#enter_with('change-indent', 'i', '', '<c-g>>', '<c-t>')
call submode#enter_with('change-indent', 'i', '', '<c-g><', '<c-d>')
call submode#map(       'change-indent', 'i', '',      '>', '<c-t>')
call submode#map(       'change-indent', 'i', '',      '<', '<c-d>')

" j  k   duplicate char below/above {{{1
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
call submode#map(       'char-around', 'i', 'r',      'j', '<plug>(duplicate-char-below)')
ino  <expr>  <plug>(duplicate-char-below)  <sid>duplicate_char_around(0)

call submode#enter_with('char-around', 'i', 'r', '<c-x>k', '<plug>(duplicate-char-above)' )
call submode#map(       'char-around', 'i', 'r',      'k', '<plug>(duplicate-char-above)')
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

" j  k   scroll window {{{1

" Make `i^gj` and `i^gk` repeatable with `j` and `k`.

call submode#enter_with('scroll-window', 'n', 'r', '<c-g>j', '<plug>(scroll-window-down)' )
call submode#map(       'scroll-window', 'n', 'r',      'j', '<plug>(scroll-window-down)')
nno  <silent>  <plug>(scroll-window-down)  <c-e>:redraw<cr>
"                                               │
"                                               └ needed because of 'lz'

call submode#enter_with('scroll-window', 'n', 'r', '<c-g>k', '<plug>(scroll-window-up)' )
call submode#map(       'scroll-window', 'n', 'r',      'k', '<plug>(scroll-window-up)')
nno  <silent>  <plug>(scroll-window-up)  <c-y>:redraw<cr>


" Do the same for insert mode.
call submode#enter_with('scroll-window', 'i', 'r', '<c-g>j', '<plug>(scroll-window-down)' )
call submode#map(       'scroll-window', 'i', 'r',      'j', '<plug>(scroll-window-down)')
ino  <plug>(scroll-window-down)  <c-x><c-e>

call submode#enter_with('scroll-window', 'i', 'r', '<c-g>k', '<plug>(scroll-window-up)' )
call submode#map(       'scroll-window', 'i', 'r',      'k', '<plug>(scroll-window-up)')
ino  <plug>(scroll-window-up)  <c-x><c-y>

"        repeatable_motions {{{1
"  z,   z; {{{2

" Why no visual mode?
" It doesn't makes sense to create a submode in visual mode when we move across files.

call submode#enter_with('repeat-motion-z', 'n', 'r', 'z;', '<plug>(forward-z,_z;)<plug>(submode-redraw)')
call submode#enter_with('repeat-motion-z', 'n', 'r', 'z,', '<plug>(backward-z,_z;)<plug>(submode-redraw)')
call submode#map(       'repeat-motion-z', 'n', 'r',  ';', '<plug>(forward-z,_z;)<plug>(submode-redraw)')
call submode#map(       'repeat-motion-z', 'n', 'r',  ',', '<plug>(backward-z,_z;)<plug>(submode-redraw)')
" We may be in the submode, but think we aren't anymore, and thus press `z;`.
" If that's the case, we want `z;` to keep its original meaning (the one outside the submode).
call submode#map(       'repeat-motion-z', 'n', 'r', 'z;', '<plug>(forward-z,_z;)<plug>(submode-redraw)')
call submode#map(       'repeat-motion-z', 'n', 'r', 'z,', '<plug>(backward-z,_z;)<plug>(submode-redraw)')

" Map the dot and undo commands in the submode.{{{
"
" We  may  use  `z;`  to  repeat  a motion  across  different  files,  during  a
" refactoring. When  that  happens,  we'll  want to  repeat  the  same  edition,
" pressing the dot  command. But in the submode,  `.` will have to  wait for the
" timeout (unless we press it twice), and it will make us leave the submode.
"
" Same thing for the undo command.
"
" So, we map them in the submode.
"
" Example:
"
"     :vim /pat/ ./**/*
"     ]q
"     ciw rep
"     z;
"     .
"     ;
"     .
"     ;
"     .
"     …
"}}}
call submode#map(       'repeat-motion-z', 'n', 'r',  '.', '.')
call submode#map(       'repeat-motion-z', 'n', 'r',  'u', 'u')
"                                                │
"                                                └ we need recursiveness:
"                                                `.` and `u` are customized by `vim-repeat`
"                                                we want to go on using these customizations
"                                                while in the submode

" FIXME:{{{
"     vim /\[0\]/gj ~/.vim/**/*.vim ~/.vim/**/vim.snippets ~/.vim/vimrc
"     :Cfilter! -other_plugins
"     ]q
"     z;
"     ;
"     ;
"     …
"
" Sometimes (for example, in comment.vim), the  cursor jumps to a temporary, and
" wrong, location.
" It seems to stay in this weird position until the timeout, and until
" the submode is left.
" MWE:
"
"     call submode#enter_with('repeat-motion-2', 'n', '', 'z;', ':cnext<cr>')
"     call submode#map(       'repeat-motion-2', 'n', '',  ';', ':cnext<cr>')
"     ✘
"
"     call submode#enter_with('repeat-motion-2', 'n', '', 'z;', ':cnext<cr>')
"     call submode#map(       'repeat-motion-2', 'n', '',  ';', ':cnext <bar> redraw<cr>')
"     ✔
"
" For the moment, I've found a solution by adding a redraw after `;`.
" But sth is weird: I don't have to do the same for `,`.
" I'm not sure where I must add a redraw, so I do it for all mappings.
"
" Anyway, the issue lies somewhere in the code of `vim-submode`.
" Fix it, or add a `:redraw` somewhere inside its code.
"}}}
nno  <silent>  <plug>(submode-redraw)  :redraw<cr>

"  +,   +; {{{2

call submode#enter_with('repeat-motion-+', 'n', 'r', '+;', '<plug>(forward-+,_+;)')
call submode#enter_with('repeat-motion-+', 'n', 'r', '+,', '<plug>(backward-+,_+;)')
call submode#map(       'repeat-motion-+', 'n', 'r',  ';', '<plug>(forward-+,_+;)')
call submode#map(       'repeat-motion-+', 'n', 'r',  ',', '<plug>(backward-+,_+;)')
call submode#map(       'repeat-motion-+', 'n', 'r', '+;', '<plug>(forward-+,_+;)')
call submode#map(       'repeat-motion-+', 'n', 'r', '+,', '<plug>(backward-+,_+;)')

call submode#enter_with('repeat-motion-+', 'x', 'r', '+;', '<plug>(forward-+,_+;)')
call submode#enter_with('repeat-motion-+', 'x', 'r', '+,', '<plug>(backward-+,_+;)')
call submode#map(       'repeat-motion-+', 'x', 'r',  ';', '<plug>(forward-+,_+;)')
call submode#map(       'repeat-motion-+', 'x', 'r',  ',', '<plug>(backward-+,_+;)')
call submode#map(       'repeat-motion-+', 'x', 'r', '+;', '<plug>(forward-+,_+;)')
call submode#map(       'repeat-motion-+', 'x', 'r', '+,', '<plug>(backward-+,_+;)')

" co,  co; {{{2

" Why no visual mode?
" It doesn't makes sense to create a submode in visual mode to cycle through options values.

call submode#enter_with('repeat-motion-co', 'n', 'r', 'co;', '<plug>(forward-co,_co;)')
call submode#enter_with('repeat-motion-co', 'n', 'r', 'co,', '<plug>(backward-co,_co;)')
call submode#map(       'repeat-motion-co', 'n', 'r',   ';', '<plug>(forward-co,_co;)')
call submode#map(       'repeat-motion-co', 'n', 'r',   ',', '<plug>(backward-co,_co;)')
call submode#map(       'repeat-motion-co', 'n', 'r', 'co;', '<plug>(forward-co,_co;)')
call submode#map(       'repeat-motion-co', 'n', 'r', 'co,', '<plug>(backward-co,_co;)')
