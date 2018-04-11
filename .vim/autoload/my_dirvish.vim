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

fu! s:restore_position(line) abort "{{{1
    " FIXME: really needed?
    "     v
    call cursor(1,1)
    let pat = '\C\V\^'.escape(a:line, '\').'\$'
    "           ^
    "           FIXME:
    "           We need it (xmind/ vs XMind/ in home/), why?
    "           Update:
    "           Because `search()` uses 'ic'.
    "
    "           Should we do the same everywhere?
    "               :vim /\C\\V/gj ...
    "           Update:
    "           I think so, at least every time we use `search()`.
    "           But, I would say all the time.
    "           'ic' is probably used in other contexts.
    "           Be consistent, use `\C` all the time if you want an exact match.
    call search(pat)
endfu

fu! s:save_position() abort "{{{1
    " grab current line; necessary to restore position later
    let line = getline('.')
    " if the  current line matches a  hidden file/directory, and we're  going to
    " hide dot  entries, we won't  be able to  restore the position;  instead we
    " will restore  the position using the  previous line which is  NOT a hidden
    " entry
    if line =~# '.*/\.[^/]\+/\?$' && s:hide_dot_entries
        let line = getline(search('.*/[^.][^/]\{-}/\?$', 'bnW'))
    endif
    return line
endfu

fu! my_dirvish#sort_and_hide() abort "{{{1
    " make sure  that `b:dirvish` exists,  because it  doesn't when we  use this
    " command:
    "
    "     $ git ls-files | vim +'setf dirvish' -
    let b:dirvish = get(b:, 'dirvish', {})

    " We're going to save the cursor position right after.
    " But if we've already visited this directory, the saving will overwrite the
    " old position. So, we need to restore the old position, now, before we save
    " it (again).
    if has_key(b:dirvish, 'line')
        call s:restore_position(b:dirvish.line)
    endif

    " Save current position before (maybe) hiding dot entries.
    let b:dirvish.line = s:save_position()

    " Also, save the position when we go up the tree.
    " Useful if we re-enter the directory afterwards.
    augroup my_dirvish_save_position
        au! * <buffer>
        au BufWinLeave <buffer> let b:dirvish.line = s:save_position()
    augroup END

    if s:hide_dot_entries
        sil! noa keepj keepp g:\v/\.[^\/]+/?$:d_
    endif

    " sort directories at the top
    sort r /[^/]$/
    " find first file
    let found_first_file = search('[^/]$', 'cW')
    if found_first_file
        " sort all the files
        .,$sort
    endif

    " restore position
    call s:restore_position(b:dirvish.line)
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

