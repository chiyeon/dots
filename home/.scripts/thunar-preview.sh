#!/bin/bash
# add a "Preview" custom action to thunar, bound to space (runs preview.sh)
set -e

UCA="$HOME/.config/Thunar/uca.xml"
ACCELS="$HOME/.config/Thunar/accels.scm"
ID="preview-quicklook"

# thunar rewrites these files on exit, so stop it first
thunar -q 2>/dev/null || true

mkdir -p "$(dirname "$UCA")"
[ -f "$UCA" ] || printf '<?xml version="1.0" encoding="UTF-8"?>\n<actions>\n</actions>\n' > "$UCA"

if ! grep -q "<unique-id>$ID</unique-id>" "$UCA"; then
    action="<action>
	<icon>view-preview</icon>
	<name>Preview</name>
	<submenu></submenu>
	<unique-id>$ID</unique-id>
	<command>$HOME/.scripts/preview.sh %f</command>
	<description>Toggle a floating quick look preview</description>
	<range></range>
	<patterns>*</patterns>
	<directories/>
	<audio-files/>
	<image-files/>
	<other-files/>
	<text-files/>
	<video-files/>
</action>"
    tmp="$(mktemp)"
    awk -v a="$action" '/<\/actions>/ { print a } { print }' "$UCA" > "$tmp"
    mv "$tmp" "$UCA"
fi

touch "$ACCELS"
sed -i "/uca-action-$ID\"/d" "$ACCELS"
echo "(gtk_accel_path \"<Actions>/ThunarActions/uca-action-$ID\" \"space\")" >> "$ACCELS"

echo "thunar preview action set (space)"
