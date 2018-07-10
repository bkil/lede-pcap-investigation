#!/bin/sh

PERIOD=60
while true; do
  CPU="`\
    top -d 1 -n $PERIOD |
    grep -E "^(CPU|Load)" |
    sed "N; s~\n~ ~" |
    tail -n 1`"
  printf "%s %s\n" "`date -Iminutes`" "$CPU"
done
