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
file.
This is called a seek operation.

To  get around  this  problem,  zsh provides  the  substitution `=(cmd)`,  which
creates a regular file (in `/tmp`) to hold the output of `cmd`.
This regular file is removed automatically as soon as the main command finishes.

Also, the temporary file created by `<()`  is read-only which is annoying if you
have to modify it.
The one  created by `=()`  is a  regular file, that  you can change  without any
warning.

