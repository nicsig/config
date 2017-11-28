" fu! My_ulti_remove_empty_lines() abort
"     augroup my_ulti_rel
"         au!
"         "                                           Remove Empty Lines ┐
"         "                                                              │
"         au User UltiSnipsExitLastSnippet call timer_start(0, s:snr().'rel_delay')
"     augroup END
" endfu

" fu! s:rel_delay(_) abort
"     keepj keepp ?^\s*fu!?,s/^\s*$//e
"     au! my_ulti_rel
"     aug! my_ulti_rel
" endfu

" fu! s:snr()
"     return matchstr(expand('<sfile>'), '<SNR>\d\+_')
" endfu
