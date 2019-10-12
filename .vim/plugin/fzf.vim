if exists('g:loaded_fzf') || stridx(&rtp, 'fzf.vim') == -1 || exists('g:no_plugin')
    finish
endif

" For more information about the available settings, read `:h fzf` *and* `:h fzf-vim`.

" Make fzf use the builtin terminal.
" Do *not* use `{'window': 'split'}`!{{{
"
" Otherwise, in  Neovim, when you  invoke an fzf  Ex command (like  `:FZF`), you
" will have 2 windows with an identical terminal buffer.
"}}}
" I have an issue!{{{
"
" See this: https://github.com/junegunn/fzf/issues/1055
"}}}
let g:fzf_layout = {'window': '10new'}

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ }

" When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
" in a window, give the focus to it, instead of loading it in the current one.
let g:fzf_buffers_jump = 1

let g:fzf_command_prefix = 'Fz'

" How do I toggle the preview window?{{{
"
" Press `?`.
" If you want to use another key:
"
"     fzf#vim#with_preview("right:50%:hidden", "?")
"                                               ^
"                                               change this
"}}}
" Where did you find this command?{{{
"
" For the most part, at the end of `:h fzf-vim-advanced-customization`.
"
" We've also tweaked it to make fzf ignore the first three fields when filtering.
" That is the file path, the line number, and the column number.
" More specifically, we pass to `fzf#vim#with_preview()` this dictionary:
"
"     {"options": "--delimiter=: --nth=4.."}
"
" Which, in turn, pass `--delimiter: --nth=4..` to `fzf(1)`.
"
" See: https://www.reddit.com/r/vim/comments/b88ohz/fzf_ignore_directoryfilename_while_searching/ejwn384/
"}}}
exe 'com -bang -nargs=* ' . g:fzf_command_prefix . 'Rg
  \ call fzf#vim#grep(
  \   "rg 2>/dev/null --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({"options": "--delimiter=: --nth=4.."}, "up:60%")
  \           : fzf#vim#with_preview({"options": "--delimiter=: --nth=4.."}, "right:50%:hidden", "?"),
  \   <bang>0)'

exe 'com -bang -nargs=? -complete=dir '.g:fzf_command_prefix.'Files call fzf#vim#files(<q-args>, fzf#vim#with_preview("right:50%"), <bang>0)'

" `:FzSnippets` prints the description of the snippets (✔), but doesn't use it when filtering the results (✘).{{{

" The  issue  is  due to  `:FzSnippets`  which  uses  the  `-n 1`  option  in  the
" `'options'` key of a dictionary.
" To fix this, we replace `-n 1` with `-n ..`.
" From `man fzf`:
"
"     /OPTIONS
"     /Search mode
"     -n, --nth=N[,..]
"           Comma-separated list of field  index expressions for limiting search
"           scope.  See FIELD INDEX EXPRESSION for the details.
"
"     /FIELD INDEX EXPRESSION
"     ..     All the fields
"}}}
exe 'com -bar -bang '.g:fzf_command_prefix.'Snippets call fzf#vim#snippets({"options": "-n .."}, <bang>0)'

