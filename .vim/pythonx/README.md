UltiSnips doesn't take into account a change in a function of a custom module,
until you restart Vim.

A function in a custom module can't access the `snip` and `vim` objects.
If you need them for a given function, do one of the 2 following things:

    • from your custom module, outside any function, import `vim`
    • from the snippet where you call the latter, pass them as arguments
