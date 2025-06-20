alias subm='smerge'
alias open="xdg-open"
# alias s="kitty +kitten ssh"
alias s="ssh"
alias n="nvim"
alias lg="lazygit"
alias icat="kitty +kitten icat"
dua() {
    dcup -d "$@" && docker attach "$@"
}
dup() {
    dcup -d "$(basename "$PWD")"
}
dupf() {
    dcup -d --force-recreate "$(basename "$PWD")"
}
dupa() {
    dcup -d "$(basename "$PWD")" && docker attach "$(basename "$PWD")"
}
ds() {
    dcr --rm "$(basename "$PWD")"
}
alias dev_start="sudo systemctl start ollama.service" #" docker.service docker.socket"
alias dev_stop="sudo systemctl stop ollama.service" #" docker.service docker.socket containerd.service"


if [ $(uname -s) = "Darwin" ]; then
	bat=batcat
else
	bat=bat
fi

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | $bat -p -lman'"
