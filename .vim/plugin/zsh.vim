" Some syntax groups defined in `$VIMRUNTIME/syntax/zsh.vim` use the argument `contains=TOP`.
" Because of this, when  we try to embed some zsh code in  a markdown file, some
" part of it may not be highlighted.
"
" Solution:
" Override  the definitions  of these  syntax groups  so that  `contains=TOP` is
" replaced with `contains=markdownEmbedzsh`.
"
" Source:
" https://github.com/derekwyatt/vim-scala/pull/59
" https://github.com/vim-pandoc/vim-pandoc-syntax/issues/54

fu! s:fix_embedding() abort
    if execute('syn list @markdownEmbedzsh', 'silent!') !~# 'markdownEmbedzsh'
        return
    endif
    syn clear zshSubst zshBrackets zshOldSubst
    syn region  zshSubst    matchgroup=zshSubstDelim
                            \ transparent
                            \ start='\$(' skip='\\)' end=')'
                            \ contained
                            \ contains=@markdownEmbedzsh
                            \ fold
    syn region  zshBrackets transparent
                            \ start='{' skip='\\}' end='}'
                            \ contained
                            \ contains=@markdownEmbedzsh
                            \ fold
    syn region  zshOldSubst matchgroup=zshSubstDelim
                            \ start=+`+ skip=+\\`+ end=+`+
                            \ contains=@markdownEmbedzsh
                            \ contained
                            \ fold
endfu

augroup syntax_fix_embedding
    au!
    au Syntax markdown call s:fix_embedding()
augroup END

