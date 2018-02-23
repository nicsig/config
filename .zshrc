# FIXME:
#
# The plugin `zsh-syntax-highlighting` breaks the `yank-pop` widget (M-y).
# After you paste a deleted text with  C-y, M-y allows you to rotate between the
# last  kills. With  the  plugin,  you  can only  get  the  previous  kill,  not
# further. Reproduce:
#
#     bindkey -e
#     . ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#     return


# To restore the file to its default contents:
#     /etc/zsh/newuser.zshrc.recommended
#
# This file only exists if the package was installed from the default repo.
# Not compiled.

# TODO:
# Do we need to set the option `zle_bracketed_paste`?
# The bracketed paste mode is useful, among other things, to prevent the shell
# from executing automatically a multi-line pasted text:
#
#     https://cirw.in/blog/bracketed-paste
#
# Atm, zsh doesn't execute a multi-line pasted text. Does it mean we're good?
# Is the bracketed paste mode enabled?
# Or do we need to copy the code of this plugin:
#
#     https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/safe-paste/safe-paste.plugin.zsh

# TODO:
# Currently we have several lines in this file which must appear before or after
# a certain point to avoid being overridden/overriding sth.
# It feels brittle. One day we could move them in the wrong order.
# Find a better way of organizing this file.

# TODO:
# I can't create a symlink for `~/.zsh_eternal_history` pointing to a file in
# Dropbox. So, for the moment, I did the opposite: a symlink in Dropbox to the
# file in ~. Once we get rid of Dropbox, version control all zsh config files,
# including the history (good idea? sensible data?).
# If it's not a good idea, then configure a cron job to automatically make
# a backup of the history on a 2nd hard drive.

# TODO:
# install a hook which would automatically `cd` into a cloned repo.
# Read `man zshcontrib`, section `Manipulating Hook Functions`.
# Also `man zshmisc`, section `SPECIAL FUNCTIONS`.

# TODO:
# automatically highlight in red special characters on the command line
# use this regex to find all non ascii characters:
#     [^\x00-\x7F]
#
# Read `man zshzle`, section `special widgets`:
#     zle-line-pre-redraw
#            Executed  whenever  the  input  line  is  about  to be redrawn,
#            providing an opportunity to update the region_highlight array.

# TODO:
# read this tuto
# http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/

# TODO:
# implement the key binding `M-Del` to delete from the cursor back to the
# previous whitespace.

# NOTE:
# there's also a `quote-line` command bound to M-' by default.
# As the name suggests, it quotes the entire line. No need to select a region.

# TODO:
# move all functions, and aliases which we want to be common to bash and zsh
# inside `~/.shrc`

# TODO:
# check that none of our alias can shadow a future command from the repos:
#     apt-file update
#     apt-file -x search '/myalias$'

# FIXME:
# understand: https://unix.stackexchange.com/questions/366549/how-to-deal-with-filenames-containing-a-single-quote-inside-a-zsh-completion-fun

# TODO:
# To read:
# https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide
# https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
# https://github.com/sindresorhus/pure (≈ 550 sloc, 2 fichiers: pure.zsh, async.zsh)

# initialize the prompt system
#@ autoload -Uz promptinit
#         ││
#         ││
#         │└── from `man zshbuiltins`:
#         │     mark the function to be autoloaded using the zsh style,
#         │     as if the option KSH_AUTOLOAD was unset
#         │
#         └── from `man zshmisc`:
#             suppress usual alias expansion during reading
#
#                                                                               ┌─ autoload flag
#                                                                               │
# according to `run-help autoload`,   `autoload`   is equivalent to `functions -u`
# according to `run-help functions`,  `functions`  is equivalent to `typeset -f`
#                                                                             │
#                                                                             └─ refer to function
#                                                                                rather than parameter
# according to `run-help typeset`,    `typeset`    sets or displays attributes and
#                                                  values for shell parameters
#@ promptinit

# To choose a theme, use these commands:
#
#     prompt -l              list available themes
#     prompt -p              preview available themes
#     prompt <your theme>    enable a theme
#     prompt off             no theme

# ┌─ man zshparam
# │    > PARAMETERS USED BY THE SHELL
# │
# │         ┌ man zshzle
# │         │   > CHARACTER HIGHLIGHTING
# │  ┌──────┤
PS1='%F{blue}%1d%f%% '
#            └─┤
#              └ man zshmisc
#                  > SIMPLE PROMPT ESCAPES
#                    > Shell state

# Alternatives:
#     PS1='%F{34}%1d%f%% '
#     PS1=$'%{\e[34m%1d\e[m%}%% '

# FIXME:
# Change the `_sr` function so that it looks in:
#     /usr/lib/share/elvi  +  ~/.config/surfraw/elvi/

# WARNING:
# a completion function doesn't work for an alias, only for a command
# or a function
#
# WARNING:
# Sometimes, when I define a test completion function, it seems zsh memorize it
# even if I comment the whole .zshrc and I remove the file where it was defined.
# To fix this, try to restore the line:
#     fpath=(~/.zsh/completion $fpath)
#
# If the pb occurs again, comment out the `fpath` line, and try to add or remove
# a file inside /usr/local/share/zsh/site-functions/, to force zsh to update its
# database of completion functions.
# Try to find where this database is, or better understand how all of this
# works.

# FIXME:
# Is this line really necessary? The completion functions seem to work
# without.
autoload -Uz _vc _sr

# `fpath` is an array (colon separated list) of directories specifying the
# search path for function definitions.
# This path is searched when a function with the `-u` attribute is referenced.
#
# Any change to `fpath` after the `compinit` function has been invoked won't
# have any effect, so `fpath` must be completely defined before `compinit`.
#
# Add `~/.zsh/my-completions` to the FRONT of `fpath`, to override any functions
# coming from zsh installation.

#                                                       ┌ additional completion definitions
#                                                       │ not available in a default installation
#                                                       │ useful for virtualbox
#                             ┌─────────────────────────┤
fpath=(~/.zsh/my-completions/ ~/.zsh/zsh-completions/src/ $fpath)

# Add completion for the `dasht` command:
#
#     https://github.com/sunaku/dasht
fpath+=~/GitRepos/dasht/etc/zsh/completions/

# Use modern completion system
autoload -Uz compinit
compinit

