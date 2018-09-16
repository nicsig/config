" replace noisy/ugly markers, used in folds, with ❭ and ❬
exe 'syn match dircolorsFoldMarkers  /#\?\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=dircolorsComment'
exe 'syn match dircolorsFoldMarkers  /#\?\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=dircolorsComment'
