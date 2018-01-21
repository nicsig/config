if !has_key(get(g:, 'plugs', {}), 'vim-lg-lib')
    finish
endif

" after/ftplugin/vim-plug.vim
" autoload/slow_mappings/repeatable_motions.vim
" plugged/vim-help/after/ftplugin/help.vim
" plugged/vim-lg-lib/autoload/lg/motion/repeatable/main.vim
" plugged/vim-man/ftplugin/man.vim
" plugged/vim-markdown/ftplugin/markdown.vim
" plugged/vim-vim/after/ftplugin/vim.vim

" Alternative:{{{
"
"     sil verb runtime autoload/lg/motion/main.vim
"     if v:errmsg ==# 'not found in ''runtimepath'': "autoload/lg/motion/main.vim"'
"         finish
"     endif
"}}}

" Command to get info about the db {{{1

com!  -nargs=?  -complete=custom,lg#motion#repeatable#listing#complete
\     ListRepeatableMotions
\     call lg#motion#repeatable#listing#main(<q-args>)

" Mappings to repeat motions (; …) {{{1

noremap  <expr><unique>  t   lg#motion#repeatable#main#fts('t')
noremap  <expr><unique>  T   lg#motion#repeatable#main#fts('T')
noremap  <expr><unique>  f   lg#motion#repeatable#main#fts('f')
noremap  <expr><unique>  F   lg#motion#repeatable#main#fts('F')
noremap  <expr><unique>  ss  lg#motion#repeatable#main#fts('s')
noremap  <expr><unique>  SS  lg#motion#repeatable#main#fts('S')

nnoremap  <expr>  <plug>(z_semicolon)     lg#motion#repeatable#main#move_again('z, z;','fwd')
nnoremap  <expr>  <plug>(z_comma)         lg#motion#repeatable#main#move_again('z, z;','bwd')
nnoremap  <expr>  <plug>(plus_semicolon)  lg#motion#repeatable#main#move_again('+, +;','fwd')
nnoremap  <expr>  <plug>(plus_comma)      lg#motion#repeatable#main#move_again('+, +;','bwd')
nno       <expr>  <plug>(co_semicolon)    lg#motion#repeatable#main#move_again('co, co;','fwd')
nno       <expr>  <plug>(co_comma)        lg#motion#repeatable#main#move_again('co, co;','bwd')

" Make motions repeatable {{{1

" Rule: Use the same mode in a function call than the the one of the original motion{{{
"
" The mode you give to the function  which makes a motion repeatable must be
" EXACTLY the same as the original one.
"
" In particular, don't use '' if your motion is defined in normal mode.
" Yes `nvo` includes `n`, but it doesn't matter:  n != nvo
"
" If you don't respect this rule, you will break the motion, because the wrapper
" installed around it will fail to retrieve it from the db (wrong mode).
"
" Use '' only for a motion defined explicitly with `:noremap` or `:map`.
"}}}
" Rule: For a motion to be made repeatable, it must ALREADY be defined.{{{
"
" Don't invoke `lg#motion#repeatable#main#make()` for a custom motion
" which you're not sure whether it has been defined, or will be later.
"
" Indeed, the function needs to save all the information relative to the
" original motion in a database.
"}}}
" Why making motions repeatable in this file?{{{
"
"     1. We source it AFTER Vim has started, so all plugins have been
"        sourced and any custom motion has already been defined.
"        We can be sure we're respecting the previous rule.
"
"     2. The process can be slow. This file allows us to delay it
"        until Vim has started, and to keep a short startup time.
"}}}

" TODO:
" Shouldn't we move the 'mode' and 'buffer' key in each motion?
" Pro:
" We would only need 1 invocation of the function.
" Con:
" We would have a fucking big dictionary as argument.
" Also, we would need to change the code of the function.
" Would it be complex?

" cycle through help topics relevant for last errors
" we don't have a pair of motions to move in 2 directions,
" so I just repeat the same keys for 'bwd' and 'fwd'
call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis': ['z,', 'z;'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [{'bwd': '-e',  'fwd': '-e'}]
\ })

" resize window
call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis': ['z,', 'z;'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': 'Z<c-h>',  'fwd': 'Z<c-l>' },
\                     { 'bwd': 'Z<c-k>',  'fwd': 'Z<c-j>' },
\                   ]
\ })

