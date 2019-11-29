augroup tmuxprompt_stl
    au!
    au FileType tmuxprompt call lg#set_stl('%y%=%-'..winwidth(0)/8..'l')
augroup END
