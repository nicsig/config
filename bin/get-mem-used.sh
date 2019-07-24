#!/bin/sh

free | awk '/Mem/ { total = $2; used = $3}; END { printf("%d", 100 * used / total) }'