# By default, `run-help` is an alias for `man`.
# Remove it silently (black hole is needed to avoid error messages when we
# reload zshrc).
# This is necessary ONLY if we've compiled zsh. If we've installed it from
# a default repo, the help files have probably already been generated,
# and `run-help` hasn't been aliased to `man`.
unalias run-help >/dev/null 2>&1
# autoload `run-help` function
autoload -Uz run-help


# When we hit C-w, don't delete back to a space, but to a space OR a slash.
# Useful to have more control over deletion on a filepath.
#
# http://stackoverflow.com/a/1438523
autoload -Uz select-word-style
select-word-style bash
# Info: `backward-kill-word` is bound to C-w
#
# More flexible, easier solution (and more robust?):
#     http://stackoverflow.com/a/11200998


# load `cdr` function to go back to previously visited directories
# FIXME: comment to develop by reading see `man zshcontrib`
# (how to use it?, how it works?)
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

autoload zmv
autoload zrecompile

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# not sure, but the first part of the next command probably makes completion
# case-insensitive:    https://unix.stackexchange.com/q/185537/232487
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


zstyle ':completion:*' menu select

# Don't move this line after the `Sourcing` section. It would reset `fzf` key
# bindings.
#
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# don't move sourcing after syntax highlighting
# Sourcing {{{1

# Le code qui suit a pour but de sourcer un ensemble de fonctions fournies par
# le script fasd:
#
# posix-alias          define aliases that applies to all posix shells
# zsh-hook             define _fasd_preexec and add it to zsh preexec array
# zsh-ccomp            zsh command mode completion definitions
# zsh-ccomp-install    setup command mode completion for zsh
# zsh-wcomp            zsh word mode completion definitions
# zsh-wcomp-install    setup word mode completion for zsh
#
# Pour réduire le ralentissement induit par ces fonctions au lancement d'un
# shell zsh, on les écrit dans un fichier cache, ~/.fasd-init-zsh, qu'on met à
# jour quand le script fasd est plus récent (-nt).
#
# Code inspiré (adaptation bash → zsh) par un passage de cette page:
#     https://github.com/clvv/fasd#install
#
# Alternativement, pour initialiser fasd, on pourrait se contenter d'une des
# lignes qui suit :
#
# eval "$(fasd --init auto)"                        code générique pour n'importe quel shell
# eval "$(fasd --init posix-alias zsh-hook)"        code minimaliste pour zsh (pas de complétion via tab)

fasd_cache="${HOME}/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "${fasd_cache}" -o ! -s "${fasd_cache}" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install >| "${fasd_cache}"
fi
. "${fasd_cache}"
unset fasd_cache


# source fzf config
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# https://github.com/zsh-users/zaw
#
# Usage:
#
#     1. Trigger zaw by pressing C-x ;
#     2. select source and press Enter
#     3. filter items with zsh patterns separated by spaces, use C-n, C-p and select one
#     4. press enter key to execute default action, or Meta-enter to write one
#
# TODO:
# Read the whole readme. In particular the sections:
#
#     shortcut widgets
#     key binds and styles
#     making sources

. ~/.zsh/plugins/zaw/zaw.zsh


# source our custom aliases and functions (common to bash and zsh) last
# so that they can override anything that could have been sourced before
. ~/.shrc

# Aliases {{{1
# global {{{2

# We could implement the following global aliases as abbreviations, but we won't
# because they can only be used at the end of a command. To be expanded,
# an abbreviation needs to be followed by a space.

# count lines
alias -g CL="| wc -l"

alias -g L="| less"

# pretty print
alias -g PP="| column -t"

# silence!
#                    ┌───── redirect output to /dev/null
#                    │    ┌ same thing for errors
#           ┌────────┤ ┌──┤
alias -g S=">/dev/null 2>&1 &"
#                           │
#                           └─ execute in background

alias -g V="| vipe >/dev/null"
#                  │
#                  └─ don't write on the terminal, the Vim buffer is enough

# regular {{{2

# TODO:
# I don't move the `fasd` aliases into `~/.shrc` because I only source its
# functions in zsh. IIRC, the syntax isn't the same between bash and zsh.
# Look at the readme:
#     https://github.com/clvv/fasd
#
# If we want to move them in `~/.shrc`, first look at the `sourcing` section and
# change the code so that it checks which shell is running.
# Basically, we would need to also move the sourcing in `shrc`, check which shell
# is running, and source `fasd` functions with the right syntax.

# fasd
alias m='f -e mpv'
#           │
#           └─ look for a file and open it with `mpv`

alias o='a -e xdg-open'
#           │
#           └─ open with `xdg-open`

alias v='f -t -e vim -b viminfo'
#           │  │      │
#           │  │      └─ use `viminfo` backend only (search only for files present in `viminfo`)
#           │  └─ open with vim
#           └─ match by recent access only

# suffix {{{2

# automatically open a file with the right program, according to its extension

alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv
alias -s {jpg,png}=feh
alias -s gif=ristretto
alias -s {epub,mobi}=ebook-viewer
alias -s {md,markdown,txt,html,css}=vim
alias -s odt=libreoffice
alias -s pdf=evince

# Environment Variables {{{1

# commands whose combined user and system execution times (measured in seconds)
# are greater than this value have timing statistics printed for them
# the report can be formatted with `TIMEFMT` (man zshparam)
export REPORTTIME=15

