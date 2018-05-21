" Make fzf use Vim's terminal, like it does in Neovim.
" If you have an issue, see this:
"
"     https://github.com/junegunn/fzf/issues/1055

let g:fzf_layout = { 'window': 'split' }

let g:fzf_action = {
\                    'ctrl-t': 'tab split',
\                    'ctrl-s': 'split',
\                    'ctrl-v': 'vsplit',
\                  }

" When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
" in a window, give the focus to it, instead of loading it in the current one.
let g:fzf_buffers_jump = 1

let g:fzf_command_prefix = 'Fz'

" Preview the contents of the selected result in the output of `:Files`.
" Needs the shell pgm `$ coderay`.
" Install it with:
"
"       $ gem install coderay

let g:fzf_files_options =
            \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

