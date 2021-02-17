vim9script noclear

def plugin#fzf#commits(char = '') #{{{1
    var cwd: string = getcwd()
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

