#compdef upp.sh

local programs
programs=(ansifilter gawk jumpapp mpv tmux trans vim weechat zsh)
# https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#complex-completions-with-_values-_sep_parts--_multi_parts
_values 'programs' ${programs} && return 0
