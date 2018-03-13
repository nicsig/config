" I don't like using 'on', because it's a hacky workaround, and most of the time,
" it's unneeded. The `autoload/` mechanism is the proper way to lazy-load a plugin.
"
" However, the `undotree` plugin doesn't use `autoload/`. So, we make an
" exception for it. Otherwise, it would increase Vim starting time by around
" 1.3 ms (yeah, no big deal).

" Give automatically the focus to the `undotree` window.
let g:undotree_SetFocusWhenToggle = 1

" Open automatically the diff window.
let g:undotree_DiffAutoOpen = 1

