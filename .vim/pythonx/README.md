UltiSnips doesn't take into account a change in a function of a custom module,
until you restart Vim.


A function in a custom module can't access the `snip` and `vim` objects.
If you need them for a given function, do one of the 2 following things:

 - from your custom module, outside any function, import `vim`
 - from the snippet where you call the latter, pass `vim` and/or `snip` as arguments


Note that it seems  you can't import `snip`. So, the only way  for a function to
access it, relies on you passing it as an argument.


Contrary to a snippet file, where UltiSnips automatically pre-import the modules:

 - os
 - random
 - re
 - string
 - vim

… no module is are pre-imported in a custom python module.

If you need one of them in one of your helper function, import it at the beginning
of the file.