# Functions {{{1
ccheat() { #{{{2
  emulate -LR zsh
  # cette fonction a pour but de coloriser la sortie de la commande cheat{{{
  # pour ce faire, on utilise la commande highlight (à installer)
  # à laquelle on fait passer 3 arguments :
  # -O xterm256 : formatage destiné à un terminal (il existe d'autres formats, html, ansi, bbcode...)
  # -S bash : syntaxe bash
  # -s olive :    thème olive (il en existe d'autres : 'highlight -w' pour en voir une liste)
  # -O, -s, -S, -w = --out-format, --style, --syntax, --list-themes

  # pour ajouter à bash la complétion des arguments passés à cheat :
  # cd /etc/bash_completion.d/ && wget https://raw.githubusercontent.com/chrisallenlane/cheat/master/cheat/autocompletion/cheat.bash

  # autre solution utilisant pygments
  # documentation de pygments : http://pygments.org/docs/
  #
  # pygmentize fait partie soit du paquet .deb python-pygments soit du paquet pip pygments
  #
  # on utilise pygmentize pour coloriser la sortie de la commande cheat
  # l'option -l permet de spécifier un lexer
  # un lexer est un programme réalisant une analyse syntaxique : https://en.wikipedia.org/wiki/Lexical_analysis
  # 'pygmentize -L' liste les différents lexers disponibles
  # le lexer bash ne produit pas la colorisation que j'attends
  # du coup pour le moment j'utilise le lexer spécifique au language C (mieux mais pas parfait)

  # on peut aussi utiliser l'option -g (guess), qui laisse le soin à pygmentize de deviner le type de code qu'il est en train d'analyser

  # cheat "$1" | pygmentize -l c

  # Remarque : on pourrait se passer du pgm cheat :
  # cd ~/.cheat && cat <cmd> | highlight | less -iR# }}}

  cheat "$1" | highlight -O xterm256 -S bash -s olive
}
cmdfu() { #{{{2
  emulate -LR zsh

  # Cette fonction permet de faire des recherches sur le site www.commandlinefu.com depuis le terminal.
  # Dependency: highlight package

  #                             ┌── yes, we can imbricate quotes, without escaping them
  #                             │
  keywords="$(sed 's/ /-/g' <<< "$@")"
  # on affecte à encoding l'encodage en base64 des mots-clés
  # FIXME:
  # how to get rid of `echo`?
  # we can't use `<<<` because `base64` doesn't accept a string as its input,
  # only a file
  encoding="$(echo -n "$@" | base64)"
  #                 │
  #                 └── remove ending newline, because it alters the encoding result

  # Pour finir on télécharge la page web en mode silencieux (-s) pour ne pas
  # afficher la progression ni les erreurs.
  curl -s "http://www.commandlinefu.com/commands/matching/$keywords/$encoding/sort-by-votes/plaintext" \
    | highlight -O xterm256 -S bash -s bright | less -iR

}

dl_sub() { #{{{2
  emulate -LR zsh
  cd ~/Videos/
  subliminal -l fr -- "$1"
  cd -
}

fzf_sr() { #{{{2
  emulate -LR zsh
  sr "$(sed '/^$/d' ~/.config/surfraw/bookmarks | sort -n | fzf -e)" ;}
  #     └─────────────────────────────────────┤   └─────┤   └────┤
  #                                           │         │        └ search the pattern input by the user
  #                                           │         │          exactly (disable fuzzy matching)
  #                                           │         │
  #                                           │         └───────── sort numerically
  #                                           │
  #                                           └─────────────────── remove empty lines in
  #                                                                the bookmark file

lrv() { #{{{2
  emulate -LR zsh

  # Fonction lrv (Locate with Regexp and Vim) qui permet de simplifier
  # la syntaxe d'une recherche avec locate quand on veut utiliser une expression régulière.

  # En effet si on cherche tous les fichiers contenant foo et (bar ou baz), il faut taper :
  # locate -ir 'foo.*\(bar\|baz\)'

  # Grâce à la fonction qui suit on peut se contenter de taper :  lrv 'foo (bar|baz)'

  # On echo tous les arguments passés à la fonction, et on fait 4 substitutions
  # (en affectant le résultat à la variable `keywords`) :

  #     <space>   →  .*  du coup 'foo bar' devient 'foo.*bar'

  #     (         →  \(
  #     |         →  \|      plus besoin d'échapper les symboles (,| et )
  #     )         →  \)

  # Vim lit le résultat de la commande `locate` (via le dernier tiret qui redirige
  # stdin vers le pipe précédent), en mode read-only (-R).
  # Ceci permet d'ouvrir ensuite les fichiers trouvés via le raccourci go de vim.
  # Le mode read-only évite d'écrire un fichier par accident (et en plus pas de .swp).

  keywords=$(echo "$@" | sed 's/ /.*/g' | sed 's:(:\\(:g'| sed 's:|:\\|:g' | sed 's:):\\):g')
  locate -ir "$keywords" | vim -R --not-a-term -

}

mcheat() { #{{{2
  emulate -LR zsh

  cheat "$1" | highlight -O xterm256 -S bash -s olive | less -iR

  # -i = --ignore-case, insensible à la casse lors de recherches
  # -R = --RAW-CONTROL-CHARS,
  #      nécessaire pour que less n'affiche pas les caractères de contrôle définissant les couleurs
  #      mais les envoie à l'émulateur de terminal qui les interprètera pour coloriser le texte

}

#  mkcd {{{2

# create directory and cd into it right away
mkcd() {
  emulate -LR zsh
  mkdir "$*" && cd "$*"
}

mountp() { #{{{2
  emulate -LR zsh

  # mount pretty ; fonction qui espace / rend plus jolie la sortie de la commande mount
  mount | awk '{ printf "%-11s %s %-26s %s %-15s %s\n", $1, $2, $3, $4, $5, $6 }' -

}

nstring() { #{{{2
  emulate -LR zsh

  # Description:
  # count the nb of occurrences of a substring `sub` inside a string `foo`.
  #
  # Usage:    nstring sub str

  grep -o "$1" <<< "$2" | wc -l
  #     │       │
  #     │       └── redirection ; `grep` only accepts filepaths, not a string
  #     └── --only-matching; print  only the matched (non-empty) parts of
  #                          a matching line, with each such part on a separate
  #                          output line

}

