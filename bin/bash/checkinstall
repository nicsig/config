#!/bin/bash

# Why did you stop assimilating this script?{{{
#
# We need to assimilate another script `~/bin/bash/installwatch.sh`.
# But we also need to find a way to compile our own
# `/usr/lib/checkinstall/installwatch.so`.
#
# This is way beyond what I'm able to do now.
# Maybe in the future.
#}}}

# In the original script, there's a missing space (`/usr/bin/checkinstall:1364`):{{{
#
#     if [ $? -gt 0 ]; then
#                  ^
#
# Because of this, shellcheck is unable to find all the errors in the script.
# If you don't fix this, shellcheck will only find 4 errors.
# If you fix it, shellcheck will find 515 errors.
#
# ---
#
# There was also a missing dollar at `/usr/bin/checkinstall:469`:
#
#     if [ $deref_parents -eq 1 ]; then
#          ^
#}}}

# To convert an inline comment into a comment on its own line, use this temporary mapping:{{{
#
#     nno cd f#D:-put<cr>==:+s/\s*$//<cr>
#
# This may help fixing wrong indentation (not sure).
#}}}
# If you have some wrong indentation:{{{
#
# it may be due to a comment containing an `if` keyword inside an `if` block.
#
#     func() {
#       if 1; then
#         # a comment containing the if keyword
#         echo
#       else
#         echo
#       fi
#     }
#
# In that case, replace the `i` (codepoint 69) with `і` (codepoint 456).
# Or, replace `I` (49) with `І` (406).
# The issue may be reproducible with other keywords in other blocks.
#
# If you need to find a homoglyph:
# https://www.irongeek.com/homoglyph-attack-generator.php
#}}}

# Trap the INT signal (ctrl-c, for example)
trap trapint 2

INSTALLDIR=$(readlink -f "$0")
INSTALLDIR=$(dirname "$INSTALLDIR")/..

DIRECTORIO_FUENTE=$(pwd)
PKG_BASENAME="$(basename "$DIRECTORIO_FUENTE")"

# functions {{{1
usage() { #{{{2
  # We've removed these options:{{{
  #
  #     *Package type selection*
  #
  #     -t,--type=<slackware|rpm|debian> Choose packaging system
  #     -S                               Build a Slackware package
  #     -R                               Build a RPM package
  #     -D                               Build a Debian package
  #
  #     *Scripting options*
  #
  #     ...
  #     --rpmflags=<flags>             Pass this flags to the rpm installer
  #     --rpmi                         Use the -i flag for rpm when installing a .rpm
  #     --rpmu                         Use the -U flag for rpm when installing a .rpm
  #     ...
  #     --spec=<path>                  .spec file location
  #
  #     *Info display options*
  #
  #     ...
  #     -ss                            Run an interactive Slackware installation script
  #     --showslack=<yes|no>           Toggle interactive Slackware installation script
  #
  #     *Package tuning options*
  #     ...
  #     --review-spec                  Review the spec file before creating a .rpm
  #     --newslack                     Use the new (8.1+) Slackware description format
  #                                    ("--newslack" implies "-S")
  #
  #     *Cleanup options*
  #     ...
  #     --delspec=<yes|no>             Delete spec file upon termination
  #     --bk                           Backup any overwritten files
  #
  #     *About CheckInstall*
  #
  #     ...
  #     --copyright                    Show Copyright information
  #}}}
  cat <<EOF >&2

Usage: checkinstall [options] [command [command arguments]]
Options:

*Install options*

--install=<yes|no>             Toggle created package installation
--fstrans=<yes|no>             Enable/disable the filesystem translation code

*Scripting options*

-y, --default                  Accept default answers to all questions
--pkgname=<name>               Set name
--pkgversion=<version>         Set version
-A, --arch, --pkgarch=<arch>   Set architecture
--pkgrelease=<release>         Set release
--pkglicense=<license>         Set license
--pkggroup=<group>             Set software group
--pkgsource=<source>           Set source location
--pkgaltsource=<altsource>     Set alternate source location
--pakdir=<directory>           The new package will be saved here
--maintainer=<email addr>      The package maintainer (.deb)
--provides=<list>              Features provided by this package
--requires=<list>              Features required by this package
--conflicts=<list>             Packages that this package cannot be installed with (.deb)
--replaces=<list>              Packages that this package replaces (.deb)
--dpkgflags=<flags>            Pass this flags to the dpkg installer
--nodoc                        Do not include documentation files

*Info display options*

-d<0|1|2>                      Set debug level
-si                            Run an interactive install command
--showinstall=<yes|no>         Toggle interactive install command

*Package tuning options*

--autodoinst=<yes|no>          Toggle the creation of a doinst.sh script
--strip=<yes|no>               Strip any ELF binaries found inside the package
--stripso=<yes|no>             Strip any ELF binary libraries (.so files)
--addso=<yes|no>               Search for any shared libs and add
                               them to /etc/ld.so.conf
--reset-uids=<yes|no>          Reset perms for all files to o=g, dirs to 755 and
                               the owner/group for all dirs to root.root
--gzman=<yes|no>               Compress any man pages found inside the package
--docdir=<path>                Where to put documentation files
                               The package name+version gets automatically appended.
                               To avoid that prefix the path with a colon (:).
--umask=<mask>                 Set the umask value
--exclude=<file|dir[,...]>     Exclude these files/directories from the package
--include=<listfile>           Force the inclusion in the package of the
                               files/dirs listed in "listfile"
--inspect                      Inspect the package's file list
--review-control               Review the control file before creating a .deb
--with-tar=/path/to/tar        Manually set the path to the tar binary
                               in this system

*Cleanup options*

--deldoc=<yes|no>              Delete doc-pak upon termination
--deldesc=<yes|no>             Delete description-pak upon termination
--backup=<yes|no>              Toggle backup

*About CheckInstall*

--help, -h                     Show this message

EOF
exit 64
}
echop() { #{{{2
  # printf with newline at the end
  # Why the shift?{{{
  #
  # We need the newline to be appended to  the end of the format, not to the end
  # of the arguments.
  #}}}
  local format="$1"
  shift
  printf -- "$format\n" "$@" >&2
}

echopn() { #{{{2
  # printf with NO newline at the end
  printf -- "$@" >&2
}

help_notice() { #{{{2
  echo
  echop 'Use --help or -h to get more information'
  echo
  exit 65
}

boolean_usage() { #{{{2
  echo
  echop '%s is an invalid value for %s' "$2" "$1"
  help_notice
  exit 65
}

# yes or no #{{{2

y_or_n() {
  if [ "$1" ]; then
    DEFAULTYN="$1"
  else
    DEFAULTYN='y'
  fi
  DEFAULTYN=$(echo $DEFAULTYN | tr '[:upper:]' '[:lower:]')

  if [ "$DEFAULTYN" = "y" ]; then
    # Print the default option
    echo -n ' [y]: '
  else
    echo -n ' [n]: '
  fi

  # Should we accept all the defaults?
  if [ "$ACCEPT_DEFAULT" -eq 0 ]; then
    read YN
    YN=$(echo "$YN" | tr '[:upper:]' '[:lower:]')
    # іf the user pressed ENTER then
    ! [ "$YN" ] && YN=$DEFAULTYN
  else
    YN=$DEFAULTYN
    echo "$YN"
  fi
  if [ "$YN" = "y" ] ;then
    return 0
  else
    return 1
  fi
}

ok_or_failed() { #{{{2
  # Prints OK or FAILED! depending on previous command return value
  if [ $? -gt 0 ]; then
    echop ' FAILED!'
    return 1
  else
    echop 'OK'
    return 0
  fi
}

restore_backup() { #{{{2
  # Іf we have translation turned on then we didn't do a backup
  if [ "${TRANSLATE}" = "1" ]; then return 0; fi

 # Else, restore the backup іf it exists

 rm -rf "${TMP_DIR}/BACKUP/no-backup" &> /dev/null

 ls "${TMP_DIR}/BACKUP/"* &> /dev/null
 if [ $? -eq 0 ]; then
   echopn "Restoring overwritten files from backup..."
   cd "${TMP_DIR}/BACKUP"
   files=$(ls -A)
   tar -cpf - "$files" | tar -f - -xvpC / &> /dev/null
   ok_or_failed
   echo
 fi
}

trapint() { #{{{2
  echo
  echo
  echop "*** SIGINT received ***"
  cleanup
}

