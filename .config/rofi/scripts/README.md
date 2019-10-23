# Where did you find the inspiration for those scripts?

Playlist Gotbletu Rofi: <https://www.youtube.com/playlist?list=PLqv94xWU9zZ0LVP1SEFQsLEYjZC_SUB3m>
Playlist Gotbletu Surfraw: <https://www.youtube.com/playlist?list=PLqv94xWU9zZ2e-lDbmBpdASA6A6JF4Nyz>

    % sr -elvi | awk -F'-' '{ print $1 }' | sort | uniq | sed '/^ .*:$/d; s/\s*$//; /ixquick/d; 1iixquick' V

