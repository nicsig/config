if exists('g:loaded_sneak') || stridx(&rtp, 'vim-sneak') == -1 || exists('g:no_plugin')
    finish
endif

" Why must I put the config of sneak.vim in this directory instead of `~/.vim/after/plugin/`?{{{
"
" We  need `g:sneak#absolute_dir` to be  sourced early, before the  interface of
" `vim-sneak` is installed.
" Otherwise, when we repeat a backward  motion by pressing `,`, it moves forward
" instead of backward.
"}}}

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

