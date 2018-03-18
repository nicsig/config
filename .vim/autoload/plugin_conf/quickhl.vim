" FIXME:
" We have no way to expand a match.
"
" I.e. we can highlight a line:
"
"     SPC h h _
"
" We can highlight another:
"
"     SPC h h _
"
" But they will be colored differently.
"
" Maybe we could use `SPC H` as another prefix to add/remove
" a match to/from another.

" TODO:
" We can't highlight a multi-line visual selection:
"
"         foo
"         bar
"         baz
"         qux
"         norf
"
" For the moment, we need to do:
"
"     QuickhlManualAdd! ^foo.*\n\_.\{-}\nnorf.*
"
" Which is not  really correct, because if there are  several matches, they will
" ALL be highlighted; not just the one we selected.
" Also, it could highlight matches where the lines are broken in different ways.

" TODO:
" I don't like the plugin highlighting all windows.
" I would prefer it to affect only the current window.
" And maybe all the others via an option, command argument, ...

" TODO:
" Study vim-operator-user:
"
"     ~/.vim/plugged/vim-operator-user/doc/operator-user.txt
"
" We've installed it to be able to highlight a text-object.
" The code is short: 76 sloc.

" FIXME:
" We can't clear a highlight installed from a visual selection,
" nor from an operation on a text-object.
" We can only reset everything.
"
" Update:
" We  can  clear  a particular  highlight,  but  we  need  to target  the  exact
" same  text. This can  be done  by reselecting  the same  visual selection,  or
" reperforming the same operation on the same text-object.

" TODO:
" Add a command/mapping to populate the  loclist with the positions matching the
" first character of all the matches.
" It would  be handy to jump  from one to another  if they are far  away, and to
" find a subset of matches we want to clear.

" highlight word under cursor
nmap  <unique>  +h*  <plug>(quickhl-manual-this)

" highlight visual Selection
xmap  <unique>  +h  <plug>(quickhl-manual-this)

" highlight word under cursor, adding boundaries (\< word \>)
nmap  <unique>  +hg*  <plug>(quickhl-manual-this-whole-word)

" cleaN the highlight under the cursor
nmap  <unique>  +hn  <plug>(quickhl-manual-clear)

" cleaN all highlights
nmap  <unique>  +hN  <plug>(quickhl-manual-reset)

" highlight word under cursor Dynamically
nmap  <unique>  +hd  <plug>(quickhl-cword-toggle)

" FIXME: Utterly broken:{{{
"
"     Error detected while processing function quickhl#tag#toggle[3]..quickhl#tag#enable[8]..quickhl#tag#refresh[1]..quickhl#
"     windo[6]..223[5]..221:
"     line    4:
"     E33: No previous substitute regular expression
"     E33: No previous substitute regular expression
"     E475: Invalid argument: fugitive-~
"     Error detected while processing function quickhl#tag#refresh[1]..quickhl#windo[6]..223[5]..221:
"     line    4:
"     E33: No previous substitute regular expression
"     E33: No previous substitute regular expression
"     E475: Invalid argument: fugitive-~
"     E33: No previous substitute regular expression
"     E33: No previous substitute regular expression
"     E475: Invalid argument: fugitive-~
"     E33: No previous substitute regular expression
"     E33: No previous substitute regular expression
"     E475: Invalid argument: fugitive-~
"     E33: No previous substitute regular expression
"     E33: No previous substitute regular expression
"     E475: Invalid argument: fugitive-~
"
" Once the error is raised, you have to press C-c, then restart Vim.
" Otherwise, Vim is unusable, errors keep coming.
" Same thing for the command:
"
"         :QuickhlTagToggle
"
" Check whether you can reproduce with a minimal vimrc.
"}}}
" nmap  <unique>  +h]  <plug>(quickhl-tag-toggle)

" highlight text-object
nmap  <unique>  +h  <plug>(operator-quickhl-manual-this-motion)