nv() ( #{{{2

# oNe Vim:    open files from any shell in a single Vim instance.
#
# How it should work:
#
#     - if no server, with the name VIM, is currently running, start one
#     - if there's one, and the function received arguments, send them to the server
#     - if there's one, but no arguments have been passed to the function, start
#       a new simple session (!=server)
#
# It should also support some default flags such as `-q` (populate qfl from
# file) and -o/-O (display each argument in a viewport).


# Usually, we surround the code of a function with `{}`, but here we use `()`.
# Why?
# Because inside the code, when `nv` receives the `-q` flag as an argument,
# we change the value of `IFS`. So if we do sth like:
#
#         nv -q 'grep -Rn foo *'
#
# … after populating the qfl of the Vim server, the value of `IFS` in the current
# shell will change from ' \t\n' to ' '. This can break many things.
# `()` will create a subshell, so no risk of affecting the current one.


  # NOTE: the function doesn't handle the case where we use a flag while no VIM
  # serve is running. I don't try to handle it, because it would probably
  # require a lot of code, and it's not sth I need.

  # check if a VIM server is running
  #
  # Why VIM?
  # That's the default name that Vim uses for the server name to connect to,
  # when we use the `--remote` option to open a file in a Vim server.
  # We can tell Vim we want to connect to an arbitrary server with
  # `--servername`, but by default it will use `--servername VIM`.
  #
  # We can exploit this: by using the servername `VIM`, we won't have to tell
  # Vim later which server we want to connect to.

  # if there IS a VIM server currently running …
  if vim --serverlist | grep -q VIM; then

    # … but `nv` didn't receive any argument
    if [[ $# -eq 0 ]]; then
      # … then start a new Vim session
      vim -w /tmp/.vimkeys

    # if `nv` received arguments, and the first is `-b`, we want to edit
    # a binary file (or several):
    #
    #     1. remove the first argument `-b` (`shift 1`)
    #
    #     2. send the file(s) to the server
    #
    #     3. enable 'binary' option, to let Vim know that it's going to edit
    #        binary file(s), and to prevent it from making some transformations
    #        which could damage them
    #
    #     4. give them the `xxd` filetype, to get some syntax highlighting
    #
    #     5. filter their contents into hexadecimal with the external `xxd` command
    elif [[ $1 == -b ]]; then
      shift 1
      vim --remote "$@"
      vim --remote-send ":argdo setl binary ft=xxd<cr>"
      vim --remote-send ":argdo %!xxd<cr><cr>"

    # if `nv` received arguments, and the first is `-d`, we have to compare the
    # other ones:
    #
    #         1. open a new tabpage in the Vim server
    #         2. send the other arguments to the Vim server
    #         3. display them in vertical viewports
    #         4. execute `:diffthis` on each buffer displayed in a window
    elif [[ $1 == -d ]]; then
      shift 1
      vim --remote-send ":tabnew<cr>"
      vim --remote "$@"
      vim --remote-send ":argdo vsplit<cr>:q<cr>"
      #                                    │
      #                                    └─ last file is displayed twice, because before executing `:argdo`,
      #                                       the last file was already displayed in a window;
      #                                       so close last window
      vim --remote-send ":windo diffthis<cr>"

    # if `nv` received arguments, and the first is `-o`, send the other ones to
    # the server, and display them in horizontal viewports
    elif [[ $1 == -o ]]; then

      shift 1
      vim --remote "$@"
      vim --remote-send ":argdo split<cr>:q<cr><cr>"

    # if `nv` received arguments, and the first is `-O`, send the other ones to
    # the server, and display them in vertical viewports
    elif [[ $1 == -O ]]; then
      shift 1
      vim --remote "$@"
      vim --remote-send ":argdo vsplit<cr>:q<cr><cr>"

    # if `nv` received arguments, and the first is `-p`, send the other ones to
    # the server, and display them in tabpages
    elif [[ $1 == -p ]]; then
      shift 1
      vim --remote "$@"
      vim --remote-send ":argdo tabedit<cr>:q<cr>"

    # if `nv` received arguments, and the first is `-q`, the remaining arguments
    # are part of a shell command whose output must be used to populate the qfl:
    #         nv -q 'grep -Rn foo *'
    #
    # NOTE: we should always use single quotes around the command, to prevent
    # the shell from expanding a possible glob, before the Vim function `system()`
    #
    # NOTE: this syntax is specific to `nv`:
    #
    #         vim -q 'grep -Rn foo *'     ✘
    #         vim -q <(grep -Rn foo *)    ✔

    elif [[ $1 == -q ]]; then

      shift 1

      # We assign the value ' ' to IFS, to be sure that when the shell will
      # expand `$*`, it will use a space to separate 2 consecutive arguments.
      # Indeed, by default, it uses the first character in IFS.
      #
      # And why do we use `$*` instead of `$@`?
      # Because the Vim `system()` function expects a single string as an
      # argument, not several:
      #
      #                      ┌─ first character in IFS
      #                      │
      #     "$*"    →    "$1c$2c…"
      #     "$@"    →    "$1" "$2" …
      IFS=' '
      vim --remote-send ":cexpr system('$*')<cr>"

    # if `nv` received arguments, but none of them was a flag, those are
    # filenames, so send them to the VIM server
    else
      vim --remote "$@"
    fi

  # finally, if there's no VIM server running, start one
  # record all the typed characters inside `/tmp/.vimkeys`, until we quit Vim
  else
    vim -w /tmp/.vimkeys --servername VIM "$@"
  fi
)

ppa_what_have_you() { #{{{2
  # FIXME:
  # create a completion function which would suggest files in /var/lib/apt/lists/
  awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' "$@"
}

# trigonometry {{{2

# Trigonometric functions (input is expected in degrees).
# For more formulas (in degrees or radians):
# http://advantage-bash.blogspot.fr/2012/12/trignometry-calculator.html
# TODO:
# Check whether these formulas are always correct.

sin() {
  emulate -LR zsh
  bc -l <<< "scale=5;s($1*0.017453293)"
}

cos() {
  emulate -LR zsh
  bc -l <<< "scale=5;c($1*0.017453293)"
}

tan() {
  emulate -LR zsh
  bc -l <<< "scale=5;s($1*0.017453293)/c($1*0.017453293)"
}

asin() {
  emulate -LR zsh
  if (( $(echo "$1 == 1" | bc -l) )) ; then
    echo "90"
  elif (( $(echo "$1 < 1" | bc -l) )) ; then
  bc -l <<< "scale=3;a(sqrt((1/(1-($1^2)))-1))/0.017453293"
  elif (( $(echo "$1 > 1" | bc -l) )) ; then
    echo "error"
  fi
}

acos() {
  emulate -LR zsh
  if (( $(echo "$1 == 0" | bc -l) )) ; then
    echo "90"
  elif (( $(echo "$1 <= 1" | bc -l) )) ; then
  bc -l <<< "scale=3;a(sqrt((1/($1^2))-1))/0.017453293"
  elif (( $(echo "$1 > 1" | bc -l) )) ; then
    echo "error"
  fi
}

atan() {
  emulate -LR zsh
  bc -l <<< "scale=3;a($1)/0.017453293"
}

# vc {{{2

vc() {
  emulate -LR zsh
  cd ~/.cheat; vim "$1"; cd - >/dev/null;
}

# Key Bindings {{{1
# S-Tab {{{2

# use S-Tab to cycle backward during a completion
# the shell doesn't seem to recognize the keysym `S-Tab`
# but when we press `S-Tab`, the terminal receives the keycodes `escape + [ + Z`
# so we use them in the lhs of our key binding
bindkey '\e[Z' reverse-menu-complete

# CTRL {{{2
# C-SPC      set-mark-command {{{3

bindkey '^ ' set-mark-command

# C-q        quote-big-word {{{3

# useful to quote a url which contains special characters
quote-big-word() {
  emulate -LR zsh
  zle set-mark-command
  zle vi-backward-blank-word
  zle quote-region

  # Alternative:
  #
  #   RBUFFER+="'"
  #   zle vi-backward-blank-word
  #   LBUFFER+="'"
  #   zle vi-forward-blank-word
}
zle -N quote-big-word
#    │
#    └─ -N widget [ function ]
#       Create a user-defined widget. When the new widget is invoked
#       from within the editor, the specified shell function is called.
#       If no function name is specified, it defaults to the same name as the
#       widget.
bindkey '^Q' quote-big-word

# C-u        backward-kill-line {{{3

# By default, C-u deletes the whole line (kill-whole-line).
# I prefer the behavior of readline which deletes only from the cursor till the
# beginning of the line.
bindkey '^U' backward-kill-line

# C-x        (prefix) {{{3
# C-x SPC         magic-space {{{4
# perform history expansion
bindkey '^X ' magic-space

# C-x C-a/d/f     fasd {{{4

# we can't bind the `magic-space` widget to the space key, because we use the
# latter for `expand-abbrev`

bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)
bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)

