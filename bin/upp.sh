#!/bin/bash
# How much time the compilation is expected to take?{{{
#
#   ≈ 13 min  for mpv
#   ≈ 30s     for tmux
#   ≈ 4 min   for vim
#   ≈ 2min20s for weechat
#   ≈ 2 min   for zsh
#}}}

# Nvim: If a network connection fails during the compilation, the latter will also fail.{{{
# In that case, re-try a compilation (now or a bit later).
#}}}
# Vim: After an update, in case of an issue, restart Vim in a new shell!{{{
#
# Otherwise, there can be spurious bugs in the current session.
# To avoid them, start Vim from a NEW shell.
#}}}
# Tmux: Do *not* compile from a commit which has not been checked by travis!{{{
#
# This kind of commit doesn't have a `autogen.sh` file.
# And I think that `$ git describe` fails on such a commit...
#}}}

DEBUG=0
DEBUG_LOGFILE=/tmp/debug

# exit upon error{{{
#
# man bash
#     /SHELL BUILTIN COMMANDS
#     /^\s*set\>
#}}}
set -e
# Don't eliminate `set -e`!{{{
#
# You could be tempted to do it, because of this:
#     http://mywiki.wooledge.org/BashFAQ/105
#
# Nevertheless,  we  need  to  keep  it at  the  moment,  otherwise  the  script
# would  not  terminate when  we  execute  `exit 1`  from  a  function (such  as
# `check_vim_version_is_correct`).
#
# Source:
#     https://stackoverflow.com/a/9893727/9780968
#
# If you really want to remove it, you'll  need to find another way to quit from
# a function.
# Have a look here:
#     https://unix.stackexchange.com/a/48550/289772
#     https://stackoverflow.com/a/9894126/9780968
#}}}
# What to do if a `rm` command may fail?{{{
#
# Add the `-f` option.
#}}}
# What to do if a `mkdir` command may fail?{{{
#
# Add the `-p` option.
#}}}
# What to do if another command may fail, but there's no option to suppress the errors?{{{
#
#     set +e
#     problematic_command
#     set -e
#}}}

# Init {{{1

PGM="$1"
SUPPORTED_PGMS=(ansifilter gawk jumpapp mpv nvim tmux trans surfraw vim weechat zsh)
GIT_REPOS="${HOME}/GitRepos/"

typeset -A URLS=( \
  [ansifilter]=https://gitlab.com/saalen/ansifilter.git \
  [gawk]=git://git.savannah.gnu.org/gawk.git \
  [jumpapp]=https://github.com/mkropat/jumpapp \
  [mpv]=https://github.com/mpv-player/mpv-build \
  [nvim]=https://github.com/neovim/neovim \
  [tmux]=https://github.com/tmux/tmux \
  [trans]=https://github.com/soimort/translate-shell \
  [surfraw]=https://gitlab.com/surfraw/Surfraw \
  [vim]=https://github.com/vim/vim \
  [weechat]=https://github.com/weechat/weechat \
  [zsh]=git://git.code.sf.net/p/zsh/code \
  )

LOGDIR="${HOME}/log"
[[ -d "${LOGDIR}" ]] || mkdir "${LOGDIR}"
LOGFILE="${LOGDIR}/$(basename "$0" .sh)-${PGM}.log"

# Sanitize input {{{1

if [[ -z "${PGM}" ]]; then
  printf -- '%s: you must provide the name of the program you want to update\n' "$(basename "$0")" >&2
  exit 1
