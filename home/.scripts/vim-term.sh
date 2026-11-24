#!/bin/sh
# open files in vim inside a terminal (used by vim-term.desktop)
# $TERMINAL wins, then foot, then kitty
term="$TERMINAL"
if [ -z "$term" ]; then
    if command -v foot >/dev/null; then term=foot; else term=kitty; fi
fi
exec "$term" vim "$@"
