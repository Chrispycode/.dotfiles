export ZSH="$HOME/.oh-my-zsh"
export VI_MODE_SET_CURSOR=true

plugins=(git cp vi-mode fzf fzf-tab tmux docker-compose ansible zsh-autosuggestions zsh-syntax-highlighting mise bundler node npm ruby rails rake redis-cli python pip rust golang)

source $ZSH/oh-my-zsh.sh
source ~/.dotfiles/zsh/styles.zsh
source ~/.dotfiles/default_shell.sh

bindkey -s ^f "tmux-sessionizer\n"

eval "$(starship init zsh)"
