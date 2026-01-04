#!/usr/bin/env zsh

# yay -S brave-browser tmux ghostty btop easyeffects fzf neovim podman podman-docker podman-compose eza lazygit fastfetch starship 1password unzip
# yay -S plasma-meta dolphin konsole spectacle sddm-kcm 
# neovim build
# sudo pacman -S base-devel cmake ninja curl
# make CMAKE_BUILD_TYPE=Release && sudo make install

# ghostty build
# sudo pacman -S gtk4 gtk4-layer-shell libadwaita gettext
# zig build -p $HOME/.local -Doptimize=ReleaseFast

# fix sddm using US layout
# localectl set-x11-keymap de

# flatpak install ExtensionManager junction
# flatpak install dev.zed.Zed app.zen_browser.zen com.vysp3r.ProtonPlus org.deskflow.deskflow org.gnome.DejaDup org.gtk.Gtk3theme.adw-gtk3
# sudo dnf in neovim kitty fzf zsh fastfetch btop bat eza easyeffects adw-gtk3-theme ruby-build gnome-tweaks

# chsh -s /bin/zsh
# mv "$HOME/.zshrc" "$HOME/.zshrc_bu"
# mv "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc_bu"
# mkdir -p "$HOME/.config/zsh/plugins/"
# echo "export ZDOTDIR=$HOME/.config/zsh" >> "$HOME/.zshenv"
# mv "$HOME/.zsh_history" "$HOME/.config/zsh/.histfile"
# git clone https://github.com/Aloxaf/fzf-tab ~/.config/zsh/plugins/fzf-tab
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/plugins/zsh-syntax-highlighting
# ln -fs "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

# mv "$HOME/.bashrc" "$HOME/.bashrc_bu"
# git clone https://github.com/lincheney/fzf-tab-completion ~/.dotfiles/bash/fzf-tab-completion
# ln -fs "$HOME/.dotfiles/bash/.bashrc" "$HOME/.bashrc"

# ln -fs $HOME/.dotfiles/.tmux.conf ~/.tmux.conf
#
# ln -fs $HOME/.dotfiles/nvim ~/.config 
# ln -fs $HOME/.dotfiles/kitty.conf ~/.config/kitty/
# ln -fs $HOME/.dotfiles/ghostty.conf ~/.config/ghostty/config
# ln -fs $HOME/.dotfiles/ghostty.conf $HOME/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty
# ln -fs "$HOME/.dotfiles/btop.conf" "$HOME/.config/btop/btop.conf"
# ln -fs $HOME/.dotfiles/zathura ~/.config
# ln -fs $HOME/.dotfiles/fastfetch ~/.config/
# ln -fs $HOME/.dotfiles/walker ~/.config/
# ln -fs $HOME/.dotfiles/Gemfile ~/

# mkdir ~/.themes
# ln -fs $HOME/.dotfiles/gnome/custom ~/.themes
# ln -fs $HOME/.dotfiles/gnome/gtk3.css ~/.config/gtk-3.0/gtk.css
# ln -fs $HOME/.dotfiles/gnome/gtk4.css ~/.config/gtk-4.0/gtk.css
# flatpak -u override --filesystem=xdg-config/gtk-4.0/gtk.css:ro
# flatpak -u override --filesystem=xdg-config/gtk-3.0/gtk.css:ro
# ln -fs $HOME/.dotfiles/gnome/steam.css ~/repos/Adwaita-for-Steam/custom/custom.css
# ln -fs $HOME/.dotfiles/xdg-desktop-portal ~/.config

# mkdir ~/.local/share/color-schemes
# ln -fs $HOME/.dotfiles/kde/BreezeOLED.colors ~/.local/share/color-schemes/BreezeOLED.colors
# sudo cp $HOME/.dotfiles/kde/BreezeOLED.colors /usr/share/color-schemes/BreezeOLED.colors

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
