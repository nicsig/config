#!/bin/bash

BROWSER=firefox
FILE=$1

"${BROWSER}" "${FILE}"

while inotifywait -q "${FILE}" >/dev/null; do
  CUR_WID=$(xdotool getwindowfocus)

  # gets the first $BROWSER window, if you have more than one
  # $BROWSER window open, it might not refresh the right one,
  # as an alternative you can search by the window/html title
  WID=$(xdotool search --onlyvisible --class ${BROWSER} | head -1)

  #   TITLE="window/html file title"
  #   WID=$(xdotool search --title "${TITLE}" | head -1)

  xdotool windowactivate "${WID}"
  xdotool key 'ctrl+r'
  printf -- '%s Refresh: %s\n' "$(date +%H:%M:%S)" "${FILE}"
  xdotool windowactivate "${CUR_WID}"
done
