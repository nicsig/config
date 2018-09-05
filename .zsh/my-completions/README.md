# What's the purpose of this folder?

It contains our custom completion functions.

We  use them  to get  suggestions when  pressing Tab  after some  of our  custom
functions, such as `xt()` or `sr()`.

# How should I name the files here?

The file containing  the code of the completion function  for the custom `foo()`
function, must be named `_foo`.

# One of my completion function isn't used.  Why?

The completion  system scans the  completion files  inside `$fpath`, and  uses a
cached “dump file” to store compiled completion functions.
It should re-scan the completion files whenever their number changes.
Maybe your new completion file is absent from this dump file, and the completion
system hasn't performed a new scan.

Remove `~/.zcompdump`, and restart a shell.

For more info:

    https://unix.stackexchange.com/a/2184/289772

# Where can I get more info on how to write my own completion function?

        https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
        https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide

        https://unix.stackexchange.com/a/366565/232487
        https://github.com/chrisallenlane/cheat/blob/master/cheat/autocompletion/cheat.zsh
