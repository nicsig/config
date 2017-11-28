" Commands {{{1

" Currently, we source our html ftplugin in a markdown buffer, because that's
" what tpope does. He does this, probably because html is valid inside
" markdown. But, this cause an issue for the next command `:EmmetInstall`. It
" won't exist, until we have read at least one html file.
" So, check `:EmmetInstall` exists before trying to execute it.
if exists(':EmmetInstall') == 2
    EmmetInstall
    " Install the mapping for expanding emmet abbreviations.
    "
    " Create Emmet mappings to current buffer and, if set |g:user_emmet_complete_tag|,
    " change |'omnifunc'| option to emmet#completeTag()
endif

" Options {{{1

setl fp=js-beautify\ --html
setl kp=:DD
" OLD:{{{
"         setl kp=xdg-open\ https://developer.mozilla.org/search\\?topic=api\\&topic=html\\&q=\
"
" When hitting K, search for the word under the cursor in a search engine.
"
" We need to double escape a question mark in a url.
" The first one is removed by Vim when the value of 'keywordprg' / 'kp' is
" set. The 2nd one is necessary to prevent the shell from performing an
" expansion on the url, and forcing it to take the question mark literally.
"
" We need to do the same thing for & (double escape).
" Probably to prevent the shell from interpreting & as a special character
" (forking process).
"
" The backslash at the very end is here so that the word under the cursor is
" not passed as a 2nd argument to xdg-open. It must be a part of the url.
" The backslash removes the syntaxic value of the space which is added by Vim
" between the beginning url ('kp' value) and the searched word.
"
" The space is usually added to separate the name of the command inside 'kp'
" from the its argument (word under cursor).
"}}}

" Teardown {{{1

let b:undo_ftplugin =         get(b:, 'undo_ftplugin', '')
                    \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
                    \ ."
                    \   setl fp< kp<
                    \  "
