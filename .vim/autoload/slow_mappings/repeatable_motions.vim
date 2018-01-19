if !has_key(get(g:, 'plugs', {}), 'vim-lg-lib')
    finish
endif

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

" Why `:noremap` instead of `:nno`?{{{
"
" To also support visual mode + operator pending mode.
"}}}
" Why no `<unique>` for `,` and `;`?{{{
"
" Because `vim-sneak` has already remapped them.
" `<unique>` would prevent our needed custom mappings to overwrite
" the old definition.
"}}}
noremap  <expr>            ,  lg#motion#repeatable#main#move_again(1,'bwd')
noremap  <expr>            ;  lg#motion#repeatable#main#move_again(1,'fwd')

noremap  <expr><unique>   z,  lg#motion#repeatable#main#move_again(2,'bwd')
noremap  <expr><unique>   z;  lg#motion#repeatable#main#move_again(2,'fwd')
noremap  <expr><unique>   +,  lg#motion#repeatable#main#move_again(3,'bwd')
noremap  <expr><unique>   +;  lg#motion#repeatable#main#move_again(3,'fwd')
nno      <expr><unique>  co,  lg#motion#repeatable#main#move_again(4,'bwd')
nno      <expr><unique>  co;  lg#motion#repeatable#main#move_again(4,'fwd')

noremap  <expr><unique>  t   lg#motion#repeatable#main#fts('t')
noremap  <expr><unique>  T   lg#motion#repeatable#main#fts('T')
noremap  <expr><unique>  f   lg#motion#repeatable#main#fts('f')
noremap  <expr><unique>  F   lg#motion#repeatable#main#fts('F')
noremap  <expr><unique>  ss  lg#motion#repeatable#main#fts('s')
noremap  <expr><unique>  SS  lg#motion#repeatable#main#fts('S')

nnoremap  <expr>  <plug>(z_semicolon)     lg#motion#repeatable#main#move_again(2,'fwd')
nnoremap  <expr>  <plug>(z_comma)         lg#motion#repeatable#main#move_again(2,'bwd')
nnoremap  <expr>  <plug>(plus_semicolon)  lg#motion#repeatable#main#move_again(3,'fwd')
nnoremap  <expr>  <plug>(plus_comma)      lg#motion#repeatable#main#move_again(3,'bwd')
nno      <expr>  <plug>(co_semicolon)     lg#motion#repeatable#main#move_again(4,'fwd')
nno      <expr>  <plug>(co_comma)         lg#motion#repeatable#main#move_again(4,'bwd')

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
" Don't invoke `lg#motion#repeatable#main#make_repeatable()` for a custom motion
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

" cycle through help topics relevant for last errors
" we don't have a pair of motions to move in 2 directions,
" so I just repeat the same keys for 'bwd' and 'fwd'
call lg#motion#repeatable#main#make_repeatable({
\        'mode':    'n',
\        'buffer':  0,
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [{'bwd': '-e',  'fwd': '-e',  'axis': 2}]
\ })

" resize window
call lg#motion#repeatable#main#make_repeatable({
\        'mode':    'n',
\        'buffer':  0,
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': 'Z<c-h>',  'fwd': 'Z<c-l>',  'axis': 2 },
\                     { 'bwd': 'Z<c-k>',  'fwd': 'Z<c-j>',  'axis': 2 },
\                   ]
\ })

" built-in motions
call lg#motion#repeatable#main#make_repeatable({
\        'mode':    '',
\        'buffer':  0,
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': 'F' ,  'fwd': 'f' ,  'axis': 1 },
\                     { 'bwd': 'T' ,  'fwd': 't' ,  'axis': 1 },
\                     { 'bwd': 'SS',  'fwd': 'ss',  'axis': 1 },
\                     { 'bwd': 'g,',  'fwd': 'g;',  'axis': 1 },
\                     { 'bwd': 'g%',  'fwd': '%' ,  'axis': 1 },
\                     { 'bwd': "['",  'fwd': "]'",  'axis': 1 },
\                     { 'bwd': '["',  'fwd': ']"',  'axis': 1 },
\                     { 'bwd': '[#',  'fwd': ']#',  'axis': 1 },
\                     { 'bwd': '[(',  'fwd': '])',  'axis': 1 },
\                     { 'bwd': '[*',  'fwd': ']*',  'axis': 1 },
\                     { 'bwd': '[/',  'fwd': ']/',  'axis': 1 },
\                     { 'bwd': '[@',  'fwd': ']@',  'axis': 1 },
\                     { 'bwd': '[M',  'fwd': ']M',  'axis': 1 },
\                     { 'bwd': '[S',  'fwd': ']S',  'axis': 1 },
\                     { 'bwd': '[[',  'fwd': ']]',  'axis': 1 },
\                     { 'bwd': '[]',  'fwd': '][',  'axis': 1 },
\                     { 'bwd': '[`',  'fwd': ']`',  'axis': 1 },
\                     { 'bwd': '[c',  'fwd': ']c',  'axis': 1 },
\                     { 'bwd': '[m',  'fwd': ']m',  'axis': 1 },
\                     { 'bwd': '[s',  'fwd': ']s',  'axis': 1 },
\                     { 'bwd': '[{',  'fwd': ']}',  'axis': 1 },
\                   ],
\ })

