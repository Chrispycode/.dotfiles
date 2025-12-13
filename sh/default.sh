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
export STARSHIP_CONFIG=~/.dotfiles/starship.toml

[ -f ~/.dotfiles/sh/preload.sh ] && source ~/.dotfiles/sh/preload.sh

source ~/.dotfiles/sh/aliases.sh
[ -f ~/.dotfiles/sh/overrides.sh ] && source ~/.dotfiles/sh/overrides.sh

export GLOBAL_GEMFILE=${GLOBAL_GEMFILE:=~/Gemfile}

if [ -n "$ZSH_VERSION" ]; then
  shell_name="zsh"
elif [ -n "$BASH_VERSION" ]; then
  shell_name="bash"
else
  shell_name=$(basename $SHELL)
fi

eval "$($HOME/.local/bin/mise activate $shell_name)"
command -v fzf >/dev/null 2>&1 && source <(fzf --$shell_name)
command -v starship >/dev/null 2>&1 && eval "$(starship init $shell_name)"

if [ $(uname -s) = "Darwin" ]; then
    :
else
  export ELECTRON_OZONE_PLATFORM_HINT=auto
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1

	if [[ -n "$GNOME_DESKTOP_SESSION_ID" || "$XDG_CURRENT_DESKTOP" == "GNOME" ]] && [[ -z $DISPLAY && $XDG_SESSION_TYPE == tty ]]; then
    MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
  fi
fi
