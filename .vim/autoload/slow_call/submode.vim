if stridx(&rtp, 'vim-submode') ==# -1
    finish
endif

" Usage example:
"
"     call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
"     call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
"     call submode#map(       'undo/redo', 'n', '',  '-', 'g-')
"     call submode#map(       'undo/redo', 'n', '',  '+', 'g+')
"     call submode#leave_with('undo/redo', 'n', '', '<Esc>')

" TODO: Consider getting rid of vim-submode.{{{
"
" You could set a variable when entering  the submode, then reset it later (when
" a certain event is  fired, when a key is pressed, or when  a certain amount of
" time has elapsed).
" Then, you would inspect this variable to decide how a given key should behave.
"
" Example:
"
"     ino <c-g>j <c-r>=C_g_j()<cr>
"     ino j      <c-r>=J()<cr>
"     fu! C_g_j()
"         let s:in_submode = 1
"         let s:timer_id = timer_start(3000, {-> execute('let s:in_submode = 0')})
"         if exists('s:timer_id')
"             call timer_stop(s:timer_id)
"         endif
"         return "\<c-x>\<c-e>"
"     endfu
"     fu! J() abort
"         return get(s:, 'in_submode', 0) ? "\<c-x>\<c-e>" : 'j'
"     endfu
"}}}

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


" TODO: Do the same work for C-n, C-p, and C-h, j, k, l


" C-w g[hjkl] (tradewinds) {{{1

call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gh', '<plug>(tradewinds-h)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gj', '<plug>(tradewinds-j)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gh', '<plug>(tradewinds-k)')
call submode#enter_with('tradewinds', 'n', 'r', '<c-w>gj', '<plug>(tradewinds-l)')
call submode#map(       'tradewinds', 'n', 'r',       'h', '<plug>(tradewinds-h)')
call submode#map(       'tradewinds', 'n', 'r',       'j', '<plug>(tradewinds-j)')
call submode#map(       'tradewinds', 'n', 'r',       'k', '<plug>(tradewinds-k)')
call submode#map(       'tradewinds', 'n', 'r',       'l', '<plug>(tradewinds-l)')

" M-u [uio] (change case) {{{1

" Update: We don't use this code anymore, because we simply press `M-u`, `M-i`, `M-o`, to change the case of a word.
"
" In the past, we  pressed `M-u u`, `M-u i`, `M-u o`; so  we needed a submode to
" avoid pressing  the prefix  several times  when changing  the case  of several
" words.
" Nevertheless, I keep this commented code for the moment, because it contains 2
" fixmes which may be interesting to fix.

" FIXME: Press `M-u`, then keep pressing `i`.  Eventually, you enter insert mode and insert the `i` character.{{{
"
" Write a single word on a line, and position your cursor on its last character.
"
" Press `M-u i`: the last character is uppercased.
" Press `i`: you enter insert mode.
"
" This is unexpected; the last `i` keypress should have no effect.
" Exactly like for `M-u u u`.
"
" Press `M-u u`: the last character is uppercased.
" Press `u`: nothing happens (in particular, no undo).
"
" ---
"
" The issue is not in the lhs of the key binding.
" You can  choose `M-u <key>`,  `<key>` being any  key character, and  the issue
" persists.
"
" ---
"
" Try this experiment:
"
" At the top of `readline#move_by_words()`, write this:
"
"     let g:d_counter = get(g:, 'd_counter', 0) + 1
"     if g:d_counter == 1
"         ...
"         return ''
"     endif
"
" Replace `...` with the code inside `readline#change_case_word()`.
"
" Here's the effect of this change:
" When you press `M-u i`, `readline#move_by_words()` will execute the code
" of `readline#change_case_word()`.
" When you  press `i`  right afterward, `readline#move_by_words()`  will execute
" its own code.
"
" Now, press `M-u i` on the last character of the last word on a line: it's uppercased.
" Next, press `i`: nothing happens (in particular you don't enter insert mode).
" This  seems to  suggest that  the issue  is due  to something  that the  first
" invocation of `readline#move_by_words()` has done.
" I thought  it could be  due to the cursor  position, which is  different after
" I've pressed `M-u u` compared to `M-u i`.
" But that's not the case: the output of `getcurpos()` is identical.
"
" ---
"
" I can't reproduce if I press `M-u i` twice.
" Only if I press `M-u i i`.
" So the issue is probably due to sth which happens when we're in the submode.
" The submode plugin may contain some bug.
"}}}
" FIXME: Press `M-u u` then `M-b`: `b` is inserted.{{{
"
" I would expect `M-b` to make the cursor move one word backward.
"
" The issue also applies to other key  bindings, like `C-x j` and `C-x k`; press
" `C-x k` to duplicate the character above then `M-b`, and `b` is inserted.
"
" I can't reproduce in Nvim.
"}}}
"     call submode#enter_with('my-uppercase', 'nic', 'r', '<m-u>u', '<plug>(my-uppercase)' )
"     call submode#map(       'my-uppercase', 'nic', 'r',      'u', '<plug>(my-uppercase)')
"     nno <silent> <plug>(my-uppercase) :<c-u>call readline#change_case_save(1)<bar>set opfunc=readline#change_case_word<cr>g@l
"     ino <silent> <plug>(my-uppercase) <c-r>=readline#change_case_save(1).readline#change_case_word('', 'i')<cr>
"     cno <silent> <plug>(my-uppercase) <c-r>=readline#change_case_save(1).readline#change_case_word('', 'c')<cr>

"     call submode#enter_with('my-capitalize', 'nic', 'r', '<m-u>i', '<plug>(my-capitalize)' )
"     call submode#map(       'my-capitalize', 'nic', 'r',      'i', '<plug>(my-capitalize)')
"     nno <silent> <plug>(my-capitalize) :<c-u>set opfunc=readline#move_by_words<cr>g@l
"     ino <silent> <plug>(my-capitalize) <c-r>=readline#move_by_words('i', 1, 1)<cr>
"     cno <silent> <plug>(my-capitalize) <c-r>=readline#move_by_words('c', 1, 1)<cr>

"     call submode#enter_with('my-lowercase', 'nic', 'r', '<m-u>o', '<plug>(my-lowercase)' )
"     call submode#map(       'my-lowercase', 'nic', 'r',      'o', '<plug>(my-lowercase)')
"     nno <silent> <plug>(my-lowercase) :<c-u>call readline#change_case_save(0)<bar>set opfunc=readline#change_case_word<cr>g@l
"     ino <silent> <plug>(my-lowercase) <c-r>=readline#change_case_save(0).readline#change_case_word('', 'i')<cr>
"     cno <silent> <plug>(my-lowercase) <c-r>=readline#change_case_save(0).readline#change_case_word('', 'c')<cr>

" schlepp {{{1

"                                        ┌ recursive (remap {rhs})
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
"     ✘
"     call submode#leave_with('schlepp', 'x', '', 'U')
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
"
" Do we need sth similar in other key bindings?

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
" - They are more consistent than the default ones.
" - They are easier to repeat (via `vim-submode`).

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

    let vcol = virtcol('.')
    let line = search('\v%'.vcol.'v.*\S', (a:above ? 'b' : '').'nW')
    let char = matchstr(getline(line), '\v%'.vcol.'v.')
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

