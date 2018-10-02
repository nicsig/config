" TODO:{{{
" Find a way to remove the built-in command `:Print`.
" From `:h :Print`:
"
"         Just as ":print".  Was apparently added to Vi for
"         people that keep the shift key pressed too long...
"}}}

" vim-exchange {{{1
"
" They allow you to remove an existing  highligting created by the plugin, or to
" enable/disable/toggle the  mode which  controls whether the  plugin highlights
" the text on which we operate.

" Why the check?{{{
"
" To avoid polluting `v:errmsg` when Vim starts up.
" `v:errmsg` can be useful when we're debugging.
"}}}
if exists(':XchangeClear') == 2
    sil! delc XchangeClear
    sil! delc XchangeHighlightDisable
    sil! delc XchangeHighlightEnable
    sil! delc XchangeHighlightToggle
endif

" LogiPat {{{1

" Here are all the commands installed by the LogiPat plugin:
"
"   LP              *    call   LogiPat(<q-args>,1)
"   LPE             +    echom  LogiPat(<q-args>)
"   LPF             +    let  s:LogiPatFlags = "<args>"
"   LPR             *    call   LogiPat(<q-args>,1,"r")
"   LogiPat         *    call   LogiPat(<q-args>,1)
"   LogiPatFlags    +    let  s:LogiPatFlags = "<args>"
"
" We're going to remove all of them.
" And install just one at the end, to get back the most interesting one:
"
"         :LogiPatEcho
"
" But with a shorter name `:LogiPat`.
"
" :LP is a shorthand command version of :LogiPat
sil! delc LP

sil! delc LPE

" :LPF is a shorthand version of :LogiPatFlags.
sil! delc LPF

" `:LPR` is not documented in `:h logipat`.{{{
"
" Here's how it's defined:
"
"         LPR    *    call   LogiPat(<q-args>,1,"r")
"
" The only thing which is unique to this command, compared to the others,
" is the third optional argument 'r'.
" But it's not even used by `LogiPat()`:
"
"         $VIMRUNTIME/plugin/logiPat.vim:61
"}}}
sil! delc LPR

sil! delc LogiPatFlags

com! -nargs=+  LogiPat  echomsg LogiPat(<q-args>)

" man.vim {{{1
"
" The default man.vim plugin installs a useless `:MANPAGER` command:
"
"     $VIMRUNTIME/plugin/manpager.vim:5
"
" It pollutes tab completion on the command-line.
sil! delc MANPAGER

