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

### Adjustments
The .vimrc is set up by default for Linux systems. Set `clipboard` to `unnamed` on macOS

A proper sync script would handle this for us
