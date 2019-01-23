" https://neovim.io/doc/user/nvim.html#nvim-from-vim

set rtp^=~/.vim
set rtp+=~/.vim/after
" Do NOT do this `ln -s ~/.vim/after ~/.config/nvim/after`!{{{
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
"         :set rtp+=~/.vim/after
"         $ ln -s ~/.vim/after ~/.config/nvim/after
"}}}

" What does it do?{{{
"
" It adds to 'pp':
"
"     ~/.fzf
"     ~/.vim              because we've manually added it to 'rtp' just before
"     ~/.vim/after        "
"     ~/.vim/plugged/*    all directories inside
"}}}
let &packpath = &rtp

" Purpose:{{{
"
" On Ubuntu 16.04, we've installed the deb package `usrmerge`.
" As a result, `/bin` is a symlink to `/usr/bin`.
" So, the python2 interpreter can be found with 2 paths:
"
"     /bin/python2
"     /usr/bin/python2
"
" Because of this, `:CheckHealth` contains the following message:
"
"     - INFO: Multiple python2 executables found.  Set `g:python_host_prog` to avoid surprises.
"     - INFO: Executable: /usr/bin/python2
"     - INFO: Other python executable: /bin/python2
"
" To get rid of the message, we explicitly tell Neovim which path it must use
" to invoke the python2 interpreter.
"
" We do the same for the python3 interpreter, for 3 reasons:
"
"    - it helps Neovim find the interpreter faster, which makes startup faster too
"    - no surprise (Neovim won't use a possible old installation we forgot to remove)
"    - in case of an issue `:CheckHealth` will give better advice
"}}}
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" How to disable Python 2 or Python 3 support?{{{
"
"     let g:loaded_python_provider = 0
"
"     let g:loaded_python3_provider = 0
"}}}

source $HOME/.vim/vimrc

