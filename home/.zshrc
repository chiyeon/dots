# --- ENV --- (exported vars live in ~/.zshenv)
# History Settings
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000

# --- ZSH ---
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
# Up/Down search history for what you've already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for k in '^[[A' '^[OA'; do bindkey $k up-line-or-beginning-search; done
for k in '^[[B' '^[OB'; do bindkey $k down-line-or-beginning-search; done

# Make sure ctrl+r works in tmux
bindkey '^R' history-incremental-search-backward

# Word movement: Alt/Ctrl + Left/Right (plus Alt+B/F)
for k in '^[[1;3D' '^[[1;5D' '^[b'; do bindkey $k backward-word; done
for k in '^[[1;3C' '^[[1;5C' '^[f'; do bindkey $k forward-word; done

# Home/End/Delete (sequences vary by terminal, so bind the common ones)
for k in '^A' '^[[H' '^[OH' '^[[1~'; do bindkey $k beginning-of-line; done
for k in '^E' '^[[F' '^[OF' '^[[4~'; do bindkey $k end-of-line; done
bindkey '^[[3~' delete-char

# Word deletion: Alt+Backspace / Alt+D
bindkey '^[^?' backward-kill-word
bindkey '^[d'  forward-kill-word
unset k

# --- ALIASES & FUNCTIONS ---
# Core
# GNU ls has --color/-v; BSD ls (macOS) uses -G
if ls --color=auto -d . &>/dev/null; then
    alias ls='ls --color=auto -hv'
else
    alias ls='ls -Gh'
fi
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias l='ls'
alias ll='ls -l'
alias la='ls -lA'
alias mv='mv -i'
alias ff='find . | grep -E'
alias d='dirs -v'

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
autoload -Uz add-zsh-hook
_prompt_precmd() {
    vcs_info
    print -Pn "\e]2;%-3~\a" # Window title logic
}
add-zsh-hook precmd _prompt_precmd

# The Visual Prompt (user@host shown over ssh)
[[ -n $SSH_CONNECTION ]] && _prompt_host='%F{yellow}%n@%m%f ' || _prompt_host=''
PROMPT="$_prompt_host"'%F{blue}%B%~%b%f %F{white}${vcs_info_msg_0_}%f
%F{green}:%f '


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

# --- LOCAL ---
# machine-specific overrides, not tracked in dots
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# greeting only in top-level shells (not tmux panes or nested shells)
[[ -z $TMUX && $SHLVL -eq 1 ]] && (( $+commands[fastfetch] )) && fastfetch
