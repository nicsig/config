" https://neovim.io/doc/user/nvim.html#nvim-from-vim

set rtp^=~/.vim
set rtp+=~/.vim/after
" Do *not* do this `ln -s ~/.vim/after ~/.config/nvim/after`!{{{
"
" Neovim automatically includes `~/.config/nvim/after` in the rtp.
"
" So,  if   you  symlink  the   latter  to  `~/.vim/after`,  AND   manually  add
" `~/.vim/after` to the rtp, `~/.vim/after` will be effectively present twice.
" Because of that, the filetype plugins will be sourced twice, which will cause errors.
" For example, `b:undo_ftplugin` will often contain 2 unmap commands for the same key.
" The 2nd time, the command will fail because the mapping has already been deleted.
"
" Summary:
" one of them work as expected, but not both:
"
"     :set rtp+=~/.vim/after
"     $ ln -s ~/.vim/after ~/.config/nvim/after
"}}}

" What does it do?{{{
"
" It adds to `'pp'`:
"
"     ~/.fzf
"     ~/.vim              because we've manually added it to 'rtp' just before
"     ~/.vim/after        "
"     ~/.vim/plugged/*    all directories inside
"}}}
let &packpath = &rtp

" disable Python 2 support (it's deprecated anyway)
let g:loaded_python_provider = 0
" Purpose:{{{
"
" On Ubuntu 16.04, we've installed the deb package `usrmerge`.
" As a result, `/bin` is a symlink to `/usr/bin`.
" So, the python3 interpreter can be found with 2 paths:
"
"     /bin/python3
"     /usr/bin/python3
"
" Because of this, `:CheckHealth` contains the following message:
"
"    - INFO: Multiple python3 executables found.  Set `g:python3_host_prog` to avoid surprises.
"    - INFO: Executable: /usr/bin/python3
"    - INFO: Other python executable: /bin/python3
"
" To get rid of the message, we explicitly tell Neovim which path it must use
" to invoke the python3 interpreter.
"
" Also, this provides these additional benefits:
"
"    - it helps Neovim find the interpreter faster, which makes startup faster too
"    - no surprise (Neovim won't use a possible old installation we forgot to remove)
"    - in case of an issue `:CheckHealth` will give better advice
"}}}
let g:python3_host_prog = '/usr/bin/python3'

" disable Ruby and Node.js support (we don't need them, and the less code, the fewer issues)
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0

source $HOME/.vim/vimrc
