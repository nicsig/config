" Redefine the `zshComment` group to include our custom `zshCommentTitle` item.{{{
"
" The latter is defined in `lg#styled_comment#syntax()`:
"
"     ~/.vim/plugged/vim-lg-lib/autoload/lg/styled_comment.vim
"}}}
syn clear zshComment
syn region zshComment start=/\%(^\|\s\+\)#/ end=/$/  oneline fold contains=zshTodo,@Spell,zshCommentTitle
syn region zshComment start=/^\s*#/ end=/^\%(\s*#\)\@!/  fold contains=zshTodo,@Spell,zshCommentTitle

