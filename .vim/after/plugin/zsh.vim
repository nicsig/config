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
