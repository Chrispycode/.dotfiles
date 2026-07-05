alias subm='smerge'
alias s="ssh"
alias n="nvim"
alias lg="lazygit"
alias icat="kitty +kitten icat"
alias ta="tmux attach"
docker_compose() {
	if [ -n "$GLOBAL_DOCKER_COMPOSE_FILE" ]; then
		docker compose -f "$GLOBAL_DOCKER_COMPOSE_FILE" "$@"
	else
		docker compose "$@"
	fi
}
alias dco="docker_compose"
alias dcup="docker_compose up"
alias dcr="docker_compose run --rm"
alias dck="docker_compose kill"
dua() {
  docker_compose up -d "$@" && docker attach "$@"
}
dup() {
  docker_compose up -d "$(basename "$PWD")"
}
dupf() {
  docker_compose up -d --force-recreate "$(basename "$PWD")"
}
dupa() {
  docker_compose up -d "$(basename "$PWD")" && docker attach "$(basename "$PWD")"
}
ds() {
	docker_compose run --rm "$(basename "$PWD")"
}
dsb() {
	docker_compose run --rm "$(basename "$PWD")" bash
}
alias dev_start="sudo systemctl start ollama.service" #" docker.service docker.socket"
alias dev_stop="sudo systemctl stop ollama.service" #" docker.service docker.socket containerd.service"
alias fzfy="fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75%"
alias yayf="yay -Slq | fzfy | xargs -ro yay -S"
alias fzfp="fzf --preview='fzf-preview.sh {}'"
alias sys="TEMD_COLORS=1 systemctl"
alias syss="TEMD_COLORS=1 systemctl status"
alias sysd="TEMD_COLORS=1 systemctl disable"
alias syse="TEMD_COLORS=1 systemctl enable"

nva() { sessionizer nvim-attach "${1:-main}"; }
na() { sessionizer nvim-last; }
ns() { sessionizer nvim-new; }

if [ $(uname -s) = "Darwin" ]; then
	bat=bat
else
	# change xdg-open default before
	# xdg-mime default org.gnome.Nautilus.desktop inode/directory
	open() { 
		xdg-open "$@" >/dev/null 2>&1 & disown; 
	}
	# Debian/Ubuntu installs bat as batcat
	if command -v batcat &>/dev/null; then
		bat=batcat
	else
		bat=bat
	fi
fi

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | $bat -p -lman'"
