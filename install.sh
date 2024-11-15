#!/usr/bin/env zsh

# sudo pacman -Sy brave-browser tmux kitty btop docker easyeffects fzf neovim
# sudo pamac build 1password annotator

# flatpak install brave ExtensionManager junction
# sudo dnf in neovim kitty fzf zsh fastfetch btop bat eza easyeffects adw-gtk3-theme ruby-build gnome-tweaks
# chsh -s /bin/zsh

# git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
# git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# git clone https://github.com/gpakosz/.tmux.git && ln -s -f $HOME/.tmux/.tmux.conf && cp $HOME/.tmux/.tmux.conf.local .

# mv "$HOME/.zshrc_bu"
ln -fs "$HOME/.dotfiles/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
ln -fs "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"
ln -fs $HOME/.dotfiles/nvim ~/.config 
ln -fs $HOME/.dotfiles/.tmux.conf.local ~/.tmux.conf.local
ln -fs $HOME/.dotfiles/kitty.conf ~/.config/kitty
# ln -fs $HOME/Gemfile ~/

# ln -s "$HOME/.dotfiles/docker-compose.yml" "$HOME/docker-compose.yml"

ln -fs $HOME/.dotfiles/gnome/custom ~/.themes
ln -fs $HOME/.dotfiles/gnome/gtk3.css ~/.config/gtk-3.0/gtk.css
ln -fs $HOME/.dotfiles/gnome/gtk4.css ~/.config/gtk-4.0/gtk.css
# sudo flatpak override --filesystem=xdg-config/gtk-4.0/gtk.css:ro
# sudo flatpak override --filesystem=xdg-config/gtk-3.0/gtk.css:ro
# ln -fs $HOME/.dotfiles/gnome/steam.css ~/repos/Adwaita-for-Steam/custom/custom.css


# ln -fs $HOME/.dotfiles/settings.json ~/.config/Code/User/settings.json
# ln -fs $HOME/.dotfiles/Default\ \(Linux\).sublime-keymap ~/.config/sublime-text/Packages/User
# ln -fs $HOME/.dotfiles/Preferences.sublime-settings ~/.config/sublime-text/Packages/User
# ln -fs $HOME/.dotfiles/keybindings.json ~/.config/Code/User/keybindings.json

# tilix create shortcut with "tilix --quake" command
# dconf load /com/gexperts/Tilix/ < ./tilix.dconf
# gsettings set com.gexperts.Tilix.Settings quake-height-percent 100

# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker

# ln -fs $HOME/.dotfiles/easyeffects/input $HOME/.config/easyeffects
# ln -fs $HOME/.dotfiles/easyeffects/output $HOME/.config/easyeffects

# curl https://mise.run | sh
# mise use -g ruby node usage
