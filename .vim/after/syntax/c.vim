fu! s:fix_allbut() abort
    let groups = [
    \ 'cBlock',
    \ 'cBracket',
    \ 'cCppBracket',
    \ 'cCppParen',
    \ 'cDefine',
    \ 'cMulti',
    \ 'cParen',
    \ 'cPreProc',
    \ ]
    for group in groups
        let definition = execute('syn list ' . group)
        if stridx(definition, 'ALLBUT') == -1
            continue
        endif
        let definition = substitute(definition, '.\{-}xxx\|\n\s*links\s\+to\s\+.*', '', 'g')
        let definition = substitute(definition, 'ALLBUT,', 'ALLBUT,@cMyCustomGroups,', '')
        if stridx(definition, 'start=') >= 0
            exe 'syn clear ' . group
            exe 'syn region ' . group . ' ' . definition
        endif
    endfor
endfu

call s:fix_allbut()

