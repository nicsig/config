" Why using this file instead of `ftdetect/`?{{{
"
" Because it's sourced BEFORE `$VIMRUNTIME/filetype.vim`.
" Our autocmds  will match first,  and because  the other autocmds  use `:setf`,
" they won't re-set 'filetype'.
"
" This way, we make sure that, for  the files whose path match the patterns used
" in the following autocmds, our 'filetype' value has priority, and the filetype
" will be set only once (not twice).
"
" For more info about the syntax of this file, see `:h ftdetect`.
"}}}
" If I wanted to use `ftdetect/`, how would I procede?{{{
"
" To change the detection of the filetype of a file, you could use:
"
"         ~/.vim/ftdetect
"
" In  this folder,  you  would have  to  create (by  convention?)  one file  per
" filetype / autocmd.
"
" Example:
"        $ vim ~/.vim/ftdetect/notes.vim
"          au BufRead $HOME/{wiki/,.wiki/}* setf markdown
"
" No need for an augroup, Vim would wrap the autocmd automatically.
" No need to move the file in an `after/` subdirectory, Vim will look for
" files in `~/.vim/ftdetect` AFTER `$VIMRUNTIME/filetype.vim`.
"}}}

if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect
    " Why?{{{
    "
    " `$VIMRUNTIME/filetype.vim` thinks that the filetype of `~/.shrc` is `conf`:
    "
    "         " Generic configuration file. Use FALLBACK, it's just guessing!
    "         au filetypedetect BufNewFile,BufRead,StdinReadPost *
    "           \ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
    "           \    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
    "           \	|| getline(4) =~ '^#' || getline(5) =~ '^#') |
    "           \   setf FALLBACK conf |
    "           \ endif
    "
    " We want `sh` instead.
    "
    " About the optional FALLBACK argument:
    "
    " When it's present, a later `:setf` command will override 'filetype'.
    " This is to used for filetype detections that are just a guess.
    " `did_filetype()` will return false after this command.
    "}}}
    au! BufRead,BufNewFile ~/.{bashenv,shrc} setf sh

    " Why?{{{
    "
    " Sometimes (always?), the snippet definition file for `zsh`
    " (~/.vim/UltiSnips/zsh.snippets) has the wrong filetype:
    " `zsh` instead of `snippets`.
    "
    " This is annoying, because we can't expand our snippet `snip`, defined here:
    "     ~/.vim/UltiSnips/snippets.snippets
    "
    " The problem comes  from Vim, because it wrongly assumes  that a file whose
    " basename is `zsh` has the filetype `zsh`.
    " It doesn't do that for other filetypes:
    "
    "     $ vim py.foo
    "     :echo &ft
    "     ∅~
    "     $ vim html.foo
    "     :echo &ft
    "     ∅~
    "     $ vim zsh.foo
    "     :echo &ft
    "     zsh~
    "
    " Worse:
    "     vim zsh_foo.bar   >  :echo &ft  →  zsh
    "
    " It comes from $VIMRUNTIME/filetype.vim:2105:
    "
    "         au BufNewFile,BufRead zsh*,zlog*      call s:StarSetf('zsh')
    "}}}
    au! BufRead,BufNewFile zsh.snippets setf snippets

    au! BufRead,BufNewFile $HOME/.vim/doc/misc/{notes,galore} setf help

    au! BufRead,BufNewFile .gitignore,$HOME/.config/surfraw/bookmarks setf conf

    " ~/.vim/after/ftplugin/nfo.vim
    au! BufRead,BufNewFile *.nfo,*.NFO setf nfo

    " rofi config files
    " > Rofi themes use the .rasi file extension. The format is similar to .css.
    " Source: https://github.com/DaveDavenport/rofi/wiki/Themes
    au! BufRead,BufNewFile *.rasi setf css

    " Do *not* name the filetype `tmux_prompt`!{{{
    "
    " It would  make Vim  source the `tmux_prompt`  filetype plugin  whenever we
    " load a regular tmux buffer.
    "
    " This is because, by default, Vim sources:
    "
    "     */ftplugin/tmux.vim
    "     */fptlugin/tmux_*.vim
    "     */fptlugin/tmux/*.vim
    "}}}
    au! BufRead,BufNewFile ~/.vim/tmp/tmuxprompt setf tmuxprompt
    au! BufRead,BufNewFile ~/.vim/tmp/websearch setf websearch
    au! BufRead,BufNewFile ~/.config/zsh-snippets/main.txt setf zshsnippets
augroup END

