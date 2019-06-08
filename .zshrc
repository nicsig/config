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
# http://unix.stackexchange.com/a/12108/125618
# http://unix.stackexchange.com/a/12146/125618
# http://unix.stackexchange.com/a/72092/125618
# https://en.wikipedia.org/wiki/Software_flow_control
#}}}
stty -ixon
# disable SIGQUIT signal
# Why?{{{
#
# By default, the terminal driver interprets `C-\` as the order to send the
# `SIGQUIT` signal to the foreground process.
# The latter can react to this signal however it wants; usually, it quits:
#
#     $ sleep 100
#     C-\
#     ^\[1]    28832 quit (core dumped)  sleep 100~
#
# We disable  this signal, because we could  use `C-\` as a key  binding in some
# application.
#}}}
stty quit undef

# How to use one of the custom prompts available by default?{{{
#
# initialize the prompt system
#
#     autoload -Uz promptinit
#     promptinit
#
# To choose a theme, use these commands:
#
#    ┌─────────────────────┬──────────────────────────┐
#    │ prompt -l           │ list available themes    │
#    ├─────────────────────┼──────────────────────────┤
#    │ prompt -p           │ preview available themes │
#    ├─────────────────────┼──────────────────────────┤
#    │ prompt <your theme> │ enable a theme           │
#    ├─────────────────────┼──────────────────────────┤
#    │ prompt off          │ no theme                 │
#    └─────────────────────┴──────────────────────────┘
#}}}
# Why a newline in the prompt?{{{
#
# It's easier to copy-paste a command,  without having to remove a possible long
# filepath.
#}}}

# What's `PS1`?{{{
#
# A variable which can be used to set the left prompt.
#}}}
# Why this dollar sign?{{{
#
# By prefixing the string  with a dollar sign, you can  include single quotes by
# escaping them  (man [bash|zshmisc]  > QUOTING); otherwise,  you would  need to
# write `'\''`, which is less readable
#}}}
# What's `%F{blue}`?{{{
#
# It sets the color to blue.
#
#     $ man zshmisc /SIMPLE PROMPT ESCAPES /Shell state
#}}}
# What's `%~`?{{{
#
# It inserts the path to the current working directory.
#
# `$HOME` is replaced with `~`.
# And the path to a named directory is replaced with its name;
# if the result is shorter and if you've referred to it in a command at least once.
#
#     man zshparam
#     /PARAMETERS USED BY THE SHELL
#}}}
# What's `%f`?{{{
#
# It resets the color.
#}}}
# What's `%(?..[%?] )`?{{{
#
# It adds an indicator showing whether the last command succeeded ($?).
#
#     man zshmisc
#     /CONDITIONAL SUBSTRINGS IN PROMPTS
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
# Why this weird percent sign at the end?{{{
#
# We use it to move to the start of the previous prompts with a tmux key binding.
#
# Do *not* use a no-break space instead.
# If you copy the command, paste it  in your notes without removing the no-break
# space, then try to “source” it with `+s`, it won't work because the space will
# be considered as being part of the command name.
#}}}
PS1=$'%F{blue}%~%f %F{red}%(?..[%?] )%f\n٪ '
# TODO: add git branch in prompt{{{
#
#     # https://stackoverflow.com/a/12935606/9780968
#
#     setopt PROMPT_SUBST
#     autoload -Uz vcs_info
#     zstyle ':vcs_info:*' stagedstr 'M'
#     zstyle ':vcs_info:*' unstagedstr 'M'
#     zstyle ':vcs_info:*' check-for-changes true
#     zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#     zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
#     zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
#     zstyle ':vcs_info:*' enable git
#
#     ┌ see `man zshcontrib` > +vi-git-myfirsthook()
#     │
#     +vi-git-untracked() {
#       if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true' ]] && \
#       [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]]; then
#         hook_com[unstaged]+='%F{1}??%f'
#       fi
#     }
#
#     precmd () { vcs_info }
#     PROMPT='%F{5}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_} %f%# '
#
# Alternative:
#
#     autoload -Uz vcs_info
#     precmd_vcs_info() { vcs_info }
#     precmd_functions+=( precmd_vcs_info )
#     setopt prompt_subst
#     RPROMPT=\$vcs_info_msg_0_
#     # PROMPT=\$vcs_info_msg_0_'%# '
#     zstyle ':vcs_info:git:*' formats '%b'
#
# Source:
#     https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
#
# Issue:
# When you cd into a non git directory (like `~`):
#
#     VCS_INFO_detect_p4:79: maximum nested function level reached; increase FUNCNEST?
#}}}
# TODO: add indicator to see nested shells.{{{
#
#   https://github.com/wincent/wincent
#   https://raw.githubusercontent.com/wincent/wincent/media/prompt-root-shlvl-3.png
#}}}
# TODO: add indicator to see background processes.{{{
#
#   https://github.com/wincent/wincent
#   https://raw.githubusercontent.com/wincent/wincent/media/prompt-bg.png
#}}}
# TODO: add indicator to better see we're root.{{{
#
#   https://github.com/wincent/wincent
#   https://raw.githubusercontent.com/wincent/wincent/media/prompt-root.png
#}}}

# Why?{{{
#
# Named directories  are handy to  abbreviate the reference to  some directories
# with long paths.
#
# Here, as an example,  when I cd into `~/Downloads/XDCC`, I  want the prompt to
# print `~xdcc` instead of the full path.
#
# To do so, we need to:
#
#    1. create the named directory `~xdcc`
#    2. refer to it in a(ny) command
#}}}
# Could we use another command instead of `:`?{{{
#
# Yes, any command would do.
# }}}
# What does `:` do in general?{{{
#
# From `man zshbuiltins`:
#
# > : [ arg ... ]
#
# >      This  command  does  nothing,  although  normal  argument  expansions  is
# >      performed which may have effects on shell parameters.
#}}}
xdcc=~/Downloads/XDCC/
: ~xdcc

tmp=/run/user/$UID/tmp
: ~tmp

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
#                                   ├──────────────────────────────┐
fpath=( ${HOME}/.zsh/my-completions ${HOME}/.zsh/zsh-completions/src $fpath )

# we use `~/.zsh/my-func` to autoload some of our own custom functions
fpath=( ${HOME}/.zsh/my_func $fpath )

# Add completion for the `dasht` command:
#
#     https://github.com/sunaku/dasht
fpath+=${HOME}/GitRepos/dasht/etc/zsh/completions

# Why loading this module?{{{
#
# We need it for:
#
#    - the `list-prompt` style to work
#    - the `menuselect` keymap to be available when we install key bindings.
#}}}
zmodload zsh/complist

# What's the purpose of these commands?{{{
#
# They  install  programmable completion  functions  for  the most  common  Unix
# commands.
# They  also enable  some more  central  functionality, on  which `zstyle`,  for
# example, rely.
#}}}
# What's the equivalent in bash?{{{
#
#     $ . /etc/bash_completion
#}}}
# What's `autoload`?{{{
#
# `autoload` is equivalent to `functions -u`    (see `run-help autoload`)
#                                      │
#                                      └ autoload flag
#
# `functions` is equivalent to `typeset -f`     (see `run-help functions`)
#                                     │
#                                     └ the following name refers to a function
#                                       and not a parameter
#
# So:
#
#     autoload
#     ⇔
#     typeset -f -u
#
# Also, `typeset`  sets or displays  attributes and values for  shell parameters
# (see `run-help typeset`).
#}}}
# Why is `compinit` an autoloadable function, instead of a simple sourced script?{{{
#
# The behavior of a script could be altered by custom aliases.
# OTOH, a function can be made  autoloadable with `autoload` which can be passed
# the `-U` option, to suppress alias expansion.
#}}}
autoload -Uz compinit
#         ││{{{
#         │└ from `man zshbuiltins` (AUTOLOADING FUNCTIONS):
#         │      mark the function to be autoloaded using the zsh style,
#         │      as if the option KSH_AUTOLOAD was unset
#         │
#         │      i.e. the definition file contains the body of the function directly
#         │      (not `myfunc() {code}`, but just `code`)
#         │
#         └ from `man zshmisc`:
#               suppress usual alias expansion during reading
#}}}
compinit
# Is `compinit` slow?{{{
#
# The first time you start it, yes.
# If you've removed `~/.zcompdump`, yes.
#
# Otherwise, no.
#}}}

# What do these commands do?{{{
#
# A command of the form:
#
#     compdef foo=bar
#
# tells zsh to complete `foo` like it would complete `bar`.
#
# For more info, see:
#
#     https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#copying-completions-from-another-command
#}}}
compdef environ=kill
compdef ppa_what_have_i_installed=ppa_what_can_i_install
compdef surfraw=sr
# Why?{{{
#
# The virtualbox package provides different commands.
# Among them are:
#
#    - `vboxmanage` and `VBoxManage`
#    - `vboxheadless` and `VBoxHeadless`
#
# Thanks to the  `zsh-completions` plugin, we have completions  for the commands
# containing uppercase characters.
# But we don't have completions for the commands written exclusively in lowercase.
# So, we tell zsh to complete the  lowercase commands like it would complete the
# uppercase ones.
#}}}
compdef vboxmanage=VBoxManage
compdef vboxheadless=VBoxHeadless

# What's the purpose of these commands?{{{
#
# For some commands, like `$ pandoc`, there's no easy way to find/generate a zsh
# completion function. But there's one for bash.
# In this case, it can be useful to use the bash completion function.
# To do so, we need to install a compatibility layer to emulate `compgen` and `complete`.
#
# Source:
#     $ man zshcompsys
#}}}
# Will it always work as expected?{{{
#
# It depends on whether the bash completion function you want to use needs
# only `compgen` and/or `complete`.
# If so, it should work, otherwise probably not.
#
# Source:
#     https://unix.stackexchange.com/a/417143/289772
#}}}
autoload -Uz bashcompinit
bashcompinit

# TODO: When you update zsh, try to remove all our code related to `$ pandoc`.{{{
#
# A commit has added support for completing `$ pandoc`:
# https://github.com/zsh-users/zsh/commit/cecaad96cb9a2324e73c58f5dfa8b16fa0d3c589
#}}}
# Why do you need to source this `_pandoc` file here?{{{
#
# There's no default zsh completion function for pandoc:
#     https://github.com/jgm/pandoc/issues/4668
#
# So, we try to use the bash one instead.
#}}}
# How did you generate this file?{{{
#
#     $ pandoc --bash-completion
#}}}
# Is there an alternative to `. /path/to/_pandoc`?{{{
#
# Yes:
#     $ . =(pandoc --bash-completion)
# Or:
#     # From: https://pandoc.org/MANUAL.html
#     $ eval "$(pandoc --bash-completion)"
#}}}
# Why don't you use it?{{{
#
# I don't want to re-generate the  bash completion function every time I start a
# zsh shell.
#}}}

# Why do you use this `bash_source` function? Why don't you source `_pandoc` with a simple `source` or `.`?{{{
#
# To  avoid the  bash `shopt`  builtin and  to avoid  problems with  common bash
# functions that have the same name as zsh ones.
#}}}
# Where did you find the code of these 2 functions?{{{
#
#     https://web.archive.org/web/20180404080213/http://zshwiki.org/home/convert/bash
#}}}
# Are they really necessary for us now? {{{
#
# They don't seem necessary for `pandoc`, at least atm.
# They're not strictly necessary for `tldr`,  but without them, for some reason,
# you would need to press Tab twice to get the completion menu.
#}}}
# TODO: Autoload the functions.
bash_source() {
  alias shopt=':'
  alias _expand=_bash_expand
  alias _complete=_bash_comp
  emulate -L sh
  setopt KSH_GLOB BRACE_EXPAND
  unsetopt SH_GLOB

  source "$@"
}
have() {
  unset have
  (( ${+commands[$1]} )) && have=yes
}
bash_source ~/.zsh/my-completions/_pandoc
# TODO: Sourcing this completion function is too slow. Find a way to make it faster.{{{
#
# It's slow because it runs an external process:
#
#     tldr 2>/dev/null --list
#
# We should cache the output in a file, and ask the completion function to read it.
# It's ok for the completion function to be slightly slow when we press Tab after `$ tldr`.
# It is *not* ok for the sourcing of the function to be slow, because it affects
# every zsh start.
#
# Update:
# The completion still works, even though we've commented the next line.
# However, we have to press Tab twice, instead of once.
# How is that possible?
#}}}
#     bash_source ~/.zsh/my-completions/_tldr

# Why removing the alias `run-help`?{{{
#
# By default, `run-help` is merely an alias for `man`.
# We want the `run-help` shell function  which, before printing a manpage, tries
# to find a help file in case the argument is a builtin command name.
#}}}
# Why silently?{{{
#
# To avoid error messages when we reload zshrc.
#}}}
unalias run-help >/dev/null 2>&1
# Where is this `run-help` function?{{{
#
# It should be in:
#     /usr/share/zsh/functions/Misc/run-help
#
# Otherwise, have a look at:
#     % dpkg -L zsh | grep /run-help$
#}}}
# What should I do if `run-help` doesn't work?{{{
#
# Its directory must be in `$fpath`.
# Make sure it is, and if it's not, add it.
#
# Also, the help pages must have been generated.
# They  should be  in  the default  value  given  to `HELPDIR`  in  the code  of
# `run-help`:
# Probably something like:
#
#     /usr/share/zsh/X.Y.Z-dev-0/help/
#
# If they are not in the directory, try to generate them.
# Download this perl script:
#     https://github.com/zsh-users/zsh/blob/master/Util/helpfiles
#
# And use it:
#     perl /path/to/helpfiles  dest
#                              │
#                              └ where you want the helpfiles to be written
#
# Then, export  `HELPDIR` with the  value of  the directory where  you generated
# your helpfiles:
#     export HELPDIR=/path/to/dir
#}}}
autoload -Uz run-help
# Purpose:{{{
#
# Show me the help of `aptitude`, when I type `sudo aptitude` then press
# the key binding invoking `run-help`.
#
# By default, it's the help of `sudo` which would be shown.
#
# Note, that  `run-help` will  first show you  that `sudo` is  an alias  on your
# machine. Press any key to get the manpage of `aptitude`.
#
# Do  the  same  thing for  various  other  commands  (if  you type  `git  add`,
# `run-help` should show you the help of `git-add`, ...).
#
#     https://stackoverflow.com/a/32293317/9780968
#}}}
# Where did you find this list of functions?{{{
#
#     $ dpkg -L zsh | grep run-help
#}}}
autoload -Uz run-help-sudo \
             run-help-git \
             run-help-ip \
             run-help-openssl \
             run-help-sudo


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

