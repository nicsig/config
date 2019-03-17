# Usage
## What's the purpose of this directory?

It contains our custom completion functions.

We  use them  to get  suggestions when  pressing Tab  after some  of our  custom
functions, such as `xt()` or `sr()`.

## How should I name the files here?

The file containing  the code of the completion function  for the custom `foo()`
function, must be named `_foo`.

## Can I write a completion function for an alias?  A function?  For a script?

Not for an alias.
But you can for a script and a shell function.

---

TODO:

You can customize the completion of an alias in bash:

    $ alias vtex="vim --servername VIM"
    $ complete -f -X '!*.tex' vtex
    $ vtex Tab
        → only suggests `.tex` files

How to do the same in zsh?

## Can I write use a bash completion function?

You can try.

Write its contents in a file here, then source it from `~/.zshrc`.

That's what we did for pandoc.
It works thanks to these lines in `~/.zshrc`:

    autoload -Uz bashcompinit
    bashcompinit

Note that  whether it succeeds  or not depends on  which features does  the bash
function rely on.

Source: <https://unix.stackexchange.com/a/417143/289772>

##
# Documentation
## Where can I get more info on how to write my own completion function?

        https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
        https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide

        https://unix.stackexchange.com/a/366565/232487
        https://github.com/chrisallenlane/cheat/blob/master/cheat/autocompletion/cheat.zsh

##
# Issues
## One of my completion function isn't used.  Why?

The completion  system scans the  completion files  inside `$fpath`, and  uses a
cached “dump file” to store compiled completion functions.
It should re-scan the completion files whenever their number changes.
Maybe your new completion file is absent from this dump file, and the completion
system hasn't performed a new scan.

Remove `~/.zcompdump`, and restart a shell, or execute:

        $ rm -f ~/.zcompdump; compinit
          ├──────────────────────────┘
          └ command found here:
                  https://github.com/zsh-users/zsh-completions#manual-installation

For more info:

        https://unix.stackexchange.com/a/2184/289772

##
# Todo
## `_ppa_what_can_i_install` and `_ppa_what_have_i_installed` give too many suggestions.

We don't use the i386 cpu architecture.

---

    $ ppa_what_can_i_install google Tab
        → ∅

    $ ppa_what_have_i_installed google Tab
        → ∅

## Improve the completion function `_cs` to get the names of the cheatsheets dynamically.

For the candidates, use the output of `$ fd cheat.txt ~/wiki`.

