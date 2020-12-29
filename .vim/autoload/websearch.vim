vim9script noclear

def websearch#undoFtplugin()
    set bh< bl< cul< stl< swf< wrap<
    unlet! b:url
    nunmap <buffer> q
    nunmap <buffer> <cr>
    nunmap <buffer> ZZ
enddef