# What does the style 'format' control?{{{
#
# It controls the appearance of a description for each list of matches, when you
# tab-complete a word on the command line.
# Its value gives the format to print the message in.
#
# Example:
#
#     % zstyle ':completion:*' format 'foo %d bar'
#     % true Tab
#         → “foo no argument or option bar”
#}}}
# How is the sequence '%d' expanded?{{{
#
# Into a description of the matches.
#
# For example:
#
#     % echo Tab
#       → file
#
#     % true Tab
#       → no argument or option
#
#     % cat qqq Tab
#       → ˋfiles', ˋfile', or ˋcorrections'
#}}}
# What about '%D'?{{{
#
# If there  are no matches, the  description mentions the name  of each expected
# list of matches.
# `%d` separates those names with spaces, `%D` with newlines.
#
# Don't use `%D` for any context which is not tagged with 'warnings';
# it only works with 'warnings'.
#}}}
# How to print the text in bold?  In standout mode?  Underlined?{{{
#
# You can use the same escape sequences you would use in a prompt,
# described in `man zshmisc`, section EXPANSION OF PROMPT SEQUENCES:
#
#    ┌─────────┬───────────┐
#    │ %B...%b │ Bold      │
#    ├─────────┼───────────┤
#    │ %S...%s │ Standout  │
#    ├─────────┼───────────┤
#    │ %U...%u │ Underline │
#    └─────────┴───────────┘
#}}}
# How to start/stop using a new foreground color?  Background color?{{{
#
#    ┌──────────────┬──────────────────┐
#    │ %F{123}...%f │ Foreground color │
#    ├──────────────┼──────────────────┤
#    │ %K{123}...%k │ bacKground color │
#    └──────────────┴──────────────────┘
#}}}

# zstyle ':completion:*:paths' ambiguous false

# We set the 'format' style for some well-known tags.
# When does a completer tag the description of a list of matches with 'messages'?{{{
#
# When there can't be any completion.
# Ex:
#     % true Tab
#}}}
# What about 'descriptions'?{{{
#
# When there are matches.
# Ex:
#     % echo Tab
#}}}
# What about 'warnings'?{{{
#
# When there are no matches.
# Ex:
#     % cat qqq Tab
#}}}
zstyle ':completion:*:messages'     format '%d'
zstyle ':completion:*:descriptions' format '%F{232}%K{230}%d%f%k'
zstyle ':completion:*:warnings'     format $'No matches:\n%D'

# What does `group-name` control?{{{
#
# It allows you to group the matches with particular tags to the same list.
#}}}
# Why do you set it to an empty string?{{{
#
# When we don't name our group  (empty string), the completion system groups the
# matches according to their tag:
#
#    - external command
#    - builtin command
#    - shell function
#    - alias
#    - parameter
#    ...
#}}}
# How could I group the matches of command names (not shell functions, parameters, ...) together?{{{
#
#     zstyle ':completion:*:*:-command-:*:(commands|builtins|reserved-words|aliases)' group-name commands
#                             ├───────┘   ├────────────────────────────────────────┘
#                             │           └ zsh glob pattern matching several types of matches
#                             │
#                             └ Usually, we write the name of a command in this field.
#                               But  here, we  use  a  special name  `-command-`,
#                               which  restricts   the  style  to   a  completion
#                               triggered in command position.
#
# Alternatively,  if you  couldn't use the  glob pattern in  the tag  field, you
# could write this instead:
#
#     zstyle ':completion:*:*:-command-:*:commands'       group-name commands
#     zstyle ':completion:*:*:-command-:*:builtins'       group-name commands
#     zstyle ':completion:*:*:-command-:*:reserved-words' group-name commands
#     zstyle ':completion:*:*:-command-:*:aliases'        group-name commands
#                                                                    ├──────┘
#                                                                    └ arbitrary name for our group;
#                                                                      every type of matches in this group
#                                                                      would be printed in the same list
#}}}
zstyle ':completion:*' group-name ''
# What does `separate-sections` control?{{{
#
# It's used with the `manuals` tag when completing names of manual pages.
# When set,  zsh prints the different  sections of the manual  where the matches
# can be found.
#
# If the `group-name` style is also set to an empty string, pages from different
# sections will appear separately in different lists.
#}}}
zstyle ':completion:*:manuals' separate-sections true

# Which style controls the printing of descriptions when completing command options?{{{
#
# 'verbose'
#
#     zstyle ':completion:*' verbose true
#
# Try it on this command:
#
#     % typeset - Tab
#}}}
# Why don't you set it?{{{
#
# It's already set to true by default.
#}}}
# What does the style `list-separator` control?{{{
#
# It defines the characters printed between a match and its description.
# By default, its value is `--`.
# I  prefer `  #`  as  it reminds  me  of a  shell  comment,  and separates  the
# description further from the match, which makes it more readable.
#}}}
zstyle ':completion:*' list-separator '  #'
# What does the style `auto-description` control?{{{
#
# It  defines  the  description  for  options that  are  not  described  by  the
# completion functions, but that have exactly one argument.
# The sequence `%d`  in the value will  be replaced by the  description for this
# argument.
#
# Example:
#     % fetchmail --a Tab
#     option
#     --all         # retrieve old and new messages
#     --antispam    # ,   set antispam response values
#     --auth        # specify: authentication types
#                     ├───────┘├──────────────────┘
#                     │        └ added by the expansion of `%d`:
#                     │              description of the argument of `--auth`
#                     │
#                     └ added by the value of `auto-description`
#}}}
zstyle ':completion:*' auto-description 'specify: %d'

zstyle ':completion:*' list-prompt %SAt %p%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#                                            ├────┘{{{
#                                            └ `man zshexpn`
#                                              > PARAMETER EXPANSION
#                                              > Parameter Expansion Flags
#                                              > s:string:
#                                                     Force field splitting at the separator string.
#}}}
# TODO: read this:
#   https://unix.stackexchange.com/a/477527/289772
zstyle ':completion:*' list-colors ''

zstyle ':completion:*' completer _expand _complete _correct _approximate
# show completion menu when number of options is at least 2
# Warning: It has a side-effect:{{{
#
#   % cd /u/l/m Tab a
#               │   │
#               │   └ remove suggestions
#               └ prints suggestions
#
# Without this style,  the suggestions would stay printed, even  after we insert
# 'a'.
#}}}
zstyle ':completion:*' menu select=2
# not sure, but the first part of the next command probably makes completion
# case-insensitive:    https://unix.stackexchange.com/q/185537/232487
# TODO: Sometimes, it doesn't work as I would want.{{{
#
# For   example,  suppose   I  have   the   directory  `lol/`   and  the   movie
# `The.Lego.Movie.2.1080p.HDRip.X264.AC3-EVO.mkv`:
#     $ mpv lego Tab
#     →
#     $ mpv lol
# However:
#     $ mpv the Tab
#     →
#     $ mpv The.Lego.Movie.2.1080p.HDRip.X264.AC3-EVO.mkv
#}}}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' use-compctl false
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# This zstyle is important to make our `$ environ` function be completed with *all* the running processes.{{{
#
# And not just the processes running in the current shell.
# Found here: https://unix.stackexchange.com/a/281614/289772
#}}}
zstyle ':completion:*:processes' command 'ps -A'

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
#
# `(-.)`  is a  glob qualifier  restricting the  expansion to  regular files  or
# symlinks pointing to to regular files.
# `(-/)` does the same thing but for directories.
# `(#i)` is a globbing flag which makes the following pattern case-insensitive.
zstyle ':completion:*:*:mpv:*' file-patterns '*.(#i)(flv|mp4|webm|mkv|wmv|mov|avi|mp3|ogg|wma|flac|wav|aiff|m4a|m4b|m4v|gif|ifo)(-.) *(-/):directories' '*:all-files'

# creates an alias and precedes the command with
# sudo if $EUID is not zero.

# Respect these principles for ordering the sections:{{{
#
# `Plugins` should be near the beginning because  we need to be able to override
# whatever interface they install.
#
# `Abbreviations` should be  right after `Key Bindings` because  it installs key
# bindings.
#
# `Syntax Highlighting` should  be at the end, because the  documentation of the
# plugin explains  that it must  be sourced after  all custom widgets  have been
# created (i.e., after all `zle -N` calls).
# Indeed, the plugin creates a wrapper around each widget.
# If we source it  before some custom widgets, it will still  work, but it won't
# be able to properly highlight the latters.
#}}}

# Plugins {{{1

# if we execute a non-existing command, suggest us some package(s),
# where we could find it (requires the deb package `command-not-found`)
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

# download fasd
if [[ ! -f "${HOME}/bin/fasd" ]]; then
  curl -Ls 'https://raw.githubusercontent.com/clvv/fasd/master/fasd' -o "${HOME}/bin/fasd"
  chmod +x "${HOME}/bin/fasd"
fi

# Why the guard?{{{
#
# In a virtual console, fasd slightly slows  down the shell when the prompt must
# be updated (after executing a command like `cd` or `ls`).
#
# The culprit line is:
#
#     . "${fasd_cache}"
#
# We could disable  only this line, but  it wouldn't make sense  to execute some
# code which we won't use, so we disable everything related to fasd.
#}}}
if [[ -n "${DISPLAY}" ]]; then
  # When we start a shell, the fasd functions may slow the start up.
  # As a workaround, we write them in a cache (`~/.fasd-init-zsh`), which we
  # update when fasd is more recent.
  fasd_cache="${HOME}/.fasd-init-zsh"
  #     ┌ ~/bin/fasd is newer than the cache{{{
  #     │                                           ┌ the cache doesn't exist, or it's empty
  #     ├──────────────────────────────────────┐    ├──────────────────┐}}}
  if [[ "$(command -v fasd)" -nt "${fasd_cache}" || ! -s "${fasd_cache}" ]]; then
    # What does it do?{{{
    #
    # It writes some code in a cache.
    # The code sets up:
    #
    #    - a command hook that executes on every command
    #    - an advanced tab completion
    #
    # The hook will  scan your commands' arguments and determine  if any of them
    # refer to existing files or directories.
    # If yes, fasd will add them to its database.
    #
    # See `$ man fasd` for more info.
    #}}}
    # Why caching the code?{{{
    #
    # We use `fasd` as an external binary.
    # Calling an external binary has some overhead.
    # OTOH, sourcing some file has no overhead.
    #}}}
    # Where did you find the command?{{{
    #
    # Read the output of:
    #
    #     $ fasd --init auto
    #
    # Note the presence of an `eval` in the code.
    # We don't use any `eval` to  avoid calling an external binary every time we
    # start a shell.
    # We source a cache instead.
    #}}}
    # What does each argument passed to `fasd` mean?{{{
    #
    #    ┌───────────────────┬──────────────────────────────────────────────────────┐
    #    │ posix-alias       │ define aliases that applies to all posix shells      │
    #    ├───────────────────┼──────────────────────────────────────────────────────┤
    #    │ zsh-hook          │ define _fasd_preexec and add it to zsh preexec array │
    #    ├───────────────────┼──────────────────────────────────────────────────────┤
    #    │ zsh-ccomp         │ zsh command mode completion definitions              │
    #    ├───────────────────┼──────────────────────────────────────────────────────┤
    #    │ zsh-ccomp-install │ setup command mode completion for zsh                │
    #    ├───────────────────┼──────────────────────────────────────────────────────┤
    #    │ zsh-wcomp         │ zsh word mode completion definitions                 │
    #    ├───────────────────┼──────────────────────────────────────────────────────┤
    #    │ zsh-wcomp-install │ setup word mode completion for zsh                   │
    #    └───────────────────┴──────────────────────────────────────────────────────┘
    #}}}
    fasd --init \
      posix-alias \
      zsh-hook \
      zsh-ccomp \
      zsh-ccomp-install \
      zsh-wcomp \
      zsh-wcomp-install >| "${fasd_cache}"
      #                 │{{{
      #                 └ >| word
      # From `$ man zshmisc`:
      #
      # > Same  as >,  except that  the file  is truncated  to zero  length if  it
      # > exists, even if CLOBBER is unset.
      #}}}
  fi
  . "${fasd_cache}"
  unset fasd_cache
  # TODO: delete the cache from time to time (once per day)?{{{
  #
  # Look at our warning comment before the global alias `V`.
  # It describes an issue which may be solved by removing the fasd cache.
  #
  # More generally, maybe we should remove any cache from time to time.
  #}}}

  alias m='fasd -f -e mpv'
  #                 │
  #                 └ look for a file and open it with `mpv`

  alias o='fasd -a -e xdg-open'
  #                 │
  #                 └ open with `xdg-open`

  alias v='fasd -f -t -e vim -b viminfo'
  #                 │  │      │
  #                 │  │      └ use `viminfo` backend only (search only for files present in `viminfo`)
  #                 │  └ open with vim
  #                 └ match by recent access only

  alias j='fasd_cd -d'
  alias jj='fasd_cd -d -i'
  unalias z zz

  bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
fi

