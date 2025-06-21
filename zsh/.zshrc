export VI_MODE_SET_CURSOR=true
export ZSH="$HOME/.oh-my-zsh"

plugins=(git cp vi-mode fzf fzf-tab tmux docker-compose ansible zsh-autosuggestions zsh-syntax-highlighting mise bundler node npm ruby rails rake redis-cli python pip rust golang)

source ~/.dotfiles/sh/default.sh
source $ZSH/oh-my-zsh.sh
source ~/.dotfiles/zsh/styles.zsh

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s "^[f" "fzfp\n"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

