[[ $- != *i* ]] && return

set -o vi

# History settings
HISTSIZE=500
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace

[[ -f ~/.dotfiles/bash/completion.bash ]] && source ~/.dotfiles/bash/completion.bash
source ~/.dotfiles/sh/default.sh

bind -x '"\C-f":tmux-sessionizer'
bind -x '"\ef":fzfp'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
