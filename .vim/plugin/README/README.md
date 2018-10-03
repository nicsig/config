# Warning: ANY file in this directory will be automatically sourced. Even if it's inside a subdirectory.

        $ mkdir -p ~/.vim/plugin/foo/bar/ \
          && echo 'let g:set_from_vim_plugin = 1' >>~/.vim/plugin/foo/bar/baz.vim

        $ vim
        :echo set_from_vim_plugin
            → 1

##
# Purpose
## When should I use this directory instead of `~/.vim/after/plugin/`?

Use it by default.
Use `~/.vim/after/plugin/` only if you have to.

Plugin authors  write their plugin thinking  that the user will  configure it in
their vimrc.
And `~/.vim/plugin/` is the closest script directory to the vimrc.

Indeed, in the chronological order in which the scripts are sourced,
`~/.vim/plugin` is closer to the vimrc than `~/.vim/after/plugin/`.
Besides, both the vimrc and  `~/.vim/plugin/` are sourced before any third-party
plugin.

In practice, a  plugin often inspects some variable to  determine how it's going
to install its interface.
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

For 2 reasons:

        1. they shouldn't be sourced twice by accident

        2. they shouldn't be sourced if the plugin they configure has been
           disabled while we debug some issue (`$ vim -Nu [NORC | /tmp/vimrc]`)

## Which template should I follow?

           ┌ don't source the script twice
           │
           │                         ┌ source it only if the plugin is enabled
           │                         │
           ├────────────────────┐    ├───────────────────────────┐
        if exists('g:loaded_...') || stridx(&rtp, 'vim-...') == -1
            finish
        endif

Note that the  name of the plugin  does not necessarily begin  with 'vim-', it's
just a widely adopted convention.
Adapt the template to the plugin you're working on.

