if exists('g:loaded_fzf') || stridx(&rtp, 'fzf.vim') == -1 || exists('g:no_plugin')
    finish
endif

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
" Don't use `{'window': 'split'}`!{{{
"
" Otherwise, in  Neovim, when you  invoke an fzf  Ex command (like  `:FZF`), you
" will have 2 windows with an identical terminal buffer.
"}}}
" I have an issue!{{{
"
" See this:
"
"     https://github.com/junegunn/fzf/issues/1055
"}}}
let g:fzf_layout = {'window': '10split enew'}

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ }

" When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
" in a window, give the focus to it, instead of loading it in the current one.
let g:fzf_buffers_jump = 1

let g:fzf_command_prefix = 'Fz'

" Preview the contents of the selected result in the output of `:Files`.{{{
"
" Needs the shell pgm `$ coderay`.
" Install it with:
"
"       $ gem install coderay
"}}}
" Why do you use `bat` instead of `coderay` like before?{{{
"
" From `https://github.com/junegunn/fzf.vim/pull/712#issuecomment-432990824`:
"
"      It's  a  little hard  for  me  to imagine  that  someone  installed bat  or
"      highlight would still want to use  slower – or less "modern" – alternatives
"      like coderay or rougify.
"}}}
let g:fzf_files_options = '--preview "(highlight || bat {} || cat {}) 2>/dev/null | head -'.&lines.'"'
" TODO: The documentation doesn't mention `g:fzf_files_options` anymore.{{{
"
" It can still be used, but the help was changed in this commit:
"
"     https://github.com/junegunn/fzf.vim/commit/2eaff049464e7b8304401dd4d79c86a4b0c4ed6c
"
" Now, it gives this command:
"     com! -bang -nargs=? -complete=dir Files
"       \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"
" I've tried it, but it doesn't display any preview for the files, when we press
" `SPC ff`.
"}}}

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
exe 'command! -bar -bang '.g:fzf_command_prefix.'Snippets call fzf#vim#snippets({"options": "-n .."}, <bang>0)'


