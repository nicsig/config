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

##
# fzf.vim
## Why must I put the config of fzf.vim in this directory instead of `~/.vim/after/plugin/`?

We want all the commands installed by the plugin to be prefixed by `Fz`:

    let g:fzf_command_prefix = 'Fz'

`fzf.vim` needs to be informed of our prefix when its interface is sourced.
`after/plugin/` would be too late, and thus `fzf.vim` would install all of its
commands ignoring our prefix.

##
## For some reason, `:FzHistory` has become slow.  How to make it fast again?

`:FzHistory` runs `filereadable()` on all files in the list `v:oldfiles`:

    " ~/.vim/plugged/fzf.vim/autoload/fzf/vim.vim:457
    return fzf#vim#_uniq(map(
      \ filter([expand('%')], 'len(v:val)')
      \   + filter(map(s:buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
      \   + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
                                      ^^^^^^^^^^^^

You probably have  some filepath(s) in `v:oldfiles`,  for which `filereadable()`
takes some time.

For example:

    :Time sil echo filereadable('/run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.1/README')
    0.125 seconds to run :echo filereadable('/run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.1/README')~
      │
      └ if you don't get such a slow time, try to open a ftp link with `$ (g)vim`

This is way too much; compare with a regular filepath:

    :Time sil echo filereadable('/tmp/file')
    0.000 seconds to run :echo filereadable('/tmp/file')~

This can quickly add up, and make `:FzHistory` slow (several seconds).

To fix this, you can clear every problematic filepath from `v:oldfiles`:

    let v:oldfiles[12] = ''
    let v:oldfiles[34] = ''
    ...

But this will not persist after restarting Vim.
To remove the problematic filepaths definitively, you also need to edit `~/.viminfo`:

    fu! MakeFzHistoryFastAgain() abort
        for i in range(0, 99)
            if v:oldfiles[i] =~# '/gvfs/'
                let v:oldfiles[i] = ''
            endif
        endfor
        sp ~/.viminfo
        g@^>.*/gvfs/@.,/^>/-d_
        update
    endfu
    call MakeFzHistoryFastAgain()

##
## colors
### The colors in an fzf buffer seem wrong.  How to fix them?

Make sure you've properly set `g:terminal_ansi_colors` in `~/.vim/autoload/colorscheme.vim`.

---

Explanation.

An fzf buffer is based on a terminal buffer, where `:setf fzf` is run.
So, if colors are wrong in a terminal buffer, they will also be wrong in an fzf buffer.

For more info, read our comments in `~/.vim/autoload/colorscheme.vim`, above the
`g:terminal_ansi_colors` assignment.

### Why are the colors different in an fzf buffer in Vim vs in Nvim?

I don't know.
For some reason, they choose different colors in the terminal palette.
However, Nvim seems to be more consistent in its choices inside/outside tmux.

---

For example, let's consider the color of the currently selected entry in `:FzHistory`.

In xterm:

   - Vim uses color 254
   - Nvim uses color 7

In xterm + tmux:

   - Vim uses color 227
   - Nvim uses color 7 (255 if you don't set the `Tc` terminfo extension in tmux.conf)

Now, let's consider the `> Hist` prompt.

In xterm:

   - Vim uses color 110
   - Nvim uses color 68

In xterm + tmux:

   - Vim uses color 4
   - Nvim uses color 68

###
### I want to get the hex color code of some text in an fzf buffer.
#### I need to hover my mouse over the text, but the window is automatically closed when I press Escape!

Press `C-\ C-n` to enter normal mode without closing the window.

