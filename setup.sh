#!/bin/bash

# Ensure curl is installed for both Linux and macOS
ensure_curl() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing now..."
        case "$1" in
          'Linux')
            sudo apt-get update
            sudo apt-get install curl -y
            ;;
          'Darwin')
            brew install curl
            ;;
          *)
            echo "Unsupported operating system for curl installation."
            exit 1
            ;;
        esac
        echo "curl installed successfully."
    else
        echo "curl is already installed."
    fi
}

# Function to install zsh on Debian-based Linux
install_zsh_debian() {
    echo "Installing zsh on Debian-based Linux..."
    sudo apt-get update
    sudo apt-get install zsh -y
}

# Function to install zsh on macOS
install_zsh_macos() {
    echo "Installing zsh on macOS..."
    brew install zsh
}

# Install Oh My Zsh
install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Function to install tmux on Debian-based Linux
install_tmux_debian() {
    echo "Installing tmux on Debian-based Linux..."
    sudo apt-get update
    sudo apt-get install tmux -y
}

# Function to install tmux on macOS
install_tmux_macos() {
    echo "Installing tmux on macOS..."
    brew install tmux
}

# Function to install Neovim on Debian-based Linux
install_nvim_linux() {
    echo "Installing Neovim on Linux via PPA..."
    sudo apt-get update
    sudo apt-get install software-properties-common -y
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update
    sudo apt-get install neovim -y
}

# Function to install Neovim on macOS
install_nvim_macos() {
    echo "Installing Neovim on macOS..."
    brew install neovim
}

# Determine OS and ensure curl is installed
OS="`uname`"
ensure_curl $OS

# Check for zsh and install if not present
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Checking operating system..."
    case $OS in
      'Linux')
        install_zsh_debian
        ;;
      'Darwin')
        install_zsh_macos
        ;;
      *)
        echo "Unsupported operating system."
        exit 1
        ;;
    esac
    echo "zsh installed successfully."
else
    echo "zsh is already installed."
fi

# Set zsh as the default shell for the current user
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s $(which zsh)
    echo "zsh is now set as the default shell."
else
    echo "zsh is already the default shell."
fi

# Check for Oh My Zsh and install if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    install_oh_my_zsh
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh is already installed."
fi

# Copy .zshrc and .oh-my-zsh/custom if they exist in the cwd
if [ -f "./.zshrc" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        echo "Backing up existing .zshrc to .zshrc.backup"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
    echo "Copying .zshrc to home directory."
    cp "./.zshrc" "$HOME/"
fi

if [ -d "./.oh-my-zsh/custom" ]; then
    if [ -d "$HOME/.oh-my-zsh/custom" ]; then
        echo "Backing up existing .oh-my-zsh/custom to .oh-my-zsh/custom.backup"
        mv "$HOME/.oh-my-zsh/custom" "$HOME/.oh-my-zsh/custom.backup"
    fi
    echo "Copying custom Oh My Zsh configurations."
    cp -r "./.oh-my-zsh/custom" "$HOME/.oh-my-zsh/"
fi

# Check for tmux and install if not present
if ! command -v tmux &> /dev/null; then
    echo "tmux is not installed. Checking operating system..."
    case $OS in
      'Linux')
        install_tmux_debian
        ;;
      'Darwin')
        install_tmux_macos
        ;;
      *)
        echo "Unsupported operating system for tmux installation."
        exit 1
        ;;
    esac
    echo "tmux installed successfully."
else
    echo "tmux is already installed."
fi

# Install Tmux Plugin Manager (tpm) if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Tmux Plugin Manager (tpm) is not installed. Installing now..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "tpm installed successfully."
else
    echo "Tmux Plugin Manager (tpm) is already installed."
fi

# Copy .tmux and .tmux.conf if they exist in the cwd
if [ -d "./.tmux" ]; then
    if [ -d "$HOME/.tmux" ]; then
        echo "Backing up existing .tmux directory to .tmux.backup"
        mv "$HOME/.tmux" "$HOME/.tmux.backup"
    fi
    echo "Copying .tmux directory."
    cp -r "./.tmux" "$HOME/"
fi

if [ -f "./.tmux.conf" ]; then
    if [ -f "$HOME/.tmux.conf" ]; then
        echo "Backing up existing .tmux.conf to .tmux.conf.backup"
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
    fi
    echo "Copying .tmux.conf."
    cp "./.tmux.conf" "$HOME/"
fi

# Check for Neovim and install if not present
if ! command -v nvim &> /dev/null; then
    echo "Neovim is not installed. Checking operating system..."
    case $OS in
      'Linux')
        install_nvim_linux
        ;;
      'Darwin')
        install_nvim_macos
        ;;
      *)
        echo "Unsupported operating system for Neovim installation."
        exit 1
        ;;
    esac
    echo "Neovim installed successfully."
else
    echo "Neovim is already installed."
fi

# Copy init.lua if it exists in the cwd
if [ -f "./init.lua" ]; then
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        echo "Backing up existing init.lua to init.lua.backup"
        mv "$HOME/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua.backup"
    fi
    echo "Copying init.lua to Neovim config directory."
    mkdir -p "$HOME/.config/nvim"
    cp "./init.lua" "$HOME/.config/nvim/"
fi

