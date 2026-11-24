# chiyeon/dots
a collection of... dots

The `main` branch contains common, system-agnostic scripts & configuration for \*NIX systems. it tries to stay up to date... it tries.

The other branches are device specific configurations, latest being `drpepper-t14s` for the Thinkpad T14s Gen3

## Setup
Create symlinks of all `home/` dot files (backs up existing files)
```
./sync.sh
```

Alternatively `./sync.sh --help`

### Local overrides
Machine-specific settings go in `~/.zshenv.local`, `~/.zshrc.local` and `~/.config/tmux/tmux.local.conf` (all untracked, sourced if present).

vim plugins are off by default. To turn them on for a machine:
```
echo 'export VIM_ENABLE_PLUGINS=1' >> ~/.zshenv.local
```

### Migrating from the old layout
vim and tmux configs now live under `~/.config`. `sync.sh` doesn't remove old links, so on existing machines delete `~/.vimrc`, `~/.tmux.conf` and `~/.vim/autoload/plug.vim` first; vim and tmux read those before the `~/.config` copies.
