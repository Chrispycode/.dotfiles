#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  >&2 echo "No preview for $word"
  exit 1
fi


file=${1/#\~\//$HOME/}
type=$(file --dereference --mime -- "$file")

if [[ ! $type =~ image/ ]]; then
  if [[ $type =~ =binary ]]; then
    if [ -f "/etc/debian_version" ]; then
      ls -1lah --color "$1"
    else
      eza --git -hla --color=always --icons "$1"
    fi
 
    exit
  fi

  # Sometimes bat is installed as batcat.
  if command -v batcat > /dev/null; then
    batname="batcat"
  elif command -v bat > /dev/null; then
    batname="bat"
  else
    cat "$1"
    exit
  fi

  ${batname} --style="${BAT_STYLE:-numbers}" --theme=ansi --color=always --pager=never -- "$file"
  exit
fi

dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
if [[ $dim = x ]]; then
  dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
elif ! [[ $KITTY_WINDOW_ID ]] && (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
  # Avoid scrolling issue when the Sixel image touches the bottom of the screen
  # * https://github.com/junegunn/fzf/issues/2544
  dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
fi

# 1. Use kitty icat on kitty terminal (kitty might disable icat kitten for third party terminals)
if command -v kitten > /dev/null; then
  transfer_mode="memory"
  if [ -f "/etc/debian_version" ]; then
    transfer_mode="stream"
  fi

  # 1. 'memory' is the fastest option but if you want the image to be scrollable,
  #    you have to use 'stream'.
  #
  # 2. The last line of the output is the ANSI reset code without newline.
  #    This confuses fzf and makes it render scroll offset indicator.
  #    So we remove the last line and append the reset code to its previous line.
  kitty icat --clear --transfer-mode=$transfer_mode --unicode-placeholder --stdin=no --place=$dim@0x0 "${file}"

elif [[ $TERM = "xterm-ghostty" ]] || [[ $GHOSTTY_BIN_DIR ]]; then
  chafa --clear -f kitty -d 0 --animate=off -s "$dim" "${file}"

# 2. Use chafa with Sixel output
elif command -v chafa > /dev/null; then
  chafa --clear -d 0 --animate=off -s "$dim" "${file}"
  # Add a new line character so that fzf can display multiple images in the preview window
  echo

# 3. If chafa is not found but imgcat is available, use it on iTerm2
elif command -v imgcat > /dev/null; then
  # NOTE: We should use https://iterm2.com/utilities/it2check to check if the
  # user is running iTerm2. But for the sake of simplicity, we just assume
  # that's the case here.
  imgcat -W "${dim%%x*}" -H "${dim##*x}" "${file}"

# 4. Cannot find any suitable method to preview the image
else
  file "${file}"
fi