# How to check if a variable exists in a list?
#     https://stackoverflow.com/a/8063398/9780968
#
# How to negate a test with regular expressions?
#     https://stackoverflow.com/a/7846318/9780968
#
# TODO: There's a duplication of code here; remove it.{{{
# Every time we add or remove a program in the array URLS, we must do the same here.
# Find a way to extract the keys of the array and concatenate them.
#
# ---
#
# There's also a duplication of code in the definition of `SUPPORTED_PGMS`.
#}}}
elif [[ ! 'ansifilter gawk jumpapp mpv nvim surfraw tmux trans vim weechat zsh' =~ (^|[[:space:]])"${PGM}"($|[[:space:]]) ]]; then
  printf -- '%s: the only programs this script can update are:\n' "$(basename "$0")" >&2
  # How to print array elements on separate lines?
  #     https://stackoverflow.com/a/15692004/9780968
  printf -- '    %s\n' "${SUPPORTED_PGMS[@]}" >&2
  # 65 = input user data is incorrect
  exit 65
  #    │{{{
  #    └ EX_DATAERR (65)
  #
  # The command was used incorrectly, e.g.,  with the wrong number of arguments,
  # a bad flag, a bad syntax in a parameter, or whatever.
  # Source:
  #
  #     https://www.freebsd.org/cgi/man.cgi?query=sysexits&apropos=0&sektion=0&manpath=FreeBSD+4.3-RELEASE&format=html
  #}}}
fi

# Functions {{{1
main() { #{{{2
  cat <<EOF

-----------
$(date +%m-%d\ %H:%M)
-----------

EOF

  download
  get_version

  if [[ "${PGM}" == 'vim' ]]; then
    check_vim_version_is_correct
  elif [[ "${PGM}" == 'tmux' ]]; then
    check_tmux_version_is_correct
  fi

  clean
  install_dependencies
  configure
  build
  install
  update_alternatives
  xdg_mime_default
}

build() { #{{{2
  if [[ "${PGM}" == 'mpv' ]]; then
    aptitude install devscripts equivs
    mk-build-deps -s sudo -i
    # The readme adds the `-j4` flag, to use 4 cores.
    # I don't use `-j` because it would probably consume too much cpu.
    # I'm ok with a building process which takes more time (≈ 12 min).
    dpkg-buildpackage -uc -us -b

  elif [[ "${PGM}" == 'jumpapp' ]]; then
    make deb

  elif [[ "${PGM}" == 'nvim' ]]; then
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
    #                                    ├─────────────────────────────────────┘{{{
    #                                    └ necessary to be able to use `checkinstall` later
    #
    # https://github.com/neovim/neovim/issues/2364#issuecomment-113966180
    # https://github.com/serverwentdown/env/commit/a05a31733443fcb0979fecf18f2aa8e9e2722c7c
    #
    # TODO:
    # What do we lose by disabling jemalloc?
    # Are we going to suffer from a noticeable performance hit?
    # I could  be wrong,  but after  reading this  (and because  Neovim is  probably a
    # single-threaded process) I don't think so:
    # https://stackoverflow.com/a/1624744/9780968
    #}}}

  else
    make
    # What to do if the zsh manpages are not installed?{{{
    #
    # Try:
    #     sudo make install.info
    #     sudo make install.man
    #}}}
  fi

  # How to check whether the zsh compiled binary is working as expected?{{{
  #
  #     $ make check
  #}}}
  # If you want to test the Vim binary, try sth like this:{{{
  #     xfce4-terminal -e 'make test' 2>/dev/null
  #
  # But not this:
  #     make test    ✘
  #
  # Because of:
  #     test1 FAILED - terminal size must be 80x24 or larger
  #
  # Neither this:
  #     xfce4-terminal -e 'make test'    ✘
  #
  # Because of:
  #     xfce4-terminal: Gdk-WARNING: gdk_window_set_icon_list: icons too large
  #     https://github.com/snwh/paper-icon-theme/issues/340
  #}}}
  # TODO:
  # If there's a valid error during the test, `2>/dev/null` won't stop our script
  # from installing the binary.
  # We need a way to ignore just a specific error. Not any error.
}

