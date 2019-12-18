" Some `.nfo` files use special characters to make better-looking ASCII art.{{{
"
" Google “example nfo art”.
" Or visit: http://www.textfiles.com/piracy/NFO/
"
" Source:
" https://www.reddit.com/r/vim/comments/aj9ejv/view_nfo_files_with_vim/eetqozi/
"}}}
" Why `:noa`?{{{
"
" To avoid these errors:
"
"     E218: autocommand nesting too deep~
"     Error detected while processing FileType Autocommands for "*":~
"     E218: autocommand nesting too deep~
"}}}
" Why `:nos`?{{{
"
" If the nfo  file is already open  in another Vim instance,  you'll get `E325`;
" that's because  our `swapfile_handling` autocmd  is not triggered  (because of
" `:noa`).
" I don't want to  be bothered by Vim asking me whether I  want to edit the file
" and how.
"}}}
noa nos edit ++enc=cp437
