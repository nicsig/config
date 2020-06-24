" The default syntax plugin wrongly highlights the word `display`:{{{
"
"     syn keyword xdefaultsTodo contained TODO FIXME XXX display
"                                                        ^-----^
"}}}
syn clear xdefaultsTodo
syn keyword xdefaultsTodo contained TODO FIXME XXX
