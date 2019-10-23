#!/bin/bash

# https://github.com/DaveDavenport/rofi/issues/205
# https://github.com/DaveDavenport/rofi/issues/63
# https://github.com/DaveDavenport/rofi/tree/next/Examples

if [[ "$@" == 'quit' ]]; then
  exit 0
fi

if [[ -z "$@" ]]; then
  printf -- "bookmarks\nwebsearch\nlocate\napps\nquit"
else
  if [[ "$@" == 'bookmarks' ]]; then
    echo ''
  elif [[ "$@" == 'websearch' ]]; then
    sr -elvi | awk -F'-' '{ print $1 }' | sed '/^ .*:$/d; s/\s*$//'
  else
    sr -browser= $@
  fi
  printf -- 'quit'
fi

exit 0

