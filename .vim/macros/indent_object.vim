" Source: https://vimways.org/2018/transactions-pending/

" These objects are only useful for languages where the indentation has a meaning.
" Like python for example.
" But not in others, like VimL.
"
" Indeed, if you press `yii` on a line of a VimL function, there's a good chance
" you end up copying the whole body of the function.
" Because `yii` means:
"
"    > copy up to / down to a line  which has a lower indentation level than the
"    > current one.

" indentation level sans any surrounding empty lines
xno ii <c-\><c-n><cmd>call <sid>in_indentation()<cr>
" indentation level and any surrounding empty lines
xno ai <c-\><c-n><cmd>call <sid>around_indentation()<cr>

ono ii <cmd>call <sid>in_indentation()<cr>
ono ai <cmd>call <sid>around_indentation()<cr>

fu s:in_indentation() abort "{{{1
    " select all text in current indentation level excluding any empty lines
    " that precede or follow the current indentationt level
    "
    " NOTE: if the current  level of indentation is 1 (ie  in virtual column 1),
    " then the entire buffer will be selected

    " move to beginning of line and get virtcol (current indentation level)
    norm! ^
    let vCol = (getline('.') =~# '^\s*$' ? '$' : '.')->virtcol()

    " pattern matching anything except empty lines and lines with recorded
    " indentation level
    let pat = '^\%(\s*\%' .. vCol .. 'v\|^$\)\@!'

    " find first match (backwards & don't wrap or move cursor)
    let start = search(pat, 'bWn') + 1

    " next, find first match (forwards & don't wrap or move cursor)
    let end = search(pat, 'Wn')

    if end != 0
        " if search succeeded, it went too far, so subtract 1
        let end -= 1
    endif

    " go to start (this includes empty lines) and--importantly--column 0
    exe 'norm! ' .. start .. 'G0'

    " skip empty lines (unless already on one .. need to be in column 0)
    call search('^[^\n\r]', 'Wc')

    " go to end (this includes empty lines)
    exe 'norm! Vo' .. end .. 'G'

    " skip backwards to last selected non-empty line
    call search('^[^\n\r]', 'bWc')

    " go to end-of-line 'cause why not
    norm! $o
endfu
" }}}1

fu s:around_indentation() abort "{{{1
    " select all text in the current indentation level including any emtpy
    " lines that precede or follow the current indentation level;
    "
    " the current implementation is pretty fast, even for many lines since it
    " uses "search()" with "\%v" to find the unindented levels
    "
    " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
    " then the entire buffer will be selected
    "
    " WARNING: python devs have been known to become addicted to this

    " move to beginning of line and get virtcol (current indentation level)
    norm! ^
    let vCol = (getline('.') =~# '^\s*$' ? '$' : '.')->virtcol()

    " pattern matching anything except empty lines and lines with recorded
    " indentation level
    let pat = '^\%(\s*\%' .. vCol .. 'v\|^$\)\@!'

    " find first match (backwards & don't wrap or move cursor)
    let start = search(pat, 'Wbn') + 1

    " NOTE: if  start is 0,  then search() failed; otherwise  search() succeeded
    " and start does not equal line('.')
    "
    " FORMER:  start is  0;  so,  if we  add  1 to  start,  then  it will  match
    " everything from beginning of the buffer  (if you don't like this, then you
    " can modify the code) since this will be the equivalent of "norm! 1G" below
    "
    " LATTER: start is not  0 but is also not equal  to line('.'); therefore, we
    " want to add one  to start since it will always match one  line too high if
    " search() succeeds

    " next, find first match (forwards & don't wrap or move cursor)
    let end = search(pat, 'Wn')

    " NOTE: if end is 0, then search() failed; otherwise, if end is not equal to
    " line('.'), then the search succeeded.
    "
    " FORMER: end  is 0;  we want this  to match until  the end-of-buffer  if it
    " fails to  find a match for  same reason as mentioned  above; again, modify
    " code if you do not like this); therefore, keep 0--see "NOTE:" below inside
    " the if block comment
    "
    " LATTER: end  is not 0,  so the search()  must have succeeded,  which means
    " that end will match a different line than line('.')

    if end != 0
        " if end is 0, then the search() failed; if we subtract 1, then it
        " will effectively do "norm! -1G" which is definitely not what is
        " desired for probably every circumstance; therefore, only subtract one
        " if the search() succeeded since this means that it will match at least
        " one line too far down
        "
        " NOTE: exe "norm! 0G" still goes  to end-of-buffer just like "norm! G",
        " so it's ok if  end is kept as 0.  As mentioned  above, this means that
        " it will  match until  end of buffer,  but that is  what I  want anyway
        " (change code if you don't want)
        let end -= 1
    endif

    " finally, select from start to end
    exe 'norm! ' .. start .. 'G0V' .. end .. 'G$o'
endfu
" }}}1
