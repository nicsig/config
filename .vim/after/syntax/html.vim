" The default  html syntax plugin  considers some closing greater-than  signs as
" errors, and so highlights them in red.
" This is distracting when we're writing an emmet expression such as:
"
"         #page>div.logo+ul#navigation>li*5>a{Item $}
hi link htmlError Normal
