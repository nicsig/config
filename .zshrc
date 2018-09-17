# noa vim //gj /home/jean/Dropbox/conf/bin/**/*.sh ~/.shrc ~/.bashrc ~/.zshrc ~/.zshenv ~/.vim/plugged/vim-snippets/UltiSnips/sh.snippets | cw
#         ^
#         put whatever pattern you want to refactor


# TODO:
# Make sure to never abuse the `local` keyword.
# Remember the issue we had created in `gifrec.sh`.
# Note that the variables  set by a script should not  affect the current shell,
# because the script is executed in a subshell.
# So, is it recommended to use `local` in the functions of a script?
#
# Update:
# The google style guide recommends to always use them.
# Maybe  we should  re-use `local`  in `gifrec.sh`,  and pass  the variables  as
# arguments between functions...
# What about `VERSION` inside `upp.sh`? Should we make this variable local?
#
# Update:
#

# TODO:
# review `printf` everywhere  (unnecessary double quotes, extract interpolations
# using %s items, replace a multi-line printf with a here-doc ...)

# TODO: improve our scripts by reading:
#
#     http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
#
# Also, have a look at `bashmount`:
#
#     https://github.com/jamielinux/bashmount
#     https://www.youtube.com/watch?v=WaYZ9D7sX4U

# TODO:
# To document in our notes:
#
#     https://unix.stackexchange.com/a/88851/289772

# TODO:
# Do these substitutions:
#
#     ~ → ${HOME}
#
#     [ ... ] → [[ ... ]] (noa vim /\s\[\s/gj ~/bin/**/*.sh | cw)
#
#     "${HOME}"/file → "${HOME}/file"

# TODO:
# Search for `HOME` in zshrc/bashrc.
# Should we quote all the time?
# Example:
#
#            v                            v v                                 v
#     fpath=("${HOME}/.zsh/my-completions/" "${HOME}/.zsh/zsh-completions/src/" $fpath)
#                                                                               ^^^^^^
#                                                                               what about that?
#                                                                               ${fpath}?
#                                                                               "${fpath}"?
# Example:
#
#     [[ -f "${HOME}/.fzf.zsh" ]] && . "${HOME}/.fzf.zsh"
#           ^                ^
#
# Example:
#
#     export CDPATH=:"${HOME}":/tmp
#                    ^       ^
#
# See:
#     https://unix.stackexchange.com/a/68748/289772


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
# When we clone a git repo, it would be useful to automatically cd into it.
# Install a hook to do that.
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
#
# Also read this:
#
#     https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/regexp.md

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
# check that none of our alias can shadow a future command from the repos:
#     apt-file update
#     apt-file -x search '/myalias$'

# TODO:
# understand: https://unix.stackexchange.com/questions/366549/how-to-deal-with-filenames-containing-a-single-quote-inside-a-zsh-completion-fun

# TODO:
# To read:
# https://github.com/sindresorhus/pure (≈ 550 sloc, 2 fichiers: pure.zsh, async.zsh)

# How to use one of the custom prompts available by default?{{{
#
# initialize the prompt system
#
#     autoload -Uz promptinit
#     promptinit
#
# To choose a theme, use these commands:
#
#     ┌─────────────────────┬──────────────────────────┐
#     │ prompt -l           │ list available themes    │
#     ├─────────────────────┼──────────────────────────┤
#     │ prompt -p           │ preview available themes │
#     ├─────────────────────┼──────────────────────────┤
#     │ prompt <your theme> │ enable a theme           │
#     ├─────────────────────┼──────────────────────────┤
#     │ prompt off          │ no theme                 │
#     └─────────────────────┴──────────────────────────┘
#}}}
# Why a newline in the prompt?{{{
#
# It's easier to copy-paste a command,  without having to remove a possible long
# filepath.
#}}}

# ┌ set left prompt{{{
# │
# │   man zshzle
# │   > CHARACTER HIGHLIGHTING
# │
# │  ┌ set the color to blue
# │  │
# │  │   man zshmisc
# │  │   > SIMPLE PROMPT ESCAPES
# │  │   > Shell state
# │  │
# │  │       ┌ current workding directory (but replace $HOME by a tilde)
# │  │       │
# │  │       │   man zshparam
# │  │       │   > PARAMETERS USED BY THE SHELL
# │  │       │
# │  │       │ ┌ reset the color
# │  │       │ │
# │  │       │ │         ┌ Add an indicator showing whether the last command succeeded ($?):
# │  │       │ │         │
# │  │       │ │         │     man zshmisc
# │  │       │ │         │     > CONDITIONAL SUBSTRINGS IN PROMPTS
# │  │       │ │         │
# │  ├──────┐├┐├┐        ├─────────┐}}}
PS1='%F{blue}%~%f %F{red}%(?..[%?] )%f
$ '
# How does `%(?..[%?] )` work?{{{
#
# The syntax of a conditional substring in a prompt is:
#
#     %(x.true-text.false-text)
#       │ │        ││
#       │ │        │└ text to display if the condition is false
#       │ │        │
#       │ │        └ separator between the 3 tokens
#       │ │          (it can be any character which is not in `true-text`)
#       │ │
#       │ └ text to display if the condition is true
#       │
#       └ test character (condition)
#         it can be preceded by any number to be used during the evaluation of the test
#         Example:
#
#             123?  ⇔  was the exit status of the last command 123?
#
# So:
#
#     $(?..[%?] )
#       │├┘├───┘
#       ││ └ otherwise display the exit status (`%?`),
#       ││   surrounded by brackets, and followed by a space
#       ││
#       │└ if the condition was true, display nothing
#       │
#       └ was the exit status of the last command 0?
#         (without any number, zsh assumes 0)
#}}}

# What's `fpath`?{{{
#
# An array (colon separated list) of  directories specifying the search path for
# function definitions.
# This path is searched when a function with the `-u` attribute is referenced.
#}}}
# Why do I have to set `fpath` before invoking the `compinit` function?{{{
#
# Any change to `fpath` after `compinit` has been invoked won't have any effect.
#}}}
# Why do I have to put my completion functions at the very beginning of `fpath`?{{{
#
# To override any possible conflicting function (a default one, or coming from a
# third-party plugin).
#}}}
#                                   ┌ additional completion definitions,
#                                   │ not available in a default installation,
#                                   │ useful for virtualbox
#                                   ├───────────────────────────────┐
fpath=(${HOME}/.zsh/my-completions/ ${HOME}/.zsh/zsh-completions/src/ $fpath)

# Add completion for the `dasht` command:
#
#     https://github.com/sunaku/dasht
fpath+=${HOME}/GitRepos/dasht/etc/zsh/completions/

# Use modern completion system
autoload -Uz compinit
#         ││{{{
#         │└ from `man zshbuiltins`:
#         │  mark the function to be autoloaded using the zsh style,
#         │  as if the option KSH_AUTOLOAD was unset
#         │
#         └ from `man zshmisc`:
#           suppress usual alias expansion during reading
#
# according to `run-help autoload`,   `autoload`   is equivalent to `functions -u`
#                                                                          │
#                                                                          └ autoload flag
# according to `run-help functions`,  `functions`  is equivalent to `typeset -f`
#                                                                        │
#                                                                        └─ refer to function
#                                                                           rather than parameter
#
# according to `run-help typeset`,    `typeset`    sets or displays attributes and
#                                                  values for shell parameters}}}
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
# FIXME: comment to develop by reading `man zshcontrib`
# (how to use it?, how it works?)
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