check_tmux_version_is_correct() { #{{{2
  # Why not including the regex inside `[[ ... ]]`?{{{
  #
  # You would need to use this regex:
  #
  #     ^tmux[[:space:]][0-9]\.[0-9]$
  #
  # I find it less readable.
  #}}}
  # Can I quote a regex?{{{
  #
  # It depends.
  #
  # Quoting a part of the regex forces the latter to be matched as a string.
  # So, while it doesn't make much sense to quote an entire regex, it could
  # be useful to quote some part of it.
  #}}}
  # Can I use a space in a regex?{{{
  #
  # Not a literal one.
  # You can use this though:
  #
  #     [[:blank:]] = [ \t]
  #     [[:space:]] = [ \t\n\r\f\v]
  #}}}
  # Can I use the `!~` operator to check a NON-match?{{{
  #
  # No.
  # This operator doesn't exist in bash.
  # Use the `!` operator to negate the test.
  #}}}
  REGEX='^[0-9]\.[0-9]$'
  if [[ ! "${VERSION}" =~ ${REGEX} ]]; then
    cat <<EOF >&2

Your tmux version is:
    "${VERSION}"

This may break some tmux plugins which relies on the following scheme:
    tmux X.Y

Edit the script "$(basename "$0")" so that it edits "configure.ac" correctly.

EOF
    exit 1
  fi
}

check_vim_version_is_correct() { #{{{2
      REGEX='^[0-9]:[0-9]\.[0-9].[0-9]+$'
      if [[ ! "${VERSION}" =~ ${REGEX} ]]; then
        cat <<EOF >&2

Your Vim version is:
    "${VERSION}"

This may cause 'aptitude safe-upgrade'  to overwrite your compiled package
with an older version, from the official repositories.
It would be better if your version followed the scheme:
    A:B.C.D-E

Example:
    2:8.1.0390-1

Edit the script "$(basename "$0")" so that it sets the version of your compiled
package correctly.

EOF
      exit 1
    fi
}

check_we_are_root() { #{{{2
  # We need to be root.
  #
  #      ┌─ Effective User ID
  #      │
  #      │  0 is the EUID of the root user.
  #      │
  if [[ "${EUID}" -ne 0 ]]; then
    cat <<EOF >&2
Please run as root:
    sudo "$0" "${PGM}"
EOF
    # 77 = not sufficient permission
    exit 77
  fi
}

clean() { #{{{2
  #   ┌ necessary because of `set -e`{{{
  #   │
  #   │ if the files don't exist, it will cause an error
  #   │ which will cause the script to exit prematurely
  #   │
  #   │ `-f` asks `rm` to ignore nonexistent files
  #   │ }}}
  rm -f backup*.tgz "${PGM}"*.deb

  if [[ "${PGM}" == 'weechat' ]]; then
    # Clean last `$ cmake` command:
    #     https://stackoverflow.com/a/9680493/9780968
    if [[ -d 'build' ]]; then
      rm -rf build
    fi
    #      ┌ no error if existing{{{
    #      │ we don't want an error because of `set -e`
    #      │}}}
    mkdir -p build
    cd build

  else
    # If  we've already  cleaned manually  the  repo, it's  possible that  `make
    # [dist]clean`, causes the error:
    #
    #     No rule to make target '[dist]clean'
    #
    # I don't know how to prevent these errors, so I temporarily disable `set -e`.
    set +e
    make clean
    make distclean
    set -e
  fi
}

