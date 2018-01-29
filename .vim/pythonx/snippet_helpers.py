# coding=utf-8
# The previous line  allows us to use unicode characters  in comments (like …){{{
# without python raising an exception.
#
#     https://stackoverflow.com/a/10589674/9110115
#     https://stackoverflow.com/a/729016/9110115
#
# The `-*-` prefix/suffix are not necessary, unless you use Emacs.
#}}}

import re
import vim

def my_index(a_list, pattern): #{{{1
    pat = re.compile(pattern)
    for i, s in enumerate(a_list):
        if pat.search(s):
            return i
    return -1

def trim_ws(snip): #{{{1
    # no need  to use the  `^` anchor, because  we're going to  invoke `match()`
    # which, contrary to  `search()`, always searches from the  beginning of the
    # string
    ws = re.compile('\s+$')
    #                                                    ┌ address of first line in snippet{{{
    #                                                    │ the tuple `snip.snippet_start` contains 2 numbers:
    #                                                    │
    #                                                    │     (line, column)
    #                                                    │
    #                                                    │                   ┌ address of last line in snippet
    #                                ┌───────────────────┤ ┌─────────────────┤}}}
    for i,l in enumerate(snip.buffer[snip.snippet_start[0]:snip.snippet_end[0]]):
    #   └─┤    └───────┤{{{
    #     │            │
    #     │            └ iterate over some lines of the buffer
    #     │
    #     └ i = index of item in the list
    #       l = item in the list (buffer line)
    #}}}
    # snip.buffer = lines in buffer{{{
    #
    # When you want to modify the buffer, use this variable.
    # From `:h Ultisnips-buffer-proxy`:
    #
    #     Note:   special  variable   called   'snip.buffer'   should  be   used
    #     for  all   buffer  modifications. Not  'vim.current.buffer'   and  not
    #     'vim.command("...")', because in that case  UltiSnips will not be able
    #     to track changes in buffer from actions.
    #}}}
        # check  whether  each  line  in  the  snippet  matches  an  empty  line
        # containing whitespace
        if ws.match(l):
            # if so, remove the whitespace
            snip.buffer[snip.snippet_start[0]+i] = ''
            # necessary to avoid error when we expand `fu` without a visual token
            #
            #     RuntimeError: line under the cursor was modified,
            #     but "snip.cursor" variable is not set;
            #     either set set "snip.cursor" to new cursor position,
            #     or do not modify cursor line
            snip.cursor.preserve()
            # Alternative:
            #     snip.cursor.set(i, 0)

