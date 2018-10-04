# Warning: ANY script in this directory will be automatically sourced. Even if it's inside a subdirectory.

        $ mkdir -p ~/.vim/after/plugin/foo/bar/ \
          && echo 'let g:set_from_vim_after_plugin = 1' >>~/.vim/after/plugin/foo/bar/baz.vim

        $ vim
        :echo set_from_vim_after_plugin
            → 1

So, do NOT try to lazy-load anything from this directory.
Use `autoload/` instead.

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
## Should I put a guard in those scripts?  Why?

If you can, yes.

A script  shouldn't be  sourced if  the plugin it  configures has  been disabled
while we debug some issue (`$ vim -Nu /tmp/vimrc`).
Otherwise, you may be able to reproduce a bug, that no one else will.

Note that for some scripts, you can't write a guard:

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

## How to prevent a script to be sourced twice?

I don't think you can.

The first time a  script is sourced here, the plugin  it configures will ALREADY
have been sourced.
So `g:loaded_...` will exist, and you won't be able to write this:

        if exists('g:loaded_...')
            finish
        endif

It would always prevent your script from being sourced.

OTOH, you can write this:

        if !exists('g:loaded_...')
            finish
        endif

But it serves another purpose.
It prevents the script from being sourced,  if the plugin it configures has been
disabled.