# source fzf config
# Do NOT edit this line!{{{
#
# Not a single character.
# Otherwise, when you execute:
#
#     ~/.fzf/install
#
# manually or automatically, the installer will not recognize your line.
# It will then append this line at the end of your `~/.zshrc`:
#
#     [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# As a result, some of your zsh key bindings may be overridden.
# Including the `transpose-chars` command bound to `C-t`.
#}}}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/zsh-users/zaw
#
# Usage:
#
#    1. Trigger zaw by pressing C-x ;
#    2. select source and press Enter
#    3. filter items with zsh patterns separated by spaces, use C-n, C-p and select one
#    4. press enter key to execute default action, or Meta-enter to write one
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
#    - the completion menu offered by this plugin is more readable
#      than the default one (a single column instead of several)
#
#    - we don't have to select an entry which could be far from our current position,
#      instead we can fuzzy search it via its name
#}}}
[[ -f ${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]] && \
. "${HOME}/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh"
# TODO: It installs a keybinding on C-i (tab): zic-completion
# But doing so, it overwrites a key binding from fzf: fzf-completion
# Is it an issue?

# source our custom aliases and functions (common to bash and zsh) last
# so that they can override anything that could have been sourced before
[[ -f ${HOME}/.shrc ]] && . "${HOME}/.shrc"
# TODO: Remove this once we've removed `~/.shrc`.

# Functions {{{1
alias_is_it_free() { #{{{2
  emulate -L zsh

  # make sure the name hasn't been taken yet
  printf -- 'type %s:\n' "$1"
  type "$1"

  # make sure the name won't shadow a future command
  printf -- '\napt-file -x search "/%s$":\n' "$1"
  apt-file -x search "/$1$"
}

cdt() { #{{{2
  emulate -L zsh
  cd "$(mktemp -d /tmp/.cdt.XXXXXXXXXX)"
}

chown2me() { #{{{2
  # Purpose:{{{
  #
  # Running this function  may be necessary before manually  compiling a program
  # which was installed via checkinstall (think vim or tmux).
  # }}}
  # Why don't you use a zsh snippet? {{{
  #
  # It's too easy to run the command by accident in the wrong directory.
  # We need some logic to make sure we're in the right kind of directory.
  # }}}
  if [[ ! "${PWD}" =~ "^${HOME}/GitRepos" ]]; then
    printf -- "you need to be somewhere below ${HOME}/GitRepos\n"
    return 64
  fi
  sudo chown -R $USER:$USER .
}

cs() { #{{{2
# Do *not* name the function `cheat`!{{{
#
# If you do, when you'll press Tab to get completions, a weird bug happens.
# Vim is not started properly, and you have to kill it with `$ kill vim Tab`.
# It's probably due to: `~/.zsh/zsh-completions/src/_cheat`
#
# Besides,  we'll probably read our  cheatsheets frequently, so the  shorter the
# name of the function the better.
#}}}
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <theme>
example:  $0  tmux
EOF
    return 64
  fi
  vim +"Cheat $1"
}

# cfg_* {{{2

#                                                        ┌ https://stackoverflow.com/a/7507068/9780968
#                                                        │
cfg_autostart() { "${=EDITOR}" "${HOME}/bin/autostartrc" ;}
cfg_bash() { "${=EDITOR}" -o "${HOME}/.bashrc" "${HOME}/.bashenv" "${HOME}/.bash_profile" ;}
cfg_conky_rings() { "${=EDITOR}" "${HOME}/.conky/system_rings.lua" ;}
cfg_conky_system() { "${=EDITOR}" "${HOME}/.conky/system.lua" ;}
cfg_conky_time() { "${=EDITOR}" "${HOME}/.conky/time.lua" ;}
cfg_fasd() { "${=EDITOR}" "${HOME}/.fasdrc" ;}
cfg_fd() { "${=EDITOR}" "${HOME}/.fdignore" ;}
cfg_firefox() { "${=EDITOR}" ${HOME}/.mozilla/firefox/*.default/chrome/userContent.css ;}
cfg_git() { "${=EDITOR}" -o "${HOME}/.config/git/config" "${HOME}/.cvsignore" ;}
cfg_htop() { "${=EDITOR}" "${HOME}/.config/htop/htoprc" ;}
cfg_intersubs() { "${=EDITOR}" -o "${HOME}/.config/mpv/scripts/interSubs.lua" "${HOME}/.config/mpv/scripts/interSubs.py" "${HOME}/.config/mpv/scripts/interSubs_config.py" ;}
cfg_keyboard() { "${=EDITOR}" -o ${HOME}/.config/keyboard/* ;}
cfg_kitty() { "${=EDITOR}" "${HOME}/.config/kitty.conf" ;}
cfg_latexmk() { "${=EDITOR}" "${HOME}/.config/latexmk/latexmkrcl" ;}
cfg_mpv() { "${=EDITOR}" -o "${HOME}/.config/mpv/input.conf" "${HOME}/.config/mpv/mpv.conf" ;}
cfg_newsboat() { "${=EDITOR}" -o "${HOME}/.config/newsboat/config" "${HOME}/.config/newsboat/urls" ;}
cfg_ranger() { "${=EDITOR}" "${HOME}/.config/ranger/rc.conf" ;}
cfg_readline() { "${=EDITOR}" "${HOME}/.inputrc" ;}
cfg_snippet_zsh() { "${=EDITOR}" -o ${HOME}/.config/zsh-snippet/*.txt ;}
cfg_surfraw() { "${=EDITOR}" -o "${HOME}/.config/surfraw/bookmarks" "${HOME}/.config/surfraw/conf" ;}
cfg_tmux() { "${=EDITOR}" "${HOME}/.tmux.conf" ;}
cfg_vim() { "${=EDITOR}" "${HOME}/.vim/vimrc" ;}
cfg_w3m() { "${=EDITOR}" "${HOME}/.w3m/config" ;}
cfg_xbindkeys() { "${=EDITOR}" "${HOME}/.config/keyboard/xbindkeys.conf" ;}
cfg_xfce_terminal() { "${=EDITOR}" "${HOME}/.config/xfce4/terminal/terminal.rc" ;}
cfg_xmodmap() { "${=EDITOR}" "${HOME}/.Xmodmap" ;}
cfg_zathura() { "${=EDITOR}" "${HOME}/.config/zathura/zathurarc" ;}
cfg_zsh() { "${=EDITOR}" -o "${HOME}/.zshrc" "${HOME}/.zshenv" ;}
#              │{{{
#              └ Suppose that we export a value containing a whitespace:
#
#                    export EDITOR='env not_called_by_me=1 vim'
#
# This `export`  would cause  our functions  to fail,  because of the quotes
# which prevent zsh from doing field splitting.
# Besides, even  without the quotes,  zsh (contrary to  bash) does NOT  do field
# splitting on  variable expansion.
# So zsh would interpret the name of the command as `env ...`, instead of `vim`.
#
# Fortunately, we can force zsh to do field splitting using the `=` flag.
# For more info:
#
#     man zshexpn
#     /${=spec}
#}}}

checkinstall_what_have_i_installed() { #{{{2
  emulate -L zsh
  aptitude search '?section(checkinstall)'
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
  #     vimdiff =(setopt) =(emulate -R zsh; setopt)
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

  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
  usage: $0 <keyword>
EOF
    return 64
  fi

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
  #     curl -Ls "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
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
  curl -Ls "http://www.commandlinefu.com/commands/matching/${keywords}/${encoding}/sort-by-votes/plaintext" \
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

environ() { #{{{2
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
  purpose: print the environment variables of an arbitrary process
  usage: $0 PID
EOF
    return 64
  fi
  # https://serverfault.com/a/66366
  tr '\0' '\n' </proc/$1/environ
  # Alternative: `sed 's/\x0/\n/g' "/proc/$1/environ"`
}

expand_this() { #{{{2
  # Purpose?{{{
  #
  # Suppose you want to remove some files, and you pass a glob pattern to `rm`:
  #
  #     $ rm foo*bar
  #
  # You're afraid of removing important files, because you're not sure what the glob
  # expands into.
  # `expand_this` to the rescue:
  #
  #     $ expand_this foo*bar
  #}}}
  emulate -L zsh

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
    cat <<EOF >&2
usage:
    $0 <glob pattern>
    $0 <expansion parameter>

examples:
    $0 *
    $0 "\${path[@]}"
EOF

    return 64
  fi
  printf -- '%s\n' "$@"
}
#}}}2

ff_audio_extract() { #{{{2
  emulate -L zsh
  if [[ $# -ne 3 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <audio stream number>  <output extension>
example:  $0  file.mkv  0  mp3
info:     the streams are indexed from 0
EOF
    return 64
  fi

  local out="audio.$3"
  #       ┌ input file{{{
  #       │
  #       │       ┌ disable video recording (skip video)
  #       │       │
  #       │       │   ┌ copy the audio stream keeping the original codec
  #       │       │   │}}}
  ffmpeg -i "$1" -vn -c:a copy -map "0:a:$2" "${out}"
  #                             │{{{
  #                             └ select the N-th (:"$2") audio stream
  #                               of the first input file (0:)
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The audio stream has been extracted in:  '%s'\n" "${out}"
  fi
}

ff_video_extract() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <video stream number>
example:  $0  file.mp4  0
info:     the streams are indexed from 0
EOF
    return 64
  fi

  # https://stackoverflow.com/a/965072/9780968
  local filename=$(basename -- "$1")
  local extension="${filename##*.}"
  local out="video.${extension}"

  #       ┌ input file{{{
  #       │
  #       │       ┌ disable audio recording (skip audio)
  #       │       │
  #       │       │   ┌ copy the video stream keeping the original codec
  #       │       │   │}}}
  ffmpeg -i "$1" -an -c:v copy -map "0:v:$2" "${out}"
  #                             │{{{
  #                             └ select the N-th (:"$2") video stream
  #                               of the first input file (0:)
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The video stream has been extracted in:  '%s'\n" "${out}"
  fi
}

ff_audio_record() { #{{{2
  emulate -L zsh
  local out='/tmp/rec.wav'
  ffmpeg -f pulse -i default -y "${out}"
  #       │ │        │        │{{{
  #       │ │        │        └ overwrite output files without asking
  #       │ │        │
  #       │ │        └  From `man ffmpeg-devices`:
  #       │ │
  #       │ │                  The filename to provide to the input device
  #       │ │                  is a source device or the string "default".
  #       │ │
  #       │ └ PulseAudio output device
  #       │
  #       │   See:
  #       │           man ffmpeg-devices
  #       │           /^\s*pulse$
  #       │
  #       └ -f fmt (input/output):
  #
  #             Force input or output file format.
  #             The format is normally auto detected for input files and guessed
  #             from the file extension for output  files, so this option is not
  #             needed in most cases.
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "\nThe audio stream has been recorded in:  '%s'\n" "${out}"
  fi
}

ff_desktop_record() { #{{{2
  ffmpeg -draw_mouse 1                     \
         -f x11grab                        \
         -framerate 25                     \
         -video_size '1920x1080'           \
         -i :0.0                           \
         -y                                \
                /tmp/recording_desktop.mkv \
                >/dev/null 2>&1 &
}

ff_get_stream_info() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <file>
EOF
    return 64
  fi

  ffprobe "$1" |& grep -i stream
}

ff_mux_video_and_audio() { #{{{2
  emulate -L zsh
  if [[ $# -ne 3 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <audio file>  <name of the audio track>
example:  $0  file.mkv  audio.aac  eng
EOF
    return 64
  fi

  local out='out.mkv'

  # Broken down:{{{
  #
  # -c:v copy            = copy video stream using the same codec
  # -c:a                 = copy audio stream using aac codec
  # -strict experimental = allow experimental decoders and encoders
  # -map 0               = use all the streams of the first input file
  # -map 1:a:0           = use the first audio stream of the second input file
  #
  # -metadata:s:a:1 language=jpn    = give the title 'jpn' to the 2nd audio track of the muxed file
  #           ^
  #           per-stream (≈ local to a stream) metadata
  #           For more info, see `man ffmpeg`, and search for '-map_metadata'.
  #}}}
  ffmpeg -i "$1" \
         -i "$2" \
         -c:v copy \
         -c:a aac \
         -strict experimental \
         -map 0 \
         -map 1:a:0 \
         -metadata:s:a:1 language="$3" \
         "${out}"

  if [[ $? -eq 0 ]]; then
    printf -- "The streams have been muxed in:  '%s'\n" "${out}"
  fi
}

ff_sub_extract() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  [<subtitle number>]
EOF
    return 64
  fi

  # We're going to extract the subtitles as an `.srt` file.  But what if the file contains an `.ass` subtitle stream?{{{
  #
  # It doesn't matter.
  # `ffmpeg` will do the extraction AND the conversion.
  #}}}
  local out='sub.srt'
  ffmpeg -i "$1" -map "0:s:$2" "${out}"
  #                    │ │ │{{{
  #                    │ │ └ select the N-th one
  #                    │ │
  #                    │ └ select a subtitle
  #                    │
  #                    └ select the first input file
  #}}}
  if [[ $? -eq 0 ]]; then
    printf -- "The subtitles have been extracted in:  '%s'\n" "${out}"
  fi

  # In case of an issue, see:
  #     https://superuser.com/a/927507/913143
}

ff_video_to_gif() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <video file>  <output.gif>
EOF
    return 64
  fi
  gifenc.sh "$1" "$2" >/dev/null 2>&1
}
#}}}2

find_pgm() { #{{{2
  emulate -L zsh
  # A failed filename generation makes zsh stop processing the function.{{{
  #
  # Because  of this,  and because  we  may have  a directory  in `$PATH`  which
  # doesn't contain any file (e.g.  `/usr/local/sbin/`), zsh will fail to expand
  # `$dir/*`, and when that happens, it will stop the function immediately.
  # As a result, we will be missing the programs in the directories afterwards.
  #}}}
  unsetopt NOMATCH

  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage: $0 <command name>
example: $0 edit
EOF
    return 64
  fi

  for dir in "${path[@]}"; do
    #          ┌ yes, you really need the quotes (if one of the directory name contains a path)
    #          │
    for cmd in "${dir}/"*; do
      if [[ -x "${cmd}" && ! -d "${cmd}" ]]; then
        echo "${cmd}"
      fi
    done
  done | sort | grep "$1"
}

fix() { #{{{2
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
  #     $ man infocmp /rs1
  #     $ man tput /rs1
  #}}}
  tput rs1
  tput rs2
  tput rs3
  clear
  printf -- '\ec'
}
#}}}2

fzf_clipboard() { #{{{2
  emulate -L zsh
  # TODO:
  # Find a clipboard manager which you can configure to ignore some apps.
  # Greenclip doesn't allow  you to do that  (you can but, for  some reason, its
  # configuration is reset whenever you copy some text).
  #
  # See: https://wiki.archlinux.org/index.php/Clipboard#Managers
  # (clipster seems the least bad...)
  #
  # Also, see “rofi bangs”: https://www.youtube.com/watch?v=kxJClZIXSnM
  # It could be useful to have a central location from which we can fuzzy search
  # the clipboard history, start apps, launch websearches for various engines...

  # fuzzy find clipboard history
  #     xclip -selection clipboard <<<"$(greenclip print | fzf)"
}

fzf_fasd() { #{{{2
  emulate -L zsh
  if [[ $# -ne 1 ]]; then
    cat <<EOF >&2
usage:    $0  <command>
example:  $0  vim
EOF
    return 64
  fi

  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf -- "%s is not a command\n" "${cmd}"
    return 65
  fi

  local chosen_path
  chosen_path="$(fasd -lR | fzf --no-sort --preview '{ highlight -O ansi {} || cat {} ;} 2>/dev/null')"
  if [[ "${chosen_path}" == '' ]]; then
    return
  fi

  "${cmd}" "${chosen_path}"
}

fzf_locate() { #{{{2
  emulate -L zsh
  if [[ $# -ne 2 ]]; then
    cat <<EOF >&2
usage:    $0  <command>  <pattern>
example:  $0  vim  vimrc
EOF
    return 64
  fi

  local cmd="$1"
  local pat="$2"

  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf -- "%s is not a command\n" "${cmd}"
    return 65
  fi

  # do *not* use the variable name `path`; it would conflict with the tied array `path`,
  # which would prevent the next `command` from working
  local chosen_path
  chosen_path="$(locate "${pat}" | fzf --preview '{ highlight -O ansi {} || cat {} ;} 2>/dev/null')"
  # Why?{{{
  #
  # It doesn't make sense to start a program if we don't provide it any path.
  #
  # ---
  #
  # Also, try this:
  #
  #     $ vim "$(locate vimrc | fzf)"
  #
  # Leave fzf by pressing Escape.
  # Vim will be started with a noname buffer.
  # Press `i` to enter insert mode.
  # It may not work because of this command in `vim-term`:
  #
  #     call timer_start(10, {-> execute('checktime %', 'silent!')})
  #                                                      ^^^^^^^
  #                                                      hides warning message
  #
  # There's an warning  message asking a question, but because  of `silent!`, we
  # can't see it.
  #
  # Interestingly, the issue disappears if you remove the quotes around `$()`:
  #
  #     $ vim $(locate vimrc | fzf)
  #}}}
  if [[ "${chosen_path}" == '' ]]; then
    return
  fi

  "${cmd}" "${chosen_path}"
}
#}}}2

grep_pdf() { #{{{2
  # Purpose:{{{
  #
  # Grep a pattern in a set of pdf files.
  #}}}
  # Rationale:{{{
  #
  # We can't grep for a pattern in a set of files with any grep-like shell tool.
  #
  # You can in Vim, but you need to visit each buffer so that one of our autocmd
  # converts it from pdf to text.
  # This function takes care of all of that.
  #}}}
  # Tip:{{{
  #
  # You don't  need to re-invoke this  function when you're looking  for several
  # patterns in the SAME set of files.
  # After the function has been invoked  once, the pdfs will have been converted
  # to  text in  Vim buffers,  and you'll  be able  to grep  them as  usual with
  # `:vimgrep` from the current Vim instance.
  #}}}
  # Alternative: pdfgrep utility{{{
  #
  #     $ aptitude install pdfgrep
  #     $ find /path -iname '*.pdf' -exec pdfgrep pattern {} +
  #
  # The `+`  at the end prevents  `find` from executing a  `pdfgrep` command for
  # every file it finds.
  # Instead it  concatenates  them all  and  pass them  to  a single  `pdfgrep`
  # command:
  #
  #     pdfgrep pat file1
  #     pdfgrep pat file2
  #     ...
  #   →
  #     pdfgrep pat file1 file2 ...
  #
  # Source:
  #     https://unix.stackexchange.com/a/27517/289772
  #}}}
  emulate -L zsh
  if [[ $# -lt 2 ]]; then
    cat <<EOF >&2
usage:
    $0 'vim regex' file1.pdf file2.pdf ...
    $0 'vim regex' *.pdf
EOF
    return 64
  fi
  local pat="$1"
  # remove the first argument so that `$@` expands to the files,
  # without including the pattern
  # Why `:argdo`?{{{
  #
  # Before we can grep the buffers, they need to be converted to text.
  # We have an autocmd `filter_special_file` in our vimrc to do that.
  # It listens to `BufWinEnter`.
  # So we fire it for every buffer in the arglist.
  #
  # Note that you could use `BufReadPost` too.
  #}}}
  # Why not `:doautoall BufWinEnter` instead?{{{
  #
  # For some reason it doesn't work.
  #
  # According to `:h :doautoall`, the command  works only on loaded buffers; and
  # our pdf buffers, even though not converted yet, are immediately loaded.
  #
  # Also, the help mentions this:
  #
  #     Careful: Don't use this for autocommands that delete a
  #     buffer, change to another buffer or CHANGE THE
  #     CONTENTS OF A BUFFER; THE RESULT IS UNPREDICTABLE.
  #
  # It could explain why `:doautoall` fails.
  #}}}
  # Why `sil!` before `:vim`?{{{
  #
  # If the pattern is absent, I don't want any error message to be printed.
  #}}}
  shift
  vim \
  +'argdo do BufWinEnter' \
  +"sil! noa vim /${pat}/gj ## | cw" \
  "$@"
}

help() { #{{{2
  # Rationale:{{{
  #
  # In bash, the equivalent of `run-help` is `help`.
  # This is inconsistent.
  #
  # Also, `run-help` prints on the terminal.
  # I prefer a Vim buffer.
  #}}}
  run-help "$@" | vipe
}

in_fileA_but_not_in_fileB() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage:
    $0 <file_a> <file_b>
EOF
    return 64
  fi
  # http://unix.stackexchange.com/a/28159
  # Why `wc -l <file` instead of simply `wc -l file`?{{{
  #
  #     $ wc -l file
  #     5 file
  #
  #     $ wc -l < file
  #     5
  #
  # I think that when you reconnect the  input of `$ wc` like this, it doesn't
  # see a  file anymore, only  its contents, which  removes some noise  in the
  # output.
  #}}}
  diff -U $(wc -l <"$1") "$1" "$2" | grep '^-' | sed 's/^-//g'
}

gpg_key_check() { #{{{2
  emulate -L zsh
  if [[ $# -lt 2 ]]; then
    cat <<EOF >&2
  usage: $0 /path/to/key.asc <expected fingerprint>
EOF
    return 64
  fi

  [[ $(gpg --with-fingerprint "$1" \
    | awk 'BEGIN { FS = " = " }; /fingerprint/ { print $2 }') == "$2" ]] \
    && echo 'VALID' || echo 'NOT VALID'
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
  #               ├──────┐
  keywords=$(sed 's/ /.*/g' <<< "$@" | sed 's:(:\\(:g; s:|:\\|:g; s:):\\):g')
  locate -ir "${keywords}" | vim -R --not-a-term -
  #       ││
  #       │└ search for a basic regexp (not a literal string)
  #       │
  #       └ ignore the case
}

logout() { #{{{2
  # Note that  this function  shadows the  `logout` builtin,  but we  don't care
  # because it's a synonym for `exit`.
  emulate -L zsh

  # https://unix.stackexchange.com/a/321096/289772
  session="$(loginctl session-status | awk 'NR==1{print $1}')"
  loginctl terminate-session "${session}"
}

man_pdf() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
  usage: $0 <command name>
EOF
    return 64
  fi
  manpage="$(locate $1 | sed -n "\%share/man/man[^/]*/$1\.%p")"
  # There may be several pages:{{{
  #
  #     $ locate printf | sed -n "\%share/man/man[^/]*/printf\.%p"
  #     /usr/share/man/man1/printf.1.gz~
  #     /usr/share/man/man3/printf.3.gz~
  #
  # In that case, grab the first.
  #
  # This explains how to split a string where a newline is:
  # https://stackoverflow.com/a/19772067/9780968
  #}}}
  read manpage <<<"${manpage}"
  if [[ -z "${manpage}" ]]; then
    printf -- 'no manpage was found for %s\n' "$1"
    return 65
  fi
  # For the `--mode` option, see: https://unix.stackexchange.com/a/462383/289772
  groff -man -Tpdf <(zcat "${manpage}") | zathura --mode fullscreen -
  #      │{{{
  #      └ shorthand for `-m man`
  #        include the macro package `man`
  #}}}
}

