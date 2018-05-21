See also `~/.vim/plugin/after/README.md`.

# When should I use this directory instead of `~/.vim/after/plugin/`?

When you absolutely need to prevent the plugin from installing some interface.

# Why must I put the config of UltiSnips in this directory instead of `~/.vim/after/plugin/`?

If you  configure UltiSnips from  `~/.vim/after/plugin/`, when the  interface of
UltiSnips will be sourced, it won't see you've chosen a key to expand a snippet.

So, it will use `Tab` and install some mappings.
In `vim-completion`,  we also  install some  mappings using  the `Tab`  key, and
using the `<unique>` argument.

They will conflict with the UltiSnips mappings.

---

OTOH, if  you configure UltiSnips  from this  directory, when UltiSnips  will be
sourced, it will see you've chosen a key to expand a snippet:

        let g:UltiSnipsExpandTrigger = '<S-F15>'

So, it will use it to install the mappings.
And the  key we've chosen  is purposefully  NOT `Tab`, so  when `vim-completion`
will be sourced, there'll be no conflict.

# Can I use this directory to disable some keys?

No.

Use `~/.vim/after/plugin/nop.vim`.

The `after/` directory is more reliable.
See the comment at the top of `nop.vim` for an explanation.

