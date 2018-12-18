let current_compiler = 'pandoc'

" Old Vim versions don't automatically define `:CompilerSet`.
if exists(':CompilerSet') !=# 2
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
CompilerSet mp=pandoc\ --\ %:p:S
    \\ -N
    \\ --pdf-engine=xelatex
    \\ --variable\ mainfont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ sansfont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ monofont=\"DejaVu\ Sans\ Mono\"
    \\ --variable\ fontsize=12pt
    \\ --toc
    \\ -o\ %:p:r:S.pdf

