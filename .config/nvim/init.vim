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

source $HOME/.vim/vimrc

