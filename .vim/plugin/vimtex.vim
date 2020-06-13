" Why no `g:loaded_vimtex`?{{{
"
" vimtex is (similar to) a filetype plugin.
" It doesn't  have a `plugin/` directory,  and it doesn't set  a global variable
" when Vim starts up.
"}}}
if stridx(&rtp, 'vimtex') == -1
    finish
endif

" TODO: When we `:Rename` a tex file, vimtex complains with:{{{
"
"     vimtex: "syntax on" seems to be applied before "filetype plugin on".~
"     This is suboptimal, because some syntax features require an initialized state.~
"     Please see ":help vimtex_syntax_filetype".~
"
" You can reproduce the message by running `:filetype detect on`.
" Is sth broken after running `:Rename`/`:filetype detect on`?
" Or can we ignore the message?
"}}}

" Compiler {{{1

" What's `latexmk`?{{{
"
" To compile a LaTeX document, you need a LaTeX compiler backend.
" See `:h vimtex-compiler`.
"
" `latexmk` is one of them.
" It's included in the texlive distribution:
"
"     $ ls -l ~/texlive/2018/bin/x86_64-linux/latexmk
"     lrwxrwxrwx 1 .. latexmk -> ../../texmf-dist/scripts/latexmk/latexmk.pl~
"
" ---
"
" Alternatively, you can download it and read its documentation at:
" http://personal.psu.edu/jcc8//software/latexmk-jcc/
"
" Once the script is downloaded, move it in `~/bin`.
" Rename it into `latexmk` (i.e. remove `.pl`), or update the value of the
" `executable` key in `g:vimtex_compiler_latexmk`.
"}}}
" What's the purpose of `g:vimtex_compiler_latexmk`?{{{
"
" We can configure `latexmk.pl` via `g:vimtex_compiler_latexmk`.
" The default value of this option can be found at
" `:h g:vimtex_compiler_latexmk`.
"}}}
" How do we configure it?{{{
"
" We tweak it so that:
"
"    - the 'backend' key uses Vim jobs
"    - the 'executable' key matches the right name of the script
"}}}

let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \      '-pdf',
    \      '-verbose',
    \      '-file-line-error',
    \      '-synctex=1',
    \      '-interaction=nonstopmode',
    \ ],
    \ }

" Mappings {{{1

" Why?{{{
"
" vimtex installs some mappings in insert mode to ease the insertion
" of mathematical commands like `\emptyset`.
" By default, they all use the prefix  backtick, which is annoying because I use
" the latter frequently inside comments.
" So, to avoid the  timeout when we want to insert a backtick,  we use the tilde
" as a prefix.
"
" If you want to test this feature, INSIDE a math environment:
"
"     \begin{displaymath}
"     \end{displaymath}
"
" ... insert `~0`, it should be replaced with `\emptyset`.
"
" For more info, see:    :h vimtex-imaps
" And:                   :VimtexImapsList
"}}}
let g:vimtex_imaps_leader = '~'

" Quickfix window {{{1

" Never open the qf window automatically.
" Why?{{{
"
" It can quickly become annoying when you have a minor error you can't fix.
" Every time you update the file with continuous compilations, the qf window
" will be re-opened.
"}}}
" MWE:{{{
"
"     $ cat /tmp/vimrc
"
"         set rtp^=~/.vim/plugged/vimtex/
"         so $HOME/.vim/after/plugin/vimtex.vim
"         filetype plugin indent on
"
"     $ cat /tmp/file.tex
"
"         \documentclass{article}
"         \begin{document}
"         \wrong_command
"         \end{document}
"
"     $ vim -Nu /tmp/vimrc
"
"         :e /tmp/file.tex
"         :VimtexCompileSS
"}}}
let g:vimtex_quickfix_mode = 0
let g:vimtex_quickfix_open_on_warning = 0

" Miscellaneous {{{1

" Why?{{{
"
" Depending on the contents of a `.tex` file, Vim may set the filetype to:
"
"    - plain
"    - context
"    - tex
"
" I want 'tex' no matter what.
" See: ft-tex-plugin
"}}}
let g:tex_flavor = 'latex'

" Vimtex ships with an improved version of `matchparen`.
" I don't want it; I prefer to  use the `matchparen` module of match-up, because
" its matching engine is more advanced (`:h matchup-interoperability /advanced`).
let g:vimtex_matchparen_enabled = 0

