" Redefine the `tmuxComment` group to include our custom `tmuxCommentTitle` item.{{{
"
" The latter is defined in `lg#styled_comment#syntax()`:
"
"     ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim
"}}}
syn clear tmuxComment
syn region tmuxComment start=/#/ skip=/\\\@<!\\$/ end=/$/ contains=tmuxTodo,tmuxCommentTitle

