# Warning: ANY script in this directory will be automatically sourced. Even if it's inside a subdirectory.

        $ mkdir -p ~/.vim/plugin/foo/bar/ \
          && echo 'let g:set_from_vim_plugin = 1' >>~/.vim/plugin/foo/bar/baz.vim

        $ vim
        :echo set_from_vim_plugin
            → 1

So, do NOT try to lazy-load anything from this directory.
Use `autoload/` instead.

##
# Purpose
## When should I use this directory instead of `~/.vim/after/plugin/`?

Use it by default.
Use `~/.vim/after/plugin/` only if you have to.

Theory:

Plugin authors  write their plugin thinking  that the user will  configure it in
their vimrc.
And `~/.vim/plugin/` is the closest script directory to the vimrc.

Indeed, in the chronological order in which the scripts are sourced,
`~/.vim/plugin` is closer to the vimrc than `~/.vim/after/plugin/`.
Besides, both the vimrc and  `~/.vim/plugin/` are sourced BEFORE any third-party
plugin.

---

Practice:

A plugin often inspects some variable to determine how it's going to install its
interface.
So, you need to  make sure that it exists BEFORE the interface  of the plugin is
sourced.

## Can I use this directory to disable some keys?

No.

Use `~/.vim/after/plugin/nop.vim`.

The `after/` directory is more reliable.
See the comment at the top of `nop.vim` for an explanation.

##
# Guard
## Why should I write guards in the scripts of this directory?

   1. they shouldn't be sourced twice by accident

   2. they shouldn't be sourced if the plugin they configure has been disabled
      while we debug some issue (`$ vim -Nu /tmp/vimrc`)

## Which template should I follow?

       ┌ don't source the script twice
       │
       │                         ┌ source it only if the plugin is enabled
       │                         │
       │                         │                                ┌ don't source if I'm debugging
       │                         │                                │ with `$ vim -Nu NORC`
       ├────────────────────┐    ├───────────────────────────┐    ├───────────────────┐
    if exists('g:loaded_...') || stridx(&rtp, 'vim-...') == -1 || exists('g:no_plugin')
        finish
    endif

Note that the  name of the plugin  does not necessarily begin  with 'vim-', it's
just a widely adopted convention.
Adapt the template to the plugin you're working on.

##
# Misc
## Must I avoid a conflict between a filename here, and a filename in a third-party plugin?

No.

For example, if you have the scripts:

               ┌ the example uses `~/.vim/after/plugin/`, but it applies equally well to `~/.vim/plugin/`
               ├────┐
        ~/.vim/after/plugin/abolish.vim
        ~/.vim/plugged/vim-abolish/plugin/abolish.vim

Even though they have the same name, they will be both sourced.

## Can I use `<unique>` if I install a mapping here?in one of the scripts in this directory?

No.

Consider the scripts here as an extension of your `vimrc`.

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

