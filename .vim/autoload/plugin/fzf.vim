if exists('g:autoloaded_plugin#fzf')
    finish
endif
let g:autoloaded_plugin#fzf = 1

" Init {{{1

const s:COLORS = {
    \ 'regtype': 3,
    \ 'regname': 30,
    \ }

fu plugin#fzf#commits(char) abort "{{{1
    let cwd = getcwd()
    " To use `:FzBCommits` and `:FzCommits`, we first need to be in the working tree of the repo:{{{
    "
    "    - in which the current file belongs
    "
    "    - in which we are interested;
    "      let's say, again, the one to which the current file belongs
    "}}}
    noa exe 'lcd ' .. expand('%:p:h')->fnameescape()
    exe g:fzf_command_prefix .. a:char .. 'Commits'
    noa exe 'lcd ' .. cwd
endfu

fu plugin#fzf#registers(pfx) abort "{{{1
    let source = execute('reg')->split('\n')[1:]
    " trim leading whitespace (useful to filter based on type; e.g. typing `^b` will leave only blockwise registers)
    call map(source, {_, v -> substitute(v, '^\s\+', '', '')})
    " highlight register type
    call map(source, {_, v -> substitute(v, '^\s*\zs[bcl]', "\x1b[38;5;" .. s:COLORS.regtype .. "m&\x1b[0m", '')})
    " highlight register name
    call map(source, {_, v -> substitute(v, '"\S', "\x1b[38;5;" .. s:COLORS.regname .. "m&\x1b[0m", '')})
    call fzf#wrap({
        \ 'source': source,
        \ 'options': '--ansi --nth=3.. --tiebreak=index +m',
        \ 'sink': function('s:registers_sink', [a:pfx])})
        \ ->fzf#run()
endfu

fu s:registers_sink(pfx, line) abort
    let regname = matchstr(a:line, '"\zs\S')
    if a:pfx =~# '["@]'
        call feedkeys(a:pfx .. regname, 'in')
    else
        call feedkeys((col('.') >= col('$') - 1 ? 'a' : 'i') .. "\<c-r>\<c-r>" .. regname, 'in')
    endif
endfu

