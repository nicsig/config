if exists('g:autoloaded_my_dirvish')
    finish
endif
let g:autoloaded_my_dirvish = 1

let s:hide_dot_entries = 1

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

fu! my_dirvish#sort_and_maybe_hide() abort "{{{1
    if s:hide_dot_entries
        sil! noa keepj keepp g:\v/\.[^\/]+/?$:d_
    endif
    sort :^.*[\/]:
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
    let s:hide_dot_entries = !s:hide_dot_entries
    Dirvish %
endfu

