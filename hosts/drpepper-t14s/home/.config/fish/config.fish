function fish_greeting
   fastfetch
end

set -gx VISUAL /bin/vim
set -gx EDITOR /bin/vim

alias py="python3" 
alias ll="ls -lh"
alias imgoingto="xdg-open https://www.youtube.com/watch?v=myjEoDypUD8"

set -Ux LD_LIBRARY_PATH /usr/lib

#if [ -z "$TMUX" ]; then
#   tmux attach-session -t trimnet || tmux new-session -s trimnet
#end
export PATH="$HOME/.local/bin:$PATH"
