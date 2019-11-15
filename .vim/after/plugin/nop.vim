" Purpose:{{{
"
" Use this file to disable some keys.
" Use it to remove some undesirable mappings installed by other plugins.
"}}}
" Why should I disable keys in `~/.vim/after/plugin`, instead of `vimrc`?{{{
"
" Plugin authors often use `mapcheck()` to decide whether they can remap a key.
" And,  atm, `mapcheck()`  returns an  empty string  whether there's  no mapping
" conflicting  with `{name}`,  or  the  first conflicting  mapping  has the  rhs
" `<nop>`.
" Because of this confusion, if you need to disable a key, and you do it in your
" vimrc (`nno <key> <nop>`), there's a  chance that a plugin will overwrite your
" mapping, even if it tries to avoid it by invoking `mapcheck()`.
"
" This is what happens if you disable `s` (recommended by `vim-sandwich`).
" `vim-sneak` will still remap `s`:
"
"         https://github.com/vim/vim/issues/2940
"
" In fact, it depends on the order of installation of the mappings:
"
"     $ vim -Nu NONE +'nno s <nop>' +'nno sab de' +'echo mapcheck("s", "n") is# ""'
"     0~
"     ✔
"
"     $ vim -Nu NONE +'nno sab de' +'nno s <nop>' +'echo mapcheck("s", "n") is# ""'
"     1~
"     ✘
"
" Bottom_line:
" We should disable a key after all plugins have been sourced.
" It's more reliable.
"
" Update:
" This issue has been fixed:
"     https://github.com/vim/vim/commit/f88a5bc10232cc3fac92dba4e8455f4c14311f8e
"     https://github.com/neovim/neovim/commit/207cfce3dea64eca3b93735adfac0a75cc6c1a4a
"
" Still, disabling a key after the plugins have been sourced seems more reliable.
"}}}

" Various keys used as a prefix {{{1

fu s:cancel_prefix(prefixes) abort
    for pfx in a:prefixes
        " We may let the timeout elapse.
        " In this case, the key should have no effect.
        " This is probably the reason why `:h sandwich-keymappings`, recommends this:{{{
        "
        " NOTE: To prevent unintended operation, the following setting is strongly
        "       recommended to add to your vimrc.
        "
        "         nmap s <Nop>
        "         xmap s <Nop>
        "}}}
        exe 'nno '.pfx.' <nop>'
        exe 'xno '.pfx.' <nop>'
        " Are there other mappings to disable?{{{
        "
        " In the past I also disabled `pfx Esc`.
        "
        "     exe 'nno '.pfx.'<esc> <esc>'
        "     exe 'xno '.pfx.'<esc> <esc>'
        "
        " But it doesn't seem necessary.
        "
        " If you press a prefix key  then Escape, since there's no mapping using
        " `pfx Esc` as its lhs, and since it doesn't make any sense for Vim (for
        " example  it's  not  an  operator combined  with  a  text-object),  Vim
        " probably ignores the prefix, and only types Escape.
        "
        " Confirmed by:
        "
        "     :ino + <nop>
        "     :startinsert
        "     + Esc
        "     " you get back to normal mode (meaning that Vim has pressed escape)
        "}}}
    endfor
endfu
call s:cancel_prefix(['+', '-', '<space>', '<bar>', 'U', 's', 'S'])

" You've disabled `s` and `S`. What about `sS` and `Ss`?{{{
"
" Disabling those is useless.
"
" When  you press  `s` after  `S`, `S`  is automatically  canceled (look  at the
" command-line; 'showcmd'). Only `S` remains.
" If you  wait for the timeout,  our `nno S  <nop>` mapping will be  used, which
" will make sure nothing happens.
"}}}

" i_C-n {{{1

" Why do you disable keyword completion?{{{
"
" When I want to move the cursor backward with C-b, I suspect I hit C-n
" by accident instead. Very annoying (slow popup menu; breaks workflow).
" We can still use C-p though.
"}}}
ino <expr> <c-n> pumvisible() ? '<c-n>' : ''

