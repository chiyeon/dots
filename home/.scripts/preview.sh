#!/bin/bash
# quick look style preview: opens a floating window, run again to close it
# floating/sizing comes from ~/.config/sway/config.d/preview

# toggle: close an open preview and stop
swaymsg -q '[con_mark="^preview$"] kill' 2>/dev/null && exit 0

file="$1"
if [ -z "$file" ]; then
    echo "Usage: preview <file>"
    exit 1
fi
if [ ! -e "$file" ]; then
    echo "preview: no such file: $file"
    exit 1
fi

# terminal window for text-ish previews; space quits less
term() {
    foot --app-id=preview sh -c "$1" preview "$file" &
}
LESS_SPACE_QUIT='--lesskey-content=\ quit'

mime="$(file --brief --mime-type -- "$file")"

case "$mime" in
    video/*|audio/*)
        mpv --wayland-app-id=preview --force-window=immediate --keep-open=yes \
            -- "$file" &>/dev/null &
        ;;
    image/*)
        imv -i preview -c 'bind <space> quit' -- "$file" &>/dev/null &
        ;;
    application/pdf)
        # zathura can't set its app id, so float it by pid once it maps
        zathura --config-dir="$HOME/.config/zathura-preview" -- "$file" &>/dev/null &
        pid=$!
        for _ in $(seq 50); do
            swaymsg -q "[pid=$pid] mark --add preview, floating enable, resize set 60 ppt 80 ppt, move position center" 2>/dev/null && break
            sleep 0.05
        done
        ;;
    inode/directory)
        term "ls -la --color=always -- \"\$1\" | less -R $LESS_SPACE_QUIT"
        ;;
    text/*|application/json|application/x-shellscript|application/javascript|application/xml|application/toml|application/x-yaml|inode/x-empty)
        term "bat --paging=always --pager=\"less -R $LESS_SPACE_QUIT\" -- \"\$1\""
        ;;
    *)
        term "{ file -- \"\$1\"; echo; ls -lh -- \"\$1\"; } | less $LESS_SPACE_QUIT"
        ;;
esac
