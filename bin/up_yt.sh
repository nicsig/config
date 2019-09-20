#!/bin/bash

main() { #{{{1
  printf -- 'current version: %s\n\n' "$(youtube-dl --version)"

  # https://rg3.github.io/youtube-dl/download.html
  curl -Ls 'https://yt-dl.org/downloads/latest/youtube-dl' -o "${HOME}/bin/youtube-dl"
  chmod a+rx "${HOME}/bin/youtube-dl"

  if [[ ! -d "${HOME}/Vcs/youtube-dl/" ]]; then
    mkdir -p "${HOME}/Vcs/"
    git -C "${HOME}/Vcs/" clone 'https://github.com/rg3/youtube-dl'
  fi

  cd "${HOME}/Vcs/youtube-dl" || exit
  git stash
  git checkout master
  git pull

  printf -- '\n%s\n\n' 'installing zsh completion function'
  make youtube-dl.zsh && \
    mv "${HOME}/Vcs/youtube-dl/youtube-dl.zsh" "${HOME}/.zsh/my-completions/_youtube-dl.zsh"

  # Source:{{{
  #
  #     https://askubuntu.com/a/244810/867754
  #     https://askubuntu.com/a/633924/867754
  #     man 1 manpath
  #     man 5 manpath
  #}}}
  printf -- '\n%s\n\n' 'installing manpage'
  make youtube-dl.1 && \
    mkdir -p "${HOME}/share/man/man1" && \
    mv youtube-dl.1 "${HOME}/share/man/man1"

  printf -- '\nnew version: %s\n' "$(youtube-dl --version)"
}

# Execution {{{1

main
tput bel

