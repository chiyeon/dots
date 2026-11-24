#!/bin/bash
# set default apps for common file types (re-run after installing apps)
set -e

set_default() {
    local app="$1"; shift
    for type in "$@"; do
        xdg-mime default "$app" "$type"
    done
}

set_default vim-term.desktop \
    text/plain text/markdown text/x-log application/x-shellscript \
    application/json application/x-yaml application/toml

set_default feh.desktop \
    image/png image/jpeg image/gif image/webp image/bmp image/tiff image/svg+xml

set_default vlc.desktop \
    audio/mpeg audio/mp4 audio/flac audio/ogg audio/x-wav audio/wav audio/opus audio/aac \
    video/mp4 video/x-matroska video/webm video/quicktime video/x-msvideo video/mpeg video/ogg

echo "mime defaults set"