cleanup() { #{{{2
  echo
  restore_backup
  echopn "Cleaning up..."
  cd "$DIRECTORIO_FUENTE"
  [ -n "${BUILDROOT}" ] && [ -d "${BUILDROOT}" ] && rm -rf "${BUILDROOT}"
  if [ "$DEBUG" -eq 0 ]; then
    [ -n "${TMP_DIR}" ] && [ -d "${TMP_DIR}" ] && rm -rf "${TMP_DIR}"
    rm -f checkinstall-debug*
  else
    echopn "(Debugging mode on, KEEPING temp dir $TMP_DIR)..."
  fi

  # Іf we had a pre-existing postinstall-pak, we keep it as it was.
  if [ -f "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" ]; then
    mv "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" "${DIRECTORIO_FUENTE}/postinstall-pak"
  fi

  true; ok_or_failed
  echo
  echop "Bye."
  echo
  exit 1
}

getflags() { #{{{2
  # Function to copy a directory with permissions, honours setuid, setgid,
  # sticky bits, owner, group etc.
  #
  # A bit lengthy and slow but very few directories in the largest of
  # packages have to be copied like this.

  col=$1 dir="$2"
  permissions=$(ls -ld "$dir" | awk '{print $1}')
  mask="."
  bit=2
  while [[ $bit -lt $col ]]; do mask="$mask."; bit=$((bit + 1)); done
  mask="$mask\(.\)"
  bit=$col
  while [[ $bit -lt 10 ]]; do mask="$mask."; bit=$((bit + 1)); done
  permission="$(echo "$permissions" | sed "s/$mask/\1/" | grep -v -- '-')"
  case "$permission" in
    s) echo "xs";; S) echo "s";; t) echo "xt";; T) echo "t";;
    *) echo "$permission";;
  esac
}

dircopy() { #{{{2
  src_dir="$1" dest_dir="$2"
  col=2 chmod_args=""
  set=u flags=""
  while [ $col -le 4 ]; do
    flags="${flags}$(getflags $col "$src_dir")"; col=$((col + 1))
  done
  [ -n "$flags" ] && { chmod_args="$set+$flags" ;}
  set=g flags=""
  while [ $col -le 7 ]; do
    flags="${flags}$(getflags $col "$src_dir")"; col=$((col + 1))
  done
  [ -n "$flags" ] && {
    [ -n "$chmod_args" ] && chmod_args="$chmod_args,"
      chmod_args="$chmod_args$set+$flags"
    }
  set=o flags=""
  while [ $col -le 10 ]; do
    flags="${flags}$(getflags $col "$src_dir")"; col=$((col + 1))
  done
  [ -n "$flags" ] && {
    [ -n "$chmod_args" ] && chmod_args="$chmod_args,"
      chmod_args="$chmod_args$set+$flags"
    }
  [ -d "$dest_dir" ] || {
    mkdir -p "$dest_dir"
      chmod 700 "$dest_dir"
    }
  [ -n "$chmod_args" ] && chmod "$chmod_args" "$dest_dir"
  chown "$(ls -ld "$src_dir" | awk '{print $3}')" "$dest_dir"
  chgrp "$(ls -ld "$src_dir" | awk '{print $4}')" "$dest_dir"
}

shell_escape() { #{{{2
  # This function is used to properly escape shell commands, so
  # we don't interpret the install command twice. This is useful
  # for making commands like 'make CC="gcc -some -options" install'
  # work as expected.

  for str in "$@" ; do
    echo -n "\"$str\" "
  done;
  echo
}

list_parents() { #{{{2
  # Output all the parents of the files given as arguments to stdout. Remove
  # duplicates.
  src="$*"
  files=$(for f in $src; do
  echo "$f" | awk '
  BEGIN{
  FS = "/"
}
{
  for (i=1;i<NF;i++){
    for (j=1;j<=i;j++){
      printf "%s",$(j)
      if (j != i){
        printf "/"
      }
  }
printf " "
}
}'
done)

echo "${files}"  | tr ' ' '\n' | uniq | tr '\n' ' '
return $?
}

copy_dir_hierarchy() { #{{{2
  # Copy some file ($1) whose path is given relatively to some root ($2) to a
  # destination ($3). Іf --deref-parents appear as first argument, then symlink
  # parents will not be copied as symlinks but as ordinary directories. All
  # permissions are preserved. The directories the source file was in are
  # preserved up to the root. The files that were copied are displayed on stdout
  deref_parents=0
  if echo "${1}" | grep -E '^--deref-parents'; then
    deref_parents=1
    shift
  fi
  src="${1}"
  root="${2}"
  dest="${3}"

  # All directories the file is in, e.g іf src is
  # ./usr/local/lib/installwatch.so, then files will be . ./usr ./usr/local
  # ./usr/local/lib
  files=$(list_parents "${src}")

  # Only use tar іf there are parents
  echo "${files}" | grep -E '[^[:space:]]' >/dev/null
  if [ $? -eq 0 ]; then
    if [ $deref_parents -eq 1 ]; then
      # Add the -h option to the tar command for dereferencing
      tar --no-recursion -C "${root}" -cphf - "$files" | tar -f - -xvpC "${dest}"
    else
      tar --no-recursion -C "${root}" -cpf - "$files" | tar -f - -xvpC "${dest}"
    fi
  fi

  tar -C "${root}" -cpf - "$src" | tar -f - -xvpC \
    "${dest}"

  return $?
}
#}}}1

# Get our default settings from the rc file #{{{1

####################################################################
# These are default settings for CheckInstall, modify them as you  #
# need. Remember that command line switches will override them.    #
####################################################################

# Debug level
#   0: No debug
#   1: Keep all temp files except the package's files
#   2: Keep the package's files too

DEBUG=0

INSTALLWATCH=$HOME/bin/bash/installwatch.sh

# Location of the makepkg program. "makepak" is the default, and is
# included with checkinstall. If you want to use Slackware's native "makepkg"
# then set this to "makepkg"

MAKEPKG=/sbin/makepkg

# makepkg optional flags. These are recommended if running a newer Slackware
# version: "-l y -c n"

MAKEPKG_FLAGS="-l y -c n"

# Is MAKEPKG running interactively? If so, you might want
# to see what it's doing:

SHOW_MAKEPKG=0

# Where will we keep our temp files?
BASE_TMP_DIR=/var/tmp   ##  Don't set this to /tmp or / !!

# Where to place the installed document files
DOC_DIR="/usr/share/doc"

# Default architecture type (Leave it empty to allow auto-guessing)
ARCHITECTURE=""

# Default package type. Leave it empty to enable asking everytime
#   S : Slackware
#   R : RPM
#   D : Debian

INSTYPE="D"

# Storage directory for newly created packages
# By default they will be stored at the default
# location defined for the package type

PAK_DIR=""

# RPM optional flags
RPM_FLAGS=" --force --nodeps --replacepkgs "

# dpkg optional flags
DPKG_FLAGS=""

## These are boolean. Set them to 1 or 0

# Interactively show the results of the install command (i.e. "make install")?
# This is useful for interactive installation commands
SHOW_INSTALL=1

# Show Slackware package installation script while it runs? Again, useful if
# it's an interactive script
SHOW_SLACK_INSTALL=1

# Automatic deletion of "doc-pak" upon termination?
DEL_DOCPAK=0

# Automatic deletion of the spec file?
DEL_SPEC=0

# Automatic deletion of "description-pak"?
DEL_DESC=0

# Automatically strip all ELF binaries?
STRIP_ELF=1

# Automatically strip all ELF shared libraries?
# Note: this setting will automatically be set to "0" if STRIP_ELF=0
STRIP_SO_ELF=1

# Automatically search for shared libraries and add them to /etc/ld.so.conf?
# This is experimental and could mess up your dynamic loader configuration.
# Use it only if you know what you are doing.
ADD_SO=0

# Automatically compress all man pages?
COMPRESS_MAN=1

# Set the umask to this value
CKUMASK=0022

# Backup files overwritten or modified by your install command?
BACKUP=1

# Write a doinst.sh file that installs your description (Slackware)?
AUTODOINST=1

# Are we going to use filesystem translation?
TRANSLATE=0

# Reset the owner/group of all files to root.root?
RESET_UIDS=0

# Use the new (8.1+) Slackware description file format?
NEW_SLACK=1

# Comma delimited list of files/directories to be ignored
EXCLUDE=""

# Accept default values for all questions?
ACCEPT_DEFAULT=0

# Use "-U" flag in rpm by default when installing a rpm package
# This tells rpm to (U)pdate the package instead of (i)nstalling it.
RPM_IU=U

# Inspect the file list before creating the package
CK_INSPECT=0

# Review the .spec file before creating a .rpm
REVIEW_SPEC=0

# Review the control file before creating a .deb
REVIEW_CONTROL=0

# Install the package or just create it?
INSTALL=1

# Arguments parsing {{{1