man_zsh() { #{{{2
  emulate -L zsh
  # Purpose:{{{
  #
  # We often need to look up a word in the 16 zsh man pages.
  # This function  could be handy to  narrow down the few  pages containing this
  # word.
  #}}}
  man -s1 -Kw "$@" | grep zsh
  #   ├─┘
  #   └ drastically reduce the amount of time the search takes
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

# number conversion between bases {{{2

# Source: http://user.it.uu.se/~embe8573/conf/.zsh/math {{{
#
# The link contains some errors.
# The output base should be expressed using the input base.
# This matters whenever the output base is bigger than the input base.
#}}}
change-base () {
    local from="$1"
    local to="$2"
    local value="$3"
    value="$(tr a-f A-F <<<"${value}")"

    bc <<<"ibase=${from}; obase=${to}; ${value}"
}

# To look for all the functions in this file defined without curly braces:
#
#     /^\s*\S*()\%(.*{\)\@!

# from binary
bin2oct() change-base 2 1000  "$1"
bin2dec() change-base 2 1010  "$1"
bin2hex() change-base 2 10000 "$1"

# from octal
oct2bin() change-base  8  2 "$1"
oct2dec() change-base  8 12 "$1"
oct2hex() change-base  8 20 "$1"

# from decimal
dec2bin() change-base 10  2 "$1"
dec2oct() change-base 10  8 "$1"
dec2hex() change-base 10 16 "$1"

# from hexadecimal
hex2bin() change-base 16  2 "$1"
hex2oct() change-base 16  8 "$1"
hex2dec() change-base 16  A "$1"

nv() { #{{{2
#    │
#    └ You want to prevent the  change of `IFS` from affecting the current shell?
# Ok. Then, use `local IFS`.
# Do NOT  use parentheses  to surround  the body  of the  function and  create a
# subshell. It could cause an issue when we suspend then restart Vim.
#      https://unix.stackexchange.com/a/445192/289772

  emulate -L zsh

  # check whether a Vim server is running
  #
  #                             ┌─ Why do we look for a server whose name is VIM?
  #                             │  By default, when we execute:
  #                             │          vim --remote file
  #                             │
  #                             │  ... without `--servername`, Vim tries to open `file` in a Vim server
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
    #         vim -q =(grep -Rn foo *)    ✔

    elif [[ $1 == -q ]]; then

      shift 1
      local IFS=' '

      #                                 ┌─ Why not $@?
      #                                 │  $@ would be expanded into:
      #                                 │
      #                                 │      '$1' '$2' ...
      #                                 │
      #                                 │  ... but `system()` expects a single string.
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
# For more info: `$ man zshmisc /SPECIAL FUNCTIONS /Hook Functions`
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
#}}}2

ppa_what_can_i_install() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage:
    $0 /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_xenial_universe_binary-amd64_Packages
    $0 <Tab>
EOF
    return 64
  fi
  awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' "$1"
}

ppa_what_have_i_installed() { #{{{2
  emulate -L zsh
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
usage:
    $0 /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_xenial_universe_binary-amd64_Packages
    $0 <Tab>
EOF
    return 64
  fi
  packages="$(awk '$1 == "Package:" { if (a[$2]++ == 0) print $2 }' "$1")"
  cat <<EOF
  The following packages are currently installed on your machine,
  and they can be installed from the PPA you provided.
  So, there's a good chance for them to have been installed from this PPA.
  However, they could also have been installed from somewhere else
  (e.g. your default repositories).
  To be sure, for each of them, execute this command:

      $ apt-cache policy <package>

EOF
  for package in ${=packages}; do
    if ! dpkg-query -W -f='${status}\n' "${package}" |& grep -E 'not-installed|deinstall|no packages found' >/dev/null 2>&1; then
    #                │  │{{{
    #                │  └ -f='<format>'
    #                │      You can select one or several fields, and format them
    #                │      however you want.
    #                │      For the full list of fields, see:
    #                │
    #                │         `man dpkg-query`
    #                │         > OPTIONS
    #                │         > /-f\>
    #                │
    #                └ -W [package-name-pattern...]
    #                      List all packages matching the given pattern.
    #                      The output can be  customized using the `-f` option.
    #                      `-W` is the long form of `--show`
    #                                                  ^}}}
      printf -- "${package}\n"
    fi
  done
}
#}}}2

# script variables {{{2
#
# No need to export  these variables, since you set them every  time you start a
# shell.
script_record_dest='/tmp/.script_record.log'
script_timing_dest='/tmp/.script_timing.log'
#}}}2
script_record() { #{{{2
  emulate -L zsh
  if [[ "$#" -eq 0 ]]; then
    # record interactive session
    script -q --timing=$script_timing_dest $script_record_dest
  else
    # record a specific (set of) command(s)
    script -q --timing=$script_timing_dest -c "$1" $script_record_dest
  fi
}

script_replay() { #{{{2
  emulate -L zsh
  if [[ ! -f $script_record_dest ]]; then
    cat <<EOF >&2
usage:

first invoke:
  \`script_record\` to record an interactive shell session
OR
  \`script_record 'cmd'\` to record a specific command

EOF
    return 64
  fi
  scriptreplay -s $script_record_dest -t $script_timing_dest
}
#}}}2

shellcheck_wiki() { #{{{2
  # Purpose: Get more information about an error found by shellcheck.
  xdg-open "https://github.com/koalaman/shellcheck/wiki/SC$1"
}

tor() { #{{{2
  # Why `cd ...`?  Why not running the desktop file with an absolute path?{{{
  #
  # Here's the shebang of the `.desktop` file:
  #
  #     #!/usr/bin/env ./Browser/execdesktop
  #
  # It will run a script with a relative path.
  # So the current  directory matters; it must be where  we've installed the Tor
  # browser.
  #}}}
  # If you want to add the tor browser to the application menu, run:{{{
  #
  #     $ cd ~/.local/bin/tor-browser_en-US/
  #     $ ./start-tor-browser.desktop --register-app
  #}}}
  cd ~/.local/bin/tor-browser_en-US/
  ./start-tor-browser.desktop
  cd - >/dev/null
}

truecolor() { #{{{2
  emulate -L zsh
  # How to interpret the output?{{{
  #
  # You should see either
  #
  #    - cells randomly|non- colored,
  #      (the terminal doesn't support true color)
  #
  #    - colors from red to blue, with a *non*-smooth gradient
  #      (the terminal partially supports true color)
  #
  #    - colors from red to blue, with a smooth gradient
  #      (the terminal fully supports true color)
  #}}}

  local i r g b

  # What's `r`, `g` and `b`?{{{
  #
  # The quantities of red (r), green (g) and blue (b) for each color we're going to test.}}}
  # How do we make them evolve?{{{
  #
  # To produce a specrum of colors,  they need to evolve in completely different
  # ways. So, we make:
  #
  #    - `r` decrease from 255  (to make the specrum begin from very red)
  #                 to     0  (to get most shades of red)
  #
  #    - `b` increase from   0
  #                 to   255
  #
  #    - `g`    increase from 0   to 255  (but faster than blue so that we produce more various colors)
  #      then decrease from 255 to 0    (via `if (g > 255) g = 2*255 - g;`)
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
    printf -- '\e[48;2;%d;%d;%dm \e[0m' "$r" "$g" "$b"
  done
  printf -- '\n'
}

var_what_have_you() { #{{{2
  # Purpose:{{{
  #
  # Useful to check the contents of a value of an environment variable:
  #
  #     var_what_have_you $IFS
  #
  # The number which is displayed in the lower right corner seems to be a weight
  # in bytes.
  #}}}
  var="$1"
  printf -- '%s' "${var}" | od -t c
  #                         ├┘ ├┘ │{{{
  #                         │  │  └ format = printable character or backslash escape
  #                         │  └ select output format
  #                         └ dump stdin in another format
  #}}}
}
#}}}2

vim_prof() { #{{{2
  emulate -L zsh
  local tmp
  tmp="$(mktemp /tmp/.vim_profile.XXXXXXXXXX)"
  vim --cmd "prof start ${tmp}" --cmd 'prof! file ~/.vim/vimrc' -cq
  vim "${tmp}" -c 'syn off' -c 'norm +tiE' -c 'update'
}

vim_recover() { #{{{2
  emulate -L zsh
  local file
  file="$(basename "$1")"
  # recover swapfile
  vim -r "$1" +"w /tmp/.${file}.recovered | e! | diffsp /tmp/.${file}.recovered"
  # If the recovered version of the file looks good, you still have to do this:
  #
  #     $ mv recovered_file original_file
}

vim_startup() { #{{{2
  emulate -L zsh
  local tmp
  tmp="$(mktemp /tmp/.vim_startup.XXXXXXXXXX)"
  vim --startuptime "${tmp}" \
      +'q' startup_vim_file \
      && vim +'setl bt=nofile nobl bh=wipe noswf | set ft=' \
      +'sil 7,$!sort -rnk2' \
      "${tmp}"
}
#}}}2

whichcomp() { #{{{2
  # Ask zsh where a particular completion is being sourced from.
  # Where did you find the code?{{{
  #
  # Go to the irc channel `#zsh` and run the command `!whichcomp`.
  # A bot will print the code.
  #}}}
  if [[ $# -eq 0 ]]; then
    cat <<EOF >&2
  usage: $0 <command name>
  example: $0 ls
EOF
    return 64
  fi
  # TODO: Document how the code works.
  for 1; do
    (print -raC 2 -- $^fpath/${_comps[$1]:?unknown command}(NP*$1*))
  done
}

xev_terse() { #{{{2
  # Purpose:{{{
  #
  # Filter  the output  of  `xev` so  that it  contains  only information  about
  # KeyPress events, and not about the other ones (like KeyRelease).
  #}}}
  xev | sed -n '/^KeyPress/,/^$/p'
  #             ├───────────────┘
  #             └ print every line between a line beginning with `KeyPress` and an empty line
}

xev_terse_terse() { #{{{2
  # Purpose:{{{
  #
  # Filter the  output of  `xev` so that  it contains only  the keycode  and the
  # keysym of the pressed keys.
  #}}}
  # What does `-A2` do?{{{
  #
  # The keycode and the keysym of a pressed key are printed 2 lines below
  # the line matching `^KeyPress`.
  # So, we ask `grep` to print 2 lines of trailing context after a line matching
  # `^KeyPress`.
  #
  # Mnemonics: `-A` for After
  #}}}
  # What does `--line-buffered` do?{{{
  #
  # When the output of grep is connected to a pipe, it's buffered into a 4K block.
  # That is, `grep` doesn't write anything on the pipe, until it has filled a 4K
  # buffer.
  # Because of this,  when we press a  key, `sed` doesn't receive  the output of
  # grep immediately.
  # We have to press several keys (22?) before `sed` prints something.
  # This is confusing.
  # We want `sed` to print something as soon as we press a key.
  # `--line-buffered` asks `grep` to limit the size of its buffer to a single line.
  # IOW, as soon as it has a line, it writes it to the pipe.
  #}}}
  # Is there an alternative to `--line-buffered`?{{{
  #
  # Yes, you can use the `stdbuf` command, included in the coreutils package:
  #
  #     xev |
  #     stdbuf -oL grep -A2 '^KeyPress' |
  #     sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
  #
  # Here, we use `stdbuf`  to execute `grep` and limit the  size of its internal
  # buffer to a single line, by passing the option `-oL`.
  # `-o` = `--output`, and `L` = line.
  #
  # For more info about `stdbuf`:
  #     https://unix.stackexchange.com/a/25378/289772
  #}}}
  # Source: https://wiki.xfce.org/faq
  xev |
  grep -A2 --line-buffered '^KeyPress' |
  sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
  #       ├─────────┘            ├────────┘   │    ├────┘{{{
  #       │                      │            │    └ capture the keysym (backref `\2`)
  #       │                      │            │
  #       │                      │            └ this is not a capturing group
  #       │                      │              this is a literal opening parenthesis
  #       │                      │
  #       │                      └ capture the keycode
  #       │                        so that we can refer to it later with the backref `\1`
  #       │
  #       └ operate a substitution on any line matching `keycode `
  #}}}
}
#}}}2

xt() { #{{{2
  # Purpose:{{{
  #
  # Extract an archive using the `atool` command.
  # Then,  cd  into  the  directory  where  the  contents  of  the  archive  was
  # extracted. The code is taken from `:Man atool`.
  #}}}
  emulate -L zsh

  local tmp
  tmp="$(mktemp /tmp/xt.XXXXXXXXXX)"
  #      │                  │
  #      │                  └ template for the filename, the `X` will be
  #      │                    randomly replaced with characters matched
  #      │                    by the regex `[0-9a-zA-Z]`
  #      │
  #      └ create a temporary file and store its path into `tmp`

  atool -x --save-outdir="${tmp}" "$@"
  #          │
  #          └ write the name of the folder in which the files have been
  #            extracted inside the temporary file

  # Assign the name of the extraction folder inside to the variable `dir`.
  local dir
  dir="$(cat "${tmp}")"
  [[ -d "${dir}" && "${dir}" != "" ]] && cd "${dir}"
  #  ├─────────┘    ├────────────┘       ├─────────┘
  #  │              │                    │
  #  │              │                    └ enter it
  #  │              │
  #  │              └ and if its name is not empty
  #  │
  #  └ if the directory `dir` exists

  # Delete temporary file.
  rm "${tmp}"
}

zsh_sourced_files() { #{{{2
  emulate -L zsh
  local logfile='zsh_log'
  script -c 'zsh -o SOURCE_TRACE' "${logfile}"
  # FIXME: How to exit the subshell started by `$ script`?{{{
  #
  # If I execute  `$ exit` here, not  only will the subshell  be terminated, but
  # the current function too.
  #}}}
  sed -i '/^+/!d' "${logfile}"
  "${EDITOR}" "${logfile}"
}
#}}}2

_fzf_compgen_dir() { #{{{2
  # Use `fd`  instead of  the default  `find` command to  generate the  list for
  # directory completion.
  #    - `$1` is the base path to start traversal
  #    - see `~/.fzf/shell/completion.zsh` for the details
  fd --hidden --follow --type d . "$1"
}

_fzf_compgen_path() { #{{{2
  # Use `fd` instead of the default `find` command for listing path candidates.
  fd --hidden --follow . "$1"
}
# }}}1
# Aliases {{{1
# regular {{{2
# apt {{{3

alias api='sudo aptitude install'
alias app='sudo aptitude purge'
alias aps='aptitude show'

alias afs='apt-file search'

# awk {{{3

alias rawk='rlwrap awk'

# bc {{{3

alias bc='bc -q -l'
#             │  │
#             │  └ load standard math library (to get more accuracy, and some functions)
#             │
#             └ do not print the welcome message

# cd {{{3

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# df {{{3

# I want colors too!{{{
#
# Use `$ dfc`.
#}}}
alias df='df -h -x tmpfs -T'
#             │  ├─────┘  │{{{
#             │  │        └ print filesystem type (e.g. ext4)
#             │  └ exclude filesystems of type devtmpfs
#             └ human-readable sizes
#}}}

# dirs {{{3

alias dirs='dirs -v'

# dl {{{3

# Do *not* remove `--restrict-filenames`!{{{
#
# If the filename contains spaces, we  want them to be replaced with underscores
# automatically.
# Otherwise,  when you  read a  file containing  spaces with  `$ mpv`,  it's not
# logged by  fasd (unless you  quote it,  but we always  forget to quote  such a
# file).
#}}}
alias dl_mp3='youtube-dl --restrict-filenames -x --audio-format mp3 -o "%(title)s.%(ext)s"'
alias dl_pl='youtube-dl --restrict-filenames --write-sub --sub-lang en,fr --write-auto-sub -o "%(autonumber)02d - %(title)s.%(ext)s"'

alias dl_sub_en='subliminal download -l en'
alias dl_sub_fr='subliminal download -l fr'

alias dl_video='youtube-dl --restrict-filenames --write-sub --sub-lang en,fr --write-auto-sub -o "%(title)s.%(ext)s"'

# git {{{3

# Usage:{{{
#
#     % config status
#     % config add /path/to/file
#     % config commit -m 'my message'
#     % config push
#}}}
alias config='/usr/bin/git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}"'
alias config_push='config add -u && config commit -m "update" && config push'
#                             ├┘{{{
#                             └ All tracked files in the entire working tree are updated.
#
# This removes as well as modifies index  entries to match the working tree, but
# adds no new files.
# It's easier and more reliable to use `-u`, than to manually add every modified
# file, and remove every deleted file:
#
#     $ git add -u
#   ⇔
#     $ git add file1 ... && git rm file2 ...
#}}}

alias ga='git add'

# Do not add `rlwrap` before `git commit`.{{{
# Why?
#     1. It's not needed here.
#     2. It causes an issue.
#
# How to reproduce the issue?
#
#   1. write at the beginning of vimrc:
#
#         nno <silent> cd :sil w<cr>
#         set rtp+=~/.vim/plugged/vim-gutentags/
#         finish
#
#   2. tweak some repo
#   3. try to commit with `rlwrap git commit`
#   4. write something on the 1st line and stay on the 1st line
#   5. while the buffer is still modified, hit `cd`
#
# → the line disappears
#
# It has nothing to do with the conceal feature.
# It's reproducible without syntax highglighting.
#
# Solutions:
#
#    - nno          cd :sil w<cr>
#    - nno <silent> cd :w<cr>
#    - commit without `rlwrap`
#
# We have several mechanisms to save a buffer (including an autocmd).
# It's easier (and more future-proof) to just NOT use `rlwrap`.
#
# TODO:
# I can't reproduce this issue anymore.
# Is this comment still relevant?
#}}}
alias gcm='git commit'
alias gco='git checkout'

# Mnemonics: Git Find
alias gf='git log --all --source -p -S'

alias gp='rlwrap -H /dev/null git push'

# Git Restore Last Commit
alias grlc='git reset --hard "$(git rev-parse HEAD)"'

# this shadows the `/usr/bin/gs` (ghostscript) utility, but I don't care
alias gs='git status -s'
#                     │
#                     └ `--short`, give the output in the short-format

# grep {{{3

alias grep='grep --color=auto'

# grml {{{3

alias grml='vim =(curl -Ls https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc)'

# iconv {{{3

# What's `iconv`?{{{
#
# A utility to convert a text from one encoding (-f ...) to another (-t ...).
#}}}
# What's `ascii//TRANSLIT`?{{{
#
# An encoding similar to `ascii`.
# The difference is that characters are transliterated when needed and possible.
#
# This means that when a character cannot be represented in the target character
# set, it should be approximated through one or several similar looking characters.
# Characters that cannot be transliterated are replaced with a question mark (?).
#}}}
alias iconv_no_accent='iconv -f utf8 -t ascii//TRANSLIT'

# info {{{3

# `--vi-keys` = use vi-like and less-like key bindings.
# `--init-file` = Read key bindings and variable settings from INIT-FILE
# instead of the .infokey file in your home directory.
# https://www.gnu.org/software/texinfo/manual/info-stnd/html_node/Invoking-Info.html#g_t_002d_002dinit_002dfile
alias info='info --vi-keys --init-file=~/.config/infokey'

# iotop {{{3

# `iotop` monitors which process(es) access our disk to read/write it:
alias iotop='iotop -o -P'
#                   │  │
#                   │  └ no threads
#                   │
#                   └ only active processes

# lessh {{{3

# We can have syntax highlighting in the less pager:{{{
#
#     $ sudo aptitude install source-highlight
#     $ cp /usr/share/source-highlight/src-hilite-lesspipe.sh ~/bin/src-hilite-lesspipe.sh
#     $ alias lessh='LESSOPEN="| ~/bin/src-hilite-lesspipe.sh %s" less'
#     $ lessh ~/GitRepos/ranger/ranger.py
#
# Source: https://unix.stackexchange.com/a/139787/289772
#}}}
# FIXME: `lessh` is highlighted in red (as if it was executed a wrong command).{{{
#
# It should be highlighted as an alias.
#
# It's fixed by this commit:
#
#     https://github.com/zsh-users/zsh-syntax-highlighting/commit/cb8c736a564e0023a0ef4e7635c0eb4be5eb56a4
#
# I use a purposefully older version of the zsh-syntax-highlighting plugin,
# because this commit introduces a regression:
#
#     https://github.com/zsh-users/zsh-syntax-highlighting/issues/565
#}}}
alias lessh='LESSOPEN="| ~/bin/src-hilite-lesspipe.sh %s" less'

# ls {{{3

alias ls='ls --color=auto'
alias l=ls++

# lua {{{3

alias lua='lua5.3'

# man_ascii {{{3

#                                 ┌ print 20 lines of trailing context,{{{
#                                 │ i.e. the 20 lines following the line where 'Tables' was matched
#                                 ├───┐}}}
alias man_ascii='man ascii | grep -A 20 Tables'
alias man_ascii_long='man ascii | grep -A 67 Oct | less'

# mpv {{{3

# watch a video in a virtual console
alias mpv_console='mpv -vo drm'

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

# nb {{{3

# Warning:{{{
#
# This alias shadows the `nb` binary installed by the `nanoblogger` package.
#}}}
alias nb='newsboat -q'

# nethogs {{{3

# `nethogs` is a utility showing  which processes are consuming bandwidth on our
# network interface.
alias net_watch='nethogs enp3s0'

# options {{{3

# Purpose:{{{
#
# You want to know the state of an option (enabled or disabled).
# Execute this alias, and look for the option name in both buffers.
#
# Once you find it, check the buffer where you found it.
# In the left buffer, read the value as it is:
#
#     autocd     → 'autocd' is enabled
#     nolistbeep → 'list_beep' is disabled
#
# In the right buffer, reverse the reading:
#
#     noaliases  → 'aliases' is ENabled
#     chaselinks → 'chaselinks' is DISabled
# }}}
# Why do I need to reverse the meaning of the info I read in the right buffer? {{{
#
# Because the meaning of the output of `unsetopt` is:
#
#     the values of these options is NOT ...
#
# This 'NOT' reverses the reading:
#
#     NOT nooption = NOT disabled = enabled
#     NOT option   = NOT enabled  = disabled
# }}}
# Is there an alternative?{{{
#
# Yes:  `set -o`.
#}}}
# Why don't you use it?{{{
#
# It  doesn't tell  you whether  the  default values  of the  options have  been
# changed.
#}}}
alias options='vim -O =(setopt) =(unsetopt)'
#                       │         │
#                       │         └ options whose default value has NOT changed
#                       └ options whose default value has changed


# ps {{{3

# http://0pointer.de/blog/projects/systemd-for-admins-2.html
#                   ┌ select all processes{{{
#                   │┌ user-defined format
#                   ││}}}
alias psc='ps xawf -eo pid,user,cgroup,args'
#             ││││{{{
#             ││││
#             ││││
#             │││└ ASCII art process hierarchy (forest)
#             ││└ wide output
#             │└ list the "only yourself" restriction
#             └ list the "must have a tty" restriction
#}}}

# py {{{3

alias py='/usr/local/bin/python3.7'

# qmv {{{3

alias qmv='qmv --format=destination-only'
#                │
#                └ -f, --format=FORMAT
#
# Change edit format of text file.
# Available edit formats are:
#
#     `single-column`       (or `sc`)
#     `dual-column`         (or `dc`)
#     `destination-only`    (or `do`)
#
# The default format is dual-column.

# ranger {{{3

alias fm='[[ -n "${TMUX}" ]] && tmux rename-window fm; ranger'

# rg {{{3

alias rg='rg 2>/dev/null --vimgrep -i -L'

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

# systemd {{{3

alias sc='systemctl'
alias jc='journalctl'

# Purpose: print the status of all services.
# Mnemonic: SystemCtl List services
# Tip: If you want only the running services, expand the alias and remove `--all`.
alias scl='systemctl list-units --type service --all'

# tlmgr_gui {{{3

alias tlmgr_gui='tlmgr gui -font "helvetica 20" -geometry=1920x1080-0+0 >/dev/null 2>&1 &!'
#                                                                                       ├┘
#                                                                                       └ ⇔ & disown

# top {{{3

alias top='htop'

# trash {{{3

alias te='trash-empty'

alias tl='trash-list'

alias tp='trash-put'

# TRash Restore
alias trr='rlwrap restore-trash'

# ubuntu-code-name {{{3

alias ubuntu-code-name='lsb_release -sc'
#                                    ││
#                                    │└ --codename
#                                    └ --short

# ubuntu-version {{{3

alias ubuntu-version='cat /etc/issue'

# VirtualBox {{{3

alias vb='VBoxManage'

# Useful to access the settings of a VM, from the GUI, while it's shut down.
alias vb_start='virtualbox &!'

# website_cwd {{{3

# Usage:{{{
#
#     $ website_cwd
#
# In your browser, visit 0.0.0.0:8000, and you'll get access to all the files in
# your cwd.
# This is useful when  you create a website, and you need to  view how your html
# files are rendered, without having to manually open each of them with C-o.
#}}}
# Source:{{{
#
#     https://www.commandlinefu.com/commands/view/71/serve-current-directory-tree-at-httphostname8000#comment
#     https://www.commandlinefu.com/commands/view/7338/python-version-3-serve-current-directory-tree-at-httphostname8000
#}}}
alias website_cwd='{ python3 -m http.server >/dev/null 2>&1 & ;} && disown %'

# what_is_my_ip {{{3

alias what_is_my_ip='curl ifconfig.me'

# xbindkeys {{{3

alias xbindkeys_restart='killall xbindkeys; xbindkeys -f "${HOME}/.config/keyboard/xbindkeys.conf"'

# zsh_sourcetrace {{{3

# get the list of files sourced by zsh
alias zsh_sourcetrace='zsh -o sourcetrace'
#                           ├────────────┘
#                           └ start a new zsh shell, enabling the 'sourcetrace' option
#                             see `man zshoptions` for a description of the option

# zsh_startup {{{3

alias zsh_startup='repeat 10 time zsh -i -c exit'

# }}}2
# global {{{2

# We could implement the following global aliases as abbreviations, but we won't
# because they can only be used at the end of a command.
# To be expanded, an abbreviation needs to be followed by a space.

# align columns
alias -g C='| column -t'

alias -g L='2>&1 | less -R'

# No Errors
alias -g NE='2>/dev/null'

# silence!
#           ┌ redirect output to /dev/null
#           │          ┌ same thing for errors
#           ├────────┐ ├──┐
alias -g S='>/dev/null 2>&1 &'
#                           │
#                           └ execute in background

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
#}}}

# Warning: If `cmd V` opens an empty buffer,{{{
# then later opens the right buffer (the  one containing the output of `$ cmd`),
# try to delete `~/.fasd-init-zsh`, and restart the shell.
#
# It worked in the past.
# The issue came from:
#
#     ~/.fasd-init-zsh:22
#     { eval "fasd --proc $(fasd --sanitize $1)"; } >> "/dev/null" 2>&1
#                                            ^
#                                            ✘ if you replace it with 2, the issue disappears
#
# Maybe  the issue  came  from  having installed  fasd  from  the official  repo
# (instead of github)...
#}}}
alias -g V='2>&1 | vipe >/dev/null'
#                       │
#                       └ don't write on the terminal, the Vim buffer is enough

# suffix {{{2

# automatically open a file with the right program, according to its extension

alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv
alias -s {jpg,png}=feh
alias -s gif=ristretto
alias -s {epub,mobi}=ebook-viewer
alias -s {md,markdown,txt,html,css}=vim
alias -s odt=libreoffice
alias -s pdf="${PDFVIEWER}"
# }}}1
# Hooks {{{1

# TODO: better explain how it works

# There's no  `HISTIGNORE` option in  zsh, to ask  some commands to  be excluded
# from the history.
#
# Solution:
# zsh provides a hook function `zshaddhistory` which can be used for that.
# If `zshaddhistory_functions` contains  the name of a function  which returns a
# non-zero value, the command is not saved in the history file.
# zshaddhistory_functions=(ignore_these_cmds ignore_short_or_failed_cmds)

# The shell allows newlines to separate array elements.
# So,  an array  assignment can  be split  over multiple  lines without  putting
# backslashes on the end of the line.
cmds_to_ignore_in_history=(
  api
  app
  aps
  bg
  cd
  clear
  config
  dl_video
  exit
  fg
  imv
  j
  jobs
  ls
  man
  mv
  reset
  rm
  rmdir
  sleep
  tldr
  touch
  tp
  vimdiff
  web
)

ignore_these_cmds() {
  emulate -L zsh
  local first_word
  # zsh passes the command line to this function via $1
  # we extract the first word on the line
  # Source:
  #     https://unix.stackexchange.com/a/273277/289772
  first_word=${${(z)1}[1]}
  # What's the effect of this `z` flag in the expansion of the `$1` parameter?{{{
  #
  # It splits the result of the expansion into words.
  #
  # Watch:
  #     $ sentence='Hello jane, how are you!'
  #
  #     $ printf -- '%s\n' ${sentence}
  #         Hello jane, how are you!
  #
  #     $ printf -- '%s\n' ${(z)sentence}
  #         Hello
  #         jane,
  #         how
  #         are
  #         you!
  #
  #     $ printf -- '%s\n' ${${(z)sentence}[2]}
  #         jane,
  #
  # For more info, see:
  #
  #     man zshexpn
  #     > PARAMETER EXPANSION
  #     > Parameter Expansion Flags
  #}}}

  # now we check whether it's somewhere in our array of commands to ignore
  #     https://unix.stackexchange.com/a/411331/289772
  if ((${cmds_to_ignore_in_history[(I)$first_word]})); then
    # Why `2` instead of `1`?{{{
    #
    # `1` = the command is removed from the history of the session,
    # as soon as you execute another command
    #
    # `2` = the command is still in the history of the session,
    # even after executing another command,
    # so you can retrieve it by pressing M-p or C-p
    #}}}
    return 2
  else
    return 0
  fi
}

ignore_short_or_failed_cmds() {
  emulate -L zsh
  # ignore commands who are shorter than 5 characters
  # Why `-le 6` instead of `-le 5`?{{{
  #
  # Because zsh sends a newline at the end of the command.
  #}}}
  #                             ┌ ignore non-recognized commands
  #                             ├─────────┐
  if [[ "${#1}" -le 6 ]] || [[ "$?" == 127 ]]; then
    return 0
  else
    return 2
  fi
}

# Key Bindings {{{1
# How to bind a function to a key sequence using both the meta and control modifiers?{{{
#
# This is how you would do it for `M-C-z`:
#
#     bindkey '\e^z' your_function
#                 │
#                 └ replace 'z' with the key you want
#}}}
# How to set the position of the cursor in a key binding using the `-s` flag (`bindkey -s`)?{{{
#
# Write `\e123^B` at  the end of the rhs, to position  the cursor 123 characters
# before the end of the line.
#
# Example:
#
#     bindkey -s '^Xr' '^A^Kfor f in *; do echo mv \"$f\" \"${f}\";done\e7^B'
#}}}

# fzf {{{2
# How can I rebind the fzf widget to fuzzy search the history of commands:{{{
#
#     bindkey -r '^R'
#     bindkey 'your key' fzf-history-widget
#}}}

# The default key binding to jump in a child directory is `M-c`.
# Too hard to type; let's try `M-j` instead.
bindkey -r '\ec'
bindkey '\ej' fzf-cd-widget

# The default key binding to complete a file under the current directory is `C-t`.
# It overrides the shell `transpose-chars` function.
bindkey '^X^T' fzf-file-widget
bindkey '^T' transpose-chars

# Delete {{{2

# The delete key doesn't work in zsh. Let's fix it.
# The sequence is hard-coded. I don't like that, because it may not be portable across different environments.{{{
#
# If you want sth more portable, you could try this:
#
#     autoload zkbd
#     [[ ! -f "${HOME}/.zkbd/${TERM}" ]] && zkbd
#     . "${HOME}/.zkbd/${TERM}"
#     [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
#
# This calls the zkbd utility – documented at `$ man zshcontrib /zkbd`.
#
# The first time the code  is run in a new terminal, it will  ask you to press a
# few keys.
#
# If you  can't find  one of the  key that  it asks, don't  worry; it  will just
# ignore this key in the next generated file.
# After that, it will generate the file `~/.zkbd/YOUR_TERM-:0.0`.
# Rename it in `~/.zkbd/YOUR_TERM`.
#
# The next times the code is run, it will simply source the generated file.
# You may then use `${key[Delete]}` to reference the Delete key in a bindkey command.
#
# Issue: How to reliably detect the identity of the terminal?
# In tmux, `$TERM` always contains `tmux-256color`.
# You could use `$COLORTERM`, but there's no guarantee it will work for any terminal.
# For example, gnome-terminal, st, and xterm do not set this variable.
#}}}
bindkey '\e[3~' delete-char

# The previous key binding is enough to fix the delete key in most terminals.
# But not in st. For the latter, we also need this:
if [[ -n "${DISPLAY}" ]]; then
  zle-line-init() { echoti smkx }
  zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
# What does it do?{{{
#
# It temporarily turns on the “application” mode.
#}}}
#   What's that application mode?{{{
#
# The terminal is in “normal mode” when you are on the shell's command-line, and
# in “application mode” when you are in a TUI application such as Vim.
# Depending on the mode you're in, a function key (performing an action, and not
# associated to any glyph) sends a different escape sequence.
#
# The Vim's help and the terminfo documentation use another terminology.
# They   call   the  application   mode,   resp.   keypad  transmit   mode   and
# keyboard_transmit mode.
#
# For more info:
# http://invisible-island.net/xterm/xterm.faq.html#xterm_arrows
# http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-PC-Style-Function-Keys
#
# See also:
#
#     $ man terminfo /smkx
#     :h t_ks
#}}}
#     When I inspect the escape sequence sent by a function key, it's the same in both modes!{{{
#
# It doesn't change because of our custom configuration.
# To see a difference:
#
#    - if you're in zsh, comment out the four previous lines
#    - if you're in bash, comment out the following line in `~/.inputrc`:
#
#         set enable-keypad on
#}}}

# Why the guard?{{{
#
# A virtual console has no `smkx` capability:
#
#     $ infocmp linux | grep smkx
#     ''~
#
# So, the code would raise this error:
#
#     zle-line-init:echoti: no such terminfo capability: smkx~
#}}}

# Why do we need this for st, but not for the other terminals?{{{
#
# When  you press  the  delete key,  most  terminals  react as  if  you were  in
# application  mode. That is,  they emit  the  string stored  in the  capability
# `kdch1` (Keyboard Delete 1 CHaracter).
#
#     $ infocmp -x | grep kdch1
#     ... kdch1=\E[3~,~
#               ^^^^^
#
# I don't  know why  they do  that, because,  as I  understand it,  the terminal
# should not be in  application mode when you press the delete  key outside of a
# TUI application.
#
# Anyway, st is different.
# It  correctly emits `kdch1`  *iff* you're  in application mode;  otherwise, it
# emits `dch1`.
#
# ---
#
# Here's how you can check this.
# In urxvt:
#
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput smkx
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput rmkx
#
# In st:
#
#     $ cat
#     SUPPR
#     ^[[P~
#     C-c
#
#     $ tput smkx
#     $ cat
#     SUPPR
#     ^[[3~~
#     C-c
#
#     $ tput rmkx
#}}}
# What are these `zle-line-init()` and `zle-init-finish()` functions?{{{
#
# The first function is executed every time the line editor is started to read a
# new line of input.
# The  second function  is  executed every  time the  line  editor has  finished
# reading a new line of input.
#
# See `$ man zshzle /zle-line-init`
#}}}

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
#          but when we press `S-Tab`, the terminal receives the escape sequence `escape + [ + Z`
#          so we use them in the lhs of our key binding

# Ctrl {{{2
# C-SPC      set-mark-command {{{3

bindkey '^ ' set-mark-command

# C-^        previous_directory {{{3
# cycle between current dir and old dir
__previous_directory() {
  emulate -L zsh
  # contrary to bash, zsh sets `$OLDPWD` immediately when we start a shell
  # so, no need to check it's not empty
  cd -
  # refresh the prompt so that it reflects the new working directory
  zle reset-prompt
}
zle -N __previous_directory
bindkey '^^' __previous_directory

# C-g        (prefix) {{{3

# To use `C-g` as a prefix, we need to remove the function to which it's bound by default.
# Otherwise, when  we press `C-g  C-<key>`, if we  aren't quick enough  to press
# `C-<key>`, zsh would simply cancel the command.
bindkey -r '^G'

# C-g C-g    snippets {{{4

# TODO: fully understand/comment the code

# Adapted From: https://github.com/liangguohuan/fzf-marker
# Itself Inspired By: https://github.com/pindexis/marker.git

# Usage:
# Press `C-g C-g` to choose a snippet if there's no `{{` on the cmdline.
# Press `C-g C-g` to jump to the first tabstop and remove its default value.
# Press `C-g  g` to  jump to the  first tabstop and  “reveal” its  default value
# (remove the `{{` and `}}`).

FZF_SNIPPET_COMMAND_COLOR='\x1b[38;5;33m'
FZF_SNIPPET_COMMENT_COLOR='\x1b[38;5;7m'

# snippet selection
_fzf_snippet_main_widget() {
  emulate -L zsh
  if grep -q '{{' <<<"${BUFFER}"; then
    _fzf_snippet_placeholder
  else
    local selected
    if selected=$(cat ${HOME}/.config/zsh-snippet/*.txt |
      sed "/^$\|^#/d
           s/\(^[a-zA-Z0-9_-]\+\)\s/${FZF_SNIPPET_COMMAND_COLOR}\1\x1b[0m /
           s/\s*\(#\+\)\(.*\)/${FZF_SNIPPET_COMMENT_COLOR}  \1\2\x1b[0m/" |
      fzf --height=${FZF_TMUX_HEIGHT:-40%} --reverse --ansi -q "${LBUFFER}"); then
      LBUFFER=$(sed 's/\s*#.*//' <<<"${selected}")
    fi
    zle redisplay
  fi
}

_fzf_snippet_placeholder() {
  emulate -L zsh
  local strp pos placeholder
  # What's `+?`?{{{
  #
  # A non-greedy `+` quantifier.
  # It's the equivalent of `\{-}` in Vim.
  # We can  use it here thanks  to grep's `-P` option  which allows us to  use a
  # PCRE regex.
  #}}}
  strp=$(grep -Z -P -b -o "\{\{.+?\}\}" <<<"${BUFFER}")
  strp=$(head -1 <<<"${strp}")
  pos=$(cut -d ":" -f1 <<<"${strp}")
  placeholder=${strp#*:}
  if [[ -n "$1" ]]; then
    BUFFER=$(echo -E ${BUFFER} | sed 's/{{//; s/}}//')
    CURSOR=$((${pos} + ${#placeholder} - 4))
  else
    # What's `A`?{{{
    #
    # A variable storing the delimiter used in the next sed command.
    #}}}
    #   Which value do you assign it?{{{
    #
    # A literal ‘C-a’.
    #}}}
    #     Why this particular value?{{{
    #
    # We don't know what will be in the placeholder.
    # It will contain user data, i.e. whatever  we write in the placeholder of a
    # snippet.
    # If it contains a slash, then we can't use a slash for the delimiter.
    # `C-a` should never appear in a snippet, therefore we can safely use it here.
    #}}}
    # Why don't you use this simpler assignment `A="\001"`?{{{
    #
    # It wouldn't work.
    # The sequence of characters `\001` would not be translated into a literal ‘C-a’.
    #
    # MWE:
    #     func() {
    #       A="$(tr 'x' '\001' <<<'x')"
    #       echo "s${A}bar${A}${A}" | od -t c
    #       sed "s${A}bar${A}${A}" <<<'foo bar baz'
    #     }
    #     $ func
    #     0000000   s 001   b   a   r 001 001  \n~
    #     0000010~
    #     foo  baz~
    #
    #     func() {
    #       A="\001"
    #       echo "s${A}bar${A}${A}" | od -t c
    #       sed "s${A}bar${A}${A}" <<<'foo bar baz'
    #     }
    #     $ func
    #     0000000   s   \   0   0   1   b   a   r   \   0   0   1   \   0   0   1~
    #     0000020  \n~
    #     0000021~
    #     foo bar baz~
    #}}}
    A="$(tr 'x' '\001' <<<'x')"
    BUFFER=$(echo -E ${BUFFER} | sed "s${A}${placeholder}${A}${A}")
    CURSOR=pos
  fi
}

_fzf_snippet_placeholder_widget() { _fzf_snippet_placeholder "defval" }

zle -N _fzf_snippet_main_widget
zle -N _fzf_snippet_placeholder_widget
bindkey '^G^G' _fzf_snippet_main_widget
bindkey '^Gg' _fzf_snippet_placeholder_widget
# }}}3
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
#    └ -N widget [ function ]
# Create a user-defined  widget. When the new widget is invoked  from within the
# editor, the specified shell function is called.
# If no function name is specified, it defaults to the same name as the widget.
bindkey '^Q' __quote_big_word

# C-u        backward-kill-line {{{3

# By default, C-u deletes the whole line (kill-whole-line).
# I prefer the behavior of readline which deletes only from the cursor till the
# beginning of the line.
bindkey '^U' backward-kill-line

# C-x        (prefix) {{{3

# NOTE: It seems we can't bind anything to `C-x C-c`, because `C-c` is interpreted as
# an interrupt signal sent to kill the foreground process. Even if hit after `C-x`.
#
# It's probably  done by the terminal  driver. Maybe we could disable  this with
# `stty` (the  output of  `stty -a` contains  `intr = ^C`),  but it  wouldn't be
# wise, because it's too important.
# We would need to find a way to disable it only after `C-x`.

# C-x C-e         edit-command-line {{{4

autoload -Uz edit-command-line
zle -N edit-command-line

# Why this wrapper function around the `$ vim` command?{{{
#
# It allows us to customize the environment.
#
# Atm, we simply add an autocmd to remove the leading dollar in front of a shell
# command, which  we often  paste when  we copy some  code from  the web  or our
# notes.
# We also remove a possible indentation in front of `EOF`.
# In the future, we could do more advanced things...
#
# ---
#
# Also:
#
#     C-x C-e
#     :sp
#     C-k
#     C-j
#
# The last key should move the focus to the window below but it doesn't.
# This is  because zle  doesn't properly  restore stty settings  when it  runs a
# command from within command line edition:
#
#     https://unix.stackexchange.com/q/484764/289772
#
# More specifically, it doesn't remove the terminal line setting `inlcr`.
# Here's how you can check this:
#
#     EDITOR=func
#     func() {
#       stty -a >/tmp/stty_zle
#     }
#     C-x C-e
#
#     $ stty -a >/tmp/stty
#
#     $ vimdiff /tmp/stty /tmp/stty_zle
#               ├───────┘ ├───────────┘
#               │         └ contains 'inlcr'
#               │
#               └ contains '-inlcr'
#
# Solution 1:
# Create this wrapper function around `edit-command-line()`.
#
# Solution 2:
# Copy `/usr/share/zsh/functions/Zle/edit-command-line` inside `~/.zsh/`.
# Then edit the copy to include one of those lines:
#
#     STTY=sane
#     STTY=-inlcr
#
# You would lose the possible future updates of the original function:
#
#     https://sourceforge.net/p/zsh/code/ci/ef20425381e83ebd5a10c2ab270a347018371162/log/?path=/Functions/Zle/edit-command-line
#
# Source: https://unix.stackexchange.com/a/485467/289772
#}}}
# Is `"$@"` necessary?{{{
#
# Yes, for the temporary filename to be passed.
#}}}
__sane_vim() STTY=sane command vim +'au TextChanged <buffer> sil! call source#fix_shell_cmd()' "$@"
#            ├───────┘                 {{{
#            └ man zshparam
#              /PARAMETERS USED BY THE SHELL
#
# Run `stty sane` in order to set up the terminal before executing `vim`.
# The effect of `stty sane` is local to the `vim` command, and is reset when Vim
# finishes or is suspended.
#}}}

sane-edit-command-line() {
  emulate -L zsh
  local EDITOR='__sane_vim'
  zle edit-command-line
}
zle -N sane-edit-command-line

bindkey '^X^E' sane-edit-command-line
#              ^^^^^
#              wrapper function around the `edit-command-line()` function

# C-x C-h         complete-help {{{4

# TODO:
# This shows tags when we're at a certain  point of a command line where we want
# to customize the completion system.
# Explain what tags are, and how to read the output of `_complete_help`.
#
# See `man zshcompsys` > COMPLETION SYSTEM CONFIGURATION > Overview
#                    > BINDABLE COMMANDS
bindkey '^X^H' _complete_help

# The  `_complete_help` widget  shows all  the contexts  and tags  available for
# completion at a particular point.
# This provides an easy way of finding information for tag-order and other styles.
#
# This  widget displays information about  the context names, the  tags, and the
# completion functions used when completing at the current cursor position.
# If given a  numeric argument other than  1 (as in `ESC-2 ^Xh'),  then the styles
# used and the contexts for which they are used will be shown, too.
#
# Note that  the information about styles  may be incomplete; it  depends on the
# information available  from the  completion functions called,  which in  turn is
# determined by the user's own styles and other settings.

# What's the purpose of the `_complete_debug` widget?{{{
#
# It performs ordinary  completion, but captures in a temporary  file a trace of
# the shell commands executed by the completion system.
# Each completion attempt gets its own file.
# A command to view each of these files is pushed onto the editor buffer stack.
#}}}
# Why do you create a wrapper around the default widget `_complete_debug`?{{{
#
# After invoking the `_complete_debug` widget, you'll see sth like:
#
#     Trace output left in /tmp/zsh6028echo1 (up-history to view)
#                                             ^^^^^^^^^^^^^^^^^^
# If you invoke  `up-history` (for us `C-p`  is bound to sth  similar because of
# `bindkey  -e`), in  theory zsh  should populate  the command  line with  a vim
# command to read the trace file.
# In practice, it won't happen because you've enabled 'MENU_COMPLETE'.
# Because of this, after pressing Tab, you've already entered the menu,
# and `C-p` will simply select the above match in the menu.
#
# MWE:
#
#     autoload -Uz compinit
#     compinit
#     setopt MENU_COMPLETE
#     bindkey '^X?' _complete_debug
#     bindkey '^P' up-history
#
# So, to conveniently read the trace  file, we make sure that 'MENU_COMPLETE' is
# temporarily reset.
#}}}
__complete_debug() {
  emulate -L zsh
  unsetopt MENU_COMPLETE
  zle _complete_debug
  # no need to restore the option, the change is local to the function
  # thanks to `emulate -L zsh`
}
zle -N __complete_debug
bindkey '^X?' __complete_debug

# C-x C-k         kill-region {{{4

# Usage:{{{
#
#     $ echo foo 'baz' bar
#                ^
#                cursor here
#
#     # press C-SPC to set the mark
#
#     $ echo foo 'baz' bar
#                     ^
#                     cursor moved here, so that the region covers the text 'baz'
#
#     # press C-x C-k to kill the region
#     $ echo  foo bar~
#
#     # press C-d C-e SPC C-y
#     $ echo foo bar 'baz'~
#}}}
bindkey '^X^K' kill-region

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

# re-execute last command with higher privileges
bindkey -s '^X^S' 'sudo -E env "PATH=$PATH" bash -c "!!"^M'
#        │               │      │{{{
#        │               │      └ make sure `PATH` is preserved, in case `-E` didn't
#        │               │
#        │               └ preserve some variables in current environment
#        │
#        └ interpret the arguments as strings of characters
#          without `-s`, `sudo` would be interpreted as the name of a zle widget
#}}}

# Alternative:
#     bindkey -s '^Xs' 'sudo !!^M'
#
# The 1st command is more powerul,  because it should escalate the privilege for
# the whole command-line.
# Sometimes, `sudo` fails because it doesn't affect a redirection.

# C-x D           end-of-list {{{4

# Purpose:{{{
#
# `end-of-list` allows you to make a list of matches persistent.
#
#     % echo $HO C-d
#         → parameter
#           HOME  HOST    # this list may be erased if you repress C-d later
#
#     % echo $HO C-d C-x D
#         → parameter
#           HOME  HOST    # this list is printed forever
#     % echo $HO          # new prompt automatically populated with the previous command
#}}}
bindkey '^XD' end-of-list

# C-x H           run-help {{{4

# What's this “run-help”?{{{
#
# From `type run-help`:
#
#     run-help is an autoload shell function
#}}}
# What does it do?{{{
#
# It:
#
#     1. pushes the current buffer (command line) onto the buffer stack
#     2. looks for a help page for the command name on the current command line (in case it's a builtin)
#     3. if it doesn't find one, it invokes `$ man`
#
# For more info, see `$ man zshzle`.
#}}}
bindkey '^XH' run-help

# C-x h           describe-key-briefly {{{4

# Usage:{{{
#
# Press `C-x H`,  then some key combination  for which you want the  name of the
# zle function which is invoked, like `M-!`, and you'll see something like:
#
#     "^[!" is _bash_complete-word
#}}}
bindkey '^Xh' describe-key-briefly

# }}}3
# C-z        fancy_ctrl_z {{{3

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

  # if the current line is empty ...
  if [[ $#BUFFER -eq 0 ]]; then
  #     │
  #     └ size of the buffer
    bg
    # ... redisplay the edit buffer (to get rid of a message)
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
# }}}2
# Meta {{{2
# M-[!$/@~]    _bash_complete-word {{{3

# What's this “unnamed” function?{{{
#
# An anonymous function.
# See `man zshmisc` for more info.
#}}}
# Why such a function?{{{
#
# It's automatically executed after being defined, then removed.
#}}}
# Why do you use a function?{{{
#
# To make the `key` variable local, and not pollute the shell environment.
#}}}
# Where did you find the code for the for loop?{{{
#
#     /usr/share/zsh/functions/Completion/Base/_bash_completions
#}}}
() {
  emulate -L zsh
  local key
  for key in '!' '$' '@' '/' '~'; do
    # What do these key bindings do? {{{
    #
    # They emulate what `M-!`, `M-$`, ..., `C-x !`, `C-x $`, ... do in bash.
    #
    # In bash, when  you press these keys,  you always end up  invoking the same
    # completion  function, which  seems  to inspect  the last  key  of the  key
    # binding which was pressed, to decide which kind of completion to use.
    #
    #     ! = command names
    #     $ = variable names
    #     / = file names
    #     @ = host names
    #     ~ = user names (or named directories)
    #
    #     M- = opens the completion menu
    #     C-x = prints the list of matches
    # }}}
    # Do some of them shadow a builtin zsh command?{{{
    #
    # Yes.
    # By default, `M-!` is bound to `spell-word`.
    # And `M-$` to `history-expansion`.
    #
    # I don't care  about any of them, because  it seems that Tab is  able to do
    # the same:
    #
    #     % echoz Tab
    #         → echo
    #
    #     % !! !! !! Tab
    #         → last command, 3 times
    #}}}
    if [[ "${key}" != '$' ]]; then
      bindkey "\e${key}" _bash_complete-word
    fi
    bindkey "^X${key}" _bash_list-choices
  done
}

# TODO: bash also provides `complete-in-braces`, bound by default to `M-{`.{{{
#
# Try  it in  bash; press  `M-AltGr-4` (not  `M-AltGr-x`, the  terminal wouldn't
# receive anything).
# It dumps on the command line a file pattern which can be expanded into all the
# filenames of  the current  directory whose  name matches  the text  before the
# cursor:
#
#     $ D M-{
#         → D{esktop,o{cuments,wnloads},ropbox}
#
# Unfortunately, it's not supported by `_bash_complete-word`.
# Try and find a way to re-implement it in zsh.
#}}}
# TODO: When we press `M-~`, our terminal doesn't receive anything. {{{
#
# Try this in bash:
#
#     $ xmodmap -e 'keycode  11 = a a a a asciitilde'
#     $ cat
#     # press M-AltGr-2
#         → ^[ ~
#         ✔
#
#     $ xmodmap -e 'keycode  56 = a a a a asciitilde'
#     $ cat
#     # press M-AltGr-b
#         → ∅
#         ✘
#
# It seems `M-~`  works when `~` is  produced by many keys (`a`,  `s`, `,`, ...)
# but not all (`b`, `v`, ...).
#
# Solution:
# Make another additional key generate `~`.
# Maybe you could try the key `1`.
#}}}

# M-#           pound-insert {{{3
bindkey '\e#' pound-insert

# M-,           copy-earlier-word {{{3

# Purpose:{{{
#
# `M-.` is useful to get the last argument of a previous command.
# But what if you want the last but one argument?
# Or the last but two.
#
# That's where the `copy-earlier-word` widget comes in.
#}}}
# usage:{{{
#
# Press `M-.` to insert the last argument of a previous command.
# Repeat until you reach the line of the history you're interested in.
#
# Then, press `M-,` to insert the last but one argument.
# Repeat to insert the last but two argument, etc.
#}}}
# How to cycle back to the last word of the command line?{{{
#
# Remove the inserted argument, and repeat the process:
#     `M-.` ...
#     `M-,` ...
#}}}
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '\e,' copy-earlier-word

# M-;           insert-last-word-forward {{{3

# Purpose:{{{
#
# This key binding is  useful when you press `M-.` too many  times, and you want
# to go back to the next history event (instead of the previous one).
#
#     https://unix.stackexchange.com/a/481714/289772
#}}}
# What does the `1` argument passed to `insert-last-word` mean?{{{
#
# From `man zshzle`:
#
#     When called from a shell function  invoked from a user-defined widget, the
#     command can take  one to three arguments.
#     The first argument specifies a  history offset which applies to successive
#     calls to this widget: if it is -1, the default behaviour is used, while if
#     it is 1, successive calls will move forwards through the history.
#}}}
# TODO: Where is this function syntax (no braces) documented?
insert-last-word-forward() zle insert-last-word 1
zle -N insert-last-word-forward
bindkey '\e;' insert-last-word-forward

# M-c/l/u       change-Case {{{3

# zle provides several functions to modify the case of a word:
#
#    * m-c    capitalize
#    * m-l    downcase
#    * m-u    upcase
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

# M-e         __expand_aliases {{{3

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
bindkey '\ee' __expand_aliases

# M-m           normalize_command_line {{{3

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

# M-Z           fuZzy-select-output {{{3

# insert an entry from the output of the previous command,
# selecting it with fuzzy search
bindkey -s '\eZ' '$(!!|fzf)'
# }}}2
# Menuselect {{{2
# Warning: I've disabled all key bindings using a printable character.{{{
#
# It's annoying  to type a  key expecting a character  to be inserted,  while in
# reality it's going to select another entry in the completion menu.
#}}}

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
#                          └ insert the selected match on the command line,
#                            but don't close the menu
# TODO:
# By default `M-a` is bound to `accept-and-hold` which does the same thing.
# `fzf.vim` seems to use `M-a` to do something vaguely similar: selecting
# multiple entries in a menu.
# Should we get rid of this C-o key binding and prefer M-a?

# In Vim we quit the completion menu with C-q (custom).
# We want to do the same in zsh (by default it's C-g in zsh).
bindkey -M menuselect '^Q' send-break
# }}}1
# Abbreviations {{{1

# http://zshwiki.org/home/examples/zleiab

#        ┌ `abbrev` refer to an associative array parameter
#        │
typeset -Ag abbrev
#         │
#         └ don't restrict to local scope

abbrev=(
  # column
  "Jc"    "| awk '{ print $"
  "Jn"    "2>/dev/null"
  "Jp"    "printf -- '"
  "Jt"    "| tail -20"
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

  #                ┌ remove longest suffix matching the following pattern
  #                │
  #                │   ┌ populates `$MATCH` with the suffix removed by `%%`
  #                │   │ for more info:    man zshexpn, filename generation
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
# ... as soon  as we would type a  space in a search, we would  leave the latter
# and go back to the regular command line.

# Options {{{1
# Never use `setopt` to unset an option.{{{
#
# Because, when you'll  search the option name in `man  zshoptions`, you'll lose
# time wondering why you can't find the name.
#
#     # ✔
#     unsetopt LIST_BEEP
#              ^^^^^^^^^ you can find this in `man zshoptions`
#
#     # ✘
#     setopt NOLIST_BEEP
#            ^^^^^^^^^^^ you can't find this in `man zshoptions`
#}}}

# Let us `cd` into a directory just by typing its name, without `cd`:{{{
#
#     my_dir/  ⇔  cd my_dir/
#
# Only works when `SHIN_STDIN` (SHell INput STanDard INput) is set, i.e. when the
# commands are being read from standard input, i.e. in interactive use.
#
# Works in combination with `CDPATH`:
#     $ cd /tmp
#     $ Downloads
#     $ pwd
#     ~/Downloads/
#
# Works with completion:
#     $ Do Tab
#     Documents/  Downloads/
#}}}
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
# the entire command path ($PATH?) is hashed first.
# This makes  the first completion slower  but avoids false reports  of spelling
# errors.
setopt HASH_LIST_ALL

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

# allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS

# never ring the bell on an ambiguous completion
unsetopt LIST_BEEP

# display PID when suspending processes as well
setopt LONG_LIST_JOBS

# Make zsh perform filename expansion on the command arguments of the form `var=val`.{{{
#
# zsh doesn't do it by default.
#
# MWE:
#     % unsetopt MAGIC_EQUAL_SUBST
#     % dd if=/dev/zero bs=1M count=1 of=~/test2
#                                        ^
#                                        ✘ not expanded into `/home/user`
#
#     % echo foo=~/bar:~/baz
#          → foo=~/bar:~/baz
#                ^     ^
#                ✘     ✘
#
# This behavior differs from bash.
#}}}
# It also has the positive side effect of allowing filename completion.{{{
#
#     % echo var=/us Tab
#}}}
setopt MAGIC_EQUAL_SUBST

# On an ambiguous completion, instead of listing possibilities,
# insert the first match immediately.
# This makes us enter the menu in a single Tab, instead of 2.
setopt MENU_COMPLETE

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Do not query the user before executing `rm *` or `rm path/*`
setopt RM_STAR_SILENT

# Variables {{{1
# WARNING: Make sure this `Variables` section is always after `Functions`.{{{
#
# Because  if  you  refer  to  a  function in  the  value  of  a  variable  (ex:
# `precmd_functions`), and it doesn't exist yet, it may raise an error.
#}}}

# What's `$TERM` inside a terminal, by default?{{{
#
# In many terminals, including xfce-terminal, guake, konsole:
#
#     $TERM = xterm
#
# Yeah, they lie about their identity to the programs they run.
#
# In urxvt:
#
#     $TERM = rxvt-unicode-256color
#
# urxvt tells the truth.
#}}}
# Where is the configuration file for a terminal?{{{
#
# xfce-terminal and guake don't seem to have one.
# However, you may find a way to  configure how they advertise themselves to the
# programs they run, like this:
#
#     1. right-click
#     2. preferences
#     3. compatibility
#
# urxvt uses ~/.Xresources.
#}}}
# Why do we, on some conditions, reassign `xterm-256color` to `$TERM`?{{{
#
# For the color  schemes of programs to be displayed  correctly in the terminal,
# `$TERM` must contain '-256color'.
# Otherwise, the programs  will assume the terminal is only  able to interpret a
# limited amount  of escape  sequences used  to encode 8  colors, and  they will
# restrict themselves to a limited palette.
#}}}
# Ok, but why do it in this file?{{{
#
# The configuration  of `$TERM` should  happen only in a  terminal configuration
# file.
# But for xfce4-terminal, I haven't found one.
# So, we must try to detect the identity of the terminal from here.
#}}}
# How to detect we're in an xfce terminal?{{{
#
# If you look at  the output of `env` and search for  'terminal' or 'xfce4', you
# should find `COLORTERM` whose value is set to 'xfce4-terminal'.
# We're going to use it to detect an xfce4 terminal.
#}}}
# Is it enough?{{{
#
# No, watch this:
#
#   1. start xfce4-terminal
#   2. $ tmux (start server)
#   3. $ echo $TERM  →  tmux-256color  ✔
#
#   4. start another xfce4-terminal
#   5. $ tmux (connect to running server)
#   6. $ echo $TERM  →  xterm-256color  ✘
#
# We must NOT  reset `$TERM` when the  terminal is connecting to  a running tmux
# server.
# Because the latter will already have set `$TERM` to 'tmux-256color' (thanks to
# the  option 'default-terminal'  in `~/.tmux.conf`),  which is  one of  the few
# valid value ({screen|tmux}[-256color]).
#
# One way to be sure that we're not connected to Tmux , is to check that `$TERM`
# is set to 'xterm'.
# That's the default value set by xfce4-terminal.
#
# ---
#
# Update:
# The reason given earlier is not valid anymore.
# Since tmux 2.1, `default-terminal` is a server option.
# The reason was valid before that, when `default-terminal` was a session option.
#
# Still, I  think it's a  good idea to set  `$TERM` to `xterm-256color`  only if
# it's currently set to `xterm`.
#}}}
# Alternative to support Gnome terminal, Terminator, and XFCE4 terminal:{{{
#
#     if [[ "${TERM}" == "xterm" ]]; then
#         if [[ -n "${COLORTERM}" ]]; then
#             if [[ "${COLORTERM}" == "gnome-terminal" || "${COLORTERM}" == "xfce-terminal" ]]; then
#                 TERM=xterm-256color
#             fi
#         elif [[ -n "${VTE_VERSION}" ]]; then
#             TERM=xterm-256color
#         fi
#     fi
#
# Source:
# https://github.com/romainl/Apprentice/wiki/256-colors-and-you
#}}}
# Why don't you export it in `~/.zshenv`?{{{
#
# It  worked in  the past,  but it  doesn't work  anymore in  an xfce  terminal,
# because when `~/.zshenv` is sourced, `TERM` and `COLORTERM` are not set yet.
#}}}
if [[ "${TERM}" == 'xterm' ]]; then
  if [[ "${COLORTERM}" == 'xfce4-terminal' || -n "${KONSOLE_PROFILE_NAME}" ]]; then
  #                                           ├──────────────────────────┘{{{
  #                                           └ to also detect the Konsole terminal}}}
    export TERM=xterm-256color
  fi
fi

# It doesn't seem necessary to export the variable.
# `precmd_functions` is a variable specific to the zsh shell.
# No subprocess could understand it.
#     https://stackoverflow.com/a/1158231/9780968
# precmd_functions=(__restart_vim)
# }}}1

if [[ -z "${NO_SYNTAX_HIGHLIGHTING}" ]]; then
  . "${HOME}/.zsh/syntax_highlighting.zsh"
fi

# TO_DO {{{1

# noa vim //gj /home/jean/Dropbox/conf/bin/**/*.sh ~/.shrc ~/.bashrc ~/.zshrc ~/.zshenv ~/.vim/plugged/vim-snippets/UltiSnips/sh.snippets | cw
#         ^
#         put whatever pattern you want to refactor

# TODO: Add a preview window for our zsh snippets. Like what we did with `:Rg`.

# TODO: Implement your own version of the `tldr` command.
#
# Write files named `tldr_mycmd.txt` in various wikis.
# Inside, write the most useful invocations of `mycmd`.
# Extract them from your notes (e.g. strace.md).
# Your notes should not contains shortcuts (that's better for a cheatsheet),
# Nor should they contain one-liner answers (those should be in a tldr file).
# Why?
# Because, these information would be quicker to access that way.
#
# Then, write  a shell `td` command  (Too long Didn't read)  which suggests such
# files and echo them in the terminal, just like `tldr`.
# Inside the files, use  escape sequences (e.g. `\e[1m...\e[0m`, `\[3m...\e[0m`,
# `\e[1;3m...\e[0m`) to add some styles (bold, italic, bold+italic).
# Use  this command  to print  the  file, so  that the  sequences are  correctly
# interpreted:
#
#     $ while read -r line; do printf -- "$line\n"; done </tmp/file
#
# Use these sandwich recipes to insert the sequences more easily:
#
#     \ + [{'buns': ['\e[3m', '\e[0m'], 'input': ['si']}]
#     \ + [{'buns': ['\e[1m', '\e[0m'], 'input': ['sb']}]
#     \ + [{'buns': ['\e[1;3m', '\e[0m'], 'input': ['sB']}]
#
# Try to give the files a dedicated filetype, and conceal the escape sequences.
#
# Update:
# Use fzf to fuzzy search through all tldr files.
# Same thing for the cheatsheets.
#
# Update:
# Write your files in a `tldr/` subdirectory, and use markdown (for folding).
#
# Update:
# Install a mapping (`-D`?) to get a tldr window when you press it on a command name.
#
# Update:
# Install a local key binding in any tldr file to fuzzy search through all shell
# commands given in answers.
# In  the preview  pane,  make fzf  display a  description  (maybe the  question
# associated with the command).
# When you select a command, make fzf write  it in the clipboard, so that we can
# paste it immediately on the shell's command-line.

# TODO: Think about how better leveraging our zsh history.
#
# For example, whenever you press `C-r` several times to retrieve the same old command,
# immediately consider adding it to our zsh snippets in `~/.config/zsh-snippet/`.
#
# Also, try  to build a  script or Vim  command to remove  as much noise  in the
# history.
#
# Also, try to build  an awk script to extract relevant info;  like what are the
# most used  commands. Act upon this info,  write scripts or snippets  to reduce
# the invocation of these commands.
#
# Also, take the habit  of prefixing your commands with a  space when you're not
# sure  they work. Otherwise,  you  may  end up  with  broken  commands in  your
# history.  Those are not interesting, and may be even dangerous.

# TODO:
# ideas to improve our scripts:
#
#    - When a script bugs several times, immediately consider adding a DEBUG variable
#      set by default to 0.
#      Then, write `printf` statements in the most useful locations, to get debugging info.
#      Guard those statements by checking the value of `DEBUG`.
#      Have a look at what we did in upp.sh.
#
#    - they should better handle errors
#      (no stacktrace, show a human-readable message;
#      take inspiration from `mv garb age`)
#
#    - usage when the script is called without arguments
#
#      Should we delegate this to a library function to avoid
#      repeating always the same kind of code?
#
#    - use the output streams correctly
#
#      Write error messages on stderr, not on stdout.
#      This way, if you pipe the output of your script to another utility,
#      and an error is raised, the message won't be sent to the utility.
#      There's no sense piping an error message to anything.
#      Same thing for a usage message (which can be seen as a special
#      kind of error message).
#      And if the user really wants to pipe the error message,
#      they still can with `2>&1 |` (or `|&`).
#
#    - An error message should always contain the name of the script/function
#      which is executed:
#
#          script_name: error message
#
#      Example:
#
#          $ mv x y
#              → mv: cannot stat 'x': No such file or directory
#                ^^
#
#      This is useful when you execute it in a pipeline, because it allows you
#      to immediately know from which simple command in the pipeline the error comes.
#
#      However, don't write the name literally.
#      Use `$0` in  a function, and `$(basename  "$0")` in a script,  so that if
#      you change  the name  of the script/function  later, the  message remains
#      valid.
#
#    - any error should be accompanied by an `exit` statement, so that:
#
#         ./script.sh && echo 'success'
#
#      doesn't print 'success' if the script fails.
#
#      Use `exit 1` for a random error, `exit 64` for a usage message,
#      `65` for bad user input, and `77` for not enough permission.
#      See here for which code to use:
#
#          https://www.freebsd.org/cgi/man.cgi?query=sysexits&apropos=0&sektion=0&manpath=FreeBSD+4.3-RELEASE&format=html
#
#      It's not an obligation to use this page, just a useful convention.
#
#    - write a manpage for the script
#
#    - split a long command using an array whose elements are arguments of the latter:
#          https://unix.stackexchange.com/a/473257/289772
#
#    - use  lowercase  characters for  variables/parameters,  and  uppercase  for
#      environment variables
#      It's just a convention suggested on page 74 of “from bash to z shell”.
#      It's not really followed in this zshrc:
#          http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
#
#      It doesn't seem there's any convention in this file.
#      Except that most of the time, the local variables in a function
#      use lowercase characters.
#

# TODO:
# Type `$ vim Tab`.
# Look at the distance between the suggestions in the `shell function` section.
# It's too big.
# The result feels jarring compared to the other sections.
# I think it's because zsh tries to use  a certain width for the whole menu, and
# divides it by `n` (`n` being the number of suggestions on a given line).
# If `n` is small (atm we only have 3 shell functions beginning with `vim`),
# the width of each suggestion on a line is needlessly big.
#
# It seems that the completion menu splits the suggestions on several lines once
# there're 10 of them (at least if their size is similar to `vim_cfg`).
#
# How to control the geometry of the zsh completion menu?
# Width of the suggestions, max number of entries on a single line ...
# It would be useful to tell zsh that if we have less than, say, 10 suggestions,
# we want them each on a separate line.
# Or better yet, how to ask zsh to fill columns, before filling lines?
#
# The 'list_rows_first' option doesn't seem to help...
# The latter changes the position of entries in a completion menu:
# For example, the 2nd one is on the right of the 1st one, instead of below.


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
# These variables are indeed in a function, but they don't have to.
# We  could remove the  functions, and just execute  the code directly  from the
# script.
# We've put them in functions to make the code more readable.
# IOW, I think they are supposed to be accessible from the whole script.


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

# TODO: To document in our notes:
#
#     https://unix.stackexchange.com/a/88851/289772

# TODO: Do these substitutions:
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
#             v                           v v                                v
#     fpath=( "${HOME}/.zsh/my-completions" "${HOME}/.zsh/zsh-completions/src" $fpath )
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
# Currently we have several lines in this file which must appear before or after
# a certain point to avoid being overridden/overriding sth.
# It feels brittle. One day we could move them in the wrong order.
# Find a better way of organizing this file.
# Or  write  at  the  top  of  the file  that  some  sections  must  be  sourced
# before/after others.

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

# FIXME:
# Find a video whose title contains a single quote; e.g.:
#
#   [HorribleSubs] JoJo's Bizarre Adventure - Golden Wind - 01 [480p].mkv
#
# Start ranger, navigate to the directory containing of the video, and play it.
# Quit ranger:
#
#   zsh:1: unmatched '
#
# The issue is probably in ranger, because it persists even if I disable the zshrc.
# However, I can't find anything wrong in:
#
#   ~/.config/ranger/rifle.conf
#   →
#   mime ^video,       has mpv,      X, flag f = mpv -- "$@"
#                                                       ^^^^
#                                                       should properly a video title
#                                                       even if it contains a single quote

# TODO:
# understand: https://unix.stackexchange.com/questions/366549/how-to-deal-with-filenames-containing-a-single-quote-inside-a-zsh-completion-fun

# TODO: To read:
# https://github.com/sindresorhus/pure (≈ 550 sloc, 2 fichiers: pure.zsh, async.zsh)

# TODO: to read (about glob qualifiers):
#   https://unix.stackexchange.com/a/471081/289772

# TODO: Install a key binding to kill ffmpeg.
# It would be useful when we record our desktop, or the sound...

