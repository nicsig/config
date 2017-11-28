# Guard

Don't write a guard in your ftplugins:

        if exists('b:did_ftplugin')
            finish
        endif
        let b:did_ftplugin = 1

Because  a previous  ftplugin ($VIMRUNTIME/ftplugin/{filetype}.vim)  already set
the variable `b:did_ftplugin` (hit `gF`).

Creating  `b:did_ftplugin` could  be useful,  but not  in `after/`,  because its
purpose is to prevent any other filetype plugins from being sourced.

# b:did_ftplugin    b:undo_ftplugin

No  need  to delete  `b:did_ftplugin`,  nor  `b:undo_ftplugin`. Vim will  do  it
automatically:

        $VIMRUNTIME/ftplugin.vim:17

# functions

We  shouldn't define  functions in  a  filetype plugin.   They should  be in  an
`autoload/`  directory.

You  can  either use  `~/.vim/autoload/`,  or  the  `autoload/` directory  of  a
dedicated  plugin, created  for  the  occasion (with  a  `ftplugin/`, and  maybe
`syntax/`, `indent/`, … directories).
