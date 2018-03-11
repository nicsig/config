" To change the detection of the filetype of a file, we could use:
"         ~/.vim/ftdetect
"
" In this folder, we would have to create (by convention?) one file
" per filetype / autocmd.
"
" Example:
"        $ vim ~/.vim/ftdetect/notes.vim
"          au BufRead $HOME/{Dropbox/conf/cheat/,.cheat/}* set filetype=markdown
"
" No need for an augroup, Vim would wrap the autocmd automatically.
" No need to move the file in an `after/` subdirectory, Vim will look for
" files in `~/.vim/ftdetect` AFTER `$VIMRUNTIME/filetype.vim`.


" But instead, we use this file, because it's sourced BEFORE
" $VIMRUNTIME/filetype.vim . Our autocmds will match first, and because the
" other autocmds use `:setf`, they won't re-set 'filetype'.
"
" This way, we make sure that 'filetype' is set only once (not twice).
"
" For more info about the syntax of this file, see `:h ftdetect`.


if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect
    " markdown for our notes
    au! BufRead $HOME/{Dropbox/conf/cheat/,.cheat/}* set filetype=markdown

    " `$VIMRUNTIME/filetype.vim` thinks that the filetype of `~/.shrc` is `conf`:
    "
    "         " Generic configuration file (check this last, it's just guessing!)
    "         au filetypedetect BufNewFile,BufRead,StdinReadPost *
    "             \ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
    "             \    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
    "             \ || getline(4) =~ '^#' || getline(5) =~ '^#') |
    "             \   setf conf |
    "             \ endif
    "
    " We want `sh` instead.
    au! BufRead ~/.shrc set filetype=sh

    " Sometimes (always?), the snippet definition file for `zsh`
    " (~/.vim/UltiSnips/zsh.snippets) has the wrong filetype:
    " `zsh` instead of `snippets`.
    "
    " This is annoying, because we can't expand our snippet `snip`, defined here:
    "     ~/.vim/UltiSnips/snippets.snippets
    "
    " The problem comes from Vim, because it wrongly assumes that a file whose
    " basename is `zsh` has the filetype `zsh`. It doesn't do that for other
    " filetypes:
    "     vim py.foo        >  :echo &ft  →  ∅
    "     vim html.foo      >  :echo &ft  →  ∅
    "     vim zsh.foo       >  :echo &ft  →  zsh
    " Worse:
    "     vim zsh_foo.bar   >  :echo &ft  →  zsh
    "
    " It comes from $VIMRUNTIME/filetype.vim:2735:
    "
    "         au BufNewFile,BufRead zsh*,zlog*      call s:StarSetf('zsh')

    au! BufRead,BufNewFile zsh.snippets set filetype=snippets
    au! BufRead,BufNewFile $HOME/.vim/doc/misc/{notes,galore} set filetype=help

    au! BufRead,BufNewFile $HOME/.config/zathura/zathurarc set filetype=conf
augroup END
