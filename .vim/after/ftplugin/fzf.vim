" Rationale:{{{
"
" Atm,  we  set `'termwinkey'`  with  the  value `<c-s>`  (see  `vim-readline`),
" because we don't use this key in the shell.
"
" However, we can use `C-s` in an fzf  buffer, to open the path under the cursor
" in a split; and a fzf buffer is a terminal buffer.
"}}}
setl termwinkey=

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe') .. " | setl termwinkey<"

