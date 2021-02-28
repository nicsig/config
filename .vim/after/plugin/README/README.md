# Warning: ANY script in this directory will be automatically sourced.  Even if it's inside a subdirectory.

    $ mkdir -p ~/.vim/after/plugin/foo/bar/ && \
      echo 'let g:set_from_vim_after_plugin = 1' >>~/.vim/after/plugin/foo/bar/baz.vim

    $ vim
    :echo set_from_vim_after_plugin
    1~

So, do NOT try to lazy-load anything from this directory.
Use `autoload/` instead.

##
# Purpose
## What's the purpose of this directory?

You can use it to:

   - customize third-party plugins after they have been sourced

       You could also use `~/.vim/plugin/`, to customize them before
       they're sourced.

   - directly execute some interface of the plugin

       For this, you *have to* use `after/plugin/`, to be sure
       the interface has been installed.

       Btw, that's what the documentation of `Abolish.vim` recommends.

##
# Guard
## Why should I put a guard in those scripts?

A script  shouldn't be  sourced if  the plugin it  configures has  been disabled
while we debug some issue.

## Which template should I follow?

    if exists('loaded')
        # load the script only if it makes sense
        # (i.e. the plugin it configures has been loaded)
        || stridx(&rtp, 'vim-...') == -1
        finish
    endif
    var loaded = true

Note that the  name of the plugin  does not necessarily begin  with `vim-`, it's
just a widely adopted convention.  Adapt the first template to the plugin you're
working on.

You could also try to  replace `stridx(...)` with `!exists('g:loaded_...')`, but
sometimes, the author of a plugin forgets to set this variable.

