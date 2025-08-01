addToPathFront() { 
	if [[ "$PATH" != *"$1"* ]]; then 
		export PATH=$1:$PATH
	fi
}
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.dotfiles/scripts

export GOPATH="$HOME/.go"
export EDITOR=nvim
export VISUAL=nvim
export LLM="ollama"
export STARSHIP_CONFIG=~/.dotfiles/starship.toml

[ -f ~/.dotfiles/sh/preload.sh ] && source ~/.dotfiles/sh/preload.sh

source ~/.dotfiles/sh/aliases.sh
[ -f ~/.dotfiles/sh/overrides.sh ] && source ~/.dotfiles/sh/overrides.sh

export GLOBAL_GEMFILE=${GLOBAL_GEMFILE:=~/Gemfile}

if [ $(uname -s) = "Darwin" ]; then
  eval "$(/usr/local/bin/mise activate bash)"
else
  eval "$($HOME/.local/bin/mise activate bash)"

  export ELECTRON_OZONE_PLATFORM_HINT=auto
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1

	if [[ -n "$GNOME_DESKTOP_SESSION_ID" || "$XDG_CURRENT_DESKTOP" == "GNOME" ]] && [[ -z $DISPLAY && $XDG_SESSION_TYPE == tty ]]; then
    MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
  fi
fi
