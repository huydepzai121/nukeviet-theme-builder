#!/usr/bin/env bash
# Usage: ./verify.sh http://localhost:8090 "/" "/admin/" "/index.php?language=vi&nv=news"
B=$1; shift; fail=0
for u in "$@"; do c=$(curl -s -o /dev/null -w '%{http_code}' "$B$u"); echo "$c $u"; [ "$c" = 200 ] || fail=1; done
exit $fail