CKNAME=$(basename "$0")
PARAMS=$(getopt -a -n "$CKNAME" -o +d:DA:t:RShHy -l arch:,type:,si,showinstall::,deldoc::,deldesc::,strip::,addso::,install::,stripso::,gzman::,backup::,autodoinst::,reset-uids::,fstrans::,exclude:,include:,pkgname:,pkgversion:,pkgrelease:,pkglicense:,pkggroup:,pkgsource:,pkgaltsource:,pakdir:,docdir:,requires:,provides:,conflicts:,replaces:,maintainer:,dpkgflags:,pkgarch:,umask:,with-tar:,inspect,review-spec,review-control,help,nodoc,version,copyright,default -- "$@")

[ $? -gt 0 ] && help_notice

eval set -- "$PARAMS"

while [ "$1" != "--" ]; do
  case "$1" in
    -h|-H|--help)
      usage;;
    -d)
      shift
      case $(eval echo "$1") in
        0) DEBUG=0;;
        1|'') DEBUG=1;;
        2) DEBUG=2;;
        3) DEBUG=3;;
        4) DEBUG=4;;
        *)
          boolean_usage "-D" "$1"
      esac
      ;;
    -A|--arch|--pkgarch)
      shift
      ARCHITECTURE=$(eval echo "$1")
      ;;
    --umask)
      shift
      CKUMASK=$(eval echo "$1")
      ;;
    --pkgname)
      shift
      NAME=$(eval echo "$1")
      ;;
    --pkgversion)
      shift
      VERSION=$(eval echo "$1")
      ;;
    --pkgrelease)
      shift
      RELEASE=$(eval echo "$1")
      ;;
    --pkglicense)
      shift
      LICENSE=$(eval echo "$1")
      ;;
    --pkggroup)
      shift
      # note: we use PKG_GROUP instead of GROUP since (t)csh sets GROUP.
      PKG_GROUP=$(eval echo "$1")
      ;;
    --pkgsource)
      shift
      SOURCE=$(eval echo "$1")
      ;;
    --pkgaltsource)
      shift
      ALTSOURCE=$(eval echo "$1")
      ;;
    --pakdir)
      shift
      PAK_DIR=$(eval echo "$1")
      ;;
    --with-tar)
      shift
      TAR=$(eval echo "$1")
      ;;
    --docdir)
      shift
      DOC_DIR=$(eval echo "$1")
      ;;
    --provides)
      shift
      PROVIDES=$(eval echo "$1")
      ;;
    --conflicts)
      shift
      CONFLICTS=$(eval echo "$1")
      ;;
    --replaces)
      shift
      REPLACES=$(eval echo "$1")
      ;;
    --requires)
      shift
      REQUIRES=$(eval echo "$1")
      ;;
    --maintainer)
      shift
      MAINTAINER=$(eval echo "$1")
      ;;
    --dpkgflags)
      shift
      DPKG_FLAGS=$(eval echo "$1")
      ;;
    --install)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          INSTALL=1;;
        0|no)
          INSTALL=0;;
        *)
          boolean_usage "--install" "$1"
      esac
      ;;
    --si)
      SHOW_INSTALL=1;;
    --showinstall)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          SHOW_INSTALL=1;;
        0|no)
          SHOW_INSTALL=0;;
        *)
          boolean_usage "--showinstall" "$1"
      esac
      ;;
    --deldoc)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          DEL_DOCPAK=1;;
        0|no)
          DEL_DOCPAK=0;;
        *)
          boolean_usage "--deldoc" "$1"
      esac
      ;;
    --deldesc)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          DEL_DESC=1;;
        0|no)
          DEL_DESC=0;;
        *)
          boolean_usage "--deldesc" "$1"
      esac
      ;;
    --strip)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          STRIP_ELF=1;;
        0|no)
          STRIP_ELF=0;;
        *)
          boolean_usage "--strip" "$1"
      esac
      ;;
    --addso)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          ADD_SO=1;;
        0|no)
          ADD_SO=0;;
        *)
          boolean_usage "--strip" "$1"
      esac
      ;;
    --stripso)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          STRIP_SO_ELF=1
          ;;
        0|no)
          STRIP_SO_ELF=0;;
        *)
          boolean_usage "--stripso" "$1"
      esac
      ;;
    --gzman)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          COMPRESS_MAN=1;;
        0|no)
          COMPRESS_MAN=0;;
        *)
          boolean_usage "--gzman" "$1"
      esac
      ;;
    --backup)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          BACKUP=1;;
        0|no)
          BACKUP=0;;
        *)
          boolean_usage "--backup" "$1"
      esac
      ;;
    --default)
      ACCEPT_DEFAULT=1;;
    -y)
      ACCEPT_DEFAULT=1;;
    --nodoc)
      NODOC=1;;
    --inspect)
      CK_INSPECT=1;;
    --review-control)
      REVIEW_CONTROL=1;;
    --autodoinst)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          AUTODOINST=1;;
        0|no)
          AUTODOINST=0;;
        *)
          boolean_usage "--autodoinst" "$1"
      esac
      ;;
    --reset-uids)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          RESET_UIDS=1;;
        0|no)
          RESET_UIDS=0;;
        *)
          boolean_usage "--reset-uids" "$1"
      esac
      ;;
    --fstrans)
      shift
      case $(eval echo "$1") in
        1|yes|'')
          TRANSLATE=1;;
        0|no)
          TRANSLATE=0;;
        *)
          boolean_usage "--fstrans" "$1"
      esac
      ;;
    --exclude)
      shift
      EXCLUDE=$(eval echo "$1")
      ;;
    --include)
      shift
      CK_INCLUDE_FILE=$(eval echo "$1")
      ;;
  esac
  shift
done

# See іf we have and install command
shift

[ "$1" = "" ] && set -- make install

# Initialize some variables {{{1

# Debug level
! [ "$DEBUG" ] && DEBUG=0

# Which makepkg to use
! [ "$MAKEPKG" ] && MAKEPKG=/sbin/makepkg

# Default MAKEPKG flags
! [ "$MAKEPKG_FLAGS" ] && MAKEPKG_FLAGS="-l y -c n"

# Default architecture type
! [ "$ARCHITECTURE" ] && ARCHITECTURE=""

# Interactively show the results of the install command
# This is useful for interactive installation commands
! [ "$SHOW_INSTALL" ] && SHOW_INSTALL=1

# Automatic deletion of "doc-pak" upon termination
! [ "$DEL_DOCPAK" ] && DEL_DOCPAK=1

# Automatic deletion of "description-pak"
! [ "$DEL_DESC" ] && DEL_DESC=1

# Automatically strip all ELF binaries
! [ "$STRIP_ELF" ] && STRIP_ELF=1

# Don't automatically strip all ELF binaries
! [ "$STRIP_SO_ELF" ] && STRIP_SO_ELF=0

# Don't automatically search shared libraries
# nor add them to /etc/ld.so.conf
! [ "$ADD_SO" ] && ADD_SO=0

# Automatically compress all man pages
! [ "$COMPRESS_MAN" ] && COMPRESS_MAN=1

# Backup all files modified by the install command supplied by the user
! [ "$BACKUP" ] && BACKUP=1

# Write description installing code to doinst.sh
! [ "$AUTODOINST" ] && AUTODOINST=1

# Are we going to use filesystem translation?
! [ "$TRANSLATE" ] && TRANSLATE=1

# Reset the owner/group of all files to root.root?
! [ "$RESET_UIDS" ] && RESET_UIDS=0

# We won't include anything under this directories
! [ "$EXCLUDE" ] && EXCLUDE=""

# We will include anything listed in this file
! [ "$CK_INCLUDE_FILE" ] && CK_INCLUDE_FILE=""

# Accept the default answer for all the questions
! [ "$ACCEPT_DEFAULT" ] && ACCEPT_DEFAULT=0

# Use the default doc directory of /usr/doc
! [ "$DOC_DIR" ] && DOC_DIR=/usr/doc

# Do not include common documentation
! [ "$NODOC" ] && NODOC=0

# Inspect the file list before creating the package
! [ "$CK_INSPECT" ] && CK_INSPECT=0

# Review the control file before creating a .deb
! [ "$REVIEW_CONTROL" ] && REVIEW_CONTROL=0

# Set the umask
! [ "$CKUMASK" ] && CKUMASK=0022

# No real installation іf not explicitly asked
! [ "$INSTALL" ] && INSTALL=0

# The place where we will be storing the temp files
! [ "$BASE_TMP_DIR" ] && BASE_TMP_DIR=/var/tmp

# Default DPKG FLAGS
! [ "$DPKG_FLAGS" ] && DPKG_FLAGS=""

