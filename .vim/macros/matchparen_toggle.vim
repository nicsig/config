" We source this script in a mapping to toggle the matchparen module of match-up:
"     ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim:703

if g:matchup_matchparen_enabled
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
    call plugin#matchparen#install_dummy_autocmds()
else
    " Why `silent!`?{{{
    "
    " If an error is raised, `abort` would make the function sourcing this file stop.
    " We want the function to process all the code.
    "}}}
    sil! au! my_dummy_autocmds
    sil! aug! my_dummy_autocmds
    noa DoMatchParen
endif

