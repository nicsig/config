vim9 noclear

def tmuxprompt#undoFtplugin()
    set bh< bl< cul< stl< swf< wrap<
    nunmap <buffer> q
    nunmap <buffer> <cr>
    nunmap <buffer> ZZ
enddef