configure() { #{{{2
  if [[ "${PGM}" == 'gawk' ]]; then
    # `--enable-mpfr` allows us to use the `-M` command-line option.
    # Requires a package (`libmpfr4`?) which should be installed by
    # `$ aptitude build-dep gawk`.
    ./bootstrap.sh && ./configure --enable-mpfr

  # If the build fails, check whether all dependencies are installed:{{{
  #
  #     https://github.com/mpv-player/mpv-build#dependencies
  #
  # In particular the 'yasm' package.
  #}}}
  # Procedure to compile `mpv`:{{{
  #
  #     https://github.com/mpv-player/mpv-build#generic-instructions
  #
  #     $ ./rebuild
  #     $ cp ./mpv/build/mpv ~/bin
  #
  # Or:
  #     https://github.com/mpv-player/mpv-build#instructions-for-debian--ubuntu-package (used in this script)
  #}}}
  elif [[ "${PGM}" == 'mpv' ]]; then
    ./update

  elif [[ "${PGM}" == 'surfraw' ]]; then
    autoreconf -f -i
    ./configure

  elif [[ "${PGM}" == 'tmux' ]]; then
    # Why this `sed` command?{{{
    #
    # If you're installing tmux, you'll first need to edit `configure.ac`.
    #
    #     AC_INIT(tmux, master) → AC_INIT(tmux, x.y)
    #                                           ^^^
    # By  default, the  configuration assigns  `master`  as the  version of  the
    # future tmux running process, instead of something like `2.8`.
    #
    # This will  break some  tmux plugins  which inspect  the version  number to
    # decide whether it's recent enough to support some features.
    #
    # It would be useful if `./configure` had an option for that...
    # I haven't found one in `./configure --help`.
    # So, I edit `configure.ac` manually.
    #
    # https://unix.stackexchange.com/a/469130/289772
    #}}}
    # Ok, and why did you choose the regex `\S\+`?{{{
    #
    # nicm keeps changing the version reported by `$ tmux -V`.
    # In the past, he has used `master`, `X.Y-rc`, and now it's `next-X.Y`.
    # Have a look here:
    #     https://github.com/tmux/tmux/commits/master/configure.ac
    #
    # Who knows what it will be tomorrow...
    # So,  I use  the  least restrictive  regex  to match  as  many versions  as
    # possible.
    #}}}
    sed -i "/AC_INIT/s/\S\+)/${VERSION})/" configure.ac
    sh autogen.sh
    ./configure

  elif [[ "${PGM}" == 'vim' ]]; then
    # We could add the `--enable-autoservername` option,{{{
    # to start Vim with an autogenerated servername.
    #
    # But it would increase the startuptime by a few ms:
    #
    #         https://github.com/vim/vim/pull/2317#issue-273094230
    #}}}
    ./configure --enable-cscope                                                      \
                --enable-fail-if-missing                                             \
                --enable-gui=gtk3                                                    \
                --enable-luainterp=dynamic                                           \
                --enable-multibyte                                                   \
                --enable-perlinterp=yes                                              \
                --enable-python3interp=yes                                           \
                --enable-pythoninterp=yes                                            \
                --enable-rubyinterp=dynamic                                          \
                --enable-terminal                                                    \
                --prefix=/usr/local                                                  \
                --with-compiledby=user                                               \
                --with-features=huge                                                 \
                --with-luajit                                                        \
                --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
                --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/

  # If you want the online documentation, add this option:{{{
  #
  #     -DENABLE_DOC:BOOL=ON                             \
  #
  # The doc should be in `/usr/share/doc/weechat/doc/en`
  #}}}
  elif [[ "${PGM}" == 'weechat' ]]; then
    cmake .. -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo         \
             -DWEECHAT_HOME:STRING="${HOME}"/.config/weechat  \
             -DENABLE_MAN:BOOL=ON                             \
             -DENABLE_TESTS:BOOL=ON

  elif [[ "${PGM}" == 'zsh' ]]; then
    # Where did you find the configuration options?{{{
    #
    # I read the INSTALL file:
    #         https://github.com/zsh-users/zsh/blob/master/INSTALL
    #
    # I also read this link:
    #         https://gist.github.com/nicoulaj/715855
    #
    # I also read how the ubuntu devs compiled `zsh-5.2`:
    #
    #     https://launchpad.net/ubuntu/+source/zsh
    #
    #     # link found by clicking on the button below “Latest upload”
    #     https://launchpad.net/ubuntu/+source/zsh/5.2-5ubuntu1
    #
    #     # link found by clicking on the button “amd64” in the section “Builds”
    #     https://launchpad.net/ubuntu/+source/zsh/5.2-5ubuntu1/+build/10653977
    #
    #     # link found by clicking on the button “buildlog”
    #     https://launchpadlibrarian.net/280509421/buildlog_ubuntu-yakkety-amd64.zsh_5.2-5ubuntu1_BUILDING.txt.gz
    #}}}
    # How to get more information about the configuration options?{{{
    #
    #     $ ./configure --help
    #}}}

    # TODO:{{{
    # Atm, these directories are empty:
    #
    #     /usr/local/share/zsh/site-functions
    #     /usr/share/zsh/vendor-functions
    #
    # Should we remove them from:
    #
    #     --enable-site-fndir
    #     --enable-additional-fpath
    #
    # ?
    #}}}
    ./Util/preconfig
    ./configure --build=x86_64-linux-gnu \
      --prefix=/usr \
      --includedir=/usr/include \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --libdir=/usr/lib/x86_64-linux-gnu \
      --libexecdir=/usr/lib/x86_64-linux-gnu \
      --bindir=/bin \
      LDFLAGS="-Wl,--as-needed -g" \
      --enable-maildir-support \
      --enable-etcdir=/etc/zsh \
      --enable-function-subdirs \
      --enable-site-fndir=/usr/local/share/zsh/site-functions \
      --enable-fndir=/usr/share/zsh/functions \
      --with-tcsetpgrp \
      --with-term-lib="ncursesw tinfo" \
      --enable-cap \
      --enable-pcre \
      --enable-readnullcmd=pager \
      --enable-custom-patchlevel=Debian \
      --enable-additional-fpath=/usr/share/zsh/vendor-functions,/usr/share/zsh/vendor-completions \
      --disable-ansi2knr
        fi
}

