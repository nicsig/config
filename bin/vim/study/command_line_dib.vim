" Goal {{{1

" Implement  a  C-z mapping  which  deletes  all the  text  inside  the pair  of
" parentheses surrounding the cursor.

" Zen {{{1

" When you iterate  over the items from a  list, never use `i` as an  index in a
" list.
" It will confuse your reasoning.
" In your head, you count from 1.
" For items in a list, Vim counts from 0.

" Do *not*  adapt your way of  counting to Vim.  Your reasoning  is more important.
" To index an item in a list, initialize `i` to 1 , and use `i-1`.
" But when you read `i-1`, in your head, keep thinking "this is the i-th item":

"     for i in range(len(list))
"         "            ┌ think “this is the i-th item in the list“
"         "            │ not “the (i-1)th“
"         "            │ forget the `-1`, see it as an ARTEFACT due to Vim's implementation
"         "    ┌───────┤
"         echo list[i-1]
"     endfor


" When you  write a  loop, which among  other things update  a variable  in each
" iteration, do it at the END rather then the beginning.
"
" Think about this:
"
" If  you  update  a variable  in  your  loop  it's  probably to  create  a  new
" environment in which you need to repeat the same operation.
" If you create this new environment too early, you will need to adapt your code
" so that  it speaks about  the previous environment  (relative to this  new one
" you've just created).
" This is a useless complication which makes the code less readable.
"
" Create a new environment only when it's needed, not before.

" Solution 1 {{{1

" Pro: somewhat easy and short
"
" Con: not reliable, because it doesn't handle nested parentheses properly
cno <expr>  <c-z>  <sid>delete_inside_parentheses()

fu s:delete_inside_parentheses() abort "{{{2
    let pos        = getcmdpos()
    let not_before = '%(%'.pos.'c.*)@<!'
    let not_after  = '%(.*%'.pos.'c)@!'
    let pat        = '\v'.not_before.'\(\zs.{-}\ze\)'.not_after
    let line       = getcmdline()
    let new_pos    = strchars(matchstr(line, '\v.*'.not_before.'\(\ze.{-}\)'), 1)
    if new_pos == -1
        return ''
    endif
    let new_line = substitute(line, pat, '', '')
    return "\<c-e>\<c-u>"
    \     .new_line
    \     ."\<c-b>".repeat("\<right>", new_pos)
endfu

" Solution 2 {{{1

" Pro:
" reliable
"
" Con:
" long and complex

cno <expr>  <c-z>  <sid>delete_inside_parentheses()

fu s:find_parenthesis(fwd) abort "{{{2
    let found = 0
    let unbalanced = 0
    for i in a:fwd
    \        ?    range(s:vpos, len(s:chars))
    \        :    range(s:vpos, 1, -1)
        if s:chars[i-1] ==# '()'[a:fwd] && unbalanced == 0
            let found = 1
            break
        endif
        "                                                           ┌ if the cursor was initially
        "                                                           │ right before an open/closed parenthesis,
        "                                                 ┌─────────┤ ignore it (it doesn't imbalance anything)
        let unbalanced += s:chars[i-1] ==# ')('[a:fwd] && i != s:vpos
        \               ?     1
        \               : s:chars[i-1] ==# '()'[a:fwd]
        \               ?    -1
        \               :     0
    endfor
    return [ found, i ]
endfu

fu s:delete_inside_parentheses() abort "{{{2
    let pos = getcmdpos()
    let line = getcmdline()
    if pos > len(line)
        return ''
    endif

    let s:chars = split(line, '\zs')
    let s:vpos = strchars(matchstr(line, '.*\%'.pos.'c.'), 1)
    "                                                 │
    "            Vim operates on the `i(` text-object ┘
    " even when  the open parenthesis is  right AFTER the cursor;  so we include
    " the character after  the cursor in the set of  characters processed in the
    " next loop

    let [ found, i ] = s:find_parenthesis(0)
    if !found
        return ''
    endif
    let pos1 = i+1
    "            │
    "            └─ +1: we want to exclude the open parenthesis from the deletion

    let [ found, i ] = s:find_parenthesis(1)
    if !found
        return ''
    endif
    let pos2 = i-1
    "            │
    "            └─ exclude the closing parenthesis

    unlet! s:chars s:vpos

    let pat = '\%'.pos1.'v.*\%'.pos2.'v.'
    let new_line = substitute(line, pat, '', '')
    return "\<c-e>\<c-u>"
    \     .new_line."\<c-b>"
    \     .repeat("\<right>", pos1-1)
endfu
