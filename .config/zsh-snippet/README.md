# Where can I find examples of snippets?

<https://github.com/pindexis/marker/tree/master/tldr>

For a given  command, to get an  idea of which invocations could  be turned into
snippets:

    $ tldr <cmd>

##
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

