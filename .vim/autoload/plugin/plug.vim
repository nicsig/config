vim9 noclear

def plugin#plug#moveBetweenCommits(is_fwd = true) #{{{1
    # look for the next commit
    if search('^  \X*\zs\x', is_fwd ? '' : 'b') == 0
        # there's none
        return
    endif
    # open the preview window to show details about the commit under the cursor
    norm o
enddef

def plugin#plug#showDocumentation() #{{{1
    var name: string = getline('.')->matchstr('^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in globpath(g:plugs[name].dir, 'doc/*.txt')->split('\n')
            exe 'tabe +setf\ help ' .. doc
        endfor
    endif
enddef

def plugin#plug#undoFtplugin() #{{{1
    nunmap <buffer> H
    nunmap <buffer> o
    nunmap <buffer> )
    nunmap <buffer> (
enddef

