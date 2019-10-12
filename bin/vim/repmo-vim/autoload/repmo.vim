" Items:
"   key (string) key
"   revkey (string) reverse key
"   is_zap (boolean) what to repeat: 1 = user key, 0 = zap key (f, F, t or T)
if !exists('s:last')
    let s:last = {}
endif

fu repmo#key(key, revkey) abort "{{{1
    call extend(s:last, {'is_zap': 0, 'key': a:key, 'revkey': a:revkey, 'remap': 1})
    return a:key
endfu

fu repmo#self_key(key, revkey) abort "{{{1
    call extend(s:last, {'is_zap': 0, 'key': a:key, 'revkey': a:revkey, 'remap': 0})
    exe "noremap <plug>(repmo-lastkey) \<c-v>". a:key
    exe "noremap <plug>(repmo-lastrevkey) \<c-v>". a:revkey
    "                                     ├────┘
    "                                     └ :h map_backslash{{{
    "                                       :h using_ctrl-v
    "
    " > But you cannot use "<C-V>" like CTRL-V to escape the special meaning of what follows.
    "
    " Yes, we use `<c-v>` here. But it's going to be evaluated by `:exe` into `CTRL-V`.
    "}}}
    return a:key
endfu

fu repmo#last_key(zap_key, is_fwd) abort "{{{1
    " {zap_key}   (string) one of ',', ';' or ''
    if !empty(a:zap_key) && get(s:last, 'is_zap', 1)
	let lastkey = a:zap_key
    else
        let lastkey = a:is_fwd
            \ ?     get(s:last, 'remap', 1) ? get(s:last, 'key', '') : "\<plug>(repmo-lastkey)"
            \ :     get(s:last, 'remap', 1) ? get(s:last, 'revkey', '') : "\<plug>(repmo-lastrevkey)"
    endif
    return lastkey
endfu

fu repmo#zap_key(zapkey) abort "{{{1
    " {zapkey}	(string) one of `f`, `F`, `t` or `T`
    call extend(s:last, {'is_zap': 1})
    return a:zapkey
endfu

