if exists('g:loaded_matchup') || stridx(&rtp, 'vim-matchup') == -1
    finish
endif

" disable the matchparen module when Vim starts up
let g:matchup_matchparen_enabled = 0

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

" disable the matchparen module in insert and visual mode
let g:matchup_matchparen_nomode = "ivV\<c-v>"

