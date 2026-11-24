# --- ENV ---
export EDITOR="vim"
export PATH="$HOME/.local/bin:$PATH"

export VIM_ENABLE_PLUGINS=1
export NOTES_DIR="$HOME/.notes"

# History Settings
export HISTFILE=~/.history
export HISTSIZE=100000
export SAVEHIST=100000

# --- ZSH ---
setopt inc_append_history
setopt share_history
setopt histignorealldups
setopt prompt_subst
unsetopt BEEP

# Navigation & Logic
setopt autocd
setopt autopushd
setopt pushd_ignore_dups
setopt CORRECT
setopt EXTENDED_GLOB

# --- COMPLETION ---
autoload -Uz compinit && compinit
_comp_options+=(globdots)

# Load bash compatibility
autoload -Uz bashcompinit && bashcompinit

# Visual Menu & Colors
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Case-insensitive completion & matching middle of words
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group results by type with nice headers
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Bash-style word navigation
autoload -Uz select-word-style && select-word-style bash

# --- KEYBINDS ---
# Search history for what you've already typed using Up/Down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# make sure ctrl+r works in tmux
bindkey '^R' history-incremental-search-backward

# Standard Navigation (User Custom)
# bindkey "^[[1;3C" forward-word      # Option + Right
# bindkey "^[[1;3D" backward-word     # Option + Left
bindkey "^[b"     backward-word     # Alt/Opt + B (Alt-style)
bindkey "^[f"     forward-word      # Alt/Opt + F (Alt-style)

# Home/End Fixes
bindkey "^A"   beginning-of-line
bindkey "^E"   end-of-line
bindkey "^[[3~"  delete-char

# Word Deletion (Option + Delete / Option + Backspace)
# This handles the two most common sequences macOS sends for Opt+Delete
bindkey '^[^?' backward-kill-word 
bindkey '^[d' forward-kill-word

# Standard Delete key (The fn + delete combo)
bindkey "^[[3~" delete-char

# --- ALIASES & FUNCTIONS ---
# Core
alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias l='ls'
alias ll='ls -l'
alias la='ls -lA'
alias mv='mv -i'
alias ff='find . | grep -E'
alias d='dirs -v'

# Scripts
alias notes="$HOME/.scripts/notes.sh"
alias present="python3 $HOME/.scripts/mdslides.py"
alias journal="$HOME/.scripts/journal"

# Git Logic
alias gs='git status'
alias ga='git add'
alias gps='git push'
alias gpl='git pull'
alias gco='git commit'
alias gch='git checkout'
alias gcl='git clone'
alias gb='git branch'
alias gd='git diff'
#gch() { git checkout "$@" && git pull --rebase; }

# clawd
alias clauded='claude --dangerously-skip-permissions'

# wireguard VPN
alias wgup='sudo wg-quick up'
alias wgdown='sudo wg-quick down'

# --- VISUAL ---
# Use built-in vcs_info for faster Git branch detection
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b) '

# Runs before every prompt display
precmd() {
    vcs_info
    print -Pn "\e]2;%-3~\a" # Window title logic
}

# The Visual Prompt
if [[ -n "$SSH_CONNECTION" ]]; then
    PROMPT='%F{yellow}%n@%m%f %F{blue}%B%~%f %b%F{white}${vcs_info_msg_0_}%f
%F{green}:%f%b '
else
    PROMPT='%F{blue}%B%~%f %b%F{white}${vcs_info_msg_0_}%f
%F{green}:%f%b '
fi

fastfetch

# install-font [-y|--yes] <dir> — install all fonts in <dir> (user-local, or system-wide as root)
install-font() {
  emulate -L zsh
  setopt extended_glob null_glob
  local yes=0 src
  while (( $# )); do
    case $1 in
      -y|--yes) yes=1 ;;
      -h|--help) echo "usage: install-font [-y|--yes] <dir>"; return 0 ;;
      -*) echo "install-font: unknown option $1" >&2; return 1 ;;
      *) src=$1 ;;
    esac
    shift
  done
  [[ -d $src ]] || { echo "usage: install-font [-y|--yes] <dir>" >&2; return 1; }

  local dest
  if (( EUID == 0 )); then dest=/usr/local/share/fonts
  else dest=${XDG_DATA_HOME:-$HOME/.local/share}/fonts; fi

  local -a fonts
  fonts=( $src/**/*.(#i)(ttf|otf|ttc|otc|woff|woff2|pcf|bdf)(.) )
  (( ${#fonts} )) || { echo "install-font: no fonts found in $src" >&2; return 1; }

  echo "Fonts to install (${#fonts}):"
  printf '  %s\n' ${fonts:t}
  echo "Destination: $dest"
  if (( ! yes )); then
    local reply
    read -q "reply?Install ${#fonts} font(s) to $dest? [y/N] " || { echo; echo "Aborted."; return 1; }
    echo
  fi

  mkdir -p $dest && cp -f -- $fonts $dest/ || return 1
  command -v fc-cache >/dev/null && fc-cache -f $dest >/dev/null
  echo "Installed ${#fonts} font(s) to $dest"
}
