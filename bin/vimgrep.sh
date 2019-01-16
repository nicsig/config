#!/bin/bash

# Purpose:{{{
#
# Run a `:vimgrep` command  from (Neo)Vim and write an error  file, which can be
# parsed to get the qfl back.
#}}}
# Usage:{{{
#
#     $ vimgrep.sh vim /tmp/error_file /pat/gj files ...
#                  │
#                  └ use a Vim process (you could also use `nvim`)
#}}}
# Why do you need this script?{{{
#
# A (Neo)Vim job started directly from a Vim instance doesn't exit:
#
#     $ vim
#     :call job_start('vim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     ✘                ^
#
#     $ vim
#     :call job_start('nvim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     ✘                ^
#
# The job is in an interruptible sleep:
#
#     :let job = job_start('vim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     :exe '!ps aux | grep '.job_info(job).process
#     user  1234  ... Ss  ...  vim +call writefile(["test"], "/tmp/log") +qa!~
#                     ^✘
#
# If we start it from a script, the issue disappears.
#}}}

PGM=$1
TEMPFILE=$2
shift 2

# FIXME: We should replace `vim` with `"${PGM}"`,{{{
#
# but we don't, because for some reason a Neovim job started from Neovim doesn't exit.
#
#     $ nvim
#     :call jobstart('nvim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     ✘               ^
#
# The job is in an interruptible sleep:
#
#     :let job = jobstart('nvim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     :exe '!ps aux | grep '.jobpid(job)
#     user  1234  ... Ss  ...  nvim +call writefile(["test"], "/tmp/log") +qa!~
#                     ^✘
#
# The issue disappears if we start a Vim job:
#
#     $ nvim
#     :call jobstart('vim +''call writefile(["test"], "/tmp/log")'' +qa!')
#     ✔               ^
#}}}
vim +"noa vimgrep $*" \
    +'let matches = map(getqflist(), {i,v -> printf("%s:%d:%d:%s", bufname(v.bufnr), v.lnum, v.col, v.text)})' \
    +"call writefile(matches, \"${TEMPFILE}\")" \
    +'qa!'

