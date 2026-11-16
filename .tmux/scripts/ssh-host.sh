#!/usr/bin/env bash
tty="${1#/dev/}"
max="${2:-16}"
[ -z "$tty" ] && exit 0

args=$(ps -t "$tty" -o args= 2>/dev/null | grep -E '^(/[^ ]*/)?ssh ' | head -n1)
[ -z "$args" ] && exit 0

host=$(echo "$args" | awk '{
  for (i = 2; i <= NF; i++) {
    if ($i ~ /^-[BbcDEeFIiJLlmOopQRSWw]$/) { i++; continue }
    if ($i ~ /^-/) continue
    print $i; exit
  }
}')

host="${host#ssh://}"
host="${host#*@}"

if [ "${#host}" -gt "$max" ]; then
  case "$host" in
  *[!0-9.]*)
    two=$(echo "$host" | cut -d. -f1-2)
    if [ "${#two}" -le "$max" ]; then host="$two"; else host=$(echo "$host" | cut -d. -f1); fi
    ;;
  esac
  [ "${#host}" -gt "$max" ] && host="${host:0:$((max - 1))}"
fi
echo "$host"
