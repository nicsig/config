let current_compiler = 'pandoc'

" Old Vim versions don't automatically define `:CompilerSet`.
if exists(':CompilerSet') != 2
    com -nargs=* CompilerSet setl <args>
endif

" TODO: I'm not sure you can set 'efm' correctly.{{{
"
" When  an  error  occurs, the  message  comes  from  LaTeX  which works  on  an
" intermediate  file  (≈ contents  of  the  markdown  file  written in  a  LaTeX
" document).
" As a  result, the line  error doesn't match the  one in the  original markdown
" file.
"}}}
" CompilerSet efm=

" Where could I add `--`?{{{
"
" Right in front of `%:p:S`.
"}}}
" Why would I do it?{{{
"
" To avoid an error in case the filename begins with a hyphen.
"}}}
" Why don't you do it then?{{{
"
" There's no need to.
" We use `:p` which makes the filepath absolute, and thus begin with a `/`.
"}}}
CompilerSet mp=pandoc
    \\ -N
    \\ --pdf-engine=xelatex
    \\ --variable\ mainfont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ sansfont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ monofont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ fontsize=12pt
    \\ --toc
    \\ -o\ %:p:r:S.pdf
    \\ %:p:S

