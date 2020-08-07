" Options {{{1

" If you have issues with indentation, read:{{{
"
"     :h html-indent
"     https://www.reddit.com/r/vim/comments/7h2zx4/help_with_html_indentation/dqnp1jp/
"
" And maybe try to add this in your vimrc:
"
"     let g:html_indent_script1 = 'inc'
"     let g:html_indent_style1 = 'inc'
"     let g:html_indent_inctags = 'html,body,head,tbody,p,li,dd,dt,h1,h2,h3,h4,h5,h6,blockquote,section'
"}}}

setl fp=js-beautify\ --html

" google style guide
setl sw=2

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| setl sw< | set fp<'

