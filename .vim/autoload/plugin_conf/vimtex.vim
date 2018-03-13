" VimtexImapsList
let g:vimtex_imaps_leader = '~'

" Vimtex ships with an improved version of `matchparen`.
" I don't want it.

let g:vimtex_matchparen_enabled = 0

" To compile a LaTeX document, you need a LaTeX compiler backend.
" See `:h vimtex-compiler`.
"
" latexmk.pl is one of them.
" You can download it and read its documentation at:
"
"     http://personal.psu.edu/jcc8//software/latexmk-jcc/
"
" Once the script is downloaded, move it in ~/bin.
"
" We can configure it via `g:vimtex_compiler_latexmk`.
" The default value of this option can be found at
" `:h g:vimtex_compiler_latexmk`.
"
" We tweak it so that:
"
"     • the 'backend' key uses Vim's or Neovim's jobs
"     • the 'executable' key matches the right name of the script
let g:vimtex_compiler_latexmk = {
    \ 'backend' : has('nvim') ? 'nvim' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk.pl',
    \ 'options' : [
    \      '-pdf',
    \      '-verbose',
    \      '-file-line-error',
    \      '-synctex=1',
    \      '-interaction=nonstopmode',
    \ ],
    \}

" Depending on the contents of a `.tex` file, Vim may set the filetype to:
"
"     • plain
"     • context
"     • latex
"
" I want 'latex' no matter what.
" See: ft-tex-plugin
let g:tex_flavor = 'latex'

