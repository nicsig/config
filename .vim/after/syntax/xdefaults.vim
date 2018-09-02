exe 'syn match xdefaultsMarkers  /\s*{'.'{{\d*\s*\ze\n/  conceal cchar=❭  containedin=xdefaultsComment'
exe 'syn match xdefaultsMarkers  /\s*}'.'}}\d*\s*\ze\n/  conceal cchar=❬  containedin=xdefaultsComment'
