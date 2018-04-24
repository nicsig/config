fu! snippets#get_autoload_funcname() abort "{{{1
    return expand('%:p') =~# 'autoload\|plugin'
       \ ?     substitute(matchstr(expand('%:p'), '\%(autoload\|plugin\)/\zs.*\ze.vim'), '/', '#', 'g').'#'
       \ :     ''
endfu

fu! snippets#get_lg_tag_number() abort "{{{1
    let lines = reverse(getline(1, line('.')-1))
    call filter(lines, {i,v -> v =~# '^\s*\*lg-lib-\%(\d\+\)\*\s*$'})
    return empty(lines)
       \ ?     ''
       \ :     matchstr(lines[0], '^\s*\*lg-lib-\zs\d\+\ze\*\s*$')
endfu

