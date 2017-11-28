"                                 ┌ get rid of it once we've concealed comment leaders
"                               ┌─┤
syn match snippetsFoldMarkers  /#\?\s*{{{\d*\s*\ze\n/  conceal cchar=❭  containedin=snipComment
syn match snippetsFoldMarkers  /#\?\s*}}}\d*\s*\ze\n/  conceal cchar=❬  containedin=snipComment
