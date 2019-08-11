#!/bin/bash

# `pandoc` is a dependency; make sure it's installed
command -v pandoc >/dev/null 2>&1 \
  \ || { printf -- "%s require 'pandoc' but it's not installed.  Aborting.\n" "$(basename "$0")" >&2; exit 1; }

LOGFILE="${HOME}/log/$(basename "$0" .sh).log"

if [[ $# -eq 0 ]]; then
  printf -- "usage: %s 'url'\n" "$(basename "$0")" >&2
  exit 64
fi

main() { #{{{1
  # No need to restore the working directory later, because we're in a script.
  # And a script is executed in a subshell.
  builtin cd /tmp || exit

  cat <<EOF
---
---
$(date +%m-%d\ %H:%M)
===========
Downloading webpage...
---

EOF
  #         ┌ download even if the ssl certificate is invalid
  #         │
  #         │                                           ┌ print the page on standard output
  #         │                                           ├─┐
  wget -c --no-check-certificate --local-encoding=UTF-8 -O- "$1" \
    | pandoc -f html -t epub3 -o doc.epub
    #         ├────┘  ├─────┘    ├──────┘
    #         │       │          └ output file
    #         │       └ output format
    #         └ input format

  # See `$ ebook-convert --help`.
  cat <<EOF

Converting epub into pdf...
---

EOF
  ebook-convert doc.epub doc.pdf

  # See `$ calibredb add --help`.
  cat <<EOF

Add the epub inside Calibre library...
---

EOF
  calibredb add doc.epub

  # Save the id of the epub we've just added to calibre library.
  # We'll need it when we want to add the pdf version of the document.
  doc_id=$(calibredb list -f uuid | tail -n2 | head -n1 | cut -d' ' -f1)
  #                     ├─────┘{{{
  #                     └ don't display the title
  #                       (the latter may contain unexpected/special characters
  #                        making the extraction of the document index difficult),
  #                       instead only display the field 'uuid'
  #                       For more info:
  #
  #                             $ calibredb --help
  #                             $ calibredb list --help
  #}}}

  # Print the id of the document for debugging purpose.
  cat <<EOF

ID of the document: ${doc_id}
---
EOF

  cat <<EOF
Add the pdf inside Calibre library...
---

EOF
  calibredb add_format "${doc_id}" doc.pdf

  cat <<EOF

Starting Calibre server...
---
EOF
  [[ ! "$(pidof calibre-server)" ]] && calibre-server -p 8080 --daemonize
  #                                                    ├────┘ ├─────────┘
  #                                                    │      └ run process in background as a daemon
  #                                                    └ listen on port 8080

  rm /tmp/doc.epub
}

# Execution {{{1

main "$1" 2>&1 | tee -a "${LOGFILE}"

# Why the `&` control operator?{{{
#
# The `xdg-open` process will run as long as we don't close the pdf.
# But we want to use the current shell for other commands while the pdf is open.
# So we start the process in the  background, to get the control of the terminal
# back.
#}}}
# Why don't you include `xdg-open` in `main()`?{{{
#
# The prompt wouldn't be redrawn after the script has finished.
#
# MWE:
#
#     main() {
#       wget -O- 'https://unix.stackexchange.com/a/76720/289772' >/dev/null
#     }
#     main &
#
# The issue seems to come from a command with a lot of output, such as `wget`,
# + the `&` operator.
#
# If we remove `xdg-open` from `main()`, we don't need to apply the `&` operator
# to `wget`, which fixes the issue.
#
#     main() {
#       wget -O- 'https://unix.stackexchange.com/a/76720/289772' >/dev/null
#     }
#     main
#     xdg-open /path/to/some/pdf &
#
# Bottom line:
# Apply the `&` operator only to the command(s) which really need(s) it.
# And,  in case  of an  issue, start  your  job outside  any function,  or in  a
# dedicated function.
#}}}
xdg-open /tmp/doc.pdf &
# TODO:
# Find a way to get the path of the pdf in the Calibre library, so that we can
# remove `/tmp/doc.pdf`.

