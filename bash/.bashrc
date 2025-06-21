export GLOBAL_GEMFILE=${GLOBAL_GEMFILE:=~/Gemfile}
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

# History settings
HISTSIZE=500
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace

[[ -f ~/.dotfiles/bash/completion.bash ]] && source ~/.dotfiles/bash/completion.bash
source ~/.dotfiles/default_shell.sh

bind -x '"\C-f":tmux-sessionizer'

eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