" custom motions
call lg#motion#repeatable#main#make_repeatable({
\        'mode':    'n',
\        'buffer':  0,
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[<c-l>',  'fwd': ']<c-l>',  'axis': 2 },
\                     { 'bwd': '[<c-q>',  'fwd': ']<c-q>',  'axis': 2 },
\                     { 'bwd': '[Z'    ,  'fwd': ']Z'    ,  'axis': 1 },
\                     { 'bwd': '[z'    ,  'fwd': ']z'    ,  'axis': 1 },
\                     { 'bwd': '[a'    ,  'fwd': ']a'    ,  'axis': 2 },
\                     { 'bwd': '[b'    ,  'fwd': ']b'    ,  'axis': 2 },
\                     { 'bwd': '[e'    ,  'fwd': ']e'    ,  'axis': 3 },
\                     { 'bwd': '[f'    ,  'fwd': ']f'    ,  'axis': 2 },
\                     { 'bwd': '[h'    ,  'fwd': ']h'    ,  'axis': 1 },
\                     { 'bwd': '[l'    ,  'fwd': ']l'    ,  'axis': 1 },
\                     { 'bwd': '[q'    ,  'fwd': ']q'    ,  'axis': 2 },
\                     { 'bwd': '[t'    ,  'fwd': ']t'    ,  'axis': 2 },
\                     { 'bwd': '[u'    ,  'fwd': ']u'    ,  'axis': 1 },
\                  ]
\ })

" toggle settings
call lg#motion#repeatable#main#make_repeatable({
\        'mode':    'n',
\        'buffer':  0,
\        'from':    expand('<sfile>:p').':'.expand('<slnum>'),
\        'motions': [
\                     { 'bwd': '[oB',  'fwd': ']oB',  'axis': 4, },
\                     { 'bwd': '[oC',  'fwd': ']oC',  'axis': 4, },
\                     { 'bwd': '[oD',  'fwd': ']oD',  'axis': 4, },
\                     { 'bwd': '[oH',  'fwd': ']oH',  'axis': 4, },
\                     { 'bwd': '[oI',  'fwd': ']oI',  'axis': 4, },
\                     { 'bwd': '[oL',  'fwd': ']oL',  'axis': 4, },
\                     { 'bwd': '[oN',  'fwd': ']oN',  'axis': 4, },
\                     { 'bwd': '[oS',  'fwd': ']oS',  'axis': 4, },
\                     { 'bwd': '[oW',  'fwd': ']oW',  'axis': 4, },
\                     { 'bwd': '[oc',  'fwd': ']oc',  'axis': 4, },
\                     { 'bwd': '[od',  'fwd': ']od',  'axis': 4, },
\                     { 'bwd': '[of',  'fwd': ']of',  'axis': 4, },
\                     { 'bwd': '[og',  'fwd': ']og',  'axis': 4, },
\                     { 'bwd': '[oh',  'fwd': ']oh',  'axis': 4, },
\                     { 'bwd': '[oi',  'fwd': ']oi',  'axis': 4, },
\                     { 'bwd': '[ol',  'fwd': ']ol',  'axis': 4, },
\                     { 'bwd': '[on',  'fwd': ']on',  'axis': 4, },
\                     { 'bwd': '[oo',  'fwd': ']oo',  'axis': 4, },
\                     { 'bwd': '[op',  'fwd': ']op',  'axis': 4, },
\                     { 'bwd': '[oq',  'fwd': ']oq',  'axis': 4, },
\                     { 'bwd': '[os',  'fwd': ']os',  'axis': 4, },
\                     { 'bwd': '[ot',  'fwd': ']ot',  'axis': 4, },
\                     { 'bwd': '[ov',  'fwd': ']ov',  'axis': 4, },
\                     { 'bwd': '[ow',  'fwd': ']ow',  'axis': 4, },
\                     { 'bwd': '[oy',  'fwd': ']oy',  'axis': 4, },
\                     { 'bwd': '[oz',  'fwd': ']oz',  'axis': 4, },
\                   ]
\ })
