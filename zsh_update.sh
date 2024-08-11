# add this to .oh_my_zsh/tools/update before exit

printf "\n${BLUE}%s${RESET}\n" "Updating custom plugins"
cd custom/plugins

for plugin in */; do
  if [ -d "$plugin/.git" ]; then
     printf "${YELLOW}%s${RESET}\n" "${plugin%/}"
     git -C "$plugin" pull
  fi
done

printf "\n${BLUE}%s${RESET}\n" "Updating custom themes"
cd ../themes

for theme in */; do
  if [ -d "$theme/.git" ]; then
     printf "${YELLOW}%s${RESET}\n" "${theme%/}"
     git -C "$theme" pull
  fi
done
