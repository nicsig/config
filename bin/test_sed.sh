#!/bin/bash

# Purpose: Test a sed script against a set of input files.{{{
#
# The script is run for each file, and  the output is saved in a temporary file,
# prefixed by `tmp.`.
#
# You can review them by running `$ vim tmp.*`.
# Then, remove them by running `$ rm tmp.*`.
#}}}
# Usage:
#     $ test_sed.sh script.sed file ...

SCRIPT="$1"
EXT="${SCRIPT##*.}"

if [[ $# -lt 2 ]]; then
  printf -- 'Usage:  %s <script> <file>...\n' "$(basename "$0")"
  exit 1
elif [[ "${EXT}" != 'sed' ]]; then
  printf -- 'The first argument must be a sed script!\n'
  exit 1
fi

# Ignore the sed script; we don't want it to edit itself.
shift 1
for	file in "$@"; do
  "${SCRIPT}" "${file}" >"tmp.${file}"
done

