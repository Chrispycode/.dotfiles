#!/usr/bin/env zsh

set -e

echo "=== macOS Dotfiles Installation ==="

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages via Homebrew
echo "Installing packages..."
brew install neovim tmux fzf eza bat lazygit fastfetch starship zsh-autosuggestions zsh-syntax-highlighting ripgrep fd

# Optional: Install GUI apps via cask
brew install --cask ghostty@tip 1password

# Setup zsh
echo "Setting up zsh..."
mkdir -p "$HOME/.config/zsh/plugins"

# Backup existing zshrc
[[ -f "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc_bu"
[[ -f "$HOME/.config/zsh/.zshrc" ]] && mv "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc_bu"

# Set ZDOTDIR
if ! grep -q "ZDOTDIR" "$HOME/.zshenv" 2>/dev/null; then
  echo "export ZDOTDIR=\$HOME/.config/zsh" >> "$HOME/.zshenv"
fi

# Move history file
[[ -f "$HOME/.zsh_history" ]] && mv "$HOME/.zsh_history" "$HOME/.config/zsh/.histfile"

# Clone zsh plugins (if not using Homebrew versions)
[[ ! -d ~/.config/zsh/plugins/fzf-tab ]] && \
  git clone https://github.com/Aloxaf/fzf-tab ~/.config/zsh/plugins/fzf-tab
[[ ! -d ~/.config/zsh/plugins/zsh-autosuggestions ]] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
[[ ! -d ~/.config/zsh/plugins/zsh-syntax-highlighting ]] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting

ln -fs "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

# Setup tmux
echo "Setting up tmux..."
ln -fs "$HOME/.dotfiles/.tmux.conf" "$HOME/.tmux.conf"

# Setup neovim
echo "Setting up neovim..."
mkdir -p "$HOME/.config"
ln -fs "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"

# Setup ghostty (macOS path)
echo "Setting up ghostty..."
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -fs "$HOME/.dotfiles/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# Setup kitty
echo "Setting up kitty..."
mkdir -p "$HOME/.config/kitty"
ln -fs "$HOME/.dotfiles/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Setup btop
echo "Setting up btop..."
mkdir -p "$HOME/.config/btop"
ln -fs "$HOME/.dotfiles/btop.conf" "$HOME/.config/btop/btop.conf"

# Setup fastfetch
echo "Setting up fastfetch..."
ln -fs "$HOME/.dotfiles/fastfetch" "$HOME/.config/fastfetch"

# Setup zathura (if installed)
if command -v zathura &>/dev/null; then
  echo "Setting up zathura..."
  ln -fs "$HOME/.dotfiles/zathura" "$HOME/.config/zathura"
fi

# Setup scripts
echo "Setting up scripts..."
mkdir -p "$HOME/.local/bin"
# Scripts are added to PATH via sh/default.sh

# Link Gemfile
ln -fs "$HOME/.dotfiles/Gemfile" "$HOME/Gemfile"

# Install mise (runtime version manager)
if ! command -v mise &>/dev/null; then
  echo "Installing mise..."
  curl https://mise.run | sh
fi

# Initialize mise
echo "Initializing mise..."
~/.local/bin/mise use -g ruby node usage 2>/dev/null || true

echo ""
echo "=== Installation Complete ==="
echo ""
