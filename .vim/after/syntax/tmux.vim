syn clear tmuxComment
syn region tmuxComment start=/#/ skip=/\\\@<!\\$/ end=/$/  contains=tmuxTodo keepend

