#!/bin/bash

# Script to show the colours used for different file types

# This is just a more readable version of the 'eval' code at:
#     http://askubuntu.com/a/17300/309899

# A nice description of the colour codes is here:
#     http://askubuntu.com/a/466203/309899

IFS=:
# Don't quote `${LS_COLORS}`, it would prevent word splitting.
# We need word splitting for `SET` to iterate over the values of `LS_COLORS`.
for SET in ${LS_COLORS}; do
    # In the value of `SET`, remove everything after the equal sign.{{{
    # See:
    #     man bash
    #
    #     > Parameter Expansion
    #
    #     > ${parameter#word}
    #       ${parameter##word}
    #       ${parameter%word}
    #       ${parameter%%word}
    #}}}
    TYPE="${SET%%=*}"
    #          ├──┘{{{
    #          └ remove everything after the first equal sign
    #            (I'm not sure whether `SET` could contain an
    #            equal sign in its value, hence the double percent)
    #}}}
    # In the value of `SET`, remove everything before the equal sign.
    COLOUR="${SET#*=}"
    #            ├─┘
    #            └ remove everything before the first equal sign

    case ${TYPE} in
        no) TEXT="Global default";;
        "fi") TEXT="Normal file";;
        di) TEXT="Directory";;
        ln) TEXT="Symbolic link";;
        pi) TEXT="Named pipe";;
        so) TEXT="Socket";;
        "do") TEXT="Door";;
        bd) TEXT="Block device";;
        cd) TEXT="Character device";;
        or) TEXT="Orphaned symbolic link";;
        mi) TEXT="Missing file";;
        su) TEXT="Set UID";;
        sg) TEXT="Set GID";;
        tw) TEXT="Sticky other writable";;
        ow) TEXT="Other writable";;
        st) TEXT="Sticky";;
        ex) TEXT="Executable";;
        rs) TEXT="Reset to \"normal\" color";;
        mh) TEXT="Multi-Hardlink";;
        ca) TEXT="File with capability";;
        *) TEXT="${TYPE} (TODO: get description)";;
    esac

    printf -- "Type: %-10s Colour: %-10s \e[%sm%s\e[0m\n" "${TYPE}" "${COLOUR}" "${COLOUR}" "${TEXT}"
done

