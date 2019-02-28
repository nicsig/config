" Purpose:{{{
"
" If a commented code block precedes  an uncommented line, the latter is wrongly
" highlighted as a comment.
"
" MWE:
"
"     $ cat <<'EOF' >/tmp/tmux.conf
"     #     x
"     set -s default-terminal tmux-256color
"     EOF
"
"     :syn clear
"     :syn region tmuxComment start=/#/ end=/$/
"     :syn region tmuxCommentCodeBlock matchgroup=Comment start=/# \{5,}/ end=/$/ keepend contained containedin=tmuxComment oneline
"
" Explanation:
"
" The tmux syntax plugin defines a comment like this:
"
"     syn region tmuxComment start=/#/ skip=/\\\@<!\\$/ end=/$/ contains=tmuxTodo
"
" We customize the comments by defining `tmuxCommentCodeBlock`.
"
"     syn region tmuxCommentCodeBlock matchgroup=Comment start=/# \{5,}/ end=/$/
"     \ keepend contained containedin=tmuxComment oneline
"
" The  latter consumes  the  end of  the `tmuxComment`  region,  which makes  it
" continue on the next line.
"
" Solution:
" Redefine `tmuxComment` and give it the `keepend` attribute.
"}}}
let s:comment = matchstr(execute('syn list tmuxComment'), '\m\Cxxx\%(\s\+match\)\=\zs.*[^ \n]\ze\_s*links')
syn clear tmuxComment
exe 'syn region tmuxComment ' . s:comment . ' keepend'
unlet! s:comment