" built-in motions
call lg#motion#repeatable#main#make({
\        'mode':    '',
\        'buffer':  0,
\        'axis': [',', ';'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': 'F' ,  'fwd': 'f'  },
\                     { 'bwd': 'T' ,  'fwd': 't'  },
\                     { 'bwd': 'SS',  'fwd': 'ss' },
\                     { 'bwd': 'g,',  'fwd': 'g;' },
\                     { 'bwd': 'g%',  'fwd': '%'  },
\                     { 'bwd': "['",  'fwd': "]'" },
\                     { 'bwd': '["',  'fwd': ']"' },
\                     { 'bwd': '[#',  'fwd': ']#' },
\                     { 'bwd': '[(',  'fwd': '])' },
\                     { 'bwd': '[*',  'fwd': ']*' },
\                     { 'bwd': '[/',  'fwd': ']/' },
\                     { 'bwd': '[@',  'fwd': ']@' },
\                     { 'bwd': '[M',  'fwd': ']M' },
\                     { 'bwd': '[S',  'fwd': ']S' },
\                     { 'bwd': '[[',  'fwd': ']]' },
\                     { 'bwd': '[]',  'fwd': '][' },
\                     { 'bwd': '[`',  'fwd': ']`' },
\                     { 'bwd': '[c',  'fwd': ']c' },
\                     { 'bwd': '[m',  'fwd': ']m' },
\                     { 'bwd': '[s',  'fwd': ']s' },
\                     { 'bwd': '[{',  'fwd': ']}' },
\                   ],
\ })

" custom motions
call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis':  [',', ';'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[Z'    ,  'fwd': ']Z' },
\                     { 'bwd': '[z'    ,  'fwd': ']z' },
\                     { 'bwd': '[h'    ,  'fwd': ']h' },
\                     { 'bwd': '[l'    ,  'fwd': ']l' },
\                     { 'bwd': '[u'    ,  'fwd': ']u' },
\                  ]
\ })

call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis':  ['z,', 'z;'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[<c-l>',  'fwd': ']<c-l>' },
\                     { 'bwd': '[<c-q>',  'fwd': ']<c-q>' },
\                     { 'bwd': '[a'    ,  'fwd': ']a'     },
\                     { 'bwd': '[b'    ,  'fwd': ']b'     },
\                     { 'bwd': '[f'    ,  'fwd': ']f'     },
\                     { 'bwd': '[q'    ,  'fwd': ']q'     },
\                     { 'bwd': '[t'    ,  'fwd': ']t'     },
\                  ]
\ })

call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis':  ['+,', '+;'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[e', 'fwd': ']e'},
\                  ]
\ })

" toggle settings
call lg#motion#repeatable#main#make({
\        'mode':    'n',
\        'buffer':  0,
\        'axis':  ['co,', 'co;'],
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[oB',  'fwd': ']oB' },
\                     { 'bwd': '[oC',  'fwd': ']oC' },
\                     { 'bwd': '[oD',  'fwd': ']oD' },
\                     { 'bwd': '[oH',  'fwd': ']oH' },
\                     { 'bwd': '[oI',  'fwd': ']oI' },
\                     { 'bwd': '[oL',  'fwd': ']oL' },
\                     { 'bwd': '[oN',  'fwd': ']oN' },
\                     { 'bwd': '[oS',  'fwd': ']oS' },
\                     { 'bwd': '[oW',  'fwd': ']oW' },
\                     { 'bwd': '[oc',  'fwd': ']oc' },
\                     { 'bwd': '[od',  'fwd': ']od' },
\                     { 'bwd': '[of',  'fwd': ']of' },
\                     { 'bwd': '[og',  'fwd': ']og' },
\                     { 'bwd': '[oh',  'fwd': ']oh' },
\                     { 'bwd': '[oi',  'fwd': ']oi' },
\                     { 'bwd': '[ol',  'fwd': ']ol' },
\                     { 'bwd': '[on',  'fwd': ']on' },
\                     { 'bwd': '[oo',  'fwd': ']oo' },
\                     { 'bwd': '[op',  'fwd': ']op' },
\                     { 'bwd': '[oq',  'fwd': ']oq' },
\                     { 'bwd': '[os',  'fwd': ']os' },
\                     { 'bwd': '[ot',  'fwd': ']ot' },
\                     { 'bwd': '[ov',  'fwd': ']ov' },
\                     { 'bwd': '[ow',  'fwd': ']ow' },
\                     { 'bwd': '[oy',  'fwd': ']oy' },
\                     { 'bwd': '[oz',  'fwd': ']oz' },
\                   ]
\ })
