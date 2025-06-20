export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--border
--multi
--preview-window right:60%
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ '
--pointer='▶'
--marker='✓'
--bind='alt-p:toggle-preview'
--bind='ctrl-a:select-all'
--bind='ctrl-d:preview-half-page-down'
--bind='ctrl-u:preview-half-page-up'
"

if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash
if [ -f ~/.dotfiles/bash/fzf-tab-completion/bash/fzf-bash-completion.sh ]; then
	source ~/.dotfiles/bash/fzf-tab-completion/bash/fzf-bash-completion.sh
	bind -x '"\t": fzf_bash_completion'
fi