# Default MAKEPKG FLAGS
! [ "$MAKEPKG_FLAGS" ] && MAKEPKG_FLAGS=""

# Show the makepkg program's output?
! [ "$SHOW_MAKEPKG" ] && SHOW_MAKEPKG=0

####################
# Non-configurable #
####################

# Existing configuration files are always preserved
[ -f description-pak ] && DEL_DESC=0
[ -d doc-pak ] && DEL_DOCPAK=0

INSTALLCMD=("$@")
[ -z "${INSTALLCMD[*]}" ] && INSTALLCMD=(make install)

#################################
# Variable definition ends here #
#################################

echo

# Set the umask. Іf not specified with "--umask" then we'll use 0022, a
# standard, non-paranoid reasonable value.

if [ $DEBUG -gt 0 ] ;then
  echo "debug: Setting umask => $CKUMASK"
fi
umask $CKUMASK

# Find a safe TMP_DIR

TMP_DIR=$(mktemp -q -d -p "${BASE_TMP_DIR}")
RETURN=$?

if [ "$TMP_DIR" = "$BASE_TMP_DIR" -o "$TMP_DIR" = "/" ]; then
  echo
  echop "%s is an unacceptable value for the temp dir. Please \nedit the variable definition for %s and try again." "$TMP_DIR" "$TMP_DIR"
  echo
  echop "*** Aborting"
  echo
  exit 1
fi

if [ $RETURN -gt 0 ]; then
  echo
  echop "**** Failed to create temp dir! \n**** Do you have write permission for %s? \n\n**** Aborting installation." "$BASE_TMP_DIR"
  echo
  exit  $RETURN
fi

BUILD_DIR=${TMP_DIR}/package
mkdir "$BUILD_DIR"

if [ $DEBUG -gt 0 ] ;then
  echo "debug: The temporary directory is: [ $TMP_DIR ]"
  echo
fi

# 001117-BaP: We can create a default set of docs on the fly . . .
#   The list I've included should cover most packages adequately. Іf not,
#   then you should really create the package doc set *manually*


# Check іf --nodoc was specified
if [ "$NODOC" = "0" ]; then
  if  ! [ -d "$DIRECTORIO_FUENTE/doc-pak" ]; then
    echopn "The package documentation directory ./doc-pak does not exist. \nShould I create a default set of package docs? "
    if y_or_n; then
      echo
      echopn "Preparing package documentation..."
      mkdir doc-pak
      for f in ABOUT ABOUT-NLS ANNOUNCE AUTHORS *BUGS* CHANGES CONFIGURATION *COPYING* *COPYRIGHT* CREDITS ChangeLog Changelog CHANGELOG CONTRIBUTORS *FAQ* FEATURES FILES HACKING History HISTORY INSTALL* LICENSE LSM MANIFEST NEWS *README* *Readme* SITES *RELEASE* RELNOTES THANKS TIPS TODO VERSION CONFIGURATION* GPL License  Doc doc Docs* docs* Roadmap ROADMAP; do
        if [ -e "$f" ]; then
          if ! [ -L "$f" ]; then
            cp -a "$f" doc-pak
          else
            cp -LpR "$f" doc-pak
          fi
        fi
      done
      ok_or_failed
      DOCS=$(ls doc-pak)
      if ! [ "$DOCS" ]; then
        echo
        echop "*** No known documentation files were found. The new package \n*** won\'t include a documentation directory."
        rm -rf doc-pak                 # іf doc-pak is empty then we
      fi                                # don't need it
    fi
  fi
fi # End of NODOC

########################################
#                                      #
# Find out the packaging method to use #
#                                      #
########################################


## Do we have a package description file? Іf we don't then
## we should write one

cd "$DIRECTORIO_FUENTE"

if [ $ACCEPT_DEFAULT -eq 0 ]; then  # іf --default is given, we skip this
  if ! [ -r description-pak ]; then
    DESCRIPTION="Package created with checkinstall"
    echo
    echopn "Please write a description for the package."

    echo
    echop "End your description with an empty line or EOF."
    while [ "$DESCRIPTION" ]; do
      echo -n ">> "
      read DESCRIPTION
      [ "$DESCRIPTION" ] && echo "$DESCRIPTION" >> description-pak
    done
  fi
fi

# We still don't have it??
! [ -r description-pak ] && echo "Package created with checkinstall" > description-pak

echo
echop "*****************************************\n**** Debian package creation selected ***\n*****************************************"

########## Acquire some info about the package ##########


# Figure out what kind of machine are we running on
if ! [ "$ARCHITECTURE" ]; then
  ARCHITECTURE=$(dpkg-architecture -qDEB_HOST_ARCH)
fi

OPTION=junk
while [ "$OPTION" ]; do
  # Some sanity checks
  ! [ "$SUMMARY" ] && SUMMARY=$(head -1 description-pak)
  ! [ "$NAME" ] && NAME=$(echo "$PKG_BASENAME" | rev | cut -f2- -d"-" | rev)

  # Make the name policy compliant
  echo "$NAME" | grep -e "[[:upper:]]" &> /dev/null

  if [ $? -eq 0 ]; then
    echo
    echop "*** Warning: The package name \"%s\" contains upper case\n*** Warning: letters. dpkg might not like that so I changed\n*** Warning: them to lower case." "$NAME"
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')


  fi
  echo "$NAME" | grep -e '^[^0-9a-z]' &> /dev/null
  if [ $? -eq 0 ]; then
    echo
    echop "*** Warning: The package name \"%s\" does not start with\n*** Warning: an alphanumetic character. dpkg might not like that so I prefixed\n*** Warning: it with a number 0." "$NAME"
    NAME=${NAME/#/0}
  fi
  echo "$NAME" | grep -e '[^0-9a-z+.-]' &> /dev/null
  if [ $? -eq 0 ]; then
    NAME=${NAME//[^0-9a-z+.-]/-}
    echo
    echop "*** Warning: The package name \"%s\" contains illegal\n*** Warning: characters. dpkg might not like that so I changed\n*** Warning: them to dashes." "$NAME"
  fi

  ! [ "$VERSION" ] && VERSION=$(echo "$PKG_BASENAME" | rev | cut -f1 -d"-" | rev)
  ## Did we get a usable version?

  if [  "$VERSION" = "$PKG_BASENAME" ]; then

    # іf we did not then try getting it from the config.log file
    if [ -f "$DIRECTORIO_FUENTE/config.log" ]; then
      VERSION=$(grep '#define VERSION' config.log| awk -F \" '{print $ 2}')
    else
      # We use the current that іf everything else fails
      VERSION=$(date +%Y%m%d)
    fi
  fi

  # Check for a valid version for dpkg
  NEWVERS=$(echo "$VERSION" | grep -E '^([[:alnum:]]+:)?[[:alnum:]]+([-:.+~][[:alnum:]]+)*(-[.[:alnum:]]+)?$' 2> /dev/null)
  while [ "$NEWVERS" != "$VERSION" ]; do
    echo
    echop "*** Warning: The package version \"%s\" is not a\n*** Warning: debian policy compliant one. Please specify an alternate one" "$VERSION"
    if [ $ACCEPT_DEFAULT -eq 0 ] ; then
      read VERSION
      NEWVERS=$(echo "$VERSION" | grep -E '^([[:alnum:]]+:)?[[:alnum:]]+([-:.+~][[:alnum:]]+)*(-[.[:alnum:]]+)?$' 2> /dev/null)
    else
      VERSION=0
      NEWVERS=0
    fi
  done

  ! [ "$RELEASE" ] && RELEASE="1"
  ! [ "$LICENSE" ] && LICENSE="GPL"
  ! [ "$PKG_GROUP" ] && PKG_GROUP="checkinstall"

  ! [ "$ARCHITECTURE" ] && ARCHITECTURE="i386"
  ! [ "$SOURCE" ] && SOURCE="$PKG_BASENAME"
  ! [ "$ALTSOURCE" ] && ALTSOURCE=""
  ! [ "$PROVIDES" ] && PROVIDES="$NAME"
  ! [ "$REQUIRES" ] && REQUIRES=""
  # bond: added this so it is easy to change the Maintainer: field
  # just by setting the MAINTAINER environment variable

  # Try to find the hostname in the environment
  if [ "$HOSTNAME" ]; then
    MAINTDOMAIN=$HOSTNAME
  else
    hostname -f &> /dev/null
    if [ $? -gt 0 ]; then
      MAINTDOMAIN="localhost"
    else
      MAINTDOMAIN=$(hostname -f)
    fi
  fi
  ! [ "$MAINTAINER" ] && MAINTAINER=${LOGNAME:-root}@${MAINTDOMAIN}


  echo
  echop "This package will be built according to these values: "
  echo
  # Debian maintainers use the Maintainer: field and want to be able
  # to change it. Іf we are not on debian we don't need the field...
  echop "0 -  Maintainer: [ %s ]" "$MAINTAINER"

  echop "1 -  Summary: [ %s ]" "$SUMMARY"
  echop "2 -  Name:    [ %s ]" "$NAME"
  echop "3 -  Version: [ %s ]" "$VERSION"
  echop "4 -  Release: [ %s ]" "$RELEASE"
  echop "5 -  License: [ %s ]" "$LICENSE"
  echop "6 -  Group:   [ %s ]" "$PKG_GROUP"
  echop "7 -  Architecture: [ %s ]" "$ARCHITECTURE"
  echop "8 -  Source location: [ %s ]" "$SOURCE"
  echop "9 -  Alternate source location: [ %s ]" "$ALTSOURCE"
  echop "10 - Requires: [ %s ]" "$REQUIRES"
  echop "11 - Provides: [ %s ]" "$PROVIDES"
  echop "12 - Conflicts: [ %s ]" "$CONFLICTS"
  echop "13 - Replaces: [ %s ]" "$REPLACES"

  echo
  echopn "Enter a number to change any of them or press ENTER to continue: "
  if [ $ACCEPT_DEFAULT -eq 1 ]; then
    echo
    OPTION=""
  else
    read OPTION
  fi

  case $OPTION in
    1)
      echop "Enter new summary: "
      echo -n ">> "
      read SUMMARY
      ;;
    2)
      echop "Enter new name: "
      echo -n ">> "
      read NAME
      ;;
    3)
      echop "Enter new version: "
      echo -n ">> "
      read VERSION
      ;;
    4)
      echop "Enter new release number: "
      echo -n ">> "
      read RELEASE
      ;;
    5)
      echop "Enter the license type: "
      echo -n ">> "
      read LICENSE
      ;;
    6)
      echop "Enter the new software group: "
      echo -n ">> "
      read PKG_GROUP
      ;;
    7)
      echop "Enter the architecture type: "
      echo -n ">> "
      read ARCHITECTURE
      ;;
    8)
      echop "Enter the source location: "
      echo -n ">> "
      read SOURCE
      ;;
    9)
      echop "Enter the alternate source location: "
      echo -n ">> "
      read ALTSOURCE
      ;;
    0) # bond: again, debian-specific
      { echop "Enter the maintainer's name and e-mail address: " ; echo -n ">> " ; read MAINTAINER ;}
      ;;
    10)
      { echop "Enter the additional requirements: " ; echo -n ">> " ; read REQUIRES ;}
      ;;
    11)
      # 01-12-06 UKo: new feature
      { echop "Enter the provided features: " ; echo -n ">> " ; read PROVIDES ;}
      ;;
    12)
      { echop "Enter the conflicting packages: " ; echo -n ">> " ; read CONFLICTS ;}
      ;;
    13)
      { echop "Enter the replaced packages: " ; echo -n ">> " ; read REPLACES ;}
      ;;
  esac
