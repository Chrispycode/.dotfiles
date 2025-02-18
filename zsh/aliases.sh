alias subm='smerge'
alias open="xdg-open"
# alias s="kitty +kitten ssh"
alias s="ssh"
alias code="vscodium"
alias n="nvim . -c 'lua Snacks.dashboard.open()'"
alias lg="lazygit"
alias icat="kitty +kitten icat"
dca() { dcup -d $@ && docker attach $@ }
alias dev_start="sudo systemctl start ollama.service docker.service docker.socket"
alias dev_stop="sudo systemctl stop ollama.service docker.service docker.socket containerd.service"

