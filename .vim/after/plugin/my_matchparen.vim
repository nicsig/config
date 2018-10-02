" DO NOT rename this file to `matchparen.vim`!
" It would cause a conflict with the plugin in $VIMRUNTIME.
if exists(':DoMatchParen') != 2
    finish
endif

" The current script will be sourced when Vim starts.
" It will disable the `matchparen` plugin.
" But we also source it in a mapping to toggle the plugin.
"
"         ~/.vim/plugged/vim-toggle-settings/autoload/toggle_settings.vim:441

if exists('g:loaded_matchparen')
    " command defined in `$VIMRUNTIME/plugin/matchparen.vim`
    NoMatchParen

    " We need to always have at least one autocmd listening to `CursorMoved`.
    " Otherwise, Vim may detect the motion of the cursor too late.
    " For an explanation of the issue, see:
    "         https://github.com/vim/vim/issues/2053#issuecomment-327004968
    augroup default_cursor_moved
        au!
        au CursorMoved * "
        "                │
        "                └─ just execute a commented line
        "                   does nothing, but is just enough to register an
        "                   autocmd listening to `CursorMoved`
    augroup END

else
    noa DoMatchParen
    au! default_cursor_moved
    aug! default_cursor_moved
endif
