#!/usr/bin/env zsh

# yay -S brave-browser tmux ghostty btop easyeffects fzf neovim podman podman-docker podman-compose eza lazygit fastfetch starship 1password unzip
# yay -S plasma-meta dolphin konsole spectacle sddm-kcm 

# flatpak install ExtensionManager junction
# sudo dnf in neovim kitty fzf zsh fastfetch btop bat eza easyeffects adw-gtk3-theme ruby-build gnome-tweaks

# chsh -s /bin/zsh
# mv "$HOME/.zshrc" "$HOME/.zshrc_bu"
# git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
# git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# ln -fs "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"

# mv "$HOME/.bashrc" "$HOME/.bashrc_bu"
# git clone https://github.com/lincheney/fzf-tab-completion ~/.dotfiles/bash/fzf-tab-completion
# ln -fs "$HOME/.dotfiles/bash/.bashrc" "$HOME/.bashrc"

# git clone https://github.com/gpakosz/.tmux.git && ln -s -f $HOME/.tmux/.tmux.conf && cp $HOME/.tmux/.tmux.conf.local .
# ln -fs $HOME/.dotfiles/.tmux.conf.local ~/.tmux.conf.local
#
# ln -fs $HOME/.dotfiles/nvim ~/.config 
# ln -fs $HOME/.dotfiles/kitty.conf ~/.config/kitty
# ln -fs $HOME/.dotfiles/ghostty.conf ~/.config/ghostty/config
# ln -fs "$HOME/.dotfiles/btop.conf" "$HOME/.config/btop/btop.conf"
# ln -fs $HOME/.dotfiles/zathura ~/.config
# ln -fs $HOME/.dotfiles/fastfetch ~/.config/
# ln -fs $HOME/Gemfile ~/

# mkdir ~/.themes
# ln -fs $HOME/.dotfiles/gnome/custom ~/.themes
# ln -fs $HOME/.dotfiles/gnome/gtk3.css ~/.config/gtk-3.0/gtk.css
# ln -fs $HOME/.dotfiles/gnome/gtk4.css ~/.config/gtk-4.0/gtk.css
# flatpak -u override --filesystem=xdg-config/gtk-4.0/gtk.css:ro
# flatpak -u override --filesystem=xdg-config/gtk-3.0/gtk.css:ro
# ln -fs $HOME/.dotfiles/gnome/steam.css ~/repos/Adwaita-for-Steam/custom/custom.css

# ln -fs $HOME/.dotfiles/kde/BreezeOLED.colors ~/.local/share/color-schemes/BreezeOLED.colors

# ln -fs $HOME/.dotfiles/others/settings.json ~/.config/Code/User/settings.json
# ln -fs $HOME/.dotfiles/others/keybindings.json ~/.config/Code/User/keybindings.json

# tilix create shortcut with "tilix --quake" command
# dconf load /com/gexperts/Tilix/ < $HOME/.dotfiles/others/tilix.dconf
# gsettings set com.gexperts.Tilix.Settings quake-height-percent 100

# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
# ln -s "$HOME/.dotfiles/docker-compose.yml" "$HOME/docker-compose.yml"

# ln -fs $HOME/.dotfiles/easyeffects/input $HOME/.config/easyeffects
# ln -fs $HOME/.dotfiles/easyeffects/output $HOME/.config/easyeffects

# curl https://mise.run | sh
# mise use -g ruby node usage
