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

