augroup websearch_stl
    au!
    au FileType websearch call lg#set_stl('%y%=%-'..winwidth(0)/8..'l')
augroup END

