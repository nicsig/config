# Where can I find examples of snippets?

<https://github.com/pindexis/marker/tree/master/tldr>

For a given  command, to get an  idea of which invocations could  be turned into
snippets:

    $ tldr <cmd>

# Why do you use `§` as a comment marker?

We can't use `#`.
It appears in one of our snippets atm:

    cd ~/Vcs/vim/ && { git stash; make clean; make distclean; sed -i 's/#ABORT_CFLAGS ...
                                                                        ^

We need some character which will never appear in our snippets.
If you have a better idea for the comment marker, feel free to change it.

##
# Why do you use `$ git stash` in the snippet compiling tmux?

Just in case we've edited a file.
We want to undo any modification.

This matters, for example, if you need a tmux binary with debugging information,
but you've edited `configure.ac` with `sed(1)` in `~/bin/upp.sh`.
Indeed,  for  some  reason,  changing  the  version  prevents  the  binary  from
containing debugging information.

# Why do you use `=()` instead of `<()` in the `vimdiff` snippet?

`<()` asks the shell to open a special file (e.g. `/proc/13319/fd/11`).
Sometimes, however, you need a regular file, not a special file.
That's  because the  special files  are  streams of  data, which  when read  are
forgotten.
Some commands  need to be  able to  go backwards and  read earlier parts  of the
file; this is called a seek operation.

To  get around  this  problem,  zsh provides  the  substitution `=(cmd)`,  which
creates a regular file (in `/tmp`) to hold the output of `cmd`.
This regular file is removed automatically as soon as the main command finishes.

Also, the temporary file created by `<()`  is read-only which is annoying if you
have to modify it.
The one  created by `=()`  is a  regular file, that  you can change  without any
warning.

# Can't we use a key binding to disable the syntax highlighting in zsh?

So, you're thinking about removing this snippet:

    NO_SYNTAX_HIGHLIGHTING=yes exec zsh

For the moment, I think a snippet is better.
I don't know how frequent we'll want to disable the syntax highlighting.
It may  be something  which we  use once  a week;  in that  case, I  don't think
dedicating a key binding is worth it.

---

But if you really want a key binding, you could try this:

    bindkey -s '^G^H' 'NO_SYNTAX_HIGHLIGHTING=yes exec zsh\n'

It works, but it requires the command-line to be empty before pressing the keys.

An alternative would be:

    __no_syntax_highlighting() {
      emulate -L zsh
      # we need `-i`; otherwise, for some reason, the shell quits
      NO_SYNTAX_HIGHLIGHTING=yes exec zsh -i
    }
    zle -N __no_syntax_highlighting
    bindkey '^G^H' __no_syntax_highlighting

However for some reason, it raises the error message:

    stty: 'standard input': Inappropriate ioctl for device

because we have `stty -ixon` in our `~/.zshrc`.
I've tried to fix the error message by adding the redirections:

    >/dev/null </dev/null

but it didn't work.
If you  also redirect the  error stream  `>/dev/null </dev/null 2>&1`,  then the
shell quits again.

##
# About `sudo -E env "PATH=$PATH" zsh -c "!!"`
## why `-E`?

To preserve some variables in current environment (`man sudo /^\s*-E\>`).

## why `env "PATH=$PATH"`?

To make sure `PATH` is preserved, in case `-E` was not enough.

`env(1)` runs the next command (here bash), in an arbitrarily modified environment.

## why `bash -c`?

To escalate the privileges for the whole command-line.
Without, `sudo`  may fail if the  command includes a redirection  from/to a file
owned by root.

##
## How to use a key binding instead of a snippet?

    bindkey -s '^X^S' 'sudo -E env "PATH=$PATH" bash -c "!!"^M'
             │
             └ interpret the arguments as strings of characters
               without `-s`, `sudo` would be interpreted as the name of a zle widget

##
# About `sudo zsh -c "$(typeset -f ...); ..."`
## when do I need this snippet?

Whenever you have a custom zsh function which needs root privileges.
For example, `environ` works fine for a user process, but not for a root process:

    $ environ 1
    environ:9: permission denied: /proc/1/environ~

The snippet can help:

    $ sudo zsh -c "$(typeset -f environ); environ 1"
    HOME=/~
    init=/sbin/init~
    NETWORK_SKIP_ENSLAVED=~
    recovery=~
    TERM=linux~
    drop_caps=~
    BOOT_IMAGE=/boot/vmlinuz-4.15.0-51-generic~
    PATH=/sbin:/usr/sbin:/bin:/usr/bin~
    PWD=/~
    rootmnt=/root~

For more info, see: <https://unix.stackexchange.com/a/269080/289772>

##
## why `$()`?

`typeset -f ...` will output the code of a function.
But we don't want to read the code; we want to run it.

## why `zsh`, and not `bash`?

The code is for a *zsh* function, since we're in zsh.
So, zsh is the most appropriate shell to run it.

##
# About `cd ~/Vcs/vim && { ... make ... ;}`
## Why `sed -i 's/#ABORT_CFLAGS = -DABORT_ON_INTERNAL_ERROR/'`?

To make Vim crash and dump a core as soon as it detects an internal error (`:h E315`).

## Why `sed -i 's/#CFLAGS = -g -DSINIXN/CFLAGS = -g -DSINIXN/'`?

To make the Vim binary include debugging symbols.
See `:h debug-gcc`.

## Why `sed -i 's@#STRIP = /bin/true@STRIP = /bin/true@' src/Makefile'`?

Same as above.
Although, in  practice, it doesn't seem  to be necessary, but  it's mentioned in
`:h debug-gcc`, so better be safe than sorry.

