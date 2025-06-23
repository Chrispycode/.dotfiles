alias subm='smerge'
alias open="xdg-open"
# alias s="kitty +kitten ssh"
alias s="ssh"
alias n="nvim"
alias lg="lazygit"
alias icat="kitty +kitten icat"
alias fzfp="fzf --preview='fzf-preview.sh {}'"
dua() {
  docker compose up -d "$@" && docker attach "$@"
}
dup() {
  docker compose up -d "$(basename "$PWD")"
}
dupf() {
  docker compose up -d --force-recreate "$(basename "$PWD")"
}
dupa() {
  docker compose up -d "$(basename "$PWD")" && docker attach "$(basename "$PWD")"
}
ds() {
	docker compose run --rm "$(basename "$PWD")"
}
alias dev_start="sudo systemctl start ollama.service" #" docker.service docker.socket"
alias dev_stop="sudo systemctl stop ollama.service" #" docker.service docker.socket containerd.service"
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"


if [ $(uname -s) = "Darwin" ]; then
	bat=batcat
else
	bat=bat
fi

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | $bat -p -lman'"
