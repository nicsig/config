# Warning: ANY file in this directory will be automatically sourced. Even if it's inside a subdirectory.

    $ cat ~/.vim/plugin/foo/bar/baz.vim
        let g:loaded = 1

    $ vim
    :echo loaded
        → 1

# Which directories can I use to configure my plugins?

        ~/.vim/plugin/
        ~/.vim/after/plugin/
        ~/.vim/autoload/slow_call/

##
# Purpose
## What's the purpose of this directory?

You can use it to:

        • customize third-party plugins after they have been sourced

              You could also use `~/.vim/plugin/`.

        • directly execute some interface of the plugin

              For this, you HAVE TO use `after/plugin/`, to be sure
              the interface has been installed.

              Btw, that's what the documentation of `Abolish.vim` recommends.

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

Disable `'loadplugins'` (see `:h load-plugins`):

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

If you don't like this, you can temporarily rename this directory into
`my_plugins` (outside the rtp).

## Should I put a guard in those files?

If you can, yes.

If we  temporarily disable a  plugin in our  vimrc, its configuration  should be
disabled too, to not interfere.

Note that these  guards don't replace the previous solutions  (including the one
relying on `--noplugin`):

        - for some files, you can't write a guard.

          For example:

              • nop.vim
              • tidy_tab_completion
              • undotree.vim
              • vimtex.vim

        - you still have files in `~/.vim/plugin`, and you can't put a guard in
          those (because, when  they're sourced, you don't know  yet whether the
          plugin you're setting up will be sourced).

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

## Must I avoid a conflict between a filename here, and a filename in a third-party plugin?

No.

For example, if you have the files:

        ~/.vim/after/plugin/abolish.vim
        ~/.vim/plugged/vim-abolish/plugin/abolish.vim

Even though they have the same name, they will be both sourced.

