" Options {{{1

" We don't want global mappings. We prefer buffer-local ones.
let g:user_emmet_install_global = 0

" We only need mappings in insert and visual mode (not normal).
let g:user_emmet_mode = 'iv'

" We use `C-g` as a prefix key instead of `C-y`.
let g:user_emmet_leader_key = '<c-g>'

" https://github.com/mattn/emmet-vim/issues/378#issuecomment-329839244
"
" Issue1: Sometimes it's annoying:{{{
"
"     • write a url and press `C-g a`
"     • expand this abbreviation:    #page>div.logo+ul#navigation>li*5>a{Item $}
"}}}
" Issue2: It can break `C-g N` (jump to previous point).{{{
" The issue is in this function:
"
"     emmet#lang#html#moveNextPrev()
"
" From this file:
"     $HOME/.vim/plugged/emmet-vim/autoload/emmet/lang/html.vim:887
"
" The pattern is right, but sometimes, it needs to be searched twice
" instead of once.
"
"}}}
let g:user_emmet_settings = {
\       'html': {
\           'block_all_childless' : 1,
\       },
\ }

" For more options see:
"     ~/.vim/plugged/emmet-vim/autoload/emmet.vim:999
"
" The keys of the first level are names of filetypes.
" The keys of the second level are names of abbreviations, snippets and options.

" Mappings {{{1

augroup my_emmet
    au!
    au FileType css,html  call s:emmet_set_mappings()
    " We  enable the  emmet  mappings in  the notes  we  take about  web-related
    " technologies (html, css, emmet, ...).
    " TODO:
    " However, maybe we could enable them to all markdown files...
    "
    "     au FileType css,html,markdown  call s:emmet_set_mappings()
    "                          ^^^^^^^^
    au BufReadPost,BufNewFile  */wiki/web/*.md  call s:emmet_set_mappings()
augroup END

fu! s:emmet_set_mappings() abort
    " The default mappings are global and not silent.
    " We prefer to install them locally, and make them silent.

    " Where did you find all the `{rhs}`?{{{
    "
    "     :h emmet-customize-key-mappings
    "}}}
    " Why `C-g C-u` instead of simply `C-g u`? {{{
    "
    " To  avoid a  conflict with  the default  `C-g u`  command (:h  i^gu) which
    " breaks the undo sequence.
    "}}}
    " Same question for `C-g C-[jkm]`.{{{
    "
    " To  avoid a  conflict with  our custom mappings:
    "
    "     C-g j    scroll window downward
    "     C-g k    scroll window upward
    "     C-g m    :FzMaps
    "}}}

    imap  <buffer><nowait><silent>  <c-g>,      <plug>(emmet-expand-abbr)
    imap  <buffer><nowait><silent>  <c-g>;      <plug>(emmet-expand-word)
    imap  <buffer><nowait><silent>  <c-g><c-u>  <plug>(emmet-update-tag)
    " mnemonics: `s` for select
    imap  <buffer><nowait><silent>  <c-g>s      <plug>(emmet-balance-tag-inward)
    imap  <buffer><nowait><silent>  <c-g>S      <plug>(emmet-balance-tag-outword)
    "                                                                        ^ necessary typo
    imap  <buffer><nowait><silent>  <c-g>n      <plug>(emmet-move-next)
    imap  <buffer><nowait><silent>  <c-g>N      <plug>(emmet-move-prev)
    imap  <buffer><nowait><silent>  <c-g>i      <plug>(emmet-image-size)
    imap  <buffer><nowait><silent>  <c-g>/      <plug>(emmet-toggle-comment)
    imap  <buffer><nowait><silent>  <c-g><c-j>  <plug>(emmet-split-join-tag)
    imap  <buffer><nowait><silent>  <c-g><c-k>  <plug>(emmet-remove-tag)
    imap  <buffer><nowait><silent>  <c-g>a      <plug>(emmet-anchorize-url)
    imap  <buffer><nowait><silent>  <c-g>A      <plug>(emmet-anchorize-summary)

    xmap  <buffer><nowait><silent>  <c-g>,      <plug>(emmet-expand-abbr)
    xmap  <buffer><nowait><silent>  <c-g>;      <plug>(emmet-expand-word)
    xmap  <buffer><nowait><silent>  <c-g><c-u>  <plug>(emmet-update-tag)
    xmap  <buffer><nowait><silent>  <c-g>s      <plug>(emmet-balance-tag-inward)
    xmap  <buffer><nowait><silent>  <c-g>S      <plug>(emmet-balance-tag-outword)
    xmap  <buffer><nowait><silent>  <c-g>n      <plug>(emmet-move-next)
    xmap  <buffer><nowait><silent>  <c-g>N      <plug>(emmet-move-prev)
    xmap  <buffer><nowait><silent>  <c-g>i      <plug>(emmet-image-size)
    xmap  <buffer><nowait><silent>  <c-g>/      <plug>(emmet-toggle-comment)
    xmap  <buffer><nowait><silent>  <c-g><c-j>  <plug>(emmet-split-join-tag)
    xmap  <buffer><nowait><silent>  <c-g><c-k>  <plug>(emmet-remove-tag)
    xmap  <buffer><nowait><silent>  <c-g>a      <plug>(emmet-anchorize-url)
    xmap  <buffer><nowait><silent>  <c-g>A      <plug>(emmet-anchorize-summary)

    " These 2 mappings are specific to visual mode.
    xmap  <buffer><nowait><silent>  <c-g><c-m>  <plug>(emmet-merge-lines)
    xmap  <buffer><nowait><silent>  <c-g>p      <plug>(emmet-code-pretty)

    " Now, you also need to install the `<plug>` mappings.
    EmmetInstall
    " Would this work if I lazy-loaded emmet?{{{
    "
    " No.
    "
    " Its interface would not be installed until we read an html or css file.
    " So, the  first time  we would  read an html  or css  file, `:EmmetInstall`
    " would  not exist,  and we  couldn't use  it here  to install  the `<plug>`
    " mappings.
    "}}}
    " Would there be solutions?{{{
    "
    " You could execute `:EmmetInstall` from a filetype plugin:
    "
    "     if exists(':EmmetInstall') ==# 2
    "         EmmetInstall
    "     endif
    "
    " When a  filetype plugin is sourced,  it seems the interface  of the plugin
    " would  be finally  installed (contrary  to  when the  current function  is
    " sourced).
    " Or you could install a fire-once autocmd to slightly delay the execution
    " of `:EmmetInstall`:
    "
    "     augroup my_emmet_install
    "         au!
    "         au BufWinEnter * if index(['html', 'css'], &ft) >= 0 | EmmetInstall | endif
    "         \ | exe 'au! my_emmet_install' | aug! my_emmet_install
    "     augroup END
    "}}}
    " Why don't you lazy-load emmet?{{{
    "
    " emmet starts already  quickly (less than a fifth  of millisecond), because
    " the core of its code is autoloaded.
    "
    " Besides, we would need to write the same code in different filetype plugins
    " (violate DRY, DIE).
    "
    " Finally, we've had enough issues with lazy-loading in the past.
    " I prefer to avoid it as much as possible now.
    " It's a hack anyway, and you should use  it only as a last resort, and only
    " if the plugin is slow to start because it hasn't been autoloaded:
    "
    "     “Premature optimization is the root of all evil.“
    "}}}

    " I haven't been able to update `b:undo_ftplugin` from here ...
endfu