" i_C-r_. {{{1

" Sometimes, when leaving insert mode and pressing `SPC p` to format the current
" paragraph, Vim inserts some random text.
" I'm probably pressing some wrong keys when I type too quickly.
" The random text seems to come from a register.
" It may be the dot register.

"     ino <c-r>. <nop>

" Update:
" Commented because it breaks the  repetition of things like `ctx hello` (change
" till `x`); probably because of these lines:
"
"     let change = a:op is? "c" ? "" : "\<c-r>.\<esc>"
"     silent! call repeat#set(a:op."\<Plug>SneakRepeat".sneak#util#strlen(a:input).a:reverse.a:inclusive.(2*!empty(target)).a:input.target.change, a:count)
"
" In:
"
"     ~/.vim/plugged/vim-sneak/plugin/sneak.vim:241

" C-z {{{1

" Don't suspend if I press C-z by accident from visual mode.
vno <c-z> <nop>

" Same thing in normal mode, because of some bugs:
" https://unix.stackexchange.com/questions/q/445051/289772
" https://unix.stackexchange.com/questions/q/445239/289772
nno <c-z> <nop>

" do  dp {{{1

" I often hit `do` and `dp` by accident, when in fact I only wanted to hit
" `o` or `p`.
" Anyway, `do` and `dp` are only useful in a buffer which is in diff mode.
nno <expr> do &l:diff ? 'do' : ''
nno <expr> dp &l:diff ? 'dp' : ''

" go Esc {{{1

" When we cancel `go` with Escape, Vim moves the cursor to the top of the
" buffer (1st byte, see `:h go`). Annoying.
nno go<esc> <nop>

" Uu {{{1

" I think we often press `Uu` by accident.
" When that happens, Vim undo our edits, which I don't want.
nno Uu <nop>

" {{{1
" Remove mappings {{{1
" \ {{{2

" Why?{{{
"
" By default, vim-sneak binds `\` to the same function which is bound to `,`:
"
"     repeat the previous `fx` or `sxy` motion
"
" It does this for normal, visual and operator-pending mode.
"
" I find  this annoying,  because when  I hit  the key  by accident,  the cursor
" jumps. Besides, we already have `,`.
"}}}
" Could I remove these lines in the future?{{{
"
" In theory yes.
" If you map something  to `\`, or use it as a prefix  to build several `{lhs}`,
" `vim-sneak` won't install the mappings mentioned earlier.
"
" But I recommend you leave `unmap \` here nonetheless.
" Atm, we essentially use `\` as a prefix in filetype plugins (which `vim-sneak`
" ignores).
" We only have a few global mappings using `\`.
" And you may remove them one day.
"}}}
if maparg('\') =~? '\csneak'
    unmap \
endif

" o_z  o_Z {{{2

" Why?{{{
"
" The  default mappings  installed by  `vim-sneak`  are too  inconsistent to  be
" memorized. They also conflict with `vim-sandwich`.
"}}}
" How to find the mappings installed by `vim-sneak` in{{{
" }}}
"   normal mode?{{{
"
"     put =filter(split(execute('nno'), '\n'), {_,v -> v =~? 'sneak' && v !~? '^n\s\+\%([ft,;]\\|<plug>\)'})
"
" We invoke `filter()` to ignore:
"
"    - the `<plug>` mappings (they can't be typed directly,
"      so they can't interfer in our work)
"
"    - [fFtT,;]
"      we ignore those because, contrary to  [sSzZ]  , they ARE consistent
"}}}
"   visual mode?{{{
"
"     put =filter(split(execute('xno'), '\n'), {_,v -> v =~? 'sneak' && v !~? '^x\s\+\%([ft,;]\\|<plug>\)'})
"}}}
"   operator-pending mode?{{{
"
"     put =filter(split(execute('ono'), '\n'), {_,v -> v =~? 'sneak' && v !~? '^o\s\+\%([ft,;]\\|<plug>\)'})
"}}}
sil! ounmap z
sil! ounmap Z