download() { #{{{2
  [[ -d "${GIT_REPOS}" ]] || mkdir -p "${GIT_REPOS}"
  cd "${GIT_REPOS}"

  aptitude install git
  if [[ ! -d "${PGM}" ]]; then
    git clone "${URLS[${PGM}]}" "${PGM}"
  fi

  cd "${PGM}"
  # We edit the file `configure.ac` for tmux.
  # This edit must be stashed before going on.
  # Even  if we didn't  edited this  file, it's still  a good practice  to stash
  # (there may be other file(s) that we edit).
  git stash
  # check a master branch exists (trans has no master branch)
  # https://stackoverflow.com/q/5167957/9780968
  if git show-ref --verify --quiet refs/heads/master; then
    git checkout master
  fi
  # To prevent this kind of error:{{{
  #
  #     error: The following untracked working tree files would be overwritten by merge:~
  #       path/to/file~
  #       ...~
  #     Please move or remove them before you merge.~
  #     Aborting~
  #
  # Source: https://stackoverflow.com/a/8362346/9780968
  #}}}
  git clean -d -f .
  git pull
}

get_version() { #{{{2
  # To prevent `set -e` from terminating the script.{{{
  #
  # Indeed, `git describe --tags` gives this error:
  #
  #     fatal: No names found, cannot describe anything
  #
  # This is probably because `mpv` is special; we don't build it from its repo.
  #}}}
  if [[ "${PGM}" == 'gawk' ]]; then
    VERSION="$(git describe --tags)"
  elif [[ "${PGM}" == 'nvim' ]]; then
    VERSION="$(git describe)"
  elif [[ "${PGM}" == 'tmux' ]]; then
    # Don't add `--tags`! You would get the invalid “version” `to-merge`.
    VERSION="$(git describe --abbrev=0)"
  elif [[ "${PGM}" == 'trans' ]]; then
    VERSION="$(git describe)"
  else
    # Why `--tags`?{{{
    #
    # To avoid this kind of error:
    #
    #     fatal: No annotated tags can describe 'ab18673731522c18696b9b132d3841646904e1bd'.
    #}}}
    # Why `--abbrev=0`?{{{
    #
    # Most of the time `$ git describe --tags` will return something like:
    #
    #     v8.1.0648
    #
    # But sometimes, it will return something like:
    #
    #     v8.1.0648-1-gc8c884926
    #
    # I think it happens  when the latest commit was not  tagged, which seems to
    # be always the case when Bram commits lots of changes in `$VIMRUNTIME`.
    #
    # Anyway, the format of this version will make a regex comparison fail
    # in `check_vim_version_is_correct()`.
    # We use `--abbrev=0` to make sure it doesn't happen, and that the format of
    # the version is always the same.
    #}}}
    VERSION="$(git describe --tags --abbrev=0)"
  fi

  if [[ "${PGM}" == 'gawk' || "${PGM}" == 'surfraw' ]]; then
    VERSION="${VERSION#*-}"
    VERSION="9:${VERSION%-*}"

  elif [[ "${PGM}" == 'ansifilter' || "${PGM}" == 'jumpapp' || "${PGM}" == 'trans' || "${PGM}" = 'weechat' ]]; then
    # for `dpkg  -i mpv_*.deb` to success  later, the version number  must begin
    # with a digit
    VERSION="${VERSION#v}"

  elif [[ "${PGM}" == 'vim' || "${PGM}" == 'nvim' ]]; then
    # What's this `9:`?{{{
    #
    # Atm, the  Vim packages in the  offical repositories have a  version number
    # which looks like this:
    #
    #     2:8.0.0134-1ubuntu1~ppa1~x 500
    #
    # The `2:` is what is called the *epoch*.
    # From: https://serverfault.com/a/604549
    #
    # > This is a single (generally small) unsigned integer.
    # > It may be omitted, in which case zero is assumed.
    # > If it is omitted then the `upstream_version` may not contain any colons.
    # > It  is provided  to  allow  mistakes in  the  version  numbers of  older
    # > versions of a  package, and also a package's  previous version numbering
    # > schemes, to be left behind.
    #
    # If you don't put include an epoch in the version of your Vim package, `0:`
    # will be assumed:
    #
    #     0:X.Y.Z
    #
    # As a result, your package will be overwritten by a `$ aptitude safe-upgrade`.
    #}}}
    VERSION="9:${VERSION#v}"

  elif [[ "${PGM}" == 'zsh' ]]; then
    # for `checkinstall` to success later, the  version number must begin with a
    # digit
    VERSION="${VERSION#zsh-}"
  fi

  if [[ "${DEBUG}" -ne 0 ]]; then
    echo "${VERSION}" >>"${DEBUG_LOGFILE}"
  fi
}

