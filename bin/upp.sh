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
#
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

# TODO: Add support for updating the python interpreter.
# Updating the latter may help when you have issues to install packages with pip
# (including pip itself).

# TODO: Add python (+ruby?) integration for Neovim.
# And maybe use update-alternatives to make Neovim our default editor in the future.

# TODO: We should be able  to pass an argument to the script  so that it doesn't
# install any package.  It would just compile.
# Basically,  `main()` would  do everything  as usual,  except it  wouldn't call
# these functions at the end:
#
#     install
#     update_alternatives
#     xdg_mime_default
#
# This would be useful when we git bisect an issue.

# Init {{{1

PGM="$1"
# Purpose:{{{
#
# It  can be  useful to  compile  the program  against a  specific commit  hash,
# instead of the very latest version which may be buggy at the moment.
#}}}
COMMIT_HASH="$2"
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
# https://stackoverflow.com/a/8063398/9780968
#
# How to negate a test with regular expressions?
# https://stackoverflow.com/a/7846318/9780968
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
  # https://stackoverflow.com/a/15692004/9780968
  printf -- '    %s\n' "${SUPPORTED_PGMS[@]}" >&2
  # 65 = input user data is incorrect
  exit 65
  #    │{{{
  #    └ EX_DATAERR (65)
  #
  # The command was used incorrectly, e.g.,  with the wrong number of arguments,
  # a bad flag, a bad syntax in a parameter, or whatever.
  # Source:
  # https://www.freebsd.org/cgi/man.cgi?query=sysexits&apropos=0&sektion=0&manpath=FreeBSD+4.3-RELEASE&format=html
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

  elif [[ "${PGM}" == 'nvim' ]]; then
    make CMAKE_BUILD_TYPE=Release
    #    ├──────────────────────┘
    #    └ Full compiler optimisations and no debug information.
    #      Expect the best performance from this build type.
    #      Often used by package maintainers.

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
  #
  #     $ xterm -e 'make test'
  #
  # But not this:
  #
  #     $ make test
  #
  # Because of:
  #     test1 FAILED - terminal size must be 80x24 or larger~
  #
  # Neither this:
  #
  #     $ xfce4-terminal -e 'make test'
  #
  # Because of:
  #     xfce4-terminal: Gdk-WARNING: gdk_window_set_icon_list: icons too large~
  # https://github.com/snwh/paper-icon-theme/issues/340
  #}}}
  # TODO: If a test fails, maybe we should make the script fail too.
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
  rm -f backup*.tgz "${PGM}"*.deb

  if [[ "${PGM}" == 'weechat' ]]; then
    # Clean last `$ cmake` command:
    # https://stackoverflow.com/a/9680493/9780968
    if [[ -d 'build' ]]; then
      rm -rf build
    fi
    mkdir -p build
    cd build

  else
    make clean
    make distclean
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
  # Or: https://github.com/mpv-player/mpv-build#instructions-for-debian--ubuntu-package (used in this script)
  #}}}
  elif [[ "${PGM}" == 'mpv' ]]; then
    ./update

  elif [[ "${PGM}" == 'surfraw' ]]; then
    autoreconf -f -i
    ./configure

  elif [[ "${PGM}" == 'tmux' ]]; then
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
    # Do *not* use gtk3. Prefer gtk2; it gives a lower latency.{{{
    #
    # > We can also  note that Vim using GTK3 is slower  than its GTK2 counterpart
    # > by  an order  of magnitude. It  might therefore  be possible  that the  GTK3
    # > framework  introduces extra  latency,  as  we can  also  observe other  that
    # > GTK3-based terminals  (Terminator, Xfce4  Terminal, and GNOME  Terminal, for
    # > example) have higher latency.
    #
    # Source: https://lwn.net/Articles/751763/
    #
    # ---
    #
    # I can corroborate what the article states.
    # In my limited testing with  typometer, the latency doubles after compiling
    # with gtk3.
    #}}}

    # Why moving `/usr/bin` at the start of `PATH`?{{{
    #
    # Without, we can't run python3.
    #
    #     $ vim -Nu NONE
    #     :py3 ""
    #     E448: Could not load library function PySlice_AdjustIndices~
    #     E263: Sorry, this command is disabled, the Python library could not be loaded.~
    #
    # This is because we've compiled a more recent version of python (3.7 atm).
    # And for some reason, during the compilation, sometimes Vim uses it.
    # It mixes the default python (3.5 atm) and our local version.
    #
    # By  moving `/usr/bin`  at  the start  of  `PATH`, we  make  sure that  Vim
    # finds  the default  python  (`/usr/bin/python3`), and  not  our local  one
    # (`/usr/local/bin/python3`).
    #
    # https://stackoverflow.com/a/15282645/9780968
    # https://stackoverflow.com/questions/8391077/vim-python-support-with-non-system-python/8393716#comment21639294_8393716
    #}}}
    #   Ok, but why not simply exclude `/usr/local/bin` from `PATH` while configuring?{{{
    #
    # So, you want to try sth like this:
    #
    #     delim="$(tr x '\001' <<<x)"
    #     new_path=$(sed "s${delim}/usr/local/bin:${delim}${delim}" <<<$PATH)
    #     PATH="$new_path" ./configure ...
    #
    # It could break the compilation of some programs which need to find some utility
    # installed in `/usr/local/bin`.
    # As an  example, Vim's compilation  requires gawk,  and atm, the  latter is
    # only installed in `/usr/local/bin`.
    #}}}
    #   And why not setting `--with-python3-config-dir` with the config dir of python3.7?{{{
    #
    # So, you want to replace this:
    #
    #     --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu
    #
    # with:
    #
    #     --with-python3-config-dir=/usr/local/lib/python3.7/config-3.7m-x86_64-linux-gnu
    #
    # I tried, and the compilation succeeds, but the python3 interface doesn't work:
    #
    #     $ vim -Nu NONE
    #     :py3 ""
    #     E370: Could not load library libpython3.7m.a~
    #     E263: Sorry, this command is disabled, the Python library could not be loaded.~
    #
    # ---
    #
    # There may be sth to do with the environment variable `LD_LIBRARY_PATH`.
    # I tried to set it like this:
    #
    #     LD_LIBRARY_PATH=/usr/lib:/usr/local/lib ./configure ...
    #
    # The compilation succeeded, but the python3 interface still didn't work.
    #
    # ---
    #
    # If you  find a way  to make this  solution work, and  you need to  get the
    # config paths programmatically, try this:
    #
    #     # example of values: 2.7 and 3.5
    #     python2_version="$(readlink -f "$(which python)" | sed 's/.*\(...\)/\1/')"
    #     python3_version="$(readlink -f "$(which python3)" | sed 's/.*\(...\)/\1/')"
    #
    #     # example of paths: `/usr/lib/python2.7/config-x86_64-linux-gnu` and `/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu`
    #     python2_config_path="$(locate -r "/usr/.*lib/python${python2_version}/config-" | head -n1)"
    #     python3_config_path="$(locate -r "/usr/.*lib/python${python3_version}/config-${python3_version}" | head -n1)"
    #
    #     ...
    #
    #     --with-python-config-dir="$python2_config_path" \
    #     --with-python3-config-dir="$python3_config_path"
    #}}}
    #   Is there an alternative?{{{
    #
    # You could try to set `vi_cv_path_python3` with the path to the default python:
    #
    #     vi_cv_path_python3=/usr/bin/python3.5 ./configure ...
    #     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #
    # But I don't understand what it does, and I don't know where it's documented.
    # I found it here:
    #
    # https://stackoverflow.com/a/23095537/9780968
    #
    # ---
    #
    # Also, from `:h python-building`:
    #
    # > If you have more than one version  of Python 3, you need to link python3
    # > to the one you prefer, before running configure.
    #
    # I have no idea how to “link python3 to the one I prefer” though.
    #}}}
    PATH=/usr/bin:$PATH ./configure  \
      --enable-cscope                \
      --enable-fail-if-missing       \
      --enable-gui=gtk2              \
      --enable-luainterp=dynamic     \
      --enable-multibyte             \
      --enable-perlinterp=dynamic    \
      --enable-python3interp=dynamic \
      --enable-pythoninterp=dynamic  \
      --enable-rubyinterp=dynamic    \
      --enable-terminal              \
      --prefix=/usr/local            \
      --with-compiledby=user         \
      --with-features=huge           \
      --with-luajit                  \
      --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
      --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu

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
    # https://github.com/zsh-users/zsh/blob/master/INSTALL
    #
    # I also read this link:
    # https://gist.github.com/nicoulaj/715855
    #
    # I also read how the ubuntu devs compiled `zsh-5.2`:
    #
    # https://launchpad.net/ubuntu/+source/zsh
    #
    # link found by clicking on the button below “Latest upload”
    # https://launchpad.net/ubuntu/+source/zsh/5.2-5ubuntu1
    #
    # link found by clicking on the button “amd64” in the section “Builds”
    # https://launchpad.net/ubuntu/+source/zsh/5.2-5ubuntu1/+build/10653977
    #
    # link found by clicking on the button “buildlog”
    # https://launchpadlibrarian.net/280509421/buildlog_ubuntu-yakkety-amd64.zsh_5.2-5ubuntu1_BUILDING.txt.gz
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
  # We may have edited some file (`configure`, `Makefile`, ...).
  # Stash those edits.
  git stash
  # check a master branch exists (trans has no master branch)
  # https://stackoverflow.com/q/5167957/9780968
  if [[ -n "${COMMIT_HASH}" ]]; then
    git checkout "${COMMIT_HASH}"
    return
  elif git show-ref --verify --quiet refs/heads/master; then
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
    # I prefer `v8.1.0648`.
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
    # If you  don't include an  epoch in the version  of your Vim  package, `0:`
    # will be assumed:
    #
    #     0:X.Y.Z
    #
    # As a result, your package will be overwritten by `$ aptitude safe-upgrade`.
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
  # TODO: We don't  need the compiled  binary in  the source repository,  once a
  # debian package has been installed; try to remove it.
  # This could make you save a little space, which could add up after the compilation
  # of several programs.
  #
  # For example, the mpv binary weighs 22M (if stripped).
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
    checkinstall --pkgname="${PGM}" --backup=no -y

  else
    if [[ "${DEBUG}" -ne 0 ]]; then
      echo checkinstall --pkgname="${PGM}" --pkgversion="${VERSION}" --spec=/dev/null --backup=no -y >>"${DEBUG_LOGFILE}"
    fi
    # If this command fails for Nvim, try this:{{{
    #
    # Recompile and replace:
    #
    #     $ make CMAKE_BUILD_TYPE=Release
    #
    # With:
    #
    #     $ make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
    #
    # See:
    # https://github.com/neovim/neovim/issues/2364#issuecomment-113966180
    # https://github.com/serverwentdown/env/commit/a05a31733443fcb0979fecf18f2aa8e9e2722c7c
    #
    # Note that I  don't know whether there's a performance  cost if you disable
    # jemalloc.
    #
    # See here to understand what jemalloc is:
    # https://stackoverflow.com/a/1624744/9780968
    #
    # Note that Nvim is multi-threaded:
    # > `thread apply all bt` may be necessary because **Neovim is multi-threaded**.
    #
    # Source: https://github.com/neovim/neovim/wiki/Development-tips/fd1582128edb0130c1d5c828a3a9b55aa9107030
    #
    # ---
    #
    # Alternatively, you  could try  to pass  an option to  checkinstall, and  make it
    # generate a deb without installing it.
    # Then, you could try to force its installation with `dpkg` and the right options.
    #}}}
    checkinstall --pkgname="${PGM}" --pkgversion="${VERSION}" --spec=/dev/null --backup=no -y
    #                                 │
    #                                 └ don't overwrite my package
    #                                   with an old version from the official repositories
    #                                   when I execute `aptitude safe-upgrade`
    # Why can aptitude overwrite our compiled package?{{{
    #
    # When aptitude  finds several  candidates for the  same package,  it checks
    # their version to decide which one is the newest.
    # By default, checkinstall uses the current date as the package version:
    #
    #     20180914
    #
    # This would cause an issue for Vim:
    #
    #     $ apt-cache policy vim
    #     vim:~
    #       Installed: (none)~
    #       Candidate: 2:8.0.0134-1ubuntu1~ppa1~x~
    #       Version table:~
    #          2:8.0.0134-1ubuntu1~ppa1~x 500~
    #             500 http://ppa.launchpad.net/pi-rho/dev/ubuntu xenial/main amd64 Packages~
    #     ...~
    #
    # Here the version of the Vim package in the ppa is `2:8.0.0134`.
    # If the version of our compiled package is `20180914`, it will be considered
    # older than the one in the ppa.
    # I think that's because the format of a date is different.
    # `apt` expects a number before a colon, but there's no colon in a date.
    # So it assumes that the date should be prefixed by `0:` or `1:` which gives:
    #
    #     0:20180914
    #         <
    #     2:8.0.0134-1ubuntu1~ppa1~x
    #}}}
    # Why don't you use `--pkgname="my{PGM}"` anymore?{{{
    #
    # When checkinstall tries to install `myPGM`, it may try to overwrite a file
    # belonging to `PGM` (it will probably  happen if `PGM` is already installed
    # in a different version).
    # If that happens, the installation will fail:
    #
    #     dpkg: error processing archive /home/user/GitRepos/zsh/zsh_9999.9999-1_amd64.deb (--install):~
    #      trying to overwrite '/usr/share/man/man1/zshmodules.1.gz', which is also in package myzsh 999-1~
    #     dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)~
    #}}}
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
  #     $ sudo aptitude build-dep vim-gtk
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
  elif [[ "${PGM}" == 'tmux' ]]; then
    # https://github.com/tmux/tmux/blob/4ce26b039386caac51abdf1bf78541a500423c18/.travis.yml#L9
    aptitude install bison debhelper autotools-dev dh-autoreconf file libncurses5-dev libevent-dev pkg-config libutempter-dev build-essential
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
        update-alternatives --log "${LOGFILE}" --set "${name}" /usr/local/bin/vim
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
      # Btw, the default `nvim.desktop` file lists the same types of files.
      # For the moment, I prefer gVim to be the default.
      # In the  future, you may  choose Nvim instead;  in that case,  parse this
      # file instead (found with `$ locate nvim.desktop`):
      #
      #     /usr/local/share/applications/nvim.desktop
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
tput bel

