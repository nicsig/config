if exists('g:loaded_Verdin') || stridx(&rtp, 'vim-Verdin') == -1
    finish
endif

" Add parentheses after a completed function name.
" See `:h g:Verdin#autoparen`.
let g:Verdin#autoparen = 2

" Don't try to guess what I meant; I meant what I wrote.
let g:Verdin#fuzzymatch = 0

" Rationale:{{{
"
" Verdin is slow in our vimrc.
" You can reproduce by completing some command name, then save the Vim buffer.
" The saving will take one or two seconds.
"
" You can find which Verdin functions are the most responsible for this delay by
" executing:
"
"     :prof start /tmp/profile.log
"     :prof func *
"     :prof file *
"     :w
"     :prof pause
"     :noa qall!
"
" So, instead of using Verdin, we rely on the default omnicompletion inside our vimrc.
"
" ---
"
" According to `:h g:Verdin#setomnifunc`, we could also execute:
"
"     let b:Verdin_setomnifunc = 0
"
" However, in practice, it doesn't work.
" The plugin doesn't even seem to inspect this variable.
"}}}
augroup no_Verdin_in_vimrc
    au!
    au BufReadPost /home/jean/.vim/vimrc setl ofu=syntaxcomplete#Complete
augroup END

