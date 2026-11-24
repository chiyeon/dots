# chiyeon/dots
a collection of... dots

`home/` holds common, system-agnostic scripts & configuration for \*NIX systems (macOS and any linux). it tries to stay up to date... it tries.

`hosts/<name>/home/` holds device specific configuration layered on top, e.g. `drpepper-t14s` (Thinkpad T14s Gen3, sway) and `twilight-t480s`. `hosts/<name>/extras/` has things that aren't dotfiles (fonts, wallpapers, system configs).

## Setup
Create symlinks of all `home/` dot files (backs up existing files)
```
./sync.sh
```

Add a host to also link its files; they override `home/` where both have the same file
```
./sync.sh drpepper-t14s
```

Alternatively `./sync.sh --help`

### Default apps
After syncing, set default apps (vim in a terminal for text, imv for images, vlc for audio/video):
```
mime-defaults
```
The terminal comes from `$TERMINAL` (defaults to foot, then kitty).

### Preview
macOS quick look style previews (mpv, imv, bat, zathura) in a floating sway window (sway rules live in the `drpepper-t14s` host). `preview <file>` toggles it (or switches to another file), as does space in thunar.
```
sudo pacman -S --needed mpv imv bat zathura zathura-pdf-mupdf
thunar-preview
```

### Local overrides
Machine-specific settings go in `~/.zshenv.local`, `~/.zshrc.local` and `~/.config/tmux/tmux.local.conf` (all untracked, sourced if present).

vim plugins are off by default. To turn them on for a machine:
```
echo 'export VIM_ENABLE_PLUGINS=1' >> ~/.zshenv.local
```

### Migrating from the old layout
vim and tmux configs now live under `~/.config`. `sync.sh` doesn't remove old links, so on existing machines delete `~/.vimrc`, `~/.tmux.conf` and `~/.vim/autoload/plug.vim` first; vim and tmux read those before the `~/.config` copies.
