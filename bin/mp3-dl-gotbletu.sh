#!/bin/bash
#             _   _     _      _
#  __ _  ___ | |_| |__ | | ___| |_ _   _
# / _` |/ _ \| __| '_ \| |/ _ \ __| | | |
#| (_| | (_) | |_| |_) | |  __/ |_| |_| |
# \__, |\___/ \__|_.__/|_|\___|\__|\__,_|
# |___/
#       http://www.youtube.com/user/gotbletu
#       https://twitter.com/gotbletu
#       https://plus.google.com/+gotbletu
#       https://github.com/gotbletu
#       gotbleu@gmail.com

# a script to copy link and download youtube videos to mp3
# just create a shortcut launcher on the panel and click on it while on the youtube page to want download the mp3 from

# requires: wmctrl youtube-dl xclip

# set browser string to look for
wmctrl -a Chromium
sleep 0.5

# copy link to clipboard
xdotool key ctrl+l
sleep 0.5
xdotool key ctrl+c

# save location
cd ~/Desktop || exit

# OSD display starting
notify-send -i ~/Downloads/youtube_green.png 'Starting Download' -t 5000

# download (prevents downloading all playlist)
youtube-dl -c --restrict-filenames --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$(xclip -selection clipboard -o | cut -d\& -f1)"

# OSD display finish
notify-send -i ~/Downloads/youtube_red.png 'Finish Download' -t 5000
