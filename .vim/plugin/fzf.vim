if exists('g:loaded_fzf') || stridx(&rtp, 'fzf.vim') == -1 || exists('g:no_plugin')
    finish
endif

" For more information about the available settings, read `:h fzf` *and* `:h fzf-vim`.

" Why must I put the config of fzf.vim in this directory instead of `~/.vim/after/plugin/`?{{{
"
" We want all the commands installed by the plugin to be prefixed by `Fz`:
"
"         let g:fzf_command_prefix = 'Fz'
"
" `fzf.vim` needs to be informed of our prefix when its interface is sourced.
" `after/plugin/` would be too late, and thus `fzf.vim` would install all of its
" commands ignoring our prefix.
"}}}

" Make fzf use the builtin terminal.
" Do *not* use `{'window': 'split'}`!{{{
"
" Otherwise, in  Neovim, when you  invoke an fzf  Ex command (like  `:FZF`), you
" will have 2 windows with an identical terminal buffer.
"}}}
" Do *not* use `{'window': '10split enew'}`!{{{
"
" This  value is  suggested in  `:h fzf-examples`,  but it  contains a  typo, it
" really should be:
"
"     10split +enew
"             ^
"
" Without the `+`, `enew` would be interpreted  as a filename, which can lead to
" very-hard-to-debug issues.
"}}}
" I have an issue!{{{
"
" See this:
"
"     https://github.com/junegunn/fzf/issues/1055
"}}}
let g:fzf_layout = {'window': '10split +enew'}

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ }

" When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
" in a window, give the focus to it, instead of loading it in the current one.
let g:fzf_buffers_jump = 1

let g:fzf_command_prefix = 'Fz'

" `:FzAg` considers the path component prefixing the lines when searching for our query.  We don't want that.{{{
"
" So, we pass the `-d: -n 4..` options to `$ fzf`.
" We exclude from the search the first, second and third fields (path, line, column).
" See: https://www.reddit.com/r/vim/comments/b88ohz/fzf_ignore_directoryfilename_while_searching/ejwn384/
"}}}
exe 'com! -bar -bang '.g:fzf_command_prefix.'Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({"options": "-d: -n 4.."}, "right"), <bang>0)'

exe 'com! -bang -nargs=? -complete=dir '.g:fzf_command_prefix.'Files call fzf#vim#files(<q-args>, fzf#vim#with_preview("right:50%"), <bang>0)'

" `:FzSnippets` prints the description of the snippets (✔), but doesn't use it when filtering the results (✘).{{{

" The  issue  is  due to  `:FzSnippets`  which  uses  the  `-n 1`  option  in  the
" `'options'` key of a dictionary.
" To fix this, we replace `-n 1` with `-n ..`.
" From `$ man fzf`:
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
exe 'com! -bar -bang '.g:fzf_command_prefix.'Snippets call fzf#vim#snippets({"options": "-n .."}, <bang>0)'

