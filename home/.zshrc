# --- ENV ---
export EDITOR="vim"
export PATH="$HOME/.local/bin:$PATH"

export VIM_ENABLE_PLUGINS=1
export NOTES_DIR='$HOME/.notes'

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
zstyle ':completion:*' matcher-list 'm:{a-z criteria-Z}={A-Z criteria-a}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

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

# Standard Navigation (User Custom)
bindkey "^[[1;3C" forward-word      # Option + Right
bindkey "^[[1;3D" backward-word     # Option + Left
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
alias gc="git clone"
alias gbr='git branch -r'
gco() { git checkout "$@" && git pull --rebase; }

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
PROMPT='%F{blue}%B%~%f %b%F{white}${vcs_info_msg_0_}%f
%F{green}:%f%b '
