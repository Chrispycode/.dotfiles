#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else
	folders="$HOME/.dotfiles\n"
	folders+="$HOME/Documents\n"
	folders+=$(find ~/repos ~/repos/code -mindepth 1 -maxdepth 1 -type d)
	selected=$(echo -e "$folders" | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -c $selected
  # tmux new-session -s $selected_name -c $selected \; split-window -v -p 80
  exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
  tmux new-session -ds $selected_name -c $selected
fi

# tmux switch-client -t $selected_name
if [[ -z $TMUX ]]; then
  tmux attach-session -t $selected_name
else
  tmux switch-client -t $selected_name
fi
