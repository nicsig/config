See also `~/.vim/plugin/README.md`.

# Warning: ANY file in this directory will be automatically sourced. Even if it's inside a subdirectory.

    $ cat ~/.vim/plugin/foo/bar/baz.vim
        let g:loaded = 1

    $ vim
    :echo loaded
        → 1

##
# Purpose
## What's the purpose of this directory?

Some third-party plugins need to be customized after they have been sourced.

Write these customizations inside dedicated files in this directory.
That's what the documentation for `Abolish.vim` recommends.

## What's the purpose of `tidy_tab_completion.vim`?

Use it to remove  a command which you never use and  pollute your tab completion
suggestions.

## What's the purpose of `nop.vim`?

Use this file to disable a keysequence (`nno <key> <nop>`).

##
# Debugging
## Why can the files in this directory interfere when I debug my setup?

When you want to debug Vim by starting it like this:

        $ vim -Nu /tmp/minimal_vimrc

You still source all these files, which may interfere.
You may be able to reproduce a bug, that no one else will.

## How to prevent it from happening?

Disable 'loadplugins' (see `:h load-plugins`):

        $ vim --noplugin -Nu /tmp/minimal_vimrc
                │
                └─ same as:    --cmd 'set noloadplugins'


As a  convenience, we've  defined an  abbreviation in  `~/.zshrc` to  easily and
reliably start a Vim session with no custom config:

        Jv

    →

        vim -Nu /tmp/vimrc -U NONE -i NONE --noplugin
                │
                └─ can be tweaked,
                   because `Jv` is an abbreviation which will be expanded,
                   not an alias

---

But an issue remains.
Your custom plugins in `~/.vim/after/plugin` and the ones in $VIMRUNTIME can not
be sourced separately:

         • you either source both
         • or none (`--noplugin` or `-u NONE`)

If you don't like this, you could:

        1. rename this directory into `my_plugins` (outside the rtp)

        2. install an autocmd in `vimrc` to manually source the files

                augroup default_plugins_customization
                    au!
                    au VimEnter * call s:source_plugin_custom()
                augroup END

                fu! s:source_plugin_custom() abort
                    let files = glob($HOME.'/.vim/after/my_plugins/*.vim', 0, 1)
                    for file in files
                        exe 'source '.file
                    endfor
                endfu

This way, they would only be sourced from the vimrc.
Not when you start Vim with a minimum of customizations.

##
# Misc
## Can I use this directory to lazy-load the config of a plugin?

No.

Read the warning at the top:
all  the files  in this  directory will  be automatically  sourced during  Vim's
startup.

You can't lazy-load anything from this directory.
Use `autoload/` instead.

## Can I use `<unique>` if I install a mapping in one of the files in this directory?

No.

Consider the files here as an extension of your `vimrc`.

`<unique>` is for a plugin author who  doesn't want to overwrite the mappings of
their users.
`~/.vim/plugin/`  is  not  the  directory  of a  third-party  plugin,  it's  the
directory of a user (you).

You never use `<unique>` in your `vimrc`,  so be consistent and don't do it here
either.


In `~/.vim/after/plugin/`, there's another reason not to use it:
you want to have the last word on some mappings.
If you  use `<unique>`  in one  of your  mapping, and  a third-party  plugin has
already installed another mapping using the same key, your mapping will fail and
raise an error.

