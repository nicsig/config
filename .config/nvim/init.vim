let $VIMRUNTIME = '/usr/local/share/nvim/runtime'
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
"    - INFO: Multiple python2 executables found.  Set `g:python_host_prog` to avoid surprises.
"    - INFO: Executable: /usr/bin/python2
"    - INFO: Other python executable: /bin/python2
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

" FIXME: 'paste' is toggled when you paste a line with a trailing newline on Nvim's command-line.{{{
"
"     $ nvim -Nu NONE +'cno <c-a> <home>' +'let @+ = "\r"'
"     :
"     C-S-v
"     :echo
"     C-a
"
" I would expect the cursor to jump to the start of the line.
" Instead, it inserts all completions of `echo`:
"
"     :echo echoerr echohl echomsg echon
"
" Nvim uses the default `C-a` which suggests all possible completions.
" This is because the 'paste' option has been set.
"
" ---
"
" Is it a known issue?
"
" It definitely looks similar to the issue #7212:
" https://github.com/neovim/neovim/issues/7212
"
" which has been closed and merged with the issue #7066:
" https://github.com/neovim/neovim/issues/7066
"
" The latter is the reverse issue.
" Basically, the devs  consider #7212 and #7066 as two  opposite issues with the
" same root.
"
" Both issues should be addressed by the PR #4448:
" https://github.com/neovim/neovim/pull/4448
"
" ---
"
" I tried this, but it doesn't work:
"
"     augroup fix_bug
"         au!
"         au CmdlineLeave : if has('nvim') && getcmdline() =~# '\r$'
"             \ | call timer_start(0, {-> execute('set nopaste')})
"             \ | endif
"     augroup END
"
" I don't know why the autocmd fails, but it's not because of a plugin.
" It still fails with no config (`$ nvim -Nu /tmp/vimrc`).
"
" Also, if you replace `\r` in the regex with `.`, the autocmd works.
" So, there's definitely sth weird going on in the command which is run.
"
" Update:
" I've included this in the autocmd:
"
"     \ | call writefile([getcmdline()], '/tmp/log', 'ab')
"
" and run Nvim with no config.
" After reading  the log file,  it seems the command  which is written  has been
" stripped from the trailing carriage return.
" I think the  latter is consumed by  Nvim, and interpreted as the  Enter key we
" press to validate a command.
"
" Fun fact:
" If you repaste the command, the option is reset.
" So,  pasting the  command does  not make Nvim  set the  option; it  makes Nvim
" toggle the option.
"}}}
augroup disable_paste
    au!
    au CmdlineLeave * au OptionSet paste ++once set nopaste

    " We can't set 'paste' via the command-line anymore. We need an `<expr>` mapping to do it.
    " Why don't you join `set paste!` and `redraw` in a single `execute()`?{{{
    "
    " It  seems  the  screen  would  be redrawn  too  early,  because  we  can't
    " immediately see  the `[paste]` indicator  in the  status line; we  have to
    " wait until we move the cursor for example.
    "}}}
    nno <expr> coY execute('set paste!')[-1] + timer_start(0, {-> execute('redraw')})[-1]
augroup END
