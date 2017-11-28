fu! snippets#fold_text() abort "{{{1
    let indent = repeat(' ', (v:foldlevel-1)*3)
    let title  = substitute(getline(v:foldstart), '\v^\s*#\s*|\s*#?\{\{\{\d?', '', 'g')

    if get(b:, 'my_title_full', 0)
        let foldsize  = (v:foldend - v:foldstart)
        let linecount = '['.foldsize.']'.repeat(' ', 4 - strchars(foldsize))
        return indent.' '.linecount.' '.title
    else
        return indent.' '.title
    endif
endfu
