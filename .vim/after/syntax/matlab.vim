" An ellipsis used as a line continuation symbol is wrongly highlighted as a comment by the default syntax plugin.{{{
"
" It comes from this syntax rule:
"
"     syn match matlabComment "\.\.\..*$" contains=matlabTodo,matlabTab
"     " see: $VIMRUNTIME/syntax/matlab.vim:65
"
" I'm not sure  to understand its purpose,  but the comment says  that it should
" highlight *words*:
"
"    > MT_ADDON - correctly highlights words after '...' as comments
"
" So, let's fix  the issue by tweaking the pattern so that  it includes at least
" one non-whitespace character.
"
"     \.\.\..*$
"     →
"     \.\.\..*\S.*$
"
" ---
"
" Note that the default highlighting is really wrong.
" There is no configuration option to tweak the highlighting:
"
"     :h ft-matlab-syntax
"     E149: Sorry, no help for ft-matlab-syntax~
"
" Besides, if you:
"
"    - look for "matlab vim syntax" on github
"
"    - pick the most recent syntax plugin
"      (right now, it seems to be: https://github.com/tdehaeze/matlab-vim/blob/master/syntax/matlab.vim)
"
"    - use the latter instead of the default syntax plugin,
"
" You  should  probably  see  that  an  ellipsis  is  correctly  highlighted  by
" `matlabLineContinuation`, and not `matlabComment`.
"}}}
syn clear matlabComment
syn match matlabComment /%.*$/ contains=matlabTodo,matlabTab
syn match matlabComment /\.\.\..*\S.*$/  contains=matlabTodo,matlabTab