# C-x C-e         edit-command-line {{{4

# edit the command line in $EDITOR with C-x C-e like in readline
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# C-x C-t         fzf-file-widget {{{4
#
# By default, `fzf` rebinds `C-t` to one its function `fzf-file-widget`
# It overrides the shell transpose-chars function.
# We restore it, and rebind the fzf function to `C-x C-t`.

bindkey '^X^T' fzf-file-widget
bindkey '^T' transpose-chars

# C-x C-r         re-source zshrc {{{4

reread_zshrc() {
  emulate -LR zsh
# FIXME:
# The redirections in the following command, and all the explanation shouldn't
# be need in the next release of `zsh`. Remove the redirections and the
# comments after updating `zsh`?
#     https://github.com/zsh-users/zsh/commit/4d007e269d1892e45e44ff92b6b9a1a205ff64d5#diff-c47c7c7383225ab55ff591cb59c41e6b
#
#                      ┌ redirect stdin from /dev/null
#            ┌─────────┤
  . "${HOME}"/.zshrc < /dev/null 2> /dev/null
#                        └──────────┤
#                                   └ redirect possible error messages to
#                                   /dev/null
#
# Why those redirections?{{{
#
# They prevent  the `stty`  and `dircolors` commands,  sourced in  `~/.shrc`, to
# complain.
#
# `zsh` closes the stdin of a `zle` widget to avoid the commands it executes to
# interfere with user input. So, initially, the stdin of `reread_zshrc()` is
# closed. Because of this, the next command won't have the terminal as its
# stdin. Instead, its stdin will be the first file it opens.
# The 1st file opened by `dircolors` will be `~/.dircolors`. So, the stdin of
# `dircolors` should be `~/.dircolors`.
#
# Pb: as soon as `dircolors` opens `~/.dircolors`, it IS its stdin.
# So, `dircolors` tries to make `~/.dircolors` its stdin while it has already
# been done. It raises the error:
#
#         dircolors: /home/user/.dircolors: Bad file descriptor
#
# For the `stty` command, the problem is simpler. `stty` expects an input, but
# `zsh` has closed the terminal. The error message is similar:
#         stty: 'standard input': Bad file descriptor
#
# TODO:
# I think the whole issue has been fixed in recent versions of zsh.
# Update zsh, and if it's fixed, remove this whole comment.
#
# For more info:
#         https://unix.stackexchange.com/a/370506/232487
#}}}
}
zle -N reread_zshrc
bindkey '^X^R' reread_zshrc

# C-x C-s         reexecute-with-sudo {{{4
#
# re-execute last command with higher privileges
#
#                       ┌─ preserve some variables in current environment
#                       │
bindkey -s '^X^S' 'sudo -E PATH=$PATH bash -c "!!"^M'
#                         │
#                         └─ make sure `PATH` is preserved, in case `-E` didn't
#
# Alternative:
#     bindkey -s '^Xs' 'sudo !!^M'
#
# The 1st command is more powerul, because it should escalate the privilege for
# the whole command line. Sometimes, `sudo` fails because it doesn't affect
# a redirection.

# C-x c           snippet-compare {{{4

# Quickly compare the output of 2 commands.
# Useful when we want to see the effect of a flag/option on a command,
# or the difference between 2 similar commands (df vs dfc).
# Mnemonics: c for compare

# NOTE:
# It seems we can't bind anything to `C-x C-c`, because `C-c` is interpreted as
# an interrupt signal sent to kill the foreground process. Even if hit after `C-x`.
# It's probably done by the terminal driver. Maybe we could disable this with
# `stty` (the output of `stty -a` contains `intr = ^C`), but it wouldn't be
# wise, because it's too important. We would need to find a way to disable it
# only after `C-x`.
bindkey -s '^Xc' 'vimdiff <() <()\e5^B'
#        │
#        └── interpret the arguments as strings of characters
#            without `-s`, `vimdiff` would be interpreted as the name of a zle widget

# C-x r           snippet-rename {{{4

bindkey -s '^Xr' '^A^Kfor f in *; do mv \"$f\" \"${f}\";done\e7^B'

