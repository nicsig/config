# Which directories can I use to configure my plugins?

        ~/.vim/plugin/
        ~/.vim/after/plugin/
        ~/.vim/autoload/slow_call/

##
# When should I use this directory instead of `~/.vim/after/plugin/`?

When the  plugin inspects some variable  to determine how it's  going to install
its interface.

# Can I use this directory to disable some keys?

No.

Use `~/.vim/after/plugin/nop.vim`.

The `after/` directory is more reliable.
See the comment at the top of `nop.vim` for an explanation.

# Should I put a guard in those files?

No.

When they're  sourced, you don't know  yet whether the plugin  you're setting up
will be sourced.
If you  use `vim-plug`, maybe  you could inspect  `g:plugs`, but I  prefer using
only a plugin-manager-agnostic solution.

