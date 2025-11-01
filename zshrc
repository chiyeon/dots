# --- VISUAL ---

# Prompt
# for git branches when needed
function git_branch_name()
{
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="heads/"} {print $NF}')
    if [[ $branch == "" ]];
    then
        :
    else
        echo '('$branch') '
    fi
}

setopt prompt_subst

PS1='%F{blue}%B%~%f %b%F{white}$(git_branch_name)%f
%F{green}:%f%b '

# no visual beep
unsetopt BEEP

# --- HISTORY ---
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history
setopt share_history
setopt histignorealldups

# custom notes script setup
export PATH=$HOME/Projects/notes:$PATH

# --- KEYBINDS ---
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char


# auto complete

autoload -Uz select-word-style && select-word-style bash

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -U compinit && compinit
_comp_options+=(globdots) # hidden files

autoload -Uz bashcompinit && bashcompinit

# terminal window title
precmd () { print -Pn "\e]2;%-3~\a"; }

# --- ALIASES ---
alias keep_mac_awake='caffeinate -disu'

alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

alias l='ls'
alias ll='ls -l'
alias la='ls -lA'

alias mv='mv -i'

alias ff='find . | grep -E'

# checkout branch and pull rebase
alias gc='f() { git checkout "$@" && git pull --rebase; }; f'
alias gcb='f() { git checkout -b "eng/PR-$@"; }; f'
alias gbr='git branch -r'




# --- PATH ---
export PATH=$(brew --prefix)/bin:$PATH

# --- ENV ---
export EDITOR="vim"
