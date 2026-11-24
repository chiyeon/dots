#!/bin/sh
# open files in vim inside a terminal (used by vim-term.desktop)
exec "${TERMINAL:-kitty}" -e vim "$@"
