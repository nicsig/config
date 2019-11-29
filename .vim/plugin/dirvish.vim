augroup my_dirvish_stl
    au!
    au FileType dirvish call lg#set_stl('%y %F%<%=%-'..winwidth(0)/8..'(%l/%L%) ')
augroup END

