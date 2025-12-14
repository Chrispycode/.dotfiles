set -o vi
set -o correct

HISTFILE=~/.config/zsh/.histfile
HISTSIZE=500
SAVEHIST=10000
HISTTIMEFORMAT="%F %T"

export HISTCONTROL=erasedups:ignoredups:ignorespace
export ZSH_CACHE_DIR=~/.config/zsh
# Cache compinit for faster startup (invalidated when .zcompdump is older than any completion file)
autoload -U compinit
if [[ -f ~/.config/zsh/.zcompdump && ~/.config/zsh/.zcompdump -nt /usr/share/zsh ]]; then
  compinit -C
else
  compinit
fi
if [[ -f ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
	source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
fi
if [[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
	source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fi
if [[ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]]; then
	source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Lazy-load fzf-tab only when needed (it adds overhead to every completion)
ZSH_LAZY_LOAD_PLUGINS=(fzf-tab)

source ~/.dotfiles/sh/default.sh
source ~/.dotfiles/zsh/styles.zsh

# Change cursor shape for different vi modes
function zle-keymap-select {
    case $KEYMAP in
        vicmd)          echo -ne '\e[1 q';; # block cursor
        viins|main)     echo -ne '\e[5 q';; # beam cursor
    esac
}
zle -N zle-keymap-select
# Initialize cursor shape on start
echo -ne '\e[5 q'
# Reset cursor shape when exiting zsh
function TRAPINT() {
    echo -ne '\e[5 q'
    return $(( 128 + $1 ))
}
# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M viins "${terminfo[kend]}"  end-of-line
fi
# [Delete] - delete forward
bindkey -M viins "^[[3~" delete-char
bindkey -M viins "^[3;5~" delete-char
# utilities
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s "^[f" "fzfp\n"
