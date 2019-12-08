if exists('g:loaded_matchup') || stridx(&rtp, 'vim-matchup') == -1
    finish
endif

" Options {{{1
" Global {{{2
" matchparen module {{{3

" disable the matchparen module when Vim starts up
let g:matchup_matchparen_enabled = 0
" make sure there are always autocmds listening to some events
if ! g:matchup_matchparen_enabled
    call plugin#matchparen#install_dummy_autocmds()
endif

" Improves performance when moving with `hjkl`.{{{
"
" Deferred highlighting improves cursor  movement performance (for example, when
" using `hjkl`) by delaying highlighting for a  short time and waiting to see if
" the cursor continues moving.
"
" Without,  when you  move over  a match  (e.g. `return`  inside a  function) by
" keeping `h`  or `l` pressed,  the cursor  temporarily disappears, and  I think
" that the cpu consumption goes up.
"}}}
let g:matchup_matchparen_deferred = 1

" disable the matchparen module in insert and visual mode
let g:matchup_matchparen_nomode = "ivV\<c-v>"

" display an offscreen match in a popup window
let g:matchup_matchparen_offscreen = {'method': 'popup'}
" What are the benefits of the value `popup` compared to `status`?{{{
"
" In what follows, let's assume that  you've enabled the matchparen module, your
" cursor is on an  "open" word (e.g. `if`), and the  "close" word (e.g. `endif`)
" is not visible on the screen.
"
" Because of the value `status`, the whole  contents of the status line is lost;
" it's replaced with the close word, while the remaining part of the status line
" is syntax highlighted exactly as the matching line in the buffer.  All of this
" is jarring.
"
" Besides, there is a risk of flickering.
" Although, you can mitigate it by setting the `scrolloff` key:
"
"     let g:matchup_matchparen_offscreen = {'method': 'popup', 'scrolloff': 1}
"                                                              ^^^^^^^^^^^^^^
"
" Finally, the status line position is *fixed*;  so you have to look for the `Δ`
" symbol to  know whether the open/mid/close  word is above or  below the cursor
" line.
" Whereas the popup window position is *dynamic*; it's displayed above/below the
" cursor line, depending on where the match  is; so there's no cognitive load to
" understand whether a match is above or below the cursor line.
"}}}
" I don't want to see any offscreen match.  No popup window, and nothing in my status line!{{{
"
" Assign an empty dictionary:
"
"     let g:matchup_matchparen_offscreen = {}
"}}}

" misc. {{{3

" do not match words like `for` and `end` in strings and comments,
" but *do* match symbols like `()` (set it to 2 for nothing to be matched)
let g:matchup_delim_noskips = 1

" if I change a word, change matching words in parallel
let g:matchup_transmute_enabled = 1
" For example:{{{
"
" In an html file:
"
"     <pre>
"       text
"     </pre>
"
" Changing `<pre>` to `<div>` should produce:
"
"     <div>
"       text
"     </div>
"       ^^^
"      changed automatically (in parallel)
"}}}
" It doesn't work!{{{
"
" The matchparen module must be enabled.
"
" ---
"
" It only works if  the change was done from insert  mode (this includes replace
" mode –  which technically is  a submode of insert  mode – entered  from normal
" mode *or* from visual mode).
"
" ---
"
" `b:match_words` must contain a description of  the matching words, and it must
" contain a backref relation like `\1`.
"
" For example, for html tags, you could include this:
"
"     <\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>
"                                        │      ├┘
"                                        │      └ backref
"                                        └ separator between opening tag and closing word
"
" Note that this value is already assigned from the default html plugin:
"
"     $VIMRUNTIME/ftplugin/html.vim:34
"}}}
"}}}1
" Local {{{2

augroup my_matchup
    au!
    au FileType * call s:set_buffer_local_options()
augroup END

fu s:set_buffer_local_options() abort
    setl mps+=“:”,‘:’
    " Rationale:{{{
    "
    " If `{:}` is in `'mps'`, then, if:
    "
    "    - the matchparen module of the `vim-matchup` plugin is enabled
    "    - you move the cursor on an opening marker
    "    - the closing fold marker is offscreen
    "
    " The closing fold marker is displayed in a popup window or in the status line.
    " I don't want that.
    "
    " Solution:
    "
    " We remove `{:}` from `'mps'`, and include a pair of regexes in `b:match_words`,
    " using negative lookarounds to prevent a match in a fold marker:
    "
    "     {\@1<!{{\@!:}\@1<!}}\@!
    "                ^
    "                delimiter
    "}}}
    setl mps-={:}
    " We  want the  keywords to  be searched  exactly as  we've written  them in
    " `b:match_words`, no matter the value of `&ic`.
    let b:match_ignorecase = 0
    if exists('b:match_words')
        let b:match_words ..= ',{\@1<!{{\@!:}\@1<!}}\@!'
    endif
    " Why don't you set `b:undo_ftplugin`?{{{
    "
    " So, you're thinking about sth like this:
    "
    "     let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')..'| setl mps< | unlet! b:match_ignorecase b:match_words'
    "
    " It would make sense  if we set them for *some* filetypes  only; but we set
    " them for *all* filetypes, so setting `b:undo_ftplugin` is useless.
    "}}}
endfu