install() { #{{{2
  if [[ "${PGM}" == 'mpv' ]]; then
    rm -f ../mpv_*.changes
    mv ../mpv_*.deb .
    # We can't use `checkinstall` for `mpv`, because the compilation has already
    # produced a `.deb` package.
    dpkg -i mpv_*.deb
    return
  fi

  # We don't have any version number for `mpv` (because `git describe` fails).
  if [[ "${PGM}" == 'mpv' ]]; then
    checkinstall --pkgname "${PGM}" -y

  elif [[ "${PGM}" == 'jumpapp' ]]; then
    # Can't use `checkinstall`, because:
    #     make: *** No rule to make target 'install'.  Stop.
    sudo dpkg -i jumpapp*all.deb

  else
    # TODO: Sometimes, checkinstall ignores the options `--pkgversion`, `--pkgname`, ...{{{
    #
    # This is because if  it finds a .spec file at the root  of the project, and
    # its  basename matches  the  program  (e.g. ansifilter.spec,  weechat.spec,
    # ...), then it uses its contents to assign the values of these options.
    # IOW, a {vim|tmux|...}.spec file has priority over `--pkg...`.
    #
    # Besides, sometimes, the values in the .spec file are not literal.
    # For example, in `~/GitRepos/weechat/weechat.spec:31`, one can read:
    #
    #     Version:   %{version}
    #     Release:   %{release}
    #
    # Currently, here are the repos which have a spec file:
    #
    #    - ansifilter (but no issue)
    #
    #    - jumpapp; issue, because of:
    #
    #         3 -  Version: [ VERSION ]
    #         4 -  Release: [ 1%{?dist} ]
    #
    #    - weechat; issue, because of:
    #
    #         2 -  Name:    [ 0--name- ]
    #         3 -  Version: [  ]
    #         4 -  Release: [ %{release} ]
    #
    # This can cause an issue, especially for the version field.
    #
    # Solution1:
    #
    # Use `--spec /dev/null`.
    # This will prevent checkinstall from using any spec file.
    #
    # Solution2:
    # Test the existence of a spec file, and  if there's one, use sed to edit it
    # before invoking checkinstall.
    #
    # ---
    #
    # Once you've implemented a solution, test it against surfraw.
    # Right now, checkinstall does not install the latter.
    #
    # ---
    #
    # Update:
    # Here's a first attempt to replace `%{name}` with `weechat`:
    #
    #     $ sed '/^%define\s\+name/{s/.*\s//; h; s/^/%define name /}; /^Name:/{G; s/^\(Name:\s\+\)%{name}\n\(\w\+\)/\1\2/}' weechat.spec
    #
    # It's a bit long, maybe we could improve the code...
    #}}}
    if [[ "${DEBUG}" -ne 0 ]]; then
      echo checkinstall --pkgname "${PGM}" --pkgversion "${VERSION}" --spec /dev/null -y >>"${DEBUG_LOGFILE}"
    fi
    checkinstall --pkgname "${PGM}" --pkgversion "${VERSION}" --spec /dev/null -y
    #                                 │
    #                                 └ don't overwrite my package
    #                                   with an old version from the official repositories
    #                                   when I execute `aptitude safe-upgrade`
    # Why can aptitude overwrite our compiled package?{{{
    #
    # It seems that the packages from the priority of the official repositories is 500.
    # While the priority of our compiled package is only 100.
    #
    # So, when  aptitude finds several versions  of the same package,  it checks
    # their version to decide which one is the newer one.
    # By default, checkinstall uses the current date as the package version:
    #
    #     20180914
    #
    # This would cause an issue for Vim:
    #
    #     $ apt-cache policy vim
    #     vim:
    #       Installed: (none)
    #       Candidate: 2:8.0.0134-1ubuntu1~ppa1~x
    #       Version table:
    #          2:8.0.0134-1ubuntu1~ppa1~x 500
    #             500 http://ppa.launchpad.net/pi-rho/dev/ubuntu xenial/main amd64 Packages
    #     ...
    #
    # Here the version of the Vim package in the ppa is `2:8.0.0134`.
    # If the version of our compiled package is `20180914`, it will be considered
    # older than the one in the ppa.
    # I think that's because the format of a date is different.
    # `apt` expects a number before a colon, but there's no colon in a date.
    # So it assumes that the date should be prefixed by `0:` or `1:` which gives:
    #
    #     0:20180914
    #     <
    #     2:8.0.0134-1ubuntu1~ppa1~x
    #}}}
    # Why don't you use `--pkgname "my{PGM}"` anymore?{{{
    #
    # When checkinstall tries  to install `myPGM`, it may try  to overwrite a file
    # belonging to `PGM` (it will probably happen if `PGM` is installed).
    # If that happens, the installation will fail:
    #
    #     dpkg: error processing archive /home/user/GitRepos/zsh/zsh_9999.9999-1_amd64.deb (--install):
    #      trying to overwrite '/usr/share/man/man1/zshmodules.1.gz', which is also in package myzsh 999-1
    #     dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
    #}}}

    if [[ ${PGM} == 'nvim' ]]; then
      # By default, when you run `$ man man`, the manpage is not prettified like
      # it is when you run `:Man man` from a Neovim instance; let's fix that:
      sed -i.bak '/function! man#init_pager()/ {/endfunction/s//do <nomodeline> man BufReadCmd/}' /usr/local/share/nvim/runtime/autoload/man.vim
    fi
  fi
}

