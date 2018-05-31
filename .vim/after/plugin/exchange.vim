if !exists('g:loaded_exchange')
    finish
endif

" We want linewise exchanges to be re-indented with `==`.
" For more info:    :h g:exchange_indent

let g:exchange_indent = '=='