autoload -Uz zmv
autoload -Uz zrecompile

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
# Necessary to be able to move in a completion menu:
#
#     bindkey -M menuselect '^L' forward-char
zstyle ':completion:*' menu select
# enable case-insensitive search (useful for the `zaw` plugin)
zstyle ':filter-select' case-insensitive yes
# Suggest us only video files when we tab complete `$ mpv`.
#
# TODO: To explain.
# Source:
#     https://github.com/mpv-player/mpv/wiki/Zsh-completion-customization
zstyle ':completion:*:*:mpv:*' file-patterns '*.(#i)(flv|mp4|webm|mkv|wmv|mov|avi|mp3|ogg|wma|flac|wav|aiff|m4a|m4b|m4v|gif|ifo)(-.) *(-/):directories' '*:all-files'

# Use emacs keybindings even if our EDITOR is set to vi.
# Warning:{{{
#
# Don't move this line after the `Sourcing` section.
# It would reset `fzf` key bindings.
#
# Don't move it after the `Abbreviations` section either.
# It would break them too (maybe because it removes the space key binding?).
#}}}
bindkey -e

# disable XON/XOFF flow control
# Why?{{{
#
# By default, `C-s` and `C-q`  are interpreted by the terminal driver as
# “stop sending data“, “continue sending“.
#
# Explanations:
#         http://unix.stackexchange.com/a/12108/125618
#         http://unix.stackexchange.com/a/12146/125618
#         http://unix.stackexchange.com/a/72092/125618
#         https://en.wikipedia.org/wiki/Software_flow_control
#}}}
stty -ixon


# don't move `Plugins` after syntax highlighting
# Plugins {{{1

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

if [[ ! -f ${HOME}/bin/fasd ]]; then
  curl -sL 'https://raw.githubusercontent.com/clvv/fasd/master/fasd' -o "${HOME}/bin/fasd"
  chmod +x "${HOME}/bin/fasd"
fi

fasd_cache="${HOME}/.fasd-init-zsh"
if [[ "$(command -v fasd)" -nt "${fasd_cache}" || ! -s "${fasd_cache}" ]]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install >| "${fasd_cache}"
fi
. "${fasd_cache}"
unset fasd_cache


# source fzf config
[[ -f ${HOME}/.fzf.zsh ]] && . "${HOME}/.fzf.zsh"

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
[[ -f ${HOME}/.zsh/plugins/zaw/zaw.zsh ]] && . "${HOME}/.zsh/plugins/zaw/zaw.zsh"

