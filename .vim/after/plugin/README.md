If a command pollute your tab completion suggestions, remove it in:

        tidy_tab_completion.vim


Some third-party plugins need to be customized after they have been sourced.

We write these default plugin customizations inside dedicated files in this directory.
That's what the documentation for `Abolish.vim` recommends.
But it causes an issue. When you want to debug Vim by starting it like this:

      $ vim -Nu /tmp/minimal_vimrc

You still source all these files and they may interfere.
You may be able to reproduce a bug, that no one else will.
One solution is to disable 'loadplugins' (see `:h load-plugins`):

        $ vim --noplugin -Nu /tmp/minimal_vimrc
                │
                └─ same as:    --cmd 'set noloadplugins'


We've defined an  abbreviation in `~/.zshrc` to easily and  reliably start a Vim
session with no custom config:

        Jv    →    vim --noplugin -i NONE -Nu NONE
                                              │
                                              └─ can be tweaked, because `Jv` is an abbreviation, not an alias


But an issue remains:
with this  setup, your custom plugins  in `~/.vim/after/plugin` and the  ones in
$VIMRUNTIME can not be sourced separately:

         • you either source both
         • or none (`--noplugin` or `-u NONE`)

If you don't like this you could:

        • rename this directory into `my_plugins` (outside the rtp)
        • install an autocmd in `vimrc` to manually source the files

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

This way, they would only be sourced from the vimrc. Not when you start Vim with
a minimum of customizations.

