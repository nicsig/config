" Purpose:{{{
"
" The current script will be sourced when Vim starts.
" It will disable the `matchparen` plugin.
" But we also source it in a mapping to toggle the plugin.
"
"     ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim:441
"}}}
" Warning: DO NOT rename this file to `matchparen.vim`!{{{
"
" If you do, when you'll press `cop`, you'll execute:
"
"     runtime! plugin/matchparen.vim
"
" This will source the current script (✔), then `$VIMRUNTIME/plugin/matchparen.vim` (✘).
" The default script would undo our toggling.
"}}}

" TODO: Should we keep or remove `has('vim_starting')`.
" Remember that we can set `g:matchup_matchparen_enabled` to 0.
" Have a look also at `g:matchup_delim_start_plaintext`.
"
" ---
"
" Idea: to  toggle the plugin locally  (just for the current  buffer), you could
" set  `b:matchup_matchparen_enabled`  to `0`  in  all  the buffers  except  the
" current one.
if exists(':DoMatchParen') != 2 || exists('g:no_after_plugin') || has('vim_starting')
    finish
endif

if exists('#matchup_matchparen#CursorMoved')
    " Where is `:NoMatchParen` defined?{{{
    "
    " By default, in `$VIMRUNTIME/plugin/matchparen.vim`
    " But we use `vim-matchup` which redefines this command as well as `:DoMatchParen`
    " in `~/.vim/plugged/vim-matchup/plugin/matchup.vim`.
    "}}}
    " Do I need to preserve {{{
    "}}}
    "   the current/previous window?{{{
    "
    " Not if you use `vim-matchup`.
    " But you would probably need to preserve them, if you used the default matchparen plugin.
    "}}}
    "   the height of the windows, if some of them are squashed?{{{
    "
    " Same answer as previously.
    "}}}
    NoMatchParen
    " We need to always have at least one autocmd listening to `CursorMoved`.{{{
    "
    " Otherwise, Vim may detect the motion of the cursor too late.
    "
    " For an explanation of the issue, see:
    " https://github.com/vim/vim/issues/2053#issuecomment-327004968
    "
    " Although, I don't think it really explains the issue...
    "}}}
    "   Same thing for `TextChanged`.{{{
    "
    " MWE:
    "
    "     $ cat <<'EOF' >/tmp/vimrc
    "     nno <expr> "" Func()
    "     fu Func() abort
    "         augroup format_automatic_link
    "             au!
    "             au TextChanged * s/^\s*\zshttp.*/<&>/e | au! format_automatic_link
    "         augroup END
    "         return '"+'
    "     endfu
    "     au VimEnter * exe 'au! matchparen' | au! my_default_autocmds
    "     EOF
    "
    " The purpose  of this vimrc is  to automatically surround a  url with angle
    " brackets to format  it as a markdown  link, when you paste  it by pressing
    " `""p`.
    "
    "     $ vim -Nu /tmp/vimrc +'let @+ = "http://www.example.com"'
    "     ""p
    "     <http://www.example.com>~
    "     ✔
    "
    "     u
    "     ""p
    "     http://www.example.com~
    "     ✘
    "
    " To reproduce  the issue, before  pressing `""p`,  run `:au` and  make sure
    " there's no autocmd listening to `TextChanged` in there.
    "}}}
    "   Why also `CursorMovedI`, `WinEnter` and `TextChangedI`?{{{
    "
    " The matchparen plugin also installs autocmds listening to these events.
    " If we disable  the plugin, I want  to be sure that there's  still at least
    " one autocmd listening to each of them.
    " Otherwise, we could encounter bugs which  are hard to understand, and that
    " other people can't reproduce.
    "}}}
    let events =<< trim END
        CursorMoved
        CursorMovedI
        WinEnter
        TextChanged
        TextChangedI
    END
    for event in events
        " Why not using a guard to only install the autocmd if there's none?{{{
        "
        " So, sth like this:
        "
        "     if !exists('#' . event)
        "     ...
        "     endif
        "
        " It wouldn't be reliable.
        " Indeed, we could have a temporary one-shot autocmd listening to the event.
        " In that case, the guard would prevent the installation of the autocmd running `"`.
        " Shortly after, the one-shot autocmd could be removed, and we would end
        " up with no autocmd listening to our event.
        "}}}
        augroup my_default_autocmds
            " An empty commented  line does nothing, so will  have a minimal
            " impact  on Vim's  performance, but  is enough  to register  an
            " autocmd listening to a given event.
            exe 'au! '..event..' * "'
        augroup END
    endfor
else
    " Why `silent!`?{{{
    "
    " If an error is raised, `abort` would make the function sourcing this file stop.
    " We want the function to process all the code.
    "}}}
    sil! au! my_default_autocmds
    sil! aug! my_default_autocmds
    noa DoMatchParen
endif

