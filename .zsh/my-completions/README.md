# Usage
## What's the purpose of this directory?

It contains our custom completion functions.

We  use them  to get  suggestions when  pressing Tab  after some  of our  custom
functions, such as `xt()` or `sr()`.

## How should I name the files here?

The file containing  the code of the completion function  for the custom `foo()`
function, must be named `_foo`.

## Can I write a completion function for an alias?  A function?  For a script?

You can write one for a script and a shell function.

For an alias, simply run this:

    $ compdef myalias=myfunc

For example:

                                         don't forget the underscore
                                         v
    $ cat <<'EOF' >~/.zsh/my-completions/_func
    #compdef func

    local programs
    programs=(mpv vim zsh)
    _values 'programs' ${programs}
    EOF

    $ compdef foo=func
                  ^
                  no underscore

    $ foo Tab
    mpv vim zsh~

For more info:
<https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#copying-completions-from-another-command>

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

For more info: <https://unix.stackexchange.com/a/2184/289772>