# Why?{{{
#
# When we try to cd into a directory:
#
#     • the completion menu offered by this plugin is more readable
#       than the default one (a single column instead of several)
#
#     • we don't have to select an entry which could be far from our current position,
#       instead we can fuzzy search it via its name
#}}}
[[ -f ${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]] && \
. "${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh"

# source our custom aliases and functions (common to bash and zsh) last
# so that they can override anything that could have been sourced before
[[ -f ${HOME}/.shrc ]] && . "${HOME}/.shrc"

# Aliases {{{1
# regular {{{2
# aptitude {{{3

# TODO: to remove?
alias kff='killall ffmpeg 2>/dev/null'

alias api='sudo aptitude install'
alias app='sudo aptitude purge'
alias aps='aptitude show'

# bc {{{3

alias bc='bc -q -l'
#             │  │
#             │  └ load standard math library (to get more accuracy, and some functions)
#             │
#             └ do not print the welcome message

# bookmarks {{{3

alias bookmarks='vim +"setl nowrap" ~/.config/surfraw/bookmarks'

# cd {{{3

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# df {{{3

alias df=dfc

# dl {{{3

alias dl_mp3='youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s"'
alias dl_pl='youtube-dl --write-sub --sub-lang en,fr --write-auto-sub -o "%(autonumber)02d - %(title)s.%(ext)s"'

alias dl_sub_en='subliminal download -l en'
alias dl_sub_fr='subliminal download -l fr'

alias dl_video='youtube-dl --write-sub --sub-lang en,fr --write-auto-sub -o "%(title)s.%(ext)s"'

# fasd {{{3

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

# grep {{{3

alias grep='grep --color=auto'

# ls {{{3

alias ls='ls --color=auto'
alias l=ls++

# mpv {{{3

# start `mpv` in “keybindings testing mode”
alias mpv_test_keybinding='mpv --input-test --force-window --idle'
#                                │            │              │{{{
#                                │            │              └ don't quit immediately,
#                                │            │                even though there's no file to play
#                                │            │
#                                │            └ create a video output window even if there is no video
#                                │
#                                └ when I press a key, don't execute the bound command,
#                                instead, display the name of the key on the OSD;
#                                useful when you're crafting a key binding
#}}}

# ranger {{{3

alias fm='[[ -n "${TMUX}" ]] && tmux rename-window fm; python ~/GitRepos/ranger/ranger.py -d'

# sudo {{{3

# Why?{{{
#
# Suppose you have an alias `foo`.
# You want to execute it with `sudo`:
#
#     # ✘
#     $ sudo foo
#
# It won't  work because the shell  doesn't check for an alias  beyond the first
# word.
# The solution is given in `man bash` (/^ALIASES):
#
#      If  the last  character of  the alias  value is  a blank,  then the  next
#      command word following the alias is also checked for alias expansion.
#
# By creating the alias  `alias sudo='sudo '`, we make sure  that when the shell
# will  expand  the alias  `sudo`  in  `sudo foo`,  the  last  character of  the
# expansion will be a blank.
# This  will cause the shell  to check the next  word for an alias,  and make it
# expand `foo`.
#
# See also:
#
#     https://askubuntu.com/a/22043/867754
#}}}
alias sudo='sudo '

# tlmgr_gui {{{3

alias tlmgr_gui='tlmgr gui -font "helvetica 20" -geometry=1920x1080-0+0 >/dev/null 2>&1 & disown'

# top {{{3

alias top='htop'

# trash {{{3

alias te='trash-empty'

alias tl='trash-list'

alias tp='trash-put'

# TRash Restore
alias trr='rlwrap restore-trash'

# xbindkeys {{{3

alias xbindkeys_restart='killall xbindkeys && xbindkeys -f "${HOME}"/.config/xbindkeysrc &'

# zsh_sourcetrace {{{3

# get the list of files sourced by zsh
alias zsh_sourcetrace='zsh -o sourcetrace'
#                           ├────────────┘
#                           └ start a new zsh shell, enabling the 'sourcetrace' option
#                             see `man zshoptions` for a description of the option

# global {{{2

# We could implement the following global aliases as abbreviations, but we won't
# because they can only be used at the end of a command.
# To be expanded, an abbreviation needs to be followed by a space.

# align columns
alias -g AC='| column -t'

alias -g L='2>&1 | less -R'

# silence!
#                    ┌───── redirect output to /dev/null
#                    │    ┌ same thing for errors
#           ┌────────┤ ┌──┤
alias -g S='>/dev/null 2>&1 &'
#                           │
#                           └─ execute in background

# watch a video STream with the local video player:
#
#     $ youtube-dl [-f best] 'url' ST
alias -g ST=' -o -| mpv --cache=4096 -'
#                         │
#                         └ sets the size of the cache to 4096kB
#
# Why is a cache important?{{{
#
# May be useful
# When playing files from slow media, it's necessary, but  can also have negative
# effects, especially  with file formats  that require a  lot of seeking,  such as
# MP4.
#}}}
# Is there a downside to using a cache?{{{
#
# Yes.
#}}}
# Why giving the value '4096'?{{{
#
# Because.
#}}}
# The default value of the 'cache' option is 'auto', which means that `mpv` will
# decide depending on the media whether it must cache data.
# Also,  `--cache=auto` implies  that  the size  of  the cache  will  be set  by
# '--cache-default', whose default value is '75000kB'.
# It's too much according to this:
#
#     https://streamlink.github.io/issues.html#issues-player-caching
#
# They recommend using between '1024' and '8192', so we take the middle value.

# Note that half the cache size will be used to allow fast seeking back.
# This is also the reason why a full cache is usually not reported as 100% full.
# The cache  fill display  does not  include the  part of  the cache  reserved for
# seeking back.
# The actual  maximum percentage will usually  be the ratio between  readahead and
# backbuffer sizes.

alias -g V='2>&1 | vipe >/dev/null'
#                       │
#                       └─ don't write on the terminal, the Vim buffer is enough

# suffix {{{2

# automatically open a file with the right program, according to its extension

alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv
alias -s {jpg,png}=feh
alias -s gif=ristretto
alias -s {epub,mobi}=ebook-viewer
alias -s {md,markdown,txt,html,css}=vim
alias -s odt=libreoffice
alias -s pdf=zathura

# Functions {{{1
alias_is_it_free() { #{{{2
  emulate -L zsh
  apt-file -x search "/$1$"
}

cdt() { #{{{2
  emulate -L zsh
  builtin cd "$(mktemp -d /tmp/.cdt.XXXXXXXXXX)"
}

# *_cfg {{{2

#                                                       ┌ https://stackoverflow.com/a/7507068/9780968
#                                                       │
autostart_cfg() { "${EDITOR}" "${HOME}/bin/autostartrc" ;}
bash_cfg() { "${EDITOR}" "${HOME}/.bashrc" ;}
conky_rings_cfg() { "${EDITOR}" "${HOME}/.conky/system_rings.lua" ;}
conky_system_cfg() { "${EDITOR}" "${HOME}/.conky/system.lua" ;}
conky_time_cfg() { "${EDITOR}" "${HOME}/.conky/time.lua" ;}
firefox_cfg() { "${EDITOR}" "${HOME}/.mozilla/firefox/*.default/chrome/userContent.css" ;}
mpv_cfg() { "${EDITOR}" "${HOME}/.config/mpv/input.conf" ;}
tmux_cfg() { "${EDITOR}" "${HOME}/.tmux.conf" ;}
vim_cfg() { "${EDITOR}" "${HOME}/.vim/vimrc" ;}
w3m_cfg() { "${EDITOR}" "${HOME}/.w3m/config" ;}
xbindkeys_cfg() { "${EDITOR}" "${HOME}/.config/xbindkeysrc" ;}
xmodmap_cfg() { "${EDITOR}" "${HOME}/.Xmodmap" ;}
zsh_cfg() { "${EDITOR}" "${HOME}/.zshrc" ;}

checkinstall_what_have_you() { #{{{2
  emulate -L zsh
  aptitude search "?section(checkinstall)"
}

cmdfu() { #{{{2
  # Why don't you use the `-R` option anymore (`emulate -LR`)?{{{
  #
  # `emulate -R zsh` resets all the options to their default value, which can be
  # checked with:
  #
  #               ┌ current environment
  #               │         ┌ reset environment
  #               │         │
  #     vimdiff <(setopt) <(emulate -R zsh; setopt)
  #
  # It can be useful, but it can also have undesired effect:
  #
  #     https://unix.stackexchange.com/questions/372779/when-is-it-necessary-to-include-emulate-lr-zsh-in-a-function-invoked-by-a-zsh/372866#comment663732_372866
  #
  # Besides, most widgets shipped with zsh use `-L` instead of `-LR`.
  #}}}
  emulate -L zsh
  #        │{{{
  #        └ any option reset via `setopt` should be local to the current function,
  #          so that it doesn't affect the current shell
  #
  #          See:
  #              `man zshbuiltins`
  #              > SHELL BUILTIN COMMANDS
  #              > emulate
  #}}}

  # Purpose: {{{
  #
  # Look up keywords on `www.commandlinefu.com`.
  #}}}
  # Dependencies:{{{
  #
  # It needs the `highlight` or `pygments` package:
  #
  #     $ sudo aptitude install highlight (✔)
  # OR
  #     $ sudo aptitude install python-pygments (✔✔)
  # OR
  #     $ python3 -m pip install --user pygments (✔✔✔)
  #}}}

  # Where is `pygments` documentation? {{{
  #
  #     http://pygments.org/docs/
  #}}}
  # What's a lexer?{{{
  #
  # A program performing a lexical analysis:
  #
  #     https://en.wikipedia.org/wiki/Lexical_analysis#Lexer_generator
  #}}}
  # How to list all available lexers?{{{
  #
  #     $ pygmentize -L
  #}}}
  # How to select a lexer?{{{
  #
  #     $ pygmentize -l <my_lexer>
  #}}}

  # store our keywords in the variable `keywords`, replacing spaces with dashes
  keywords="$(sed 's/ /-/g' <<< "$@")"
  # store their base64 encoding in `encoding`
  # Could I replace `printf` with `<<<`?{{{
  #
  # No.
  #
  # Watch:
  #
  #         $ printf -- 'hello world' | base64
  #
  #             → aGVsbG8gd29ybGQ= (✔)
  #
  #         $ base64 <<< 'hello world'
  #         $ printf -- 'hello world\n' | base64
  #
  #             → aGVsbG8gd29ybGQK (✘)
  #
  # We can't use `<<<` because when the shell expands a “here string”:
  #
  #       The result is  supplied as a single string, WITH A  NEWLINE APPENDED, to the
  #       command on its standard input.
  #
  # The appended newline alters the encoding.
  #}}}
  encoding="$(printf -- "$@" | base64)"

  # Alternative using `highlight`:{{{
  #
  #     curl -sL "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
  #     | highlight -O xterm256 -S bash -s bright | less -iR
  #                  │           │       │
  #                  │           │       └ we want the 'olive' highlighting style
  #                  │           │         (to get the list of available styles: `highligh -w`)
  #                  │           │
  #                  │           └ the syntax of the input file is bash
  #                  │
  #                  └ output the file for a terminal
  #                    (you can use other formats: html, latex ...)
  #}}}
  #     ┌ download silently (no errors, no progression){{{
  #     │
  #     │┌ if the url page has changed, try the new address
  #     ││}}}
  curl -sL "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
  | pygmentize -l shell \
  | less -iR
  #       ││{{{
  #       │└ --RAW-CONTROL-CHARS
  #       │
  #       │  don't display control characters used to set colors;
  #       │  send them instead to the terminal which will interpret them
  #       │  to colorize the text
  #       │
  #       └ --ignore-case
  #
  #        when we search for a  pattern (`/pat`), ignore the difference between
  #        uppercase and lowercase characters in the text
  #}}}
}

ff_audio_record() { #{{{2
  emulate -L zsh
  ffmpeg -f pulse -i default -y /tmp/rec.wav
  printf -- "\nThe audio stream has been recorded into '/tmp/rec.wav'\n"
}

ff_extract_sub() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF
usage:    $0 <file> [<subtitle number>]
EOF
    return
  fi
  ffmpeg -i "$1" -map 0:s:"$2" sub.srt
}

fix_terminal() { #{{{2
  emulate -L zsh

  # For more info:
  #     https://unix.stackexchange.com/q/79684/289772
  reset
  stty sane
  stty -ixon
  # What's the `rs1` capability?{{{
  #
  # A Reset String.
  #
  #     $ man -Kw rs1
  #     $ man infocmp (/rs1)
  #     $ man tput (/rs1)
  #}}}
  tput rs1
  tput rs2
  tput rs3
  clear
  printf -- '\ec'
  "${HOME}/bin/keyboard.sh"
}

