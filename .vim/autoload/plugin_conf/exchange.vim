" By default,  a region of  text which is going  to be exchanged  is highlighted
" with `IncSearch`. Currently, in my colorscheme,  the latter is yellow, and the
" cursor becomes white when I move it inside some text colored by `IncSearch`.
" So, the cursor  is hard to see. We  choose another HG to make  the cursor more
" visible.
hi link ExchangeRegion Search

" We want linewise exchanges to be re-indented with `==`.
" For more info:    :h g:exchange_indent

let g:exchange_indent = '=='

