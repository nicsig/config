fu plugin#fzf#commits(char) abort "{{{1
    let cwd = getcwd()
    " To use `:FzBCommits` and `:FzCommits`, we first need to be in the working tree of the repo:{{{
    "
    "    - in which the current file belongs
    "
    "    - in which we are interested;
    "      let's say, again, the one where the current file belong
    "}}}
    noa exe 'lcd '..fnameescape(expand('%:p:h'))
    exe g:fzf_command_prefix..a:char..'Commits'
    noa exe 'lcd '..cwd
endfu

fu plugin#fzf#registers(mode) abort "{{{1
    let source = split(execute('reg'), '\n')[1:]
    " trim leading whitespace (useful to filter based on type; e.g. typing `^b` will leave only blockwise registers)
    call map(source, {_,v -> substitute(v, '^\s\+', '', '')})
    " highlight register name
    call map(source, {_,v -> substitute(v, '"\S', "\x1b[38;5;30m&\x1b[0m", '')})
    " highlight register type
    call map(source, {_,v -> substitute(v, '^\s*\zsc', "\x1b[38;5;3m&\x1b[0m", '')})
    call map(source, {_,v -> substitute(v, '^\s*\zsb', "\x1b[38;5;5m&\x1b[0m", '')})
    call fzf#run(fzf#wrap('registers', {
        \ 'source': source,
        \ 'options': '--ansi --tiebreak=index +m',
        \ 'sink': function('s:registers_sink', [a:mode])}))
endfu

fu s:registers_sink(mode, line) abort
    let regname = matchstr(a:line, '"\zs\S')
    if a:mode is# 'n'
        call feedkeys('"'..regname, 'in')
    else
        call feedkeys((col('.') >= col('$') - 1 ? 'a' : 'i').."\<c-r>\<c-r>"..regname, 'in')
    endif
endfu