done

# The PKG_BASENAME is adjusted to reflect any changes
# in the NAME and VERSION of the package
# NOTE: on debian we use NAME alone, instead - see below

PKG_BASENAME="$NAME-$VERSION"

###########################################################


#
# We run the program installation from the source directory
#

# Write a small script to run the install command. This way the LD_PRELOAD
# environment variable will be available to it, wich among other things
# will allow proper detection of new symbolic links and files created by
# subshells.

[ $DEBUG -gt 0 ] && echo "debug: CK_INCLUDE_FILE = $CK_INCLUDE_FILE"

TMP_SCRIPT=${TMP_DIR}/installscript.sh

cat << EOF > $TMP_SCRIPT
#!/bin/sh

cd "$DIRECTORIO_FUENTE"
EOF

shell_escape "${INSTALLCMD[@]}" >> "$TMP_SCRIPT"

cat << EOF >> $TMP_SCRIPT
# Report success or failure
if [ \$? -eq 0 ]; then
   exit 0
 else
   exit 1
fi

EOF

# No one needs to see what we are doing. It's safer this way.
chmod 700 "$TMP_SCRIPT"


echo
echopn "Installing with %s..." "${INSTALLCMD[*]}"


#
#   We exclude as many "dangerous" directories as possible from translation.
# installwatch excludes itself some directories, but we put them all here,
# to be explicit.
#
IEXCLUDE="${DIRECTORIO_FUENTE},/dev,/proc,/tmp,/var/tmp"


# Run the install command, showing the results interactively іf we were asked
# to do so in the configuration section (see the SHOW_INSTALL switch above)
INSTALL_FAILED=0
if [ $SHOW_INSTALL -eq 0 ]; then

  $INSTALLWATCH --logfile="${TMP_DIR}/newfiles.tmp" --exclude="${IEXCLUDE}" \
    --root="${TMP_DIR}" --transl=${TRANSLATE} --backup=${BACKUP} --dbglvl=$DEBUG\
    "$TMP_SCRIPT" &> "/${TMP_DIR}/install.log"

  ok_or_failed
  INSTALL_FAILED=$?
else
  echo
  echo
  echop "========================= Installation results ==========================="
  $INSTALLWATCH --logfile="${TMP_DIR}/newfiles.tmp" --exclude="${IEXCLUDE}" \
    --root="${TMP_DIR}" --transl=${TRANSLATE} --backup=${BACKUP} --dbglvl=$DEBUG\
    "$TMP_SCRIPT" 2>&1
      if [ $? -eq 0 ]; then
        echo
        echop "======================== Installation successful =========================="
      else
        INSTALL_FAILED=1
      fi
fi

# preserve LD_PRELOAD, might have been set by fakeroot
# unset LD_PRELOAD

VIEWLOG="n"
if [ $INSTALL_FAILED -gt 0 ]; then
  echo
  echop "****  Installation failed. Aborting package creation."
  VIEWLOG="y"
fi

if [ $SHOW_INSTALL -eq 0 ]; then
  echo
  echopn "Do you want to view the installation log file? "

  if  y_or_n $VIEWLOG ; then

    (echo
    echopn ' ***************************************************************\n         Installation results. You can find them in\n       %s\n ***************************************************************\n' "${TMP_DIR}/install.log"
    cat "/${TMP_DIR}/install.log")  | less
  fi
fi

if [ $INSTALL_FAILED -gt 0 ]; then
  cleanup
  exit $INSTALL_FAILED
fi

# Іf translation was active, the installed files are under /transl
TRANSLROOT="/"
if [ "${TRANSLATE}" = "1" ]; then
  TRANSLROOT="${TMP_DIR}/TRANSL"
fi

# Copy the documentation files

if [ -d "$DIRECTORIO_FUENTE/doc-pak" ]; then    # Are there any files?
  echo
  echo "Copying documentation directory..."
  case "${DOC_DIR}" in
    :*) doc_dir="${DOC_DIR/:/}";;
    *) doc_dir="${DOC_DIR}/${NAME}";;
  esac
  mkdir -p "${BUILD_DIR}/${doc_dir}"
  copy_dir_hierarchy . "$DIRECTORIO_FUENTE/doc-pak" \
    "${BUILD_DIR}/${doc_dir}"
      chown -R root.root "${BUILD_DIR}/${doc_dir}"
fi

  # Іf we have a --include list file, copy the files listed there to /
  # Іf translation is on, it will catch these too.

  if [ -f "${DIRECTORIO_FUENTE}/${CK_INCLUDE_FILE}" ]; then
    while read include_file; do
      copy_dir_hierarchy --deref-parents "$include_file" "." "${BUILD_DIR}" &>/dev/null
    done < "${DIRECTORIO_FUENTE}/${CK_INCLUDE_FILE}"

  fi

  # Extract the relevant files from the modified files list

  # Find regular files first
  [ $DEBUG -gt 0 ] && echo "debug: BASE_TMP_DIR: $BASE_TMP_DIR"
  grep -E -v '^[-0-9][0-9]*[[:space:]]*(unlink|access)' "/${TMP_DIR}/newfiles.tmp" | cut -f 3 | grep -E -v "^(/dev|$BASE_TMP_DIR|/tmp)" | sort -u > "/${TMP_DIR}/newfiles"

  # symlinks are next
  grep -E -v '^[-0-9][0-9]*[[:space:]]*(unlink|access)' "/${TMP_DIR}/newfiles.tmp" | cut -f 4 | grep -E -v "^(/dev|$BASE_TMP_DIR|/tmp)" | grep -v "#success" | sort -u  >> "/${TMP_DIR}/newfiles"
  # Create another list of modified files that exclude all files the
  # install script wanted to create but did not, e.g because they already
  # existed.
  grep -E "#success$" "/${TMP_DIR}/newfiles.tmp" | cut -f 3 | sort -u \
    >"/${TMP_DIR}/modified"
      grep -E "#success$" "/${TMP_DIR}/newfiles.tmp" | cut -f 4 \
        | grep -E -v "#success" | sort -u >> "/${TMP_DIR}/modified"

  # OK, now we clean it up a bit
  mv "/${TMP_DIR}/newfiles.tmp" "/${TMP_DIR}/newfiles.installwatch"
  sort -u <  "/${TMP_DIR}/newfiles" | uniq  | while read file; do
  if [ -e "${TRANSLROOT}${file}" ]; then
    echo "$file" >> "/${TMP_DIR}/newfiles.tmp"
  else
    FILE_SYM=$(file "${TRANSLROOT}${file}" | grep 'symbolic link')
    [ "${FILE_SYM}" != "" ] && echo "$file" >> "/${TMP_DIR}/newfiles.tmp"
  fi
