# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/chiyeon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# screenshot macro
alias ss='grim -g "$(slurp)"'

fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
prompt pure

# set terminal
export TERMINAL=foot
export TERM=foot

# set emscripten
LANG=C
source "/home/chi/lib/emsdk/emsdk_env.sh"

# set grim directory for screenshots
GRIM_DEFAULT_DIR=/home/chi/Pictures/screenshots

# adj path
export PATH=$PATH:~/.local/bin

# custom aliases

# dd alias for burning to a disk

