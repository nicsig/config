" The default indentation is wrong:{{{
"
"     /pat/{
"     s/foo/bar/
"     s/foo/bar/
"     }
"
"     =ip →
"
"     /pat/{
"         s/foo/bar/
"             s/foo/bar/
"     }
"
" Since `'indentexpr'`  and `'equalprg'` are empty  in a sed buffer  by default,
" Vim uses the internal formatting function (`:h C-indenting`).
" I don't know how to configure it yet.
" So I leverage the Awk indenting function, which, for the moment, seems to do a
" good job.
"}}}
setl inde=GetAwkIndent()

" Teardown {{{1

let b:undo_indent = get(b:, 'undo_indent', 'exe')
    \ .. '| setl indk<'

