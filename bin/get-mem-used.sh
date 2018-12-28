#!/bin/bash

used=$(free | grep Mem | awk '{print $3}')
total=$(free | grep Mem | awk '{print $2}')

percentage=$(bc <<< "100*${used}/${total}")

printf -- '%s' "${percentage}"
