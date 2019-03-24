# repmo.vim

With repmo, you can map keys and make them repeatable with a key.
Repmo is  targeted at motions and  scroll commands, because for  each mapped key
you need to specify an opposite key.

For   key  mapping   there  are   two  functions:   `repmo#self_key()`  indicates
*remapping off* (required when  mapping a builtin key  to itself), `repmo#key()`
indicates *remapping on* (usually for everything else).
The indicator is used by repetition keys.

## Mappings

There is no plugin file, mappings should be defined in the vimrc.

```vim
    " map a motion and its reverse motion
    noremap <expr> h repmo#self_key('h', 'l')|sunmap h
    noremap <expr> l repmo#self_key('l', 'h')|sunmap l

    " if you like `:noremap j gj`, you can keep that
    map <expr> j repmo#key('gj', 'gk')|sunmap j
    map <expr> k repmo#key('gk', 'gj')|sunmap k

    " repeat the last motion or the last zap-key
    map <expr> ; repmo#last_key(';', 1)|sunmap ;
    map <expr> , repmo#last_key(',', 0)|sunmap ,

    " add these mappings when repeating with `;` or `,`
    noremap <expr> f repmo#zap_key('f')|sunmap f
    noremap <expr> F repmo#zap_key('F')|sunmap F
    noremap <expr> t repmo#zap_key('t')|sunmap t
    noremap <expr> T repmo#zap_key('T')|sunmap T
```

Scroll commands work too:

```vim
    noremap <expr> <c-e> repmo#self_key('<c-e>', '<c-y>')
    noremap <expr> <c-y> repmo#self_key('<c-y>', '<c-e>')
```

Alternative repetition keys (also working in addition to `;` and `,`):

```vim
    " repeat the last motion
    map <expr> <space> repmo#last_key('', 1)|sunmap <space>
    map <expr> <bs>    repmo#last_key('', 0)|sunmap <bs>
```

## Foreign scripts support

If you  want to use `;`  and `,` for  repetition, then this may  raise conflicts
with foreign scripts.
But you can set up repmo to work together with many of these scripts:

Make it work with [Fanfingtastic](https://github.com/dahu/vim-fanfingtastic):

```vim
    " Do not map fanfingtastic keys:
    let g:fing_enabled = 0

    map <expr> ; repmo#last_key('<Plug>fanfingtastic_;', 1)|sunmap ;
    map <expr> , repmo#last_key('<Plug>fanfingtastic_,', 0)|sunmap ,

    map <expr> f repmo#zap_key('<Plug>fanfingtastic_f')|sunmap f
    map <expr> F repmo#zap_key('<Plug>fanfingtastic_F')|sunmap F
    map <expr> t repmo#zap_key('<Plug>fanfingtastic_t')|sunmap t
    map <expr> T repmo#zap_key('<Plug>fanfingtastic_T')|sunmap T
```

or if you like [Sneak](https://github.com/justinmk/vim-sneak):

```vim
    map  <expr> ; repmo#last_key('<Plug>Sneak_;', 1)|sunmap ;
    map  <expr> , repmo#last_key('<Plug>Sneak_,', 0)|sunmap ,

    map  <expr> s repmo#zap_key('<Plug>Sneak_s')|ounmap s|sunmap s
    map  <expr> S repmo#zap_key('<Plug>Sneak_S')|ounmap S|sunmap S
    omap <expr> z repmo#zap_key('<Plug>Sneak_s')
    omap <expr> Z repmo#zap_key('<Plug>Sneak_S')
    map  <expr> f repmo#zap_key('<Plug>Sneak_f')|sunmap f
    map  <expr> F repmo#zap_key('<Plug>Sneak_F')|sunmap F
    map  <expr> t repmo#zap_key('<Plug>Sneak_t')|sunmap t
    map  <expr> T repmo#zap_key('<Plug>Sneak_T')|sunmap T
```

## Notes

The odd term "zap-key" means one of `f`, `F`, `t`, `T`, `;` or `,` (no text is deleted!).

The leading colons are only for readability, nevertheless Vim treats them as whitespace.