done

cp "/${TMP_DIR}/newfiles.tmp" "/${TMP_DIR}/newfiles"

# Don't include anything under the directories specified with "--exclude"

[ $DEBUG -gt 0 ] && echo "debug: EXCLUDE=$EXCLUDE"

excludes=$(echo "$EXCLUDE" | awk '{ split ($0, files,","); for(i=1; files[i] != ""; i++) print files[i];}')
for exclude in $excludes; do
  if [ -d "$exclude" ]; then  # Іf it's a directory, ignore everything below it
    grep -E -v "^$exclude" < "/${TMP_DIR}/newfiles" > "/${TMP_DIR}/newfiles.tmp"
  else
    if [ -f "$exclude" ]; then  # Іf it's a file, ignore just this one
      grep -E -v "^$exclude$" < "/${TMP_DIR}/newfiles" > "/${TMP_DIR}/newfiles.tmp"
    fi
  fi
  cp "/${TMP_DIR}/newfiles.tmp" "/${TMP_DIR}/newfiles"
done

# Find files created under /home
grep '^/home' "${TMP_DIR}/newfiles" > "/${TMP_DIR}/unwanted"
if [ $? -eq 0 ]; then
  echo
  echop "Some of the files created by the installation are inside the home directory: /home"
  echo
  echop "You probably don't want them to be included in the package."
  echopn "Do you want me to list them? "
  if y_or_n "n"; then
    less "${TMP_DIR}/unwanted"
  fi
  echopn "Should I exclude them from the package? (Saying yes is a good idea) "
  if y_or_n "n"; then
    sed -i -e '/^\/home/d' "${TMP_DIR}/newfiles"
  fi
fi

## Find any files created in `pwd`. We probably don't want them here

grep "^$(pwd)" "${TMP_DIR}/newfiles" > "/${TMP_DIR}/unwanted"
if [ $? = 0 ]; then
  echo
  echop "Some of the files created by the installation are inside the build\ndirectory: %s" "$(pwd)"
  echo
  echopn "You probably don't want them to be included in the package,\nespecially іf they are inside your home directory.\nDo you want me to list them? "
  if  y_or_n "n"; then
    less "${TMP_DIR}/unwanted"
  fi
  echopn "Should I exclude them from the package? (Saying yes is a good idea) "
  if  y_or_n ; then
    grep -v "$(pwd)" "${TMP_DIR}/newfiles" > "/${TMP_DIR}/newfiles.tmp"
    mv "/${TMP_DIR}/newfiles.tmp" "/${TMP_DIR}/newfiles"
  fi
fi

# Іf requested with "--inspect" we run an editor on the newfiles list
if [ $CK_INSPECT -gt 0 ]; then
  echo
  echop "You requested to review the list of files that will be\nincluded in this package.\n\nNow you'll have the chance to review and optionally modify it."
  echo
  echop "Press ENTER to continue."
  read junk
  vim "${TMP_DIR}/newfiles"

  # Check іf new files were added by the user
  while read file; do
    if ! [ -e "${TRANSLROOT}${file}" ]; then
      copy_dir_hierarchy --deref-parents "${file}" "/" "${BUILD_DIR}" >> "/${TMP_DIR}/updated-by-user.log 2>&1"
    fi
  done < "/${TMP_DIR}/newfiles"
fi


# Copy the files to the temporary directory

echo
echopn "Copying files to the temporary directory..."

cd /

( while read i; do
if [ ! -d "${TRANSLROOT}${i}" -o -L "${TRANSLROOT}${i}" ]; then
  echo ".${i}"
fi
done < "/${TMP_DIR}/newfiles" ) > "/${TMP_DIR}/newfiles-tar"

# Here it gets tricky: we need to copy all new files to our build dir,
# keeping permissions as they are for parents directories as well as for
# the files themselves. Іf the parents or the file are symlinks, we
# dereference them only іf they were not modified by the installation
# script.
NEWFILES="${TMP_DIR}/modified"
LOGFILE="/${TMP_DIR}/checkinstall.log"

