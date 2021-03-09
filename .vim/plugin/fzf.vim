vim9script noclear

if exists('loaded') || stridx(&rtp, 'fzf.vim') == -1
    finish
endif
var loaded = true

# For more information about the available settings, read `:h fzf` *and* `:h fzf-vim`.

# Variables{{{1

# I have an issue!{{{
#
# See this: https://github.com/junegunn/fzf/issues/1055
#}}}
g:fzf_layout = {
    window: {
        width: 0.9,
        height: 0.6,
        xoffset: 0.5,
        yoffset: 0.5,
        highlight: 'Comment',
        border: 'sharp',
    }}

g:fzf_action = {
    ctrl-t: 'tab split',
    ctrl-s: 'split',
    ctrl-v: 'vsplit',
    }

# Always enable preview window on the right with 50% width.{{{
#
# By default, the preview  window is only enabled if the width  of the screen is
# bigger than 120 columns.
#}}}
g:fzf_preview_window = 'right:50%'

# When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
# in a window, give the focus to it, instead of loading it in the current one.
g:fzf_buffers_jump = true

g:fzf_command_prefix = 'Fz'

# Commands{{{1

# How do I toggle the preview window?{{{
#
# Press `?`.
# If you want to use another key:
#
#     fzf#vim#with_preview("right:50%:hidden", "?")
#                                               ^
#                                               change this
#}}}
# Where did you find this command?{{{
#
# For the most part, at the end of `:h fzf-vim-advanced-customization`.
#
# We've also tweaked it to make fzf ignore the first three fields when filtering.
# That is the file path, the line number, and the column number.
# More specifically, we pass to `fzf#vim#with_preview()` this dictionary:
#
#     {"options": "--delimiter=: --nth=4.."}
#
# Which, in turn, pass `--delimiter: --nth=4..` to `fzf(1)`.
#
# See: https://www.reddit.com/r/vim/comments/b88ohz/fzf_ignore_directoryfilename_while_searching/ejwn384/
#}}}
exe 'com -bang -nargs=* ' .. g:fzf_command_prefix
    .. 'Rg fzf#vim#grep('
    .. '"rg 2>/dev/null --column --line-number --no-heading --color=always --smart-case "'
    .. ' .. shellescape(<q-args>), 1,'
    .. ' <bang>0 ? fzf#vim#with_preview({options: "--delimiter=: --nth=4.."}, "up:60%")'
    .. ' : fzf#vim#with_preview({options: "--delimiter=: --nth=4.."}, "right:50%:hidden", "?"),'
    .. ' <bang>0)'

exe 'com -bang -nargs=? -complete=dir '
    .. g:fzf_command_prefix
    .. 'Files fzf#vim#files(<q-args>, fzf#vim#with_preview("right:50%"), <bang>0)'

# `:FzSnippets` prints the description of the snippets (✔), but doesn't use it when filtering the results (✘).{{{

# The  issue  is  due to  `:FzSnippets`  which  uses  the  `-n 1`  option  in  the
# `'options'` key of a dictionary.
# To fix this, we replace `-n 1` with `-n ..`.
# From `man fzf`:
#
#     /OPTIONS
#     /Search mode
#     -n, --nth=N[,..]
#           Comma-separated list of field  index expressions for limiting search
#           scope.  See FIELD INDEX EXPRESSION for the details.
#
#     /FIELD INDEX EXPRESSION
#     ..     All the fields
#}}}
exe 'com -bar -bang '
    .. g:fzf_command_prefix
    .. 'Snippets fzf#vim#snippets({options: "-n .."}, <bang>0)'

# Autocmds{{{1

augroup FzfOpenFolds | au!
    # press `zv` the next time Vim has nothing to do, *after* a buffer has been displayed in a window
    # Why the `mode()` condition?{{{
    #
    # For some reason, in the GUI, `norm! zv` makes the cursor move back one character when:
    #
    #    - the cursor is at the end of the line
    #    - we're in insert mode
    #    - fzf is configured to use a Vim window
    #      (popup or not; i.e. `g:fzf_layout` contains a `window` key)
    #
    # At least,  that's what happens when  we try to insert  a unicode character
    # with `vim-unichar` or `unicode.vim` via fzf.
    #}}}
    au FileType fzf au BufWinEnter * ++once au SafeState * ++once if mode() != 'i'
        |     exe 'norm! zv'
        | endif
augroup END

