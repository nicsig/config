#!/bin/bash

ncore=$(lscpu | grep -i 'cpu(s)' | head -n1 | awk '{print $2}')

avg1=$(cut -d' ' -f1 /proc/loadavg)
avg1=$(bc <<< "100*${avg1}/${ncore}")
printf -- '%s' "${avg1}"
