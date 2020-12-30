vim9script noclear

# Init {{{1

const COLORS = {
    regtype: 3,
    regname: 30,
    }

def plugin#fzf#commits(char = '') #{{{1
    var cwd = getcwd()
    # To use `:FzBCommits` and `:FzCommits`, we first need to be in the working tree of the repo:{{{
    #
    #    - in which the current file belongs
    #
    #    - in which we are interested;
    #      let's say, again, the one to which the current file belongs
    #}}}
    noa exe 'lcd ' .. expand('%:p:h')->fnameescape()
    exe g:fzf_command_prefix .. char .. 'Commits'
    noa exe 'lcd ' .. cwd
enddef

def plugin#fzf#registers(pfx: string) #{{{1
    var source = execute('reg')->split('\n')[1 :]
    # trim leading whitespace (useful to filter based on type; e.g. typing `^b` will leave only blockwise registers)
    map(source, {_, v -> substitute(v, '^\s\+', '', '')})
    # highlight register type
    map(source, {_, v -> substitute(v, '^\s*\zs[bcl]', "\x1b[38;5;" .. s:COLORS.regtype .. "m&\x1b[0m", '')})
    # highlight register name
    map(source, {_, v -> substitute(v, '"\S', "\x1b[38;5;" .. s:COLORS.regname .. "m&\x1b[0m", '')})
    fzf#wrap({
        source: source,
        options: '--ansi --nth=3.. --tiebreak=index +m',
        sink: function(RegistersSink, [pfx])})
        ->fzf#run()
enddef

def RegistersSink(pfx: string, line: string)
    var regname = matchstr(line, '"\zs\S')
    if pfx =~ '["@]'
        feedkeys(pfx .. regname, 'in')
    else
        feedkeys((col('.') >= col('$') - 1 ? 'a' : 'i') .. "\<c-r>\<c-r>" .. regname, 'in')
    endif
enddef

