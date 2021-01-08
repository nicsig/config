vim9 noclear

def plugin#matchparen#installDummyAutocmds()
    # We need to always have at least one autocmd listening to `CursorMoved`.{{{
    #
    # Otherwise, Vim may detect the motion of the cursor too late.
    #
    # For an explanation of the issue, see:
    # https://github.com/vim/vim/issues/2053#issuecomment-327004968
    #
    # Although, I don't think it really explains the issue...
    #}}}
    #   Same thing for `TextChanged`.{{{
    #
    # MWE:
    #
    #     $ cat <<'EOF' >/tmp/vimrc
    #         nno "" <cmd>call Func()<cr>"+
    #         fu Func()
    #             au TextChanged * ++once s/^\s*\zshttp.*/<&>/e
    #         endfu
    #         au VimEnter * au! matchparen
    #     EOF
    #
    # The purpose  of this vimrc is  to automatically surround a  url with angle
    # brackets to format  it as a markdown  link, when you paste  it by pressing
    # `""p`.
    #
    #     $ vim -Nu /tmp/vimrc +'let @+ = "http://www.example.com"'
    #     ""p
    #     <http://www.example.com>~
    #     ✔
    #
    #     u
    #     ""p
    #     http://www.example.com~
    #     ✘
    #
    # To reproduce  the issue, before  pressing `""p`,  run `:au` and  make sure
    # there's no autocmd listening to `TextChanged` in there.
    #}}}
    #   Why also `CursorMovedI`, `WinEnter` and `TextChangedI`?{{{
    #
    # The default matchparen plugin also installs autocmds listening to these events.
    # If we disable  the plugin, I want  to be sure that there's  still at least
    # one autocmd listening to each of them.
    # Otherwise, we could encounter bugs which  are hard to understand, and that
    # other people can't reproduce.
    #}}}
    var events =<< trim END
        CursorMoved
        CursorMovedI
        WinEnter
        TextChanged
        TextChangedI
    END
    for event in events
        # Why not using a guard to only install the autocmd if there's none?{{{
        #
        # So, sth like this:
        #
        #     if !exists('#' .. event)
        #     ...
        #     endif
        #
        # It wouldn't be reliable.
        # Indeed, we could have a temporary one-shot autocmd listening to the event.
        # In that case, the guard would prevent the installation of the autocmd running `"`.
        # Shortly after, the one-shot autocmd could be removed, and we would end
        # up with no autocmd listening to our event.
        #}}}
        augroup MyDummyAutocmds
            exe 'au! ' .. event .. ' * #'
        augroup END
    endfor
enddef

