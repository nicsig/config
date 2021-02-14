vim9script noclear

def tmuxprompt#undoFtplugin()
    set bh< bl< cul< stl< swf< wrap<
    nunmap <buffer> q
    nunmap <buffer> gx
enddef

