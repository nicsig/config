" See also:  $VIMRUNTIME/syntax/tmux.vim
syn region tmuxBackticks matchgroup=Comment start=/`/ end=/`/ oneline concealends containedin=tmuxComment

exe 'syn match tmuxFoldMarkers  /\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=tmuxComment'
exe 'syn match tmuxFoldMarkers  /\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=tmuxComment'

hi link  tmuxBackticks    Backticks
