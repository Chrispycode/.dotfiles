# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
addToPathFront() { if [[ "$PATH" != *"$1"* ]]; then; export PATH=$1:$PATH; fi }
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.dotfiles/scripts

if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
  MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export GOPATH="$HOME/.go"
export EDITOR=nvim
export VISUAL=nvim
export RANGER_LOAD_DEFAULT_RC=false
export LLM="ollama"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git cp bundler node npm ruby rails rbenv rake redis-cli python pip fzf fzf-tab docker-compose ansible zsh-autosuggestions zsh-syntax-highlighting mise tmux)

if [ -f ~/.dotfiles/preload ]; then
  source ~/.dotfiles/preload
fi

source $ZSH/oh-my-zsh.sh
source ~/.dotfiles/zsh/styles.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.dotfiles/zsh/aliases.sh
if [ -f ~/.dotfiles/overrides ]; then
  source ~/.dotfiles/overrides
fi

export GLOBAL_GEMFILE=${GLOBAL_GEMFILE:=~/Gemfile}

eval "$($HOME/.local/bin/mise activate zsh)"

bindkey -s ^f "tmux-sessionizer\n"
