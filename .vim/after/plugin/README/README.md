# Warning: ANY file in this directory will be automatically sourced. Even if it's inside a subdirectory.

        $ mkdir -p ~/.vim/after/plugin/foo/bar/ \
          && echo 'let g:set_from_vim_after_plugin = 1' >>~/.vim/after/plugin/foo/bar/baz.vim

        $ vim
        :echo set_from_vim_after_plugin
            → 1

##
# Purpose
## What's the purpose of this directory?

You can use it to:

        • customize third-party plugins after they have been sourced

              You could also use `~/.vim/plugin/`, to customize them before
              they're sourced.

        • directly execute some interface of the plugin

              For this, you HAVE TO use `after/plugin/`, to be sure
              the interface has been installed.

              Btw, that's what the documentation of `Abolish.vim` recommends.

##
# Guard
## Should I put a guard in those files?  Why?

If you can, yes.

A script  shouldn't be  sourced if  the plugin it  configures has  been disabled
while we debug some issue (`$ vim -Nu /tmp/vimrc`).
Otherwise, you may be able to reproduce a bug, that no one else will.

Note that for some files, you can't write a guard:

        • nop.vim
        • matchparen_toggle.vim
        • tidy_tab_completion.vim

## Which template should I follow?

           ┌ load the script only if it makes sense
           │ (i.e. the plugin it configures has been loaded)
           │
           ├───────────────────┐
        if !exists(g:loaded_...)
            finish
        endif

Or:

        if stridx(&rtp, 'vim-...') == -1
            finish
        endif

Note that the  name of the plugin  does not necessarily begin  with 'vim-', it's
just a widely adopted convention.
Adapt the first template to the plugin you're working on.

Use the second one if the author of the plugin forgot to set a guard.

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

