bindkey -e
stty -ixon
. "${HOME}/.fasd-init-zsh"
alias j='fasd_cd -d'
# allow tmux to dump a core file if it crashes
ulimit -c unlimited
