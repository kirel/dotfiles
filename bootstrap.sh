#!/bin/bash
set -e

# Detect OS
OS_TYPE="$(uname)"
echo "==> Detected OS: $OS_TYPE"

install_1password() {
    echo "==> Setting up 1Password..."
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "    Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        # Check if 1password-cli is needed
        if ! command -v op &> /dev/null; then
            echo "    Installing 1Password CLI..."
            brew install --cask 1password-cli
        else
            echo "    1Password CLI already installed."
        fi

        # Check if 1password GUI is needed (skip if already in /Applications or installed via brew)
        if [[ ! -d "/Applications/1Password.app" ]] && ! brew list --cask 1password &>/dev/null; then
            echo "    Installing 1Password GUI..."
            brew install --cask 1password
        else
            echo "    1Password GUI already present (possibly via MDM)."
        fi
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        echo "    Installing 1Password CLI for Linux..."
        # Check for Debian/Ubuntu
        if command -v apt-get &> /dev/null; then
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
            sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
            curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
            sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22/
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
            sudo apt-get update && sudo apt-get install 1password-cli
        fi
    fi
}

# Ensure 1Password CLI is installed for secrets
if ! command -v op &> /dev/null; then
    install_1password
fi

echo "==> Preparing SSH directory..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

echo "==> Configuring personal identity and secrets..."
read -p "Email (leave empty to skip secrets) : " EMAIL

if [[ ! -z "${EMAIL}" ]]; then
    echo "    Fetching personal secrets from 1Password..."
    # my secrets
    eval $(op signin --account my)
    op inject -i .secrets.sh -o ~/.secrets.sh

    echo "    Setting global Git email..."
    git config --global user.email "$EMAIL"
fi

echo "==> Configuring optional work environment..."
# Load existing work config if available for defaults
if [[ -f ~/.work.sh ]]; then
    source ~/.work.sh
fi

read -p "Work email [${WORK_EMAIL}] (leave empty to skip) : " INPUT_WORK_EMAIL
WORK_EMAIL=${INPUT_WORK_EMAIL:-$WORK_EMAIL}

if [[ ! -z "${WORK_EMAIL}" ]]; then
    read -p "Work 1Password account ID [${OP_ACCOUNT}] : " INPUT_OP_ACCOUNT
    OP_ACCOUNT=${INPUT_OP_ACCOUNT:-$OP_ACCOUNT}

    echo "    Fetching work overrides and secrets..."
    # Work 1password account
    eval $(op signin --account "${OP_ACCOUNT}")

    # Overwrite/Create the local cache with current values
    echo "export WORK_EMAIL=\"${WORK_EMAIL}\"" > ~/.work.sh
    echo "export OP_ACCOUNT=\"${OP_ACCOUNT}\"" >> ~/.work.sh

    echo "    Linking work-specific Git config..."
    ln -sf "$PWD/.gitconfig.work" ~/.gitconfig.work
fi

echo "==> Finalizing SSH permissions..."
if ls ~/.ssh/* >/dev/null 2>&1; then
    chmod 600 ~/.ssh/*
fi
if ls ~/.ssh/*.pub >/dev/null 2>&1; then
    chmod 644 ~/.ssh/*.pub
fi

# ZSH Installation
echo "==> Checking Zsh installation..."
if ! command -v zsh &> /dev/null; then
    echo "    Zsh not found. Installing..."
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        brew install zsh
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y zsh
    fi
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone this repo if not already here (though we are likely running from it)
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "==> Cloning dotfiles repository to $DOTFILES_DIR..."
    git clone git@github.com:kirel/dotfiles.git "$DOTFILES_DIR"
fi

# Symlinking via Rake
echo "==> Creating symlinks via Rake..."
cd "$DOTFILES_DIR"
if command -v rake &> /dev/null; then
    rake
else
    echo "    Rake not found. Installing Ruby/Rake..."
    # Install rake if missing
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        brew install ruby
    else
        sudo apt-get install -y rake
    fi
    rake
fi

# Install packages
if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "==> Installing Homebrew packages from Brewfile..."
    brew bundle -v
    if [ ! -f ~/.work.sh ]; then
        echo "==> Personal machine detected. Installing MAS apps..."
        brew bundle --file=Brewfile.mas -v
    else
        echo "==> Work machine detected. Skipping personal MAS apps."
    fi
else
    # On Linux, brew bundle might still work if Homebrew is installed, 
    # but we might want to skip casks or use a different Brewfile
    if command -v brew &> /dev/null; then
        echo "==> Installing Homebrew packages for Linux..."
        brew bundle -v || true
    fi
fi

cd -
echo "Setup complete! Please restart your shell."