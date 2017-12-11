fu! vim_plug#scroll_preview(down) abort "{{{1
    sil! noautocmd wincmd P
    if &previewwindow
        exe 'norm! '.(a:down ? "\<c-e>" : "\<c-y>")
        noautocmd wincmd p
    endif
endfu

fu! vim_plug#show_documentation() abort "{{{1
    let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            exe 'tabe +setf\ help '.doc
        endfor
    endif
endfu
