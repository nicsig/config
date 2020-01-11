fu plugin#markdown#fix_embedding() abort
    " Be careful what you choose to write in the rhs of `!~#`.{{{
    "
    " In particular, do *not* just write `markdownEmbedzsh`:
    "
    "                                                              vvvvvvvvvvvvvvvv
    "     if execute('syn list @markdownEmbedzsh', 'silent!') !~# 'markdownEmbedzsh'
    "         return
    "     endif
    "
    " The guard would wrongly fail when Vim is very verbose:
    "
    "     $ rm /tmp/md.md ; vim -V15/tmp/.x /tmp/md.md
    "     Error detected while processing function plugin#markdown#fix_embedding:~
    "     line    4:~
    "     E28: No such highlight group name: zshSubst zshBrackets zshOldSubst~
    "
    " It only happens at verbose level 15 or above; not below.
    " This is because when Vim is very verbose, the output of `execute(...)` is:
    "
    "                       vvvvvvvvvvvvvvvv
    "     line 1: syn list @markdownEmbedzsh
    "     --- Syntax items ---
    "
    " Even when `@markdownEmbedzsh` does not exist.
    "
    " ---
    "
    " You need to write sth which is absent even when Vim is very verbose.
    "}}}
    if execute('syn list @markdownEmbedzsh', 'silent!') !~# 'cluster'
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

