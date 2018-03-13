" Disabled by default. We'll decide for which filetypes we want emmet's
" mappings (in an autocmd).
let g:user_emmet_install_global = 0

" Only in insert and visual mode (not normal).
let g:user_emmet_mode='iv'

" Use <c-g> as a prefix key instead of <c-y>.
let g:user_emmet_leader_key='<c-g>'

" `emmet` will combined this prefix with the keys:
"
"         , / ; A D N a d i j k n u
"                                 │
"                                 └─ could conflicts arise with default:
"
"                                       C-g j
"                                       C-g k
"                                       C-g u
"
"                                    … ?
"
" … to create various buffer-local mappings.

