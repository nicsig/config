if !exists('g:loaded_sneak_plugin')
    finish
endif

" Variables {{{1

" Repeat via `;` or `,` always goes forwards or backwards respectively,
" no matter the previous command (`f`, `F`, `t`, `T`, `s`, `S`).
let g:sneak#absolute_dir = 1

" Case sensitivity is determined by 'ignorecase' and 'smartcase'.
let g:sneak#use_ic_scs = 1

" Label-mode minimizes the steps to jump to a location, using a clever interface
" similar to vim-easymotion[2].
" Sneak label-mode is faster, simpler, and more predictable than vim-easymotion.

" To enable label-mode:
" let g:sneak#label = 1

" remove mappings {{{1
" \ {{{2
" Why?{{{
"
" By default, vim-sneak binds `\` to the same function which is bound to `,`:
"
"     repeat the previous `fx` or `sxy` motion
"
" It does this for normal, visual and operator-pending mode.
"
" I find  this annoying,  because when  I hit  the key  by accident,  the cursor
" jumps. Besides, we already have `,`.
"}}}
" Could I remove these lines in the future?{{{
"
" In theory yes.
" If you map something  to `\`, or use it as a prefix  to build several `{lhs}`,
" `vim-sneak` won't install the mappings mentioned earlier.
"
" But I recommend you leave `unmap \` here nonetheless.
" Atm, we essentially use `\` as a prefix in filetype plugins (which `vim-sneak`
" ignores).
" We only have a few global mappings using `\`.
" And you may remove them one day.
"}}}
if maparg('\') =~? '\csneak'
    unmap \
endif

" x_Z  o_z  o_Z {{{2

" Why?{{{
"
" The  default mappings  installed by  `vim-sneak`  are too  inconsistent to  be
" memorized.
" They also conflict with `vim-sandwich`.
"}}}
" How to find the mappings installed by `vim-sneak` in normal mode?{{{
"
"     put =filter(split(execute('nno'), '\n'), { i,v -> v =~? 'sneak' && v !~? '^n\s\+\%([ft,;]\\|<plug>\)'})
"
" We invoke `filter()` to ignore:
"
"         • the `<plug>` mappings (they can't be typed directly,
"           so they can't interfer in our work)
"
"         • [fFtT,;]
"           we ignore those because, contrary to  [sSzZ]  , they ARE consistent
"}}}
" How to find the mappings installed by `vim-sneak` in visual mode?{{{
"
"     put =filter(split(execute('xno'), '\n'), { i,v -> v =~? 'sneak' && v !~? '^x\s\+\%([ft,;]\\|<plug>\)'})
"}}}
sil! xunmap Z

" How to find the mappings installed by `vim-sneak` in operator-pending mode?{{{
"
"     put =filter(split(execute('ono'), '\n'), { i,v -> v =~? 'sneak' && v !~? '^o\s\+\%([ft,;]\\|<plug>\)'})
"}}}
sil! ounmap z
sil! ounmap Z

