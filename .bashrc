#
# ~/.bashrc
#

export GLOBAL_GEMFILE=${GLOBAL_GEMFILE:=~/Gemfile}
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

addToPathFront() { 
	if [[ "$PATH" != *"$1"* ]]; then 
		export PATH=$1:$PATH
	fi
}
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.dotfiles/scripts
set -o vi

export GOPATH="$HOME/.go"
export EDITOR=nvim
export VISUAL=nvim
export RANGER_LOAD_DEFAULT_RC=false

# Source custom bash completion configuration
[[ -f ~/.dotfiles/bash/completion.bash ]] && source ~/.dotfiles/bash/completion.bash
export LLM="ollama"

# History settings
HISTSIZE=500
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace

[ -f ~/.dotfiles/preload.sh ] && source ~/.dotfiles/preload.sh

source ~/.dotfiles/aliases.sh
[[ -f ~/.dotfiles/overrides.sh  ]] && source ~/.dotfiles/overrides.sh

# Starship specific settings
export STARSHIP_LOG="error"

eval "$(starship init bash)"

if [ $(uname -s) = "Darwin" ]; then
  eval "$(/usr/local/bin/mise activate bash)"
else
  eval "$($HOME/.local/bin/mise activate bash)"

  export ELECTRON_OZONE_PLATFORM_HINT=auto
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1

  if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
    MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
  fi
fi

bind -x '"\C-f":tmux-sessionizer'
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
