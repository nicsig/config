" Where does the code in this script come from?{{{
"
"     $VIMRUNTIME/syntax/hitest.vim
"}}}
" What does it do?{{{
"
" Print your current highlight settings.
"}}}
" How to use it?{{{
"
"    :so%
"}}}
" Why don't you use the original script?{{{
"
" It contains a few errors:
"
"     • `:normal` instead of `normal!`
"      (which causes an issue because of a custom mapping installed by `vim-search`)
"
"     • doesn't temporarily reset 'ww'
"     (which causes an issue because we do `set ww=h,l` in our vimrc)
"}}}

fu! s:hitest() abort
    let report      = &report
    let wrapscan    = &wrapscan
    let ww          = &ww
    let z_save      = [getreg('z'), getregtype('z')]

    set report=99999 wrapscan ww=b,s

    let @z = execute('hi')

    " Open a new window if the current one isn't empty
    if line('$') != 1 || getline(1) != ''
        new
    endif

    sil edit Highlight\ test

    setl ai bt=nofile fo=t noet noswf sw=16 ts=16
    let &tw = &columns

    " insert highlight settings
    %d_
    put z

    " remove the colored xxx items
    keepj keepp g/xxx /s///e

    " remove color settings (not needed here)
    keepj keepp v/links to/ s/\s.*$//e

    " move linked groups to the end of file
    keepj keepp g/links to/m$

    " move linked group names to the matching preferred groups
    keepj keepp %s/^\(\w\+\)\s*\(links to\)\s*\(\w\+\)$/\3\t\2 \1/e
    keepj keepp g/links to/norm! mz3ElD0#$p'zdd

    " delete empty lines
    keepj keepp g/^ *$/d_

    " precede syntax command
    keepj keepp %s/^[^ ]*/syn keyword &\t&/

    " execute syntax commands
    syn clear
    %y z
    @z

    " remove syntax commands again
    keepj keepp %s/^syn keyword //

    " pretty formatting
    keepj keepp g/^/exe "norm! Wi\r\t\eAA\ex"
    keepj keepp g/^\S/j

    " find out first syntax highlighting
    let various = &highlight . ',:Normal,:Cursor,:,'
    let i = 1
    while various =~ ':'.substitute(getline(i), '\s.*$', ',', '')
        let i += 1
        if i > line('$') | break | endif
    endwhile

    " insert headlines
    call append(0, 'Highlighting groups for various occasions')
    call append(1, '-----------------------------------------')

    if i < line('$')-1
        let header = 'Syntax highlighting groups'
        call append(i+1, ['', header, substitute(header, '.', '-', 'g')])
    endif

    call cursor(1,1)

    " restore global options and registers
    let &report   = report
    let &wrapscan = wrapscan
    let &ww       = ww
    call call('setreg', ['z'] + z_save)
endfu

call s:hitest()
