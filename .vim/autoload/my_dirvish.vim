fu! s:do_i_preview() abort "{{{1
    if get(b:dirvish, 'last_preview', 0) != line('.')
        let b:dirvish['last_preview'] = line('.')
        call s:preview()
    endif
endfu

fu! my_dirvish#install_auto_preview() abort "{{{1
    augroup my_dirvish_auto_preview
        au!
        au CursorMoved <buffer> nested call s:do_i_preview()
    augroup END
endfu

fu! s:preview() abort "{{{1
    let file = getline('.')
    if filereadable(file)
        exe 'pedit '.file
        noa wincmd P
        if &l:pvw
            norm! zv
            wincmd L
            noa wincmd p
        endif

    elseif isdirectory(file)
        let ls = systemlist('ls '.shellescape(file))
        let b:dirvish['preview_ls'] = get(b:dirvish, 'preview_ls', tempname())
        call writefile(ls, b:dirvish['preview_ls'])
        exe 'sil pedit '.b:dirvish['preview_ls']
        noa wincmd P
        if &l:pvw
            wincmd L
            noa wincmd p
        endif
    endif
endfu

fu! my_dirvish#reload() abort "{{{1
    let search_line = getline('.')
    Dirvish %
    sil! call search('\V\^' . escape(search_line, '\') . '\$', 'cw')
endfu

fu! my_dirvish#toggle_auto_preview(enable) abort "{{{1
    if a:enable && !exists('#my_dirvish_auto_preview')
        call my_dirvish#install_auto_preview()
        echo '[auto preview] ON'
        call s:preview()
    elseif !a:enable && exists('#my_dirvish_auto_preview')
        au!  my_dirvish_auto_preview
        aug! my_dirvish_auto_preview
        echo '[auto preview] OFF'
        sil! pclose
    endif
endfu

fu! my_dirvish#toggle_dot_entries() abort "{{{1
    let b:hide_dot_entries = !get(b:, 'hide_dot_entries', 1)
    if b:hide_dot_entries
        " We delete the lines beginning with a dot, followed by anything different
        " than a (back)slash, followed optionally by a slash.
        sil! keepp g:\v/\.[^\/]+/?$:d
        " We try to go back where we were before the deletion.
        " Why the :try?
        " If we were on a hidden file/directory, `:norm! `` ` will fail, because
        " it will be unable to bring us back where we were (deleted line).
        try
            norm! ``
        catch
            return lg#catch_error()
        endtry
    else
        norm R
    endif
endfu