install_dependencies() { #{{{2
  aptitude install make checkinstall

  # TODO: Make the script edit `/etc/apt/sources.list`. {{{
  #
  # And uncomment:
  #
  #     deb-src http://fr.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted
  #
  # And run `$ sudo aptitude update`, so that `aptitude build-dep` works.
  #
  # For weechat, you need to uncomment:
  #
  #     deb-src http://fr.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) universe
  #
  # For trans, you need to uncomment:
  #
  #     deb-src http://fr.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) multiverse
  #
  # For Vim, you may need to run:
  #
  #     $ sudo aptitude build-dep vim vim-gtk
  #                                   ^^^^^^^
  #                                   does it make a difference? is it necessary?
  #}}}
  aptitude build-dep "${PGM}"

  if [[ "${PGM}" == 'vim' ]]; then
    # `build-dep vim` is not enough{{{
    #
    # Actually it seems it does nothing.
    # Is it because we don't uncomment the right lines in `/etc/apt/sources.list`?
    #}}}
    # In case of a missing dependency, see:
    # https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
    # TODO: Should we also install:{{{
    #
    #    - libgtk2.0-dev
    #    - libx11-dev
    #    - libxpm-dev
    #    - libxt-dev
    # ?
    #}}}
    aptitude install libncurses5-dev \
      luajit libluajit-5.1-dev \
      libperl-dev \
      python-dev \
      python3-dev \
      ruby-dev
  elif [[ "${PGM}" == 'nvim' ]]; then
    aptitude install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
  fi
}

