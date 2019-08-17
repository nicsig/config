#!/bin/bash

if [[ $# -eq 0 ]]; then
  cat <<EOF >&2
usage:
  $0 <pid>
EOF

  exit 64
fi

# https://unix.stackexchange.com/a/85365/289772
bitmask2signals() {
  i=0
  bits="$(printf 'ibase=16; obase=2; %X\n' "0x$1" | bc)"
  while [[ -n "${bits}" ]]; do
    i=$((i + 1))
    if [[ "${bits}" == *1 ]]; then
      printf ' %s(%s)' "$(kill -l "$i")" "$i"
    fi
    bits="${bits%?}"
  done
}

grep -E '^Sig(Blk|Ign|Cgt):' "/proc/$1/status" |
  while read -r a b; do
    printf '%s%s\n' "$a" "$(bitmask2signals "$b")"
  done