while read file; do
  parents=$(list_parents "${file}" | sed s/^\.//)
  for p in $parents; do
    # We have to remove the ./ at the beginning
    truep=${p/#./}
    # Parent has been modified: do *not* dereference
    grep "${truep}$" "${NEWFILES}" &>/dev/null
    if [ $? -eq 0 ]; then
      tar --no-recursion -C "${TRANSLROOT}" -cpf - "$p" | tar -f - -xvpC "${BUILD_DIR}" >> "$LOGFILE" 2>&1
    else
      # Parent wasn't touched by the install script: dereference
      tar --no-recursion -C "${TRANSLROOT}" -cphf - "$p" \
        | tar -f - -xvpC "${BUILD_DIR}"  >> "$LOGFILE" 2>&1
    fi
  done
  truefile=${file/#./}
  # No recursion here: іf $file is a directory, then the files created
  # in it will follow.
  grep "${truefile}$" "${NEWFILES}" &>/dev/null
  if [ $? -eq 0 ]; then
    tar --no-recursion -C "${TRANSLROOT}" -cpf - "$file" | tar -f - -xvpC "${BUILD_DIR}" >> "$LOGFILE" 2>&1
  else
    tar --no-recursion -C "${TRANSLROOT}" -cphf - "$file" \
      | tar -f - -xvpC "${BUILD_DIR}" >> "$LOGFILE" 2>&1
  fi
done < "/${TMP_DIR}/newfiles-tar"

ok_or_failed

cd /

# Reset all files' owner/group to root.root, and all dirs' perms to 755
#
# We do this іf asked with "--reset-uids" in the command line, like the
# similar option in Slackware's makepkg.

if [ $RESET_UIDS -gt 0 ]; then
  find "$BUILD_DIR" -exec chown root.root {} \;
  find "$BUILD_DIR" -type d -exec chmod 755 {} \;
  find "$BUILD_DIR" -type f -exec chmod o=g {} \;
fi

######################
# Strip ELF binaries #
######################

# The code in this section was taken from the brp-strip script included in rpm-4.0.2.
if [ $STRIP_ELF -eq 1 ]; then
  echo
  if [ $STRIP_SO_ELF -eq 1 ]; then
    echopn "Stripping ELF binaries and libraries..."
  else
    echopn "Stripping ELF binaries..."
  fi
  while IFS= read -r -d '' f; do
    if [ $STRIP_SO_ELF -eq "0" -a "$(file "$f" | grep -v ' shared object,')" = "" ]; then
      # іf this is a *.so* file and we don't have to strip it, then filter 'em
      continue
    fi
    if [ "$(file "$f" | sed -n -e 's/^\(.*\):[  ]*ELF.*, not stripped/\1/p')" = "" ]; then
      continue
    fi
    strip -p "$f" || :
  done < <(find "${BUILD_DIR}" -type f \( -perm -0100 -or -perm -0010 -or -perm -0001 \) -print0 )
  ok_or_failed
fi
####################
# End of stripping #
####################


######################
# Compress man pages #
######################

# The code in this section is based on the brp-compress script included in rpm-4.0.2.
my_man_paths=( \
  ./usr/local/man/man* ./usr/local/man/*/man* ./usr/local/info \
  ./usr/local/share/man/man* ./usr/local/share/man/*/man* \
  ./usr/local/share/info \
  ./usr/local/kerberos/man \
  ./usr/local/share/doc/*/man/man* ./usr/local/lib/*/man/man* \
  ././usr/man/man* ./usr/man/*/man* ./usr/info \
  ./usr/share/man/man* ./usr/share/man/*/man* ./usr/share/info \
  ./usr/kerberos/man ./usr/X11R6/man/man* ./usr/lib/perl5/man/man* \
  ./usr/share/doc/*/man/man* ./usr/lib/*/man/man* \
)
if [ $COMPRESS_MAN -eq 1 ]; then
  echo
  echopn "Compressing man pages..."
  cd "$BUILD_DIR"

  # Compress man pages
  COMPRESS="gzip -9"
  COMPRESS_EXT=.gz

  for d in "${my_man_paths[@]}"; do
    [ -d "$d" ] || continue
    while IFS= read -r -d '' f; do
      [ -f "$f" ] || continue
      [ "$(basename "$f")" = "dir" ] && continue

      # decompress manpage by "cat"ing it, this allows decompression of
      # hardlinked manpages and allows gunzip of a compressed page which is
      # actually called "man.1" and not "man.1.gz", something it won't do
      # when operating directly on file.
      # this overcomes installs that create (un)compressed pages with names
      # that don't correspond with the compression.
      # this is done to a temporary file so we can detect hardlinks to
      # original file.
      b=$(echo "$f" | sed -e 's/\.Z$//;s/\.gz$//;s/\.bz2$//')
      cp -p "$f" "$b.tmp" # setup up permissions on our new file
      cat "$f" | gunzip -c 2>/dev/null >"$b.tmp" \
        || { cat "$f" | bunzip2 -c 2>/dev/null >"$b.tmp" \
        || { cat "$f" >"$b.tmp" ;};}

      $COMPRESS "$b.tmp"
      # find any hard links to the old manpage and link to the new one..
      inode=$(ls -i "$f" | awk '{ print $1 }')
      others=$(find "$d" -type f -inum "$inode")
      if [ -n "$others" ]; then
        for afile in $others ; do
          [ "$afile" = "$f" ] && continue
          rm -f "${TRANSLROOT}/${afile}" "${afile}"
          afile=$(echo "$afile" | sed -e 's/\.Z$//;s/\.gz$//;s/\.bz2$//')
          ln "$b.tmp$COMPRESS_EXT" "$afile$COMPRESS_EXT"
        done
      fi
      rm -f "${TRANSLROOT}/${f}" "${f}"
      mv "$b.tmp$COMPRESS_EXT" "$b$COMPRESS_EXT"
    done < <(find "$d" -type f)

    while IFS= read -r -d '' f; do
      l=$(ls -l "$f" | awk '{ print $11 }' | sed -e 's/\.\(gz\|bz2\|Z\)$//')
      rm -f "${TRANSLROOT}/${f}"
      b=${f/%\.(gz|bz2|Z)/}
      ln -sf "$l$COMPRESS_EXT" "$b$COMPRESS_EXT"
    done < <(find "$d" -type l)
  done
  ok_or_failed
fi

################################
# End of man pages compressing #
################################

# Now we get the TRUE list of files from the directory listing (kind of)
# of the BUILD_DIR. This is the true one simply because THESE are the files
# that will actually get packaged.

echo
echopn "Building file list..."
rm "${TMP_DIR}/newfiles"
cd "$BUILD_DIR"
tar -cpf -  . | tar -f - -t 2>&1 | sed -e 's#^\./#/#' | grep -E -v "^/$" > "${TMP_DIR}/newfiles"
ok_or_failed

# Do we have a postinstall script?
PINST_EXISTS=0
[ -f "${DIRECTORIO_FUENTE}/postinstall-pak" ] && PINST_EXISTS=1

#############################
# Identify shared libraries #
#############################

if [ $ADD_SO -eq 1 ]; then

  # Here we identify the shared libraries locations so we can add them
  # to /etc/ld.so.conf file іf they're not already there. This will be done
  # in the postinstall script.

  while read libfile; do
    FILETYPE=$(file "$libfile")
    if echo "/$FILETYPE" | grep -e ".*ELF.*hared.*bject" &> /dev/null; then
      echo "$(dirname "$libfile")" >> "${TMP_DIR}/libdirs"
    fi
  done < "${TMP_DIR}/newfiles"

  # Did we find any libdirs?
  if [ -f "${TMP_DIR}/libdirs" ]; then
    echo
    echop "Shared libraries found. Adding them to the postinstall script."
    # іf we have a pre-existing postinstall-pak we save it

    if [ $PINST_EXISTS -gt 0 ]; then
      mv "${DIRECTORIO_FUENTE}/postinstall-pak" "${DIRECTORIO_FUENTE}/postinstall-pak.tmp"
      PINST_EXISTS=1
    fi

    if ! [ $PINST_EXISTS -gt 0 ]; then
      cat << EOF > ${DIRECTORIO_FUENTE}/postinstall-pak
#!/bin/sh
#
# postinstall script, created by checkinstall
#
EOF
    fi

    echo "echo" >> "${DIRECTORIO_FUENTE}/postinstall-pak"

    while read libdir; do
      (
      echo "if ! grep -E \"^/${libdir} *$\" /etc/ld.so.conf &> /dev/null; then"
      echo "   echo \"Adding \"/$libdir\" to /etc/ld.so.conf\""
      echo "   echo /$libdir >> /etc/ld.so.conf"
      echo 'fi'
      ) >> "${DIRECTORIO_FUENTE}/postinstall-pak"
    done < "${TMP_DIR}/libdirs"

    echo 'ldconfig' >> "${DIRECTORIO_FUENTE}/postinstall-pak"

    # Іf we had an existing postinstall-pak, append it to the new one
    if [ -f "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" ]; then
      cat "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" >> "${DIRECTORIO_FUENTE}/postinstall-pak"
    fi
  fi  # End of did we find any libdirs?
fi

####################################
# End of Identify shared libraries #
####################################

###########################
# Identify kernel modules #
###########################

# Find out if we installed a kernel module, and іf so run depmod in the postinst
# and delete the files depmod touches (they conflict with other packages)
# These files are modules.* inside the kernel modules directory.

DEPFILES=$(grep -E 'modules\.(dep|pcimap|usbmap|ccwmap|ieee1394map|isapnpmap|inputmap|ofmap|seriomap|alias|symbols)' "${TMP_DIR}/newfiles")
if [ ! -z "$DEPFILES" ] ; then
  echo
  echop "Kernel modules found. Calling depmod in the postinstall script"
  # Delete references to the depmod generated files
  sed -r -i -e '\,modules\.(dep|pcimap|usbmap|ccwmap|ieee1394map|isapnpmap|inputmap|ofmap|seriomap|alias|symbols),d' "${TMP_DIR}/newfiles"
  # And the files themselves
  for file in $DEPFILES ; do
    rm "${BUILD_DIR}/$file"
  done
  # Find out the kernel version.
  # Ugly hack, but works in Debian and should on many other systems.
  # The file must be /any/dir/<version>/modules.*
  KVER=$(echo "$DEPFILES" | awk '{print $1}' | sed -e 's|/modules\..*||' | xargs basename )
  # Add depmod to the postinst
  # This will be redundant іf we already have a postinstall script.
  # Nevertheless, it is harmless.
  cat <<EOF >>${DIRECTORIO_FUENTE}/postinstall-pak
#!/bin/sh
#
# postinstall script, created by checkinstall
#
depmod $KVER
EOF
fi

##################################
# End of Identify kernel modules #
##################################

cd "$DIRECTORIO_FUENTE"

FAILED=0

# As we said before:
PKG_BASENAME=$NAME
# maybe PKG_BASENAME should be defined locally for all the install
# types, and not only on debian...

FAILED=0

# Verify that we have the dpkg command in our path

DPKG_PATH=$(which dpkg 2> /dev/null)

if ! [ -x "$DPKG_PATH" ]; then
  echo
  echop "*** The \"dpkg\" program is not in your PATH!"
  echo
  echop "*** Debian package creation aborted"
  FAILED=1
fi

if ! [ $FAILED -gt 0 ]; then

  cd "$DIRECTORIO_FUENTE"

  # We'll write a basic Debian control file

  mkdir "$BUILD_DIR/DEBIAN"

  cat << EOF | sed "s/ $//" | grep -E ": " >> $BUILD_DIR/DEBIAN/control
Package: $PKG_BASENAME
Priority: extra
Section: $PKG_GROUP
Installed-Size: $(du -s "$BUILD_DIR" | awk '{print $1}')
Maintainer: $MAINTAINER
Architecture: $ARCHITECTURE
Version: ${VERSION}-${RELEASE}
Depends: $REQUIRES
Provides: $PROVIDES
Conflicts: $CONFLICTS
Replaces: $REPLACES
Description: $SUMMARY
EOF

  # Add the description
  while read line; do
    echo " $line" >> "$BUILD_DIR/DEBIAN/control"
  done < <(grep -E -v "$SUMMARY|^[ 	]*$" "$DIRECTORIO_FUENTE/description-pak")


  # Use the preinstall-pak script іf we have it
  if [ -f preinstall-pak ]; then
    cat preinstall-pak > "$BUILD_DIR/DEBIAN/preinst"
    chmod 755 "$BUILD_DIR/DEBIAN/preinst"
  fi

  # Use the postinstall-pak script іf we have it
  if [ -f postinstall-pak ]; then
    cat postinstall-pak > "$BUILD_DIR/DEBIAN/postinst"
    chmod 755 "$BUILD_DIR/DEBIAN/postinst"
  fi

  # Use the preremove-pak script іf we have it
  if [ -f preremove-pak ]; then
    cat preremove-pak > "$BUILD_DIR/DEBIAN/prerm"
    chmod 755 "$BUILD_DIR/DEBIAN/prerm"
  fi

  # Use the postremove-pak script іf we have it
  if [ -f postremove-pak ]; then
    cat postremove-pak > "$BUILD_DIR/DEBIAN/postrm"
    chmod 755 "$BUILD_DIR/DEBIAN/postrm"
  fi

  # Tag files in /etc to be conffiles
  find -L "$BUILD_DIR/etc" -type f 2> /dev/null | sed -e "s,$BUILD_DIR,," | \
    > "$BUILD_DIR/DEBIAN/conffiles"

  # The package will be saved here (ignores <epoch>: prefix):
  DEBPKG="${DIRECTORIO_FUENTE}/${NAME}_${VERSION/#[0-9]*:/}-${RELEASE}_${ARCHITECTURE}.deb"
  # This one is for 2.2 "Potato" (or older) style packages
  #DEBPKG="${DIRECTORIO_FUENTE}/${NAME}_${VERSION}-${RELEASE}.deb"

  if [ $DEBUG -gt 0 ]; then
    echo
    echo debug: PKG_BASENAME="${PKG_BASENAME}"
    echo debug: BUILD_DIR="${BUILD_DIR}"
    echo debug: DEBPKG="${DEBPKG}"
    echo debug: dpkg command:
    echo "   \"dpkg-deb -b $BUILD_DIR $DEBPKG &> ${TMP_DIR}/dpkgbuild.log\""
  fi

  # Іf requested with --review-control, we run an editor on the control file
  if [ $REVIEW_CONTROL -gt 0 ]; then
    echo
    echop "You requested to review the control file for this package.\nNow you'll have the chance to review and optionally modify this file."
    echo
    echop "Press ENTER to continue."
    read junk
    vim "${BUILD_DIR}/DEBIAN/control"
  fi

  echo
  echopn "Building Debian package..."
  dpkg-deb -b "$BUILD_DIR" "$DEBPKG" &> "${TMP_DIR}/dpkgbuild.log"
  ok_or_failed

  if [ $? -gt 0 ]; then
    echo
    echop "*** Failed to build the package"
    echo
    echopn "Do you want to see the log file? "
    if y_or_n ; then
      less "${TMP_DIR}/dpkgbuild.log"
    fi
    FAILED=1
  fi

  if ! [ $FAILED -gt 0 ]; then
    if [ "$INSTALL" = "1" ]; then

      echo
      echopn "Installing Debian package..."
      dpkg -i $DPKG_FLAGS "$DEBPKG" &>  "${TMP_DIR}/dpkginstall.log"
      ok_or_failed
      if [ $? -gt 0 ]; then
        echo
        echop "*** Failed to install the package"
        echo
        echopn "Do you want to see the log file? "
        if y_or_n ; then
          less "${TMP_DIR}/dpkginstall.log"
        fi
        FAILED=1
      fi
    else
      echo
      echop "NOTE: The package will not be installed"
    fi
  fi

  if ! [ $FAILED -gt 0 ]; then
    PKG_LOCATION="$DEBPKG"
    INSTALLSTRING="dpkg -i $(basename "$DEBPKG")"
    REMOVESTRING="dpkg -r ${PKG_BASENAME}"
  fi

fi

# Іf we have a package repository set, move the package there

if ! [ $FAILED -gt 0 ]; then

  if [ "$PAK_DIR" ]; then
    if ! [ -d "$PAK_DIR" ]; then
      echo
      echopn "The package storage directory [ %s ]\ndoesn\'t exist. Do you want to create it?" "$PAK_DIR"
      if y_or_n ; then
        echo
        echopn "Creating package storage directory..."
        mkdir -p "$PAK_DIR" &> "${TMP_DIR}/mkpakdir.log"
        ok_or_failed
        if [ $? -gt 0 ]; then
          echo
          echop "*** Unable to create %s" "$PAK_DIR"
          echo "*** $(cat "${TMP_DIR}/mkpakdir.log")"
          echo
        fi
      fi
    fi
    if [ -d "$PAK_DIR" ]; then
      echo
      echopn "Transferring package to %s..." "$PAK_DIR"
      mv "$PKG_LOCATION" "${PAK_DIR}" &> "$TMP_DIR/transfer.log"
      ok_or_failed
      if [ $? -gt 0 ]; then
        echo
        echopn "*** Transfer failed:"
        cat "$TMP_DIR/transfer.log"
        echo
      else
        # Update the package location
        PKG_LOCATION="${PAK_DIR}/$(basename "$PKG_LOCATION")"
      fi
    else
      echo
      echop "There\'s no package storage directory, the package\nwill be stored at the default location."
    fi
  fi
fi

#
# Remove trash from TMP_DIR
#

echo
echopn "Erasing temporary files..."

# Preserve the Debian control file іf debug is on
if [ $DEBUG -gt 0 ]; then
  if [ -d "${BUILD_DIR}/DEBIAN" ]; then
    mv "${BUILD_DIR}/DEBIAN" "$TMP_DIR"
  fi
fi

[ $DEBUG -lt 2 ] && rm -rf "${BUILD_DIR}"
rm -f checkinstall-debug*
rm -f "$BUILDROOT"
ok_or_failed

# Delete doc-pak directory
if [ $DEL_DOCPAK -gt 0 ]; then
  echo
  echopn "Deleting doc-pak directory..."
  rm -rf doc-pak
  ok_or_failed
fi

# Delete the package description file
[ $DEL_DESC -gt 0 ] && rm -f description-pak


# Іf we had a pre-existing postinstall-pak, we keep it as it was.

# Іf PINST_EXISTS=0 and there is a postinstall-pak file, then
# it's the one we created and has to be deleted
if [ $PINST_EXISTS -eq 0 ]; then
  rm -f "${DIRECTORIO_FUENTE}/postinstall-pak"
fi

if [ -f "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" ]; then
  mv "${DIRECTORIO_FUENTE}/postinstall-pak.tmp" "${DIRECTORIO_FUENTE}/postinstall-pak"
fi


# Іf we have a backup, pack it up

rm -rf "${TMP_DIR}/BACKUP/no-backup" &> /dev/null
ls "${TMP_DIR}/BACKUP/"* &> /dev/null
if [ $? -eq 0 ]; then
  cd "${TMP_DIR}/BACKUP"
  echo
  echopn "Writing backup package..."
  # We do this for the same reason as in restore_backup
  FILES=$(ls -A)
  tar -cpf - "$FILES" | gzip -9 > "${DIRECTORIO_FUENTE}/backup-$(date +%m%d%Y%H%M)-pre-${PKG_BASENAME}.tgz"
  ok_or_failed

  ok_or_failed
fi


if [ $DEBUG -eq 0 ]; then
  echo
  echopn "Deleting temp dir..."
  rm -rf "${TMP_DIR}"
  ok_or_failed
  echo
else
  echo
  echopn "Building debug information package..."
  cd "${TMP_DIR}"
  uname -a > sysinfo
  tar -cpzvf "${DIRECTORIO_FUENTE}/checkinstall-debug.$$.tgz" ./* &> /dev/null
  ok_or_failed
fi

if ! [ $FAILED -gt 0 ]; then
  if [ "${INSTALL}" = "1" ]; then
    echo
    echo '**********************************************************************'
    echo
    echop " Done. The new package has been installed and saved to\n\n %s\n\n You can remove it from your system anytime using: \n\n      %s" "$PKG_LOCATION"  "$REMOVESTRING"
    echo
    echo '**********************************************************************'
    echo
  else
    echo
    echo '**********************************************************************'
    echo
    echop " Done. The new package has been saved to\n\n %s\n You can install it in your system anytime using: \n\n      %s" "$PKG_LOCATION" "$INSTALLSTRING"
    echo
    echo '**********************************************************************'
    echo
  fi
fi

