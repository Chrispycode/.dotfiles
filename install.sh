#!/usr/bin/env zsh

# sudo pacman -Sy brave-browser neovim kitty btop appimagelauncher gcc docker docker-compose easyeffects
# flatpak install com.google.Chrome com.microsoft.Edge org.gnome.gitlab.YaLTeR.VideoTrimmer re.sonny.Junction
# sudo pamac build 1password annotator
# git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
# git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# mv "$HOME/.zshrc_bu"
ln -fs "$HOME/.dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"
ln -fs "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"

ln -fs $HOME/.dotfiles/init.lua ~/.config/nvim
 
# ln -fs $HOME/.dotfiles/.tmux.conf ~/.tmux.conf
ln -fs $HOME/.dotfiles/.tmux.conf.local ~/.tmux.conf.local

ln -fs $HOME/.dotfiles/kitty.conf ~/.config/kitty

# ln -s "$HOME/.dotfiles/docker-compose.yml" "$HOME/docker-compose.yml"

ln -fs $HOME/.dotfiles/custom ~/.themes
ln -fs $HOME/.dotfiles/gtk3.css ~/.config/gtk-3.0/gtk.css
ln -fs $HOME/.dotfiles/gtk4.css ~/.config/gtk-4.0/gtk.css


# ln -fs $HOME/.dotfiles/settings.json ~/.config/Code/User/settings.json
# ln -fs $HOME/.dotfiles/Default\ \(Linux\).sublime-keymap ~/.config/sublime-text/Packages/User
# ln -fs $HOME/.dotfiles/Preferences.sublime-settings ~/.config/sublime-text/Packages/User
# ln -fs $HOME/.dotfiles/keybindings.json ~/.config/Code/User/keybindings.json

# make sripts executable
# chmod a+x tmux-sessionizer.sh
# chmod a+x fzf-preview.sh

# tilix create shortcut with "tilix --quake" command
# dconf load /com/gexperts/Tilix/ < ./tilix.dconf
# gsettings set com.gexperts.Tilix.Settings quake-height-percent 100

# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
