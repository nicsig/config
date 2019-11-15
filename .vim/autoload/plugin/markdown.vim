fu plugin#markdown#fix_embedding() abort
    if execute('syn list @markdownEmbedzsh', 'silent!') !~# 'markdownEmbedzsh'
        return
    endif
    syn clear zshSubst zshBrackets zshOldSubst

    " We add `contained` to each item to emulate what `:syn include` did originally.
    syn region  zshSubst    matchgroup=zshSubstDelim
                            \ start=/\$(/ skip=/\\)/ end=/)/
                            \ transparent
                            \ fold
                            \ contains=@markdownEmbedzsh
                            \ contained
    syn region  zshSubst    matchgroup=zshSubstDelim
                            \ start=/\${/ skip=/\\}/ end=/}/
                            \ fold
                            \ contains=@zshSubst,zshBrackets,zshQuoted,zshString
                            \ contained

    syn region  zshBrackets start=/{/ skip=/\\}/ end=/}/
                            \ transparent
                            \ fold
                            \ contained
    syn region  zshBrackets start='{' skip='\\}' end='}'
                            \ transparent
                            \ fold
                            \ contains=@markdownEmbedzsh
                            \ contained

    syn region  zshOldSubst matchgroup=zshSubstDelim
                            \ start=/`/ skip=/\\`/ end=/`/
                            \ fold
                            \ contains=@markdownEmbedzsh,zshOldSubst
                            \ contained
endfu

