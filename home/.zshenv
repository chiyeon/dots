# Sourced by every zsh (interactive or not) — env vars only
export EDITOR="vim"
typeset -U path
path=("$HOME/.local/bin" $path)

export NOTES_DIR="$HOME/.notes"

# machine-specific env, not tracked in dots (e.g. export VIM_ENABLE_PLUGINS=1)
[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
