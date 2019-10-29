fu vim_plug#move_between_commits(is_fwd) abort "{{{1
    " There's no commit in the main / initial window.
    "
    " We're going to press `o` later  to open the preview window showing details
    " about the commit under the cursor; this will raise an error if we haven't
    " pressed `D` / executed `:PlugDiff`.
    if !search('^  \X*\zs\x', a:is_fwd ? '' : 'b')
        return
    endif

    " Alternative: call feedkeys('o', 'ix'){{{
    "                                   │
    "                                   └ necessary!
    "
    " Without  `x` Vim  will  type  `o` AFTER  having  finished processing  this
    " function. Because of this, `wincmd P`  will be executed before the preview
    " window is opened,  which will raise an error, and  prevent the function to
    " finish its work.
    "}}}
    norm o
endfu

fu vim_plug#show_documentation() abort "{{{1
    let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            exe 'tabe +setf\ help '.doc
        endfor
    endif
endfu

fu vim_plug#undo_ftplugin() abort "{{{1
    nunmap <buffer> H
    nunmap <buffer> o
    nunmap <buffer> )
    nunmap <buffer> (
endfu