fzf_clipboard() { #{{{2
  emulate -L zsh

  # fuzzy find clipboard history
  printf -- "$(greenclip print | fzf -e -i)" | xclip -selection clipboard
}

glob_what_do_you_match() { #{{{2
  emulate -L zsh

  # Purpose?{{{
  #
  # Suppose you want to remove some files, and you pass a glob pattern to `rm`:
  #
  #     $ rm foo*bar
  #
  # You're afraid of removing important files, because you're not sure what the glob
  # expands into.
  # `glob_what_do_you_match` to the rescue:
  #
  #     $ glob_what_do_you_match foo*bar
  #}}}
  # Why not `$*`?{{{
  #
  # Because  it would  quote  the whole  expansion  of the  glob  passed to  the
  # function as a single argument.
  # As a result, the latter would be printed on a single line.
  #
  # I prefer the  expansion of the glob to be printed on  several lines: one per
  # file.
  #}}}
  if [[ $# -eq 0 ]]; then
    printf -- "usage:\n    $0 <a glob pattern>\n"
    printf -- "\nexample:\n    $0 *\n"
    return
  fi
  printf -- '%s\n' "$@"
}

loc() { #{{{2
  # Purpose:{{{
  #
  # Suppose you want to find all files containing `foo` and `bar` or `baz`:
  #
  #     $ locate -ir 'foo.*\(bar\|baz\)'
  #
  # With this function, the command is simpler:
  #
  #     $ loc 'foo (bar|baz)'
  #}}}

  emulate -L zsh
  #               ┌ 'foo bar' → 'foo.*bar'
  #               │                         ┌ ( → \(
  #               │                         │                ┌ | → \|
  #               │                         │                │                 ┌ ) → \)
  #               ├──────┐                  ├───────┐        ├───────┐         ├───────┐
  keywords=$(sed 's/ /.*/g' <<< "$@" | sed 's:(:\\(:g'| sed 's:|:\\|:g' | sed 's:):\\):g')
  locate -ir "${keywords}" | vim -R --not-a-term -
  #       ││
  #       │└ search for a basic regexp (not a literal string)
  #       │
  #       └ ignore the case
}

mkcd() { #{{{2
  # create directory and cd into it right away
  emulate -L zsh
  mkdir "$*" && cd "$*"
}

mountp() { #{{{2
  emulate -L zsh

  # mount pretty ; fonction qui espace / rend plus jolie la sortie de la commande mount
  mount | awk '{ printf -- "%-11s %s %-26s %s %-15s %s\n", $1, $2, $3, $4, $5, $6 }' -
}

nstring() { #{{{2
  emulate -L zsh

  # Description:
  # count the nb of occurrences of a substring `sub` inside a string `foo`.
  #
  # Usage:    nstring sub str

  grep -o "$1" <<< "$2" | wc -l
  #     │       │
  #     │       └ redirection ; `grep` only accepts filepaths, not a string
  #     │
  #     └ --only-matching; print  only the matched (non-empty) parts of
  #                        a matching line, with each such part on a separate
  #                        output line
}

nv() { #{{{2
#    │
#    └ You want to prevent the  change of `IFS` from affecting the current shell?
#      Ok. Then, use `local IFS`.
#      Do NOT use parentheses to surround the  body of the function and create a
#      subshell. It could cause an issue when we suspend then restart Vim.
#           https://unix.stackexchange.com/a/445192/289772

  emulate -L zsh

  # check whether a Vim server is running
  #
  #                             ┌─ Why do we look for a server whose name is VIM?
  #                             │  By default, when we execute:
  #                             │          vim --remote file
  #                             │
  #                             │  … without `--servername`, Vim tries to open `file` in a Vim server
  #                             │  whose name is VIM.
  #                             │  So, we'll use this name for our default server.
  #                             │  This way, we won't have to specify the name of the server later.
  #                             │
  if vim --serverlist | grep -q VIM; then
  #                           │
  #                           └─ be quiet (no output); if you find sth, just return 0

    # From now on, assume a VIM server is running.

    # If no argument was given, just start a new Vim session.
    if [[ $# -eq 0 ]]; then
      vim

    # If the 1st argumennt is `-b`, we want to edit binary files.
    elif [[ $1 == -b ]]; then
      # Get rid of `-b` before send the rest of the arguments to the server, by
      # shifting the arguments to the right.
      shift 1
      # Make sure that the shell uses a space, and only a space, to separate
      # 2 consecutive arguments, when it will expand the special parameter `$*`.
      local IFS=' '

      # send the filenames to the server
      vim --remote "$@"
      # For each buffer in the arglist:
      #
      #         enable the 'binary' option.
      #         Among other things, il will prevent Vim from doing any kind of
      #         conversion, which could damage the files.
      #
      #         set the filetype to `xxd` (to have syntax highlighting)
      vim --remote-send ":argdo setl binary ft=xxd<cr>"
      # filter the contents of the binary buffer through `xxd`
      vim --remote-send ":argdo %!xxd<cr><cr>"

    # If the 1st argument is `-d`, we want to compare files.
    elif [[ $1 == -d ]]; then
      shift 1
      local IFS=' '
      # open a new tabpage
      vim --remote-send ":tabnew<cr>"
      # send the files to the server
      vim --remote "$@"
      # display the buffers of the arglist in a dedicated vertical split
      vim --remote-send ":argdo vsplit<cr>:q<cr>"
      # execute `:diffthis` in each window
      vim --remote-send ":windo diffthis<cr>"

    # If the 1st argument is `-o`, we want to open each file in a dedicated horizontal split
    elif [[ $1 == "-o" ]]; then

      shift 1
      local IFS=' '

      vim --remote "$@"
      vim --remote-send ":argdo split<cr>:q<cr><cr>"
      #                                  └────┤
      #                                       └ close last window, because the last file
      #                                         is displayed twice, in 2 windows

    # If the 1st argument is `-O`, we want to open each file in a dedicated vertical split
    elif [[ $1 == -O ]]; then
      shift 1
      local IFS=' '
      vim --remote "$@"
      vim --remote-send ":argdo vsplit<cr>:q<cr><cr>"

    # If the 1st argument is `-p`, we want to open each file in a dedicated tabpage.
    elif [[ $1 == -p ]]; then
      shift 1
      local IFS=' '
      vim --remote "$@"
      vim --remote-send ":argdo tabedit<cr>:q<cr>"

    # If the 1st argument is `-q`, we want to populate the qfl with the output
    # of a shell command. The syntax should be:
    #
    #               ┌─ Use single quotes to prevent the current shell from expanding a glob.
    #               │  The glob is for the Vim function `system()`, which will send it back
    #               │  to another shell later.
    #               │
    #         nv -q 'grep -Rn foo *'
    #
    # This syntax is NOT possible with Vim:
    #
    #         vim -q grep -Rn foo *       ✘
    #
    # With Vim, you should type:
    #
    #         vim -q <(grep -Rn foo *)    ✔

    elif [[ $1 == -q ]]; then

      shift 1
      local IFS=' '

      #                                 ┌─ Why not $@?
      #                                 │  $@ would be expanded into:
      #                                 │
      #                                 │      '$1' '$2' …
      #                                 │
      #                                 │  … but `system()` expects a single string.
      #                                 │
      vim --remote-send ":cexpr system('$*')<cr>"


    # If no option was used, -[bdoOpq], we just want to send files to the server.
    else
      vim --remote "$@"
    fi

  # Finally, if `grep` didn't find any VIM server earlier, start one.
  else
    vim -w /tmp/.vimkeys --servername VIM "$@"
  fi
}

# Set a trap for when we send the signal `USR1` from our Vim mapping `SPC R`.
trap __catch_signal_usr1 USR1
# Function invoked by our trap.
__catch_signal_usr1() {
  # reset a trap for next time
  trap __catch_signal_usr1 USR1
  # useful to get rid of error messages which were displayed during last Vim
  # session
  clear
  # Why don't you restart Vim directly from the trap?{{{
  #
  # If we restart Vim, then suspend it, we can't resume it by executing `$ fg`.
  # The issue doesn't come from the code inside `nv()`, it comes from the trap.
  # MWE:
  #
  #   func() {
  #     vim
  #   }
  #
  #   $ func
  #   SPC R
  #   :stop
  #   $ fg ✘
  #
  # https://unix.stackexchange.com/a/445192/289772
  #
  # So, instead, we'll restart Vim from a hook
  #}}}
  # Set the flag with `1` to let zsh know that it should automatically restart
  # Vim the next time we're at the prompt.
  # restarting_vim=1
  nv
}

# Set an empty flag.
# We'll test it to determine whether Vim is being restarted.
# restarting_vim=
# What's this function?{{{
#
# Any function whose  name is `precmd` or inside  the array `$precmd_functions`.
# is special.
# It's automatically executed by zsh before every new prompt.
#
# Note that a prompt which is redrawn, for example, when a notification about an
# exiting job is displayed, is NOT a new prompt.
# So `precmd()` is not executed in this case.
#
# For more info: `$ man zshmisc`
#                  SPECIAL FUNCTIONS
#                  Hook Functions
#}}}
# Why do you use it?{{{
#
# To restart  Vim automatically, when we're  at the shell prompt  after pressing
# `SPC R` from Vim.
#}}}
__restart_vim() {
  emulate -L zsh
  if [[ -n "${restarting_vim}" ]]; then
    # reset the flag
    # restarting_vim=
    # FIXME: If we quit Neovim, we should restart Neovim, not Vim.
    # FIXME: Vim IS restarted the first time, but NOT the next times.{{{
    #
    # The issue is  not with the trap,  nor with the flag, because  if I execute
    # any command  (ex: `$ ls`),  causing a new prompt  to be displayed,  Vim is
    # restarted.
    # Besides,  if we  add some  command after  `nv` (ex:  `echo 'hello'`),  the
    # message is correctly displayed even when Vim is not restarted, which means
    # that this `if` block is always correctly processed.
    #
    # For some reason, `nv` is ignored.
    # Replacing `nv` with `vim` doesn't fix the issue.
    #}}}
    # Warning: don't use `vim`.{{{
    #
    # It wouldn't restart a Vim server.
    #}}}
    nv
  fi
}

palette(){ #{{{2
  emulate -L zsh

  local i
  for i in {0..255} ; do
    printf -- '\e[48;5;%dm%3d\e[0m ' "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
      printf -- '\n'
    fi
  done
}

repo_what_have_you() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    printf -- "usage:\n    $0 <press Tab>\n"
    return
  fi
  awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' /var/lib/apt/lists/*"$1"*
}

shellcheck_wiki() { #{{{2
  xdg-open "https://github.com/koalaman/shellcheck/wiki/SC$1"
}

sr_fzf() { #{{{2
  emulate -L zsh
  sr "$(sed '/^$/d' "${HOME}/.config/surfraw/bookmarks" | sort -n | fzf -e)"
  #     ├─────────────────────────────────────────────┘   ├─────┘   ├────┘
  #     │                                                 │         └ search the pattern input by the user
  #     │                                                 │           exactly (disable fuzzy matching)
  #     │                                                 │           -e` = `--exact` exact-match
  #     │                                                 │
  #     │                                                 └ sort numerically
  #     └ remove empty lines in
  #       the bookmark file
}

truecolor() { #{{{2
  emulate -L zsh

  local i r g b

  # What's `r`, `g` and `b`?{{{
  #
  # The quantities of red (r), green (g) and blue (b) for each color we're going to test.}}}
  # How do we make them evolve?{{{
  #
  # To produce a specrum of colors,  they need to evolve in completely different
  # ways. So, we make:
  #
  #     • `r` decrease from 255  (to make the specrum begin from very red)
  #                  to     0  (to get most shades of red)
  #
  #     • `b` increase from   0
  #                  to   255
  #
  #     • `g`    increase from 0   to 255  (but faster than blue so that we produce more various colors)
  #       then decrease from 255 to 0    (via `if (g > 255) g = 2*255 - g;`)
  #
  # Summary:
  #
  #     r:  255 → 0
  #     g:  0   → 255 → 0
  #     b:  0   → 255
  #}}}
  # Why 79?{{{
  #
  # By default terminals have 80 columns.
  #}}}
  for ((i = 0; i <= 79; i++)); do
    b=$((i*255/79))
    g=$((2*b))
    r=$((255-b))
    if [[ $g -gt 255 ]]; then
      g=$((2*255 - g))
    fi
    printf -- '\e[48;2;%d;%d;%dm \e[0m' $r $g $b
  done
  printf -- '\n'
}

unclutter_toggle() { #{{{2
  # Purpose:{{{
  #
  # `unclutter` interferes with `~/.config/mpv/scripts/interSubs.py`.
  #
  # Besides, it may cause issues in the future:
  #
  #     https://wiki.archlinux.org/index.php/unclutter#Known_bugs
  #
  # We  need  an easy  way  to  toggle the  program  when  watching movies  with
  # interactive subtitles.
  #}}}
  emulate -LR zsh
  local pid
  pid="$(pgrep unclutter)"
  if [[ -n "${pid}" ]]; then
    kill "${pid}"
  else
    unclutter -idle 2 & disown
    #                   │
    #                   └ https://unix.stackexchange.com/a/148698/289772
  fi
}

up() { #{{{2
  emulate -L zsh

  # make sure `~/log/` exists
  [[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
  local LOGFILE="${HOME}/log/update_system.log"
  __update_system "${LOGFILE}" 2>&1 | tee -a "${LOGFILE}"
}

__update_system() {
  emulate -L zsh

  # Why putting the month before the day?{{{
  #
  # It's a good habit.
  # If you have files  whose name begin with a date, it's easier  to find a file
  # dating from a particular time in the  output of `$ ls` (or in `ranger`) when
  # the month comes before the day.
  #}}}
  printf -- '---\n---\n%s\n===========\n\n' "$(date +%m-%d\ %H:%M)"

  printf -- 'system\n------\n\n'
  sudo aptitude update
  sudo aptitude safe-upgrade

  # What does it do?{{{
  #
  # Resynchronize the package contents from their sources.
  # The  lists of  the  contents  of packages  are  fetched  from the  location(s)
  # specified in /etc/apt/sources.list.
  #}}}
  # Why do you do it?{{{
  #
  # As time goes on, some new file(s) may be included in a package.
  # One day, we may be looking for which package contains it:
  #
  #     $ apt-file search <missing_file>
  #
  # If our local package contents are not up-to-date, the previous command
  # may return nothing (or not the package we need).
  # Thus we may wrongly assume that we can't get that file.
  #}}}
  # Why do you use `script`?{{{
  #
  # `apt-file` is a perl script, which doesn't write on its standard output,
  # but on `/dev/tty`.
  #
  # Usually, they seem to be the same thing: the standard output of a process is
  # often connected to the terminal.
  # But here, you've redirected the standard output the input of `tee`.
  # So, they're not the same anymore.
  # And I don't think it's possible to redirect `/dev/tty` to a file.
  #
  # So, we use `script` instead.
  #
  # For more:
  #   https://askubuntu.com/a/1074946/867754
  #   https://stackoverflow.com/a/4668579/9780968
  #}}}
  # Why don't you use it to log the whole function?{{{
  #
  # When you pass a value to the `-c` option of the `script` command,
  # I think that the normal shell  function lookup is suppressed, i.e. you can't
  # execute a function only a command.
  # Same thing with `bash -c '...'`.
  #
  # Besides,  `script` logs the linefeeds  as literal carriage returns  which is
  # distracting.
  # It does the same thing with other characters such as backspaces.
  #}}}
  printf -- '\napt-file\n--------\n\n'
  script -a -c 'apt-file update' -q "$1"
  #       │  │                    │   │{{{
  #       │  │                    │   └ log the output in this file
  #       │  │                    │
  #       │  │                    └ be quiet (no message when `script` starts/ends)
  #       │  │
  #       │  └ execute the next command,
  #       │    instead of waiting the user to execute commands interactively
  #       │
  #       └ append to the logfile
  #}}}

  printf -- '\npip\n---\n\n'
  python  -m pip install --upgrade pip
  python3 -m pip install --upgrade pip

  # https://stackoverflow.com/a/3452888/9780968
  # Knowing the current state of the packages could be useful to restore it later;{{{
  # copy the logged output of `pip freeze` in a file `/tmp/req.txt`, then:
  #
  #     $ python[3] -m pip install -r /tmp/req.txt
  #}}}
  printf -- '\ncurrent versions of the python2 packages\n---\n\n'
  python -m pip freeze
  printf -- '\nupdate python2 packages\n---\n\n'
  python -m pip list --outdated --format=freeze \
    | grep -Ev '^(-e|#)' \
    | cut -d= -f1 \
    | xargs -r -n1 python -m pip install --user --upgrade
    #        │  │{{{
    #        │  └ pass only one package name at a time to `pip install`,
    #        │    so that if one installation fails, the other ones go on
    #        │
    #        └ don't run the command if the input is empty
    #          (we need at least one package name)
    #}}}

  printf -- '\ncurrent versions of the python3 packages\n---\n\n'
  python3 -m pip freeze
  printf -- '\nupdate python3 packages\n---\n\n'
  python3 -m pip list --outdated --format=freeze \
    | grep -Ev '^(-e|#)' \
    | cut -d= -f1 \
    | xargs -r -n1 python3 -m pip install --user --upgrade
  # update `mpv` completion function
  curl -sL 'https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/zsh.pl' | \
    perl - \
    >"${HOME}/.zsh/my-completions/_mpv"

  __update_git_programs 'ranger' "${HOME}/GitRepos/ranger/"

  # For more info:{{{
  #
  #     https://tex.stackexchange.com/a/55459/169646
  #}}}
  printf -- '\ntexlive packages\n---\n\n'
  #       ┌ https://stackoverflow.com/a/677212/9780968
  #       ├────────┐
  if [[ $(command -v tlmgr) ]]; then
    tlmgr update --self --all --reinstall-forcibly-removed
    #              │      │     │{{{
    #              │      │     └ reinstall a package
    #              │      │       if it was corrupted during a previous update
    #              │      │
    #              │      └ update all packages
    #              │
    #              └ update `tlmgr` itself}}}
  fi

  printf -- '\nyoutube-dl\n---\n\n'
  up_yt

  [[ -d "${HOME}/.zsh/plugins" ]] || mkdir -p "${HOME}/.zsh/plugins"
  __update_git_programs 'zsh-completions'         "${HOME}/.zsh/zsh-completions/"
  __update_git_programs 'zsh-interactive-cd'      "${HOME}/.zsh/plugins/zsh-interactive-cd"
  __update_git_programs 'zsh-syntax-highlighting' "${HOME}/.zsh/plugins/zsh-syntax-highlighting"
  __update_git_programs 'zaw'                     "${HOME}/.zsh/plugins/zaw"
}

__update_git_programs() {
  emulate -L zsh

  local width dashes
  # How to get the length of a string?{{{
  #
  #   $ string='hello'
  #   $ echo ${#string}
  #
  # Source:
  #
  #     https://stackoverflow.com/a/17368090/9780968
  #}}}
  width=${#1}
  # How to repeat a string (like `repeat('foo', 3)`)? {{{
  #
  # Contrary to Vim's `printf()`, you  can give more expressions than `%s` items
  # in the format:
  #
  #     " ✘
  #     :echo printf('-%s+', 'a', 'b', 'c')
  #
  #         → E767: Too many arguments to printf()
  #
  #     # ✔
  #     $ printf -- '-%s+' 'a' 'b' 'c'
  #
  #         → -a+-b+-c+
  #
  # `$ printf` repeats the format as many times as necessary.
  # So:
  #
  #     $ printf -- '-%s' {1..5}
  #
  #         → -1-2-3-4-5
  #
  #     $ printf -- '%s' 3
  #
  #         → 3
  #
  #     $ printf -- '%.0s' 3
  #
  #         → ∅ (empty string, because the precision flag `.0` asks for 0 characters)
  #
  #     $ printf -- '-%.0s' {1..5}
  #
  #         → -----
  #
  # Source:
  #
  #     https://stackoverflow.com/a/5349842/9780968
  #}}}
  dashes="$(printf -- '-%.0s' $(seq 1 "${width}"))"
  #                │
  #                └ necessary for bash, not zsh
  # `zsh` alternative:{{{
  #
  #   dashes="$(printf -- '-%.0s' {1..${width}})"
  #
  # In bash, inside a brace expansion, you can't refer to a variable.
  # So, instead of writing this:
  #
  #     # ✘
  #     $ echo {1..${width}}
  #
  # You have to write this
  #
  #     # ✔
  #     $ echo $(seq 1 ${width})
  #}}}

  printf -- "\n$1\n%s\n\n" "${dashes}"

  [[ -d "$2" ]] || git -C "${HOME}/.zsh/plugins/" clone 'https://github.com/zsh-users/zsh-completions'
  [[ -d "$2" ]] || git -C "${HOME}/.zsh/plugins/" clone 'https://github.com/changyuheng/zsh-interactive-cd'
  [[ -d "$2" ]] || git -C "${HOME}/.zsh/plugins/" clone 'https://github.com/zsh-users/zsh-syntax-highlighting'
  [[ -d "$2" ]] || git -C "${HOME}/.zsh/plugins/" clone 'https://github.com/zsh-users/zaw'

  git -C "$2" pull
}

up_yt() { #{{{2
  emulate -L zsh

  # https://rg3.github.io/youtube-dl/download.html
  curl -sL 'https://yt-dl.org/downloads/latest/youtube-dl' -o "${HOME}/bin/youtube-dl"
  chmod a+rx "${HOME}/bin/youtube-dl"

  if [[ ! -d "${HOME}/GitRepos/youtube-dl/" ]]; then
    mkdir -p "${HOME}/GitRepos/"
    git -C "${HOME}/GitRepos/" clone 'https://github.com/rg3/youtube-dl'
  fi

  # add current directory to the top of the directory stack
  pushd >/dev/null
  cd "${HOME}/GitRepos/youtube-dl"
  git pull
  # install zsh completion function
  make youtube-dl.zsh && \
    mv "${HOME}/GitRepos/youtube-dl/youtube-dl.zsh" "${HOME}/.zsh/my-completions/_youtube-dl.zsh"

  # install manpage:
  #     https://askubuntu.com/a/244810/867754
  #     https://askubuntu.com/a/633924/867754
  #     man 1 manpath
  #     man 5 manpath
  make youtube-dl.1 && \
    mkdir -p "${HOME}/share/man/man1" && \
    mv youtube-dl.1 "${HOME}/share/man/man1"
  # remove top of the directory stack to get back where we were before updating youtube-dl
  popd >/dev/null
}

xt() { #{{{2
  # Purpose:{{{
  #
  # Extract an archive using the `atool` command.
  # Then,  cd  into  the  directory  where  the  contents  of  the  archive  was
  # extracted. The code is taken from `:Man atool`.
  #}}}
  emulate -L zsh

  local TMP
  TMP="$(mktemp /tmp/xt.XXXXXXXXXX)"
  #      │                  │
  #      │                  └ template for the filename, the `X` will be
  #      │                    randomly replaced with characters matched
  #      │                    by the regex `[0-9a-zA-Z]`
  #      │
  #      └ create a temporary file and store its path into `TMP`

  atool -x --save-outdir="${TMP}" "$@"
  #          │
  #          └ write the name of the folder in which the files have been
  #            extracted inside the temporary file

  # Assign the name of the extraction folder inside to the variable `DIR`.
  local DIR
  DIR="$(cat "${TMP}")"
  [[ -d "${DIR}" && "${DIR}" != "" ]] && cd "${DIR}"
  #  ├─────────┘    ├────────────┘       ├─────────┘
  #  │              │                    │
  #  │              │                    └ enter it
  #  │              │
  #  │              └ and if its name is not empty
  #  │
  #  └ if the directory `DIR` exists

  # Delete temporary file.
  rm "${TMP}"
}

# Variables {{{1
# WARNING: Make sure this `Variables` section is always after `Functions`.{{{
#
# Because  if  you  refer  to  a  function in  the  value  of  a  variable  (ex:
# `precmd_functions`), and it doesn't exist yet, it may raise an error.
#}}}

# It doesn't seem necessary to export the variable.
# `precmd_functions` is a variable specific to the zsh shell.
# No subprocess could understand it.
#     https://stackoverflow.com/a/1158231/9780968
# precmd_functions=(__restart_vim)

# Key Bindings {{{1
# Delete {{{2

# The delete key doesn't work in zsh.
# Fix it.
bindkey  '\e[3~'  delete-char

# S-Tab {{{2

# TODO: To document.
#
# Source:
#
#     https://unix.stackexchange.com/a/32426/232487
#
# Idea: improve the function so that it opens the completion menu,
# this way we could cd into any directory (without `cd`, thanks to `AUTOCD`).
__reverse_menu_complete_or_list_files() {
  emulate -L zsh
  if [[ $#BUFFER == 0 ]]; then
    BUFFER="ls "
    CURSOR=3
    zle list-choices
    zle backward-kill-word
  else
    # FIXME: why doesn't `s-tab` cycle backward?{{{
    #
    # MWE:
    #         autoload -Uz compinit
    #         compinit
    #         zstyle ':completion:*' menu select
    #         __reverse_menu_complete_or_list_files() {
    #           emulate -L zsh
    #           if [[ $#BUFFER == 0 ]]; then
    #             BUFFER="ls "
    #             CURSOR=3
    #             zle list-choices
    #             zle backward-kill-word
    #           else
    #             zle reverse-menu-complete
    #           fi
    #         }
    #         zle -N __reverse_menu_complete_or_list_files
    #         bindkey '\e[Z' __reverse_menu_complete_or_list_files
    #
    # If I replace `reverse-menu-complete` with `backward-kill-word`,
    # `zle` deletes the previous word as expected, so why doesn't
    # `reverse-menu-complete` work as expected?
    #
    # It  seems that  `reverse-menu-complete` is  unable to  detect that  a menu
    # completion is  opened. Therefore, it  simply tries  to COMPLETE  the entry
    # selected in the menu, instead of cycling backward.
    #}}}
    zle reverse-menu-complete
  fi
}

# bind `__reverse_menu_complete_or_list_files` to s-tab
# Why is it commented?{{{
#
# Currently,  this key  binding breaks  the behavior  of `s-tab`  when we  cycle
# through the candidates of a completion menu.
#}}}
#     zle -N __reverse_menu_complete_or_list_files
#     bindkey '\e[Z' __reverse_menu_complete_or_list_files

# use S-Tab to cycle backward during a completion
bindkey '\e[Z' reverse-menu-complete
#        ├──┘
#        └ the shell doesn't seem to recognize the keysym `S-Tab`
#          but when we press `S-Tab`, the terminal receives the keycodes `escape + [ + Z`
#          so we use them in the lhs of our key binding

# CTRL {{{2
# C-SPC      set-mark-command {{{3

bindkey '^ ' set-mark-command

# C-q        quote_big_word {{{3

# useful to quote a url which contains special characters
__quote_big_word() {
  emulate -L zsh
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
zle -N __quote_big_word
#    │
#    └─ -N widget [ function ]
#       Create a user-defined widget. When the new widget is invoked
#       from within the editor, the specified shell function is called.
#       If no function name is specified, it defaults to the same name as the
#       widget.
bindkey '^Q' __quote_big_word

# C-r C-h    fzf-history-widget {{{3

# The default key binding to search in the history of commands is `C-r`.
# Remove it, and re-bind the function to `C-r C-h`.
bindkey -r '^R'
# Why?{{{
#
# On Vim's command-line, we can't use `C-r`, nor `C-r C-r`.
# So, we use `C-r C-h`.
# To stay consistent, we do the same in the shell.
#
# Besides, we can now use `C-r` as a prefix for various key bindings.
#}}}
bindkey '^R^H' fzf-history-widget

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
autoload -Uz edit-command-line
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

__reread_zshrc() {
  emulate -L zsh
  . "${HOME}/.zshrc" 2>/dev/null
#                    └─────────┤{{{
#                              └ “stty: 'standard input': Inappropriate ioctl for device”
#
# In case of an issue, this may help:
#
#     https://unix.stackexchange.com/a/370506/232487
#     https://github.com/zsh-users/zsh/commit/4d007e269d1892e45e44ff92b6b9a1a205ff64d5#diff-c47c7c7383225ab55ff591cb59c41e6b
#}}}
}
zle -N __reread_zshrc
bindkey '^X^R' __reread_zshrc

# C-x C-s         reexecute-with-sudo {{{4
#
# re-execute last command with higher privileges
#
#                       ┌ preserve some variables in current environment
#                       │
bindkey -s '^X^S' 'sudo -E env "PATH=$PATH" bash -c "!!"^M'
#                               │
#                               └ make sure `PATH` is preserved, in case `-E` didn't
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

# C-z        fancy_ctrl_z {{{3
#
# FIXME:
# I can't bring a suspended process to the foreground anymore.
# MWE:
#
#     $ vim
#     C-z
#     C-z

# Hit `C-z` to temporarily discard the current command line.
# If the command line is empty, instead, resume execution of the last paused
# background process, so that we can put a running command in the background
# with 2 `C-z`.
# Try to reimplement what is shown here:
#
#     https://www.youtube.com/watch?v=SW-dKIO3IOI
#
# https://unix.stackexchange.com/a/10851/232487
__fancy_ctrl_z() {
  emulate -L zsh

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
    #             __fancy_ctrl_z:bg:18: no current job
  else
    # Push the entire current multiline construct onto the buffer stack.
    # If it's only a single line, this is exactly like `push-line`.
    # Next time the editor starts up or is popped with `get-line`, the construct
    # will be popped off the top of the buffer stack and loaded into the editing
    # buffer.
    zle push-input
  fi
}
zle -N __fancy_ctrl_z
# NOTE:
# This  key  binding  won't prevent  us  to  put  a  foreground process  in  the
# background. When  we hit  `C-z` while  a process  is in  the foreground,  it's
# probably the terminal driver which intercepts the keystroke and sends a signal
# to the process to  pause it. In other words, `C-z` should  reach zsh only if
# no process has the control of the terminal.
bindkey '^Z' __fancy_ctrl_z

# META {{{2
# M-#       pound-insert {{{3
bindkey '\e#' pound-insert

# M-c/l/u   change-Case {{{3

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

# M-e       run-hElp {{{3
#
# from `type run-help`:    run-help is an autoload shell function
# it's an alias to `man` that will look in other places before invoking man
#
# by default it's bound to `M-h`, but use this key to move between tmux windows
# so rebind it to `M-e` instead
bindkey '\ee' run-help

# M-m       normalize_command_line {{{3

# TODO:
# Explain how it works.
# Also,   what's   the   difference   between   `__normalize_command_line`   and
# `__expand_aliases`?
# They seem to do the same thing. If that's so, then remove one of the functions
# and key bindings.
__normalize_command_line() {
  functions[__normalize_command_line_tmp]=$BUFFER
  BUFFER=${${functions[__normalize_command_line_tmp]#$'\t'}//$'\n\t'/$'\n'}
  ((CURSOR == 0 || CURSOR == $#BUFFER))
  unset 'functions[__normalize_command_line_tmp]'
}
zle -N __normalize_command_line
bindkey '\em' __normalize_command_line

# M-o       previous_directory (Old) {{{3
# cycle between current dir and old dir
__previous_directory() {
  emulate -L zsh
  # contrary to bash, zsh sets `$OLDPWD` immediately when we start a shell
  # so, no need to check it's not empty
  builtin cd -
  # refresh the prompt so that it reflects the new working directory
  zle reset-prompt
}
zle -N __previous_directory
bindkey '\eo' __previous_directory

# M-Z       fuZzy-select-output {{{3

# insert an entry from the output of the previous command,
# selecting it with fuzzy search
bindkey -s '\eZ' '$(!!|fzf)'

# CTRL-META {{{2
# C-M-e      expand_aliases {{{3

# TODO:
# fully explain the `expand_aliases` function
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

__expand_aliases() {
  emulate -L zsh
  unset 'functions[___expand_aliases]'
  # We put the current command line into `functions[___expand_aliases]`
  functions[___expand_aliases]=$BUFFER
  #     alias ls='ls --color=auto'
  #     alias -g V='|vipe'
  #     functions[___expand_aliases]='ls V'
  #     echo $functions[___expand_aliases]          →  ls --color=auto | vipe
  #     echo $+functions[___expand_aliases]         →  1
  #    (($+functions[___expand_aliases])); echo $?  →  0

  # this command does 3 things, and stops as soon as one of them fails:
  #     check the command is syntactically valid
  #     set the buffer
  #     set the position of the cursor
  (($+functions[___expand_aliases])) &&
    BUFFER=${functions[___expand_aliases]#$'\t'} &&
    CURSOR=$#BUFFER
}

zle -N __expand_aliases
bindkey '\e^E' __expand_aliases
#        │
#        └─ C-M-e

# MENUSELECT {{{2
# Warning: I've disabled all key bindings using a printable character.{{{
#
# It's annoying  to type a  key expecting a character  to be inserted,  while in
# reality it's going to select another entry in the completion menu.
#}}}

# to install the next key bindings, we need to load the `complist` module
# otherwise the `menuselect` keymap won't exist
zmodload zsh/complist
# │
# └─ load a given module

# `zmodload`    prints the list of currently loaded modules
# `zmodload -L` prints the same list in the form of a series of zmodload commands

# use vi-like keys in menu completion
# bindkey -M menuselect 'h' backward-char
#        │
#        └─ selects the `menuselect` keymap
#
#           `bindkey -l` lists all the keymap names
#            for more info: man zshzle
# bindkey -M menuselect 'l' forward-char
# Do NOT write this:
#         bindkey -M menuselect '^J' down-line-or-history
#
# It works in any terminal, except one opened from Vim.
# The latter doesn't seem able to  distinguish `C-m` from `C-j`. At least when a
# completion menu is  opened. Because of that, when we would  hit Enter/C-m, Vim
# would move the cursor down, instead of selecting the current entry.
# bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect '^J' down-line-or-history
# bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect '^K' up-line-or-history

bindkey -M menuselect '^H' backward-char
# bindkey -M menuselect 'b' backward-char
# bindkey -M menuselect 'B' backward-char
# bindkey -M menuselect 'e' forward-char
# bindkey -M menuselect 'E' forward-char
bindkey -M menuselect '^L' forward-char
# bindkey -M menuselect 'w' forward-char
# bindkey -M menuselect 'W' forward-char

# bindkey -M menuselect '^' beginning-of-line
# bindkey -M menuselect '_' beginning-of-line
# bindkey -M menuselect '$' end-of-line

# bindkey -M menuselect 'gg' beginning-of-history
# bindkey -M menuselect 'G'  end-of-history

# TODO: How to repeat a zle function?{{{
#
# bindkey -M menuselect '^D'  5 down-line-or-history    ✘
#
#     __fast_down_line_or_history() {
#       zle down-line-or-history
#     }
#     zle -N __fast_down_line_or_history
#     bindkey -M menuselect '^D'  __fast_down_line_or_history
#
# Actually, the problem comes from the `menuselect` keymap.
# We can't bind any custom widget in this keymap:
#
#     __some_widget() {
#       zle end-of-history
#     }
#     zle -N __some_widget
#     bindkey -M menuselect 'G' __some_widget
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

# http://zshwiki.org/home/examples/zleiab

#        ┌ `abbrev` refer to an associative array parameter
#        │
declare -Ag abbrev
#         │
#         └ don't restrict to local scope

abbrev=(
  # column
  "Jc"    "| awk '{ print $"
  "Jn"    "2>/dev/null"
  "Jp"    "printf -- '"
  "Jt"    "| tail -20"
  "Jv"    "vim -Nu /tmp/vimrc -U NONE -i NONE --noplugin"
)

__abbrev_expand() {
  emulate -L zsh
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
  #                                  contrary to most regex engines, for zsh,
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
    # but zsh inserts a space before the cursor, no matter the value we give
    # to `CURSOR`. How to avoid this?
    # CURSOR=$(($#LBUFFER))
    # NOTE:
    # by default, CURSOR=$#LBUFFER
  elif [[ $MATCH = 'Jp' ]]; then
    RBUFFER="\n'"
  fi

  # we need to insert the key we've just typed (here space), otherwise,
  # we wouldn't be able to insert a space anymore
  zle self-insert
  #   │
  #   └─ run the `self-insert` widget to insert a character into the buffer at
  #   the cursor position (man zshzle)
}

# define a widget to expand when inserting a space
zle -N __abbrev_expand
# bind it to the space key
bindkey ' ' __abbrev_expand

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

# Syntax highlighting {{{1

# customize default syntax highlighting
#
#     zle_highlight=(paste:fg=yellow,underline region:fg=yellow suffix:bold)
#                    │                         │                │                                 v
#                    │                         │                └ some suffix characters (Document/)
#                    │                         │                                                  ^
#                    │                         └ the region between the cursor and the mark
#                    │
#                    └ what we paste with C-S-v

# Source the plugin `zsh-syntax-highlighting`:
#     https://github.com/zsh-users/zsh-syntax-highlighting

# It must be done after all custom widgets have been created (i.e., after all zle -N calls).
# because the plugin creates a wrapper around each of them.
# If we source it before some custom widgets, it will still work, but won't be
# able to properly highlight the latter.

[[ -f ${HOME}/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
. "${HOME}/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
#     . "$HOME/GitRepos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#     ZSH_HIGHLIGHT_HIGHLIGHTERS=(main root)
#     ZSH_HIGHLIGHT_STYLES[root]='bg=red'
