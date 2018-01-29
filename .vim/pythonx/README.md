To  store your  python helper  functions, you  can use  any sub-directory  named
`pythonx` inside a directory of the runtimepath.

For more info, see `:h pythonx-directory`.

---

UltiSnips doesn't take into account a change in a function of a custom module,
until you restart Vim.

---

A function in a custom module can't access the `snip` and `vim` objects.
If you need them for a given function, do one of the 2 following things:

 - from your custom module, outside any function, import `vim`
 - from the snippet where you call your function, pass `vim` and/or `snip` as arguments

Note that it seems  you can't import `snip`. So, the only way  for a function to
access it, relies on you passing it as an argument.

---

`snip.cursor` is ONLY accessible in a context expression.
So, in  the function of a  custom module, don't use  `snip.cursor[0]` to express
the current line address, unless maybe, if the function is evaluated from a context
expression. Instead use `vim.current.window.cursor[0])`.

See `:h UltiSnips-context-snippets` and:

    https://github.com/SirVer/ultisnips/issues/835#issuecomment-286365371

---

Contrary to a snippet file, where UltiSnips automatically pre-import the modules:

 - os
 - random
 - re
 - string
 - vim

… no module is pre-imported in a custom python module.

If you need one of them in one of your helper function, import it at the beginning
of the file.
