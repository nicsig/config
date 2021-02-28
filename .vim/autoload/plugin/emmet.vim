vim9script noclear

# Interface {{{1
def plugin#emmet#installMappings() #{{{2
    # The default mappings are not silent (and they probably don't use `<nowait>` either).
    # We prefer to make them silent.

    # Why this guard?{{{
    #
    # We need `:EmmetInstall` later at the end of the function.
    # But if we disable `emmet.vim`, it won't exist.
    # Besides, if  `emmet.vim` is disabled,  there's no point in  installing the
    # next mappings (C-g, ...).
    #}}}
    if exists(':EmmetInstall') != 2
        return
    endif

    # Where did you find all the `{rhs}`?{{{
    #
    #     :h emmet-customize-key-mappings
    #}}}
    # Why `C-g C-u` instead of simply `C-g u`? {{{
    #
    # To  avoid a  conflict with  the default  `C-g u`  command (:h  i^gu) which
    # breaks the undo sequence.
    #}}}
    # Same question for `C-g C-[jkm]`.{{{
    #
    # To  avoid a  conflict with  our custom mappings:
    #
    #     C-g j    scroll window downward
    #     C-g k    scroll window upward
    #     C-g m    :FzMaps
    #}}}

    imap <buffer><nowait><silent> <c-g>,     <plug>(emmet-expand-abbr)
    imap <buffer><nowait><silent> <c-g>;     <plug>(emmet-expand-word)
    imap <buffer><nowait><silent> <c-g><c-u> <plug>(emmet-update-tag)
    # mnemonics: `s` for select
    imap <buffer><nowait><silent> <c-g>s     <plug>(emmet-balance-tag-inward)
    imap <buffer><nowait><silent> <c-g>S     <plug>(emmet-balance-tag-outword)
    #                                                                     ^ necessary typo
    imap <buffer><nowait><silent> <c-g>n     <plug>(emmet-move-next)
    imap <buffer><nowait><silent> <c-g>N     <plug>(emmet-move-prev)
    imap <buffer><nowait><silent> <c-g>i     <plug>(emmet-image-size)
    imap <buffer><nowait><silent> <c-g>I     <plug>(emmet-image-encode)
    imap <buffer><nowait><silent> <c-g>/     <plug>(emmet-toggle-comment)
    imap <buffer><nowait><silent> <c-g><c-j> <plug>(emmet-split-join-tag)
    imap <buffer><nowait><silent> <c-g><c-k> <plug>(emmet-remove-tag)
    imap <buffer><nowait><silent> <c-g>a     <plug>(emmet-anchorize-url)
    imap <buffer><nowait><silent> <c-g>A     <plug>(emmet-anchorize-summary)

    xmap <buffer><nowait><silent> <c-g>,     <plug>(emmet-expand-abbr)
    xmap <buffer><nowait><silent> <c-g>;     <plug>(emmet-expand-word)
    xmap <buffer><nowait><silent> <c-g><c-u> <plug>(emmet-update-tag)
    xmap <buffer><nowait><silent> <c-g>s     <plug>(emmet-balance-tag-inward)
    xmap <buffer><nowait><silent> <c-g>S     <plug>(emmet-balance-tag-outword)
    xmap <buffer><nowait><silent> <c-g>n     <plug>(emmet-move-next)
    xmap <buffer><nowait><silent> <c-g>N     <plug>(emmet-move-prev)
    xmap <buffer><nowait><silent> <c-g>i     <plug>(emmet-image-size)
    xmap <buffer><nowait><silent> <c-g>/     <plug>(emmet-toggle-comment)
    xmap <buffer><nowait><silent> <c-g><c-j> <plug>(emmet-split-join-tag)
    xmap <buffer><nowait><silent> <c-g><c-k> <plug>(emmet-remove-tag)
    xmap <buffer><nowait><silent> <c-g>a     <plug>(emmet-anchorize-url)
    xmap <buffer><nowait><silent> <c-g>A     <plug>(emmet-anchorize-summary)

    # these 2 mappings are specific to visual mode
    xmap <buffer><nowait><silent> <c-g><c-m> <plug>(emmet-merge-lines)
    xmap <buffer><nowait><silent> <c-g>p     <plug>(emmet-code-pretty)

    # now, we also need to install the `<plug>` mappings
    EmmetInstall
    # Would this work if I lazy-loaded emmet?{{{
    #
    # No.
    #
    # Its interface would not be installed until we read an html or css file.
    # So, the  first time  we would  read an html  or css  file, `:EmmetInstall`
    # would  not exist,  and we  couldn't use  it here  to install  the `<plug>`
    # mappings.
    #}}}
    # Would there be solutions?{{{
    #
    # You could execute `:EmmetInstall` from a filetype plugin:
    #
    #     if exists(':EmmetInstall') == 2
    #         EmmetInstall
    #     endif
    #
    # When a  filetype plugin is sourced,  it seems the interface  of the plugin
    # would  be finally  installed (contrary  to  when the  current function  is
    # sourced).
    # Or you could install a one-shot autocmd to slightly delay the execution of
    # `:EmmetInstall`:
    #
    #     au BufWinEnter * ++once if index(['html', 'css'], &ft) >= 0 | sil! EmmetInstall | endif
    #}}}
    # Why don't you lazy-load emmet?{{{
    #
    # emmet starts already  quickly (less than a fifth  of millisecond), because
    # the core of its code is autoloaded.
    #
    # Besides, we would need to write the same code in different filetype plugins
    # (violate DRY, DIE).
    #
    # Finally, we've had enough issues with lazy-loading in the past.
    # I prefer to avoid it as much as possible now.
    # It's a hack anyway, and you should use  it only as a last resort, and only
    # if the plugin is slow to start because it hasn't been autoloaded:
    #
    #     “Premature optimization is the root of all evil.“
    #}}}

    SetUndoFtplugin()
enddef
#}}}1
# Core {{{1
def SetUndoFtplugin() #{{{2
    b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
        .. '| call ' .. expand('<SID>') .. 'UndoFtplugin()'
enddef

def UndoFtplugin() #{{{2
    iunmap <buffer> <c-g>,
    iunmap <buffer> <c-g>;
    iunmap <buffer> <c-g><c-u>
    iunmap <buffer> <c-g>s
    iunmap <buffer> <c-g>S
    iunmap <buffer> <c-g>n
    iunmap <buffer> <c-g>N
    iunmap <buffer> <c-g>i
    iunmap <buffer> <c-g>I
    iunmap <buffer> <c-g>/
    iunmap <buffer> <c-g><c-j>
    iunmap <buffer> <c-g><c-k>
    iunmap <buffer> <c-g>a
    iunmap <buffer> <c-g>A

    xunmap <buffer> <c-g>,
    xunmap <buffer> <c-g>;
    xunmap <buffer> <c-g><c-u>
    xunmap <buffer> <c-g>s
    xunmap <buffer> <c-g>S
    xunmap <buffer> <c-g>n
    xunmap <buffer> <c-g>N
    xunmap <buffer> <c-g>i
    xunmap <buffer> <c-g>/
    xunmap <buffer> <c-g><c-j>
    xunmap <buffer> <c-g><c-k>
    xunmap <buffer> <c-g>a
    xunmap <buffer> <c-g>A
    xunmap <buffer> <c-g><c-m>
    xunmap <buffer> <c-g>p
enddef
