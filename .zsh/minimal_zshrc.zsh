bindkey -e
stty -ixon
. "${HOME}/.fasd-init-zsh"
alias j='fasd_cd -d'
ulimit -c unlimited
