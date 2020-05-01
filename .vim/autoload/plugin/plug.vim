fu plugin#plug#move_between_commits(is_fwd) abort "{{{1
    " look for the next commit
    if !search('^  \X*\zs\x', a:is_fwd ? '' : 'b')
        " there's none
        return
    endif
    " open the preview window to show details about the commit under the cursor
    norm o
endfu

fu plugin#plug#show_documentation() abort "{{{1
    let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            exe 'tabe +setf\ help '.doc
        endfor
    endif
endfu

fu plugin#plug#undo_ftplugin() abort "{{{1
    nunmap <buffer> H
    nunmap <buffer> o
    nunmap <buffer> )
    nunmap <buffer> (
endfu

