" Some syntax groups defined in `$VIMRUNTIME/syntax/zsh.vim` use the argument `contains=TOP`.
" Because of this, when  we try to embed some zsh code in  a markdown file, some
" part of it may not be highlighted.
"
" Solution:
" Override  the definitions  of these  syntax groups  so that  `contains=TOP` is
" replaced with `contains=@markdownEmbedzsh`.
"
" Source:
" https://github.com/derekwyatt/vim-scala/pull/59
" https://github.com/vim-pandoc/vim-pandoc-syntax/issues/54

augroup syntax_fix_embedding
    au!
    au Syntax markdown call plugin#markdown#fix_embedding()
augroup END