# C-z        fancy-ctrl-z {{{3
#
# Hit `C-z` to temporarily discard the current command line.
# If the command line is empty, instead, resume execution of the last paused
# background process, so that we can put a running command in the background
# with 2 `C-z`.
#
# https://unix.stackexchange.com/a/10851/232487
fancy-ctrl-z () {
  # `emulate -R zsh` resets all the options to their default value, which can be
  # checked with:
  #               ┌─ current environment
  #               │         ┌─ reset environment
  #               │         │
  #     vimdiff <(setopt) <(emulate -R zsh; setopt)
  #
  # `emulate -L` makes the new values local to the current function, which
  # prevents the changes to affect the current interactive `zsh` session.
  #
  # Here, we don't need this command, however it can be a good habit to include it.
  # https://unix.stackexchange.com/a/372866/232487
  emulate -LR zsh

  # if the current line is empty …
  if [[ $#BUFFER -eq 0 ]]; then
  #     │
  #     └─ size of the buffer
    bg
    # … redisplay the edit buffer (to get rid of a message)
    zle redisplay
    # Without `zle redisplay`, when we hit `C-z` while the command line is empty,
    # we would always have an annoying message:
    #
    #     if there's a paused job:
    #             [1]    continued  sleep 100
    #
    #     if there's no paused job:
    #             fancy-ctrl-z:bg:18: no current job
  else
    # Push the entire current multiline construct onto the buffer stack.
    # If it's only a single line, this is exactly like `push-line`.
    # Next time the editor starts up or is popped with `get-line`, the construct
    # will be popped off the top of the buffer stack and loaded into the editing
    # buffer.
    zle push-input
  fi
}
zle -N fancy-ctrl-z
# NOTE:
# This  key  binding  won't prevent  us  to  put  a  foreground process  in  the
# background. When  we hit  `C-z` while  a process  is in  the foreground,  it's
# probably the terminal driver which intercepts the keystroke and sends a signal
# to the process to  pause it. In other words, `C-z` should  reach `zsh` only if
# no process has the control of the terminal.
bindkey '^Z' fancy-ctrl-z

# META {{{2
# M-#       pound-insert {{{3
bindkey '\e#' pound-insert

# M-e       run-help {{{3
#
# from `type run-help`:    run-help is an autoload shell function
# it's an alias to `man` that will look in other places before invoking man
#
# by default it's bound to `M-h`, but use this key to move between tmux windows
# so rebind it to `M-e` instead
bindkey '\ee' run-help

# M-o       previous-directory {{{3
# cycle between current dir and old dir
previous-directory() {
  emulate -LR zsh
  # contrary to bash, zsh sets `$OLDPWD` immediately when we start a shell
  # so, no need to check it's not empty
  builtin cd -
  # refresh the prompt so that it reflects the new working directory
  zle reset-prompt
}
zle -N previous-directory
bindkey '\eo' previous-directory

# M-c/l/u   change-case {{{3

# zle provides several functions to modify the case of a word:
#
#         • m-c    capitalize
#         • m-l    downcase
#         • m-u    upcase
#
# Unfortunately, we can't use some of them because they're already used in tmux / fzf.
# So, we want to use `M-u` as a prefix to change the case of a word.
# We start by removing the default key binding using `M-u` to upcase a word.
bindkey -r '\eu'

# M-u c
# upcase a word (by default it's M-c)
bindkey '\euc' capitalize-word

# M-u l
# downcase a word (by default it's M-l)
bindkey '\eul' down-case-word

# M-u u
# upcase a word (by default it's M-u)
bindkey '\euu' up-case-word

# TODO:
# Try to emulate a “submode” so that it's easier to repeat these mappings.
# We could press `M-u` to enter the submode, then, for a brief period of time,
# `c`, `l` or `u` would change the case of words.

# M-Z       fuzzy-select-output {{{3

# insert an entry from the output of the previous command,
# selecting it with fuzzy search
bindkey -s '\eZ' '$(!!|fzf)'

# CTRL-META {{{2
# C-M-e      expand-aliases {{{3

# TODO:
# fully explain the `expand-aliases` function
#
#     https://unix.stackexchange.com/a/150737/232487
#     https://unix.stackexchange.com/a/372865/232487
#     man zshexpn     →  PARAMETER EXPANSION       →  ${+name}
#     man zshmodules  →  THE ZSH/PARAMETER MODULE  →  functions
#
# functions
#
#        This  associative  array  maps names of enabled functions to their
#        definitions. Setting a key in it is like defining a function with the
#        name given by the key and the body given by the value.  Unsetting  a
#        key removes the definition for the function named by the key.

expand-aliases() {
  emulate -LR zsh
  unset 'functions[_expand-aliases]'
  # We put the current command line into `functions[_expand-aliases]`
  functions[_expand-aliases]=$BUFFER
  #     alias ls='ls --color=auto'
  #     alias -g V='|vipe'
  #     functions[_expand-aliases]='ls V'
  #     echo $functions[_expand-aliases]          →  ls --color=auto | vipe
  #     echo $+functions[_expand-aliases]         →  1
  #    (($+functions[_expand-aliases])); echo $?  →  0

  # this command does 3 things, and stops as soon as one of them fails:
  #     check the command is syntactically valid
  #     set the buffer
  #     set the position of the cursor
  (($+functions[_expand-aliases])) &&
    BUFFER=${functions[_expand-aliases]#$'\t'} &&
    CURSOR=$#BUFFER
}

zle -N expand-aliases
bindkey '\e^E' expand-aliases
#        │
#        └─ C-M-e

# MENUSELECT {{{2

# to install the next key bindings, we need to load the `complist` module
# otherwise the `menuselect` keymap won't exist
zmodload zsh/complist
# │
# └─ load a given module

# `zmodload`    prints the list of currently loaded modules
# `zmodload -L` prints the same list in the form of a series of zmodload commands

# use vi-like keys in menu completion
bindkey -M menuselect 'h' backward-char
#        │
#        └─ selects the `menuselect` keymap
#
#           `bindkey -l` lists all the keymap names
#            for more info: man zshzle
bindkey -M menuselect 'l' forward-char
# Do NOT write this:
#         bindkey -M menuselect '^J' down-line-or-history
#
# It works in any terminal, except one opened from Vim.
# The latter doesn't seem able to  distinguish `C-m` from `C-j`. At least when a
# completion menu is  opened. Because of that, when we would  hit Enter/C-m, Vim
# would move the cursor down, instead of selecting the current entry.
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect '^J' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect '^K' up-line-or-history

bindkey -M menuselect 'b' backward-char
bindkey -M menuselect 'B' backward-char
bindkey -M menuselect 'e' forward-char
bindkey -M menuselect 'E' forward-char
bindkey -M menuselect 'w' forward-char
bindkey -M menuselect 'W' forward-char

bindkey -M menuselect '^' beginning-of-line
bindkey -M menuselect '_' beginning-of-line
bindkey -M menuselect '$' end-of-line

bindkey -M menuselect 'gg' beginning-of-history
bindkey -M menuselect 'G'  end-of-history

# TODO: How to repeat a zle function?{{{
#
# bindkey -M menuselect '^D'  5 down-line-or-history    ✘
#
#     fast-down-line-or-history() {
#       zle down-line-or-history
#     }
#     zle -N fast-down-line-or-history
#     bindkey -M menuselect '^D'  fast-down-line-or-history
#
# Actually, the problem comes from the `menuselect` keymap.
# We can't bind any custom widget in this keymap:
#
#     some-widget() {
#       zle end-of-history
#     }
#     zle -N some-widget
#     bindkey -M menuselect 'G' some-widget
#
#
# G will insert G instead of moving the cursor on the last line of the
# completion menu.
#
# Read:
# man zshmodules (section `Menu selection`)
# }}}

bindkey -M menuselect '^O' accept-and-menu-complete
#                          │
#                          └─ insert the current completion into the buffer,
#                             but don't close the menu

# In Vim we quit the completion menu with C-q (custom).
# We want to do the same in zsh (by default it's C-g in zsh).
bindkey -M menuselect '^Q' send-break

# Options {{{1

# Let us `cd` into a directory just by typing its name, without `cd`:
#     my_dir/  ⇔  cd my_dir/
#
# Only works when `SHIN_STDIN` (SHell INput STanDard INput) is set, i.e. when the
# commands are being read from standard input, i.e. in interactive use.
#
# Works in combination with `CDPATH`:
#     % cd /tmp
#     % Downloads
#     % pwd
#     ~/Downloads/
#
# Works with completion:
#     % Do Tab
#     Documents/  Downloads/
setopt AUTO_CD

# allow the expansion of `{a..z}` and `{1..9}`
setopt BRACE_CCL

# don't allow a `>` redirection to overwrite the contents of an existing file
# use `>|` to override the option
# setopt NO_CLOBBER

# Try to correct the spelling of commands. The shell variable CORRECT_IGNORE may
# be set to a pattern to match words that will never be offered as corrections.
setopt CORRECT

# Whenever a command  completion or spelling correction is  attempted, make sure
# the  entire command  path  ($PATH?)  is hashed  first.  This  makes the  first
# completion slower but avoids false reports of spelling errors.
setopt HASH_LIST_ALL

# infinite history in zsh
#
# https://unix.stackexchange.com/a/273863

export HISTFILE="$HOME/.zsh_eternal_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# FIXME:
# there's no `HISTIGNORE` option in zsh, to ask some commands to be excluded
# from the history
#
# solution 1:
# zsh provides a hook function preexec that can be used for that, if it returns
# non-zero the command is not saved in history
#
# solution 2:
# alias the commands to have a space in front, maybe something like:
#     for c in (ls fg bg jobs exit clear reset); do alias $c=" $c"; done

# allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS

# display PID when suspending processes as well
setopt LONG_LIST_JOBS

# On an ambiguous completion, instead of listing possibilities,
# insert the first match immediately.
# This makes us enter the menu in a single Tab, instead of 2.
setopt MENU_COMPLETE

# Do not query the user before executing `rm *` or `rm path/*`
setopt RM_STAR_SILENT

# Abbreviations {{{1
# DON'T MOVE ABBREVIATIONS BEFORE KEY BINDINGS
#
# … because in the `key bindings` section we execute `bindkey -e`
# and it seems to break abbreviations (maybe because it removes the space key
# binding?)

# http://zshwiki.org/home/examples/zleiab

#        ┌─ `abbrev` refer to an associative array parameter
#        │
declare -Ag abbrev
#         │
#         └─ don't restrict to local scope

abbrev=(
  # column
  "Jc"    "| awk '{ print $"
  "Jn"    "2>/dev/null"
  "Jt"    "| tail -20"
  "Jv"    "vim -u NONE -U NONE -N -i NONE"
)

abbrev-expand() {
  emulate -LR zsh
  # In addition to the characters `*(|<[?`, we also want `#` to be regarded as a
  # pattern for filename generation.
  setopt EXTENDED_GLOB

  # make the `MATCH` parameter local to this function, otherwise,
  # it would pollute the shell environment with the last word before hitting
  # the last space
  local MATCH

  #                ┌─ remove longest suffix matching the following pattern
  #                │
  #                │   ┌─ populates `$MATCH` with the suffix removed by `%%`
  #                │   │  for more info:    man zshexpn, filename generation
  LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
  #                                  │
  #                                  └─ matches 0 or more of the previous pattern (word character)
  #                                  for more info:    man zshexpn, filename generation
  #
  #                                  NOTE:
  #                                  contrary to most regex engines, for `zsh`,
  #                                  `*` is not a quantifier:
  #                                  in a classical regex, it would match the pattern `.*`

  LBUFFER+=${abbrev[$MATCH]:-$MATCH}
  #        │
  #        └─ expands into:
  #        is `abbrev[$MATCH]` set, or non-null?
  #
  #            yes  →  abbrev[$MATCH]
  #            no   →         $MATCH
  #
  # For more info, man zshexpn:    ${name:-word}

  if [[ $MATCH = 'Jc' ]]; then
    RBUFFER="'}"
    # FIXME:
    # we want the cursor to be right after the `$` sign in:
    #     awk '{ print $ }'
    #
    # but `zsh` inserts a space before the cursor, no matter the value we give
    # to `CURSOR`. How to avoid this?
    # CURSOR=$(($#LBUFFER))
    # NOTE:
    # by default, CURSOR=$#LBUFFER
  fi

  # we need to insert the key we've just typed (here space), otherwise,
  # we wouldn't be able to insert a space anymore
  zle self-insert
  #   │
  #   └─ run the `self-insert` widget to insert a character into the buffer at
  #   the cursor position (man zshzle)
}

# define a widget to expand when inserting a space
zle -N abbrev-expand
# bind it to the space key
bindkey ' ' abbrev-expand

# When searching in the history with default `C-r` or `C-s`, we don't want
# a space to expand an abbreviation, just to insert itself.
# We don't have this problem because we use `fzf` which rebinds those keys.
# However, we still disable abbreviation expansion in a search:
bindkey -M isearch ' ' self-insert
#        │
#        └─ man zshzle: this key binding will only take effect in a search
#
# NOTE:
# To test the influence of this key binding, uncomment next key binding, and
# move it at the end of `~/.zshrc`:
#     bindkey "^R" history-incremental-search-backward
#
# It restores default `C-r`.
#
# Without the previous:
#     bindkey -M isearch " " self-insert
#
# … as soon as we would type a space in a search, we would leave the latter and
# go back to the regular command line.

# Various {{{1

# normalize-command-line () {
#   functions[__normalize_command_line_tmp]=$BUFFER
#   BUFFER=${${functions[__normalize_command_line_tmp]#$'\t'}//$'\n\t'/$'\n'}
#   ((CURSOR == 0 || CURSOR == $#BUFFER))
#   unset 'functions[__normalize_command_line_tmp]'
# }
# zle -N normalize-command-line
# bindkey '\eo' normalize-command-line


# TODO: fully document (and rename function?)
# Idea: improve the function so that it opens the completion menu,
# this way we could cd into any directory (without `cd`, thanks to `AUTOCD`).
#
# expand-or-complete-or-list-files
# https://unix.stackexchange.com/a/32426/232487
function expand-or-complete-or-list-files() {
  emulate -LR zsh
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls "
    CURSOR=3
    zle list-choices
    zle backward-kill-word
  else
    # FIXME:
    # why doesn't `s-tab` cycle backward?
    zle reverse-menu-complete
    # if I replace `reverse-menu-complete` with `backward-kill-word`,
    # `zle` deletes the previous word as expected, so why doesn't
    # `reverse-menu-complete` work as expected?
    #
    # It seems that `reverse-menu-complete` is unable to detect that a menu
    # completion is already in progress. Therefore, it simply tries to COMPLETE
    # the entry selected in the menu, instead of cycling backward.
  fi
}

# bind to s-tab
#   zle -N expand-or-complete-or-list-files
# FIXME:
# Currently, this binding  breaks the behavior of `s-tab` when  we cycle through
# the candidates of a completion menu.
#   bindkey '\e[Z' expand-or-complete-or-list-files

# Syntax highlighting {{{1

# customize default syntax highlighting
# zle_highlight=(paste:fg=yellow,underline region:fg=yellow suffix:bold)
#              │                         │                │                                   v
#              │                         │                └── some suffix characters (Document/)
#              │                         └── the region between the cursor and the mark       ^
#              └── what we paste with C-S-v

# Source the plugin `zsh-syntax-highlighting`:
#     https://github.com/zsh-users/zsh-syntax-highlighting

# It must be done after all custom widgets have been created (i.e., after all zle -N calls).
# because the plugin creates a wrapper around each of them.
# If we source it before some custom widgets, it will still work, but won't be
# able to properly highlight the latter.

. ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Choose which highlighters we want to enable:
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
# Warning: don't enable the `cursor` highlighter, because it doesn't seem to
# play nicely with `brackets`. The readline motions (M-b, M-f), and the editing
# become weird.

# The configuration of the plugin is written in an associative array,
# stored in a variable called `ZSH_HIGHLIGHT_STYLES`.
# Declare the latter
declare -A ZSH_HIGHLIGHT_STYLES

##################################
# Styles from `main` highlighter #
##################################

# we want some tokens to be colored in black, so that they're readable with
# a light palette
# FIXME:
# rewrite this block of lines with a `for` loop to avoid repetition,
# and to provide future scaling if we need to apply the same style (`fg=black`)
# to other tokens
#
# FIXME:
# When completing an argument (ex: echo d Tab), the argument is white.
# I've tried all available token, none seems to allow me to change this color to
# black. Ask how to do it on the bug tracker of the zsh plugin.
#
# myvar=123
ZSH_HIGHLIGHT_STYLES[assign]='fg=black'
# `backtick expansion`
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=black'
# command separators (; && …)
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=black'
ZSH_HIGHLIGHT_STYLES[default]='fg=black'
# **/*.txt
ZSH_HIGHLIGHT_STYLES[globbing]='fg=black'
# echo foo >file
ZSH_HIGHLIGHT_STYLES[redirection]='fg=black'
# short and long options (ex: -o, --long-option)
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=black'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=black'


# We can use decimal code colors from this link:
#
#     https://jonasjacek.github.io/colors/
#
# We want some tokens colored in yellow by default, to be bold and more
# readable on a light palette:
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=137,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=137,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=137,bold'



# differentiate aliases and functions from other types of command
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta,underline'

# have valid paths colored
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# The `main` highlighter recognizes many other tokens.
# For the full list, read:
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md

######################################
# Styles from `brackets` highlighter #
######################################

# Define the styles for nested brackets up to level 4.
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=202,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=green,bold'
# test it against this command:
#
#     echo (foo (bar (baz (qux))))

#####################################
# Styles from `pattern` highlighter #
#####################################

# Color in red commands beginning with some chosen pattern:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
# This works because we enabled the `pattern` highlighter.
# The syntax of the assignment is:
# ZSH_HIGHLIGHT_PATTERNS+=('shell cmd' 'style')
#                           │           │
#                           │           └── 2nd string
#                           └── 1st string

# Here are some more configurations, that are commented because they're already
# enabled by default; change them as you see fit:
#
#                                   ┌── ✘ FIXME: don't work when we change the value to `bg=blue`; why?
#                                   │            maybe because the appearance of the cursor is overridden by urxvt
#     ZSH_HIGHLIGHT_STYLES[cursor]='standout'
#     ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
#     ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
#     ZSH_HIGHLIGHT_STYLES[line]='bold'      # require the `line` highlighter to be enabled
#     ZSH_HIGHLIGHT_STYLES[root]='bg=red'
#
# For the root highlighter to work, we must write the 3 following lines in
# /root/.zshrc (as root obviously):
#
#     . $HOME/GitRepos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#     ZSH_HIGHLIGHT_HIGHLIGHTERS=(main root)
#     ZSH_HIGHLIGHT_STYLES[root]='bg=red'
