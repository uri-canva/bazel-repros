#!/usr/bin/env sh

out=$1
shift
cat "$@" > "$out"