update_alternatives(){ #{{{2
  if [[ "${PGM}" == 'awk' || "${PGM}" == 'vim' ]]; then
    update-alternatives --get-selections >"${LOGDIR}/update-alternatives-get-selections.bak"

    if [[ "${PGM}" == 'awk' ]]; then
    # Why the `--slave` option?{{{
    #
    # So that when we run `$ man awk`, the gawk manpage is opened.
    # Otherwise it would fail, because we don't have any manpage for awk.
    #}}}
    update-alternatives --log "${LOGFILE}" \
      --install /usr/bin/awk awk /usr/local/bin/gawk 60 \
      --slave /usr/share/man/man1/awk.1.gz awk.1.gz /usr/local/share/man/man1/gawk.1.gz
    # Note the order of the arguments `--log` and `--install`/`--set`.
    # `--log` should  come first because  it's an option, while  `--install` and
    # `--set` are subcommands.
    update-alternatives --log "${LOGFILE}" --set awk /usr/local/bin/gawk

    elif [[ "${PGM}" == 'vim' ]]; then
      # Vim can be invoked with any of these commands.
      # We need to tell the system that, from now on, they're all provided by `/usr/local/bin/vim`.
      typeset -a names=(editor eview evim ex gview gvim gvimdiff rgview rgvim rview rvim vi view vim vimdiff)
      for name in "${names[@]}"; do
        # add our compiled Vim to each group of alternatives
        update-alternatives --log "${LOGFILE}" \
          --install /usr/bin/"${name}" "${name}" /usr/local/bin/vim 60
        # set our compiled Vim to be the master link
        update-alternatives --log "${LOGFILE}" \
          --set "${name}" /usr/local/bin/vim
      done
    fi

  fi
}
xdg_mime_default() { #{{{2
  if [[ "${PGM}" == 'vim' ]]; then
      # What's this `gvim.desktop`?{{{
      #
      # A file installed by the Vim package.
      # It describes which files Vim can open in the line ‘MimeType=’.
      #}}}
      # What does this command do?{{{
      #
      # It parses the default `gvim.desktop` to build and run a command such as:
      #
      #     $ xdg-mime default gvim.desktop text/english text/plain text/x-makefile ...
      #
      # In effect, it makes gVim the default program to open various types of text files.
      # This matters when using `$ xdg-open` or double-clicking on the icon of a
      # file in a GUI file manager.
      #}}}
      # Is it needed?{{{
      #
      # Once  the `gvim.desktop`  file is  installed, it  doesn't make  gVim the
      # default program for text files.
      # It just informs the system that gVim *can* open some of them.
      #
      # ---
      #
      # Besides, I'm not  sure, but after installing Neovim,  it's possible that
      # the latter becomes the default program to open some text files.
      #
      # Btw, the default `nvim.desktop` file lists the same types of files.
      #
      # For the moment, I prefer gVim to be the default.
      #}}}
      grep -i 'mimetype' /usr/local/share/applications/gvim.desktop \
        | sed 's/mimetype=//i; s/;/ /g' \
        | xargs xdg-mime default gvim.desktop
  fi
}

# }}}1
# Execution {{{1

# Why do you check the root privileges outside `main()`?{{{
#
# Suppose the logfile is owned by root.
# `tee` will report an error, before `check_we_are_root` tells us to restart the
# script as root; this is noise.
#}}}
check_we_are_root
main "$1" 2>&1 | tee -a "${LOGFILE}"