augroup FzfNoTimeout | au!
    # We could have a mapping which creates a timeout when we press `C-s`, `C-v`, or `C-t`.{{{
    #
    # For example,  at the  moment, we set  `'twk'` to `<c-s>`,  and to  avoid a
    # timeout when we  press `C-s C-w` to focus another  window, we install this
    # mapping:
    #
    #     tno <buffer><nowait> <c-s><c-w> <c-s><c-w>
    #
    # In turn, the latter can cause a timeout when we press `C-s` to open a file
    # in a new split.
    #}}}
    au FileType fzf tno <buffer><nowait> <c-s> <c-s>
    au FileType fzf tno <buffer><nowait> <c-v> <c-v>
    au FileType fzf tno <buffer><nowait> <c-t> <c-t>
    # We can't use `C-w` to delete the previous word because of `'twk'`.  Let's fix this.
    au FileType fzf setl twk=<c-@> | tno <buffer><nowait> <c-w> <c-w>
augroup END

# Mappings{{{1
# `:map` {{{2

exe 'nno <space>fmn <cmd>' .. g:fzf_command_prefix .. 'Maps<cr>'
nmap <space>fmi i<plug>(fzf-maps-i)
nmap <space>fmx v<plug>(fzf-maps-x)
nmap <space>fmo y<plug>(fzf-maps-o)
# don't press `fm` (search for next `m` character) if we cancel `SPC fm`
nno <space>fm<esc> <nop>

# command-line history {{{2

# Why not `C-r C-r`?{{{
#
# Already taken (`:h c^r^r`).
#}}}
# Why not `C-r C-r C-r`?{{{
#
# Would cause a timeout when we press `C-r C-r` to insert a register literally.
#}}}
cno <expr> <c-r><c-h>
\    getcmdtype() =~ ':' ? '<c-e><c-u>' .. g:fzf_command_prefix .. 'History:<cr>'
\  : getcmdtype() =~ '[/?]' ? '<c-e><c-u><c-c><cmd>' .. g:fzf_command_prefix .. 'History/<cr>' : ''
#                                        ^---^
#                                        don't use `<esc>`; an empty pattern would search for the last pattern
#                                        and raise an error if it can't be found

# commits {{{2

nno <space>fgc <cmd>call plugin#fzf#commits()<cr>
nno <space>fgbc <cmd>call plugin#fzf#commits('B')<cr>

# miscellaneous (`:Marks`, `:Rg`, ...) {{{2

def Miscellaneous()
    nno <space>fF <cmd>FZF $HOME<cr>

    var key2cmd: dict<string> = {
        M: 'Marks',
        R: 'Rg',
        bt: 'BTags',
        c: 'Commands',
        f: 'Files',
        gf: 'GFiles',
        # `gC` for Git Changed files
        gC: 'GFiles?',
        h: 'Helptags',
        # `l` for :ls (listing)
        l: 'Buffers',
        r: 'History',
        # `:FzSnippets` only returns snippets whose tab trigger contains the text before the cursor
        s: 'Snippets',
        t: 'Tags',
        w: 'Windows',
        }

    for [char, cmd] in items(key2cmd)
        exe 'nno <space>f' .. char .. ' <cmd>' .. g:fzf_command_prefix .. cmd .. '<cr>'
    endfor

    augroup RemoveGvfsFromOldfiles | au!
        # Rationale:{{{
        #
        # If you've opened ftp files with Vim:
        #
        #     $ vim -g ftp://ftp.vim.org/pub/vim/patches/8.0/README
        #
        # `v:oldfiles` will contain filepaths such as:
        #
        #     /run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.0/README
        #
        # Those kind of paths make `:FzHistory` slow to start.
        # This is because the command  calls `filereadable()`, and the latter is
        # slow on such a path:
        #
        #     :Time echo filereadable('~/.bashrc')
        #     :Time echo filereadable('/run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.0/README')
        #
        # The first command is instantaneous.
        # The second command takes more than a tenth of a second.
        #
        # And the  effect is cumulative: the  more paths like the  previous one,
        # the slower `:FzHistory` opens its fzf window.
        #
        # The value of `v:oldfiles` is built from the viminfo file.
        # The latter is read after our vimrc, so we can't clean `v:oldfiles` right now.
        # We need to wait for Vim to have fully started up.
        #}}}
        au VimEnter * v:oldfiles->filter((_, v: string): bool => v !~ '/gvfs/')
    augroup END
enddef
Miscellaneous()

# registers {{{2

# Don't use `"""`."{{{
#
# We would type it too often by accident, and the fzf popup is too distracting.
#}}}
# Don't use `"F` either.{{{
#
# It's  a  valid command  (e.g. `"Fyy`  appends  the  current  line in  the  `f`
# register).
#}}}
nno "<c-f> <cmd>call plugin#fzf#registers('"')<cr>
nno @<c-f> <cmd>call plugin#fzf#registers('@')<cr>
ino <c-r><c-f> <cmd>call plugin#fzf#registers('<c-r>')<cr>

