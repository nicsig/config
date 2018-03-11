" See also:  $VIMRUNTIME/syntax/tmux.vim
syn region tmuxComment matchgroup=Comment start=/^\s*\zs#@\@!\s\?/ skip=/\\\@<!\\$/ end=/$/ contains=@Spell,tmuxTodo concealends
syn region tmuxCommentCode matchgroup=Number start=/^\s*\zs#@\s\?/ end=/$/ containedin=tmuxComment concealends
syn region tmuxBackticks matchgroup=Comment start=/`/ end=/`/ oneline concealends containedin=tmuxComment

exe 'syn match tmuxFoldMarkers  /\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=tmuxComment'
exe 'syn match tmuxFoldMarkers  /\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=tmuxComment'

hi link  tmuxComment      Comment
hi link  tmuxCommentCode  Number
hi link  tmuxBackticks    Backticks
