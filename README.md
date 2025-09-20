# dots
a collection of my personal dot files &amp; general linux configuration for a Thinkpad T14s G3.

## Dependencies
May not be comprehensive
- ImageMagick (sixel image preview in foot with ranger)
- Iosevka & Iosevka Nerd Font (or any other nerd font)
- tlp
- wayland, waybar, wofi, wlogout

## Installation
1. Install dependencies
2. Put `home/.config/` in `$HOME/`
3. Put `Wallpapers` in `$HOME/Pictures/`

## Optional
### Turning Thinkpad extra buttons (F9-F11) to media keys
Following [this guide](https://nyllep.wordpress.com/2022/06/14/thinkpad-media-keys-on-linux/).

1. Copy `extras/t14s-keyboard.hwdb` to `/etc/udev/hwdb.d/t14s-keyboard.hwdb`
2. Run:
```
systemd-hwdb update
udevadm control --reload-rules
udevadm trigger
```
3. Check:

Run: `udevadm info /sys/class/input/event#`

> (The # is probably 6. You can check with sudo evtest, finding "Thinkpad Extra Buttons")

Check on the right `KEYBOARD_KEY_` values, probably `4b, 4c, 4d`. They should be `previoussong, playpause, nextsong`, which can be verified in `/usr/include/linux/input-event-codes.h`

### TLP settings
Copy `extras/tlp.conf` to `/etc/tlp.conf`
Be sure to enable/restart tlp
