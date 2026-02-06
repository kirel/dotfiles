#!/bin/bash
set -e

# Detect OS
OS_TYPE="$(uname)"
echo "==> Detected OS: $OS_TYPE"

# Set SSH Agent socket for initial clone
if [[ "$OS_TYPE" == "Darwin" ]]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BU86482C3.com.1password/t/agent.sock
else
    export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

install_1password() {
    echo "==> Setting up 1Password..."
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "    Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        if ! command -v op &> /dev/null; then
            echo "    Installing 1Password CLI..."
            brew install --cask 1password-cli
        fi

        if [[ ! -d "/Applications/1Password.app" ]] && ! brew list --cask 1password &>/dev/null; then
            echo "    Installing 1Password GUI..."
            brew install --cask 1password
        fi
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        echo "    Installing 1Password CLI for Linux..."
        if command -v apt-get &> /dev/null; then
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
            sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
            curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
            sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22/
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            sudo apt-get update && sudo apt-get install 1password-cli
        fi
    fi
}

# 1. Mandatory Personal 1Password Setup
if ! command -v op &> /dev/null; then
    install_1password
    echo "==> ACTION REQUIRED: 1Password Setup"
    echo "    1. Open 1Password"
    echo "    2. Go to Settings -> Developer"
    echo "    3. Enable 'CLI' integration"
    echo "    4. Enable 'SSH Agent'"
    read -p "    Press [Enter] after you have enabled these settings to continue..."
fi

echo "==> Authenticating with Personal 1Password (needed for SSH keys)..."
eval $(op signin --account my)

# 2. Ensure Git and Clone Repository
if ! command -v git &> /dev/null; then
    echo "==> Installing Git..."
    if [[ "$OS_TYPE" == "Darwin" ]]; then brew install git; else sudo apt-get update && sudo apt-get install -y git; fi
fi

DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "==> Cloning dotfiles repository..."
    echo "    (Make sure 1Password SSH Agent is enabled in Settings -> Developer)"
    git clone git@github.com:kirel/dotfiles.git "$DOTFILES_DIR"
fi

# 3. Global Core Setup (Zsh, Oh My Zsh, Symlinks)
echo "==> Installing Zsh and Oh My Zsh..."
if ! command -v zsh &> /dev/null; then
    if [[ "$OS_TYPE" == "Darwin" ]]; then brew install zsh; else sudo apt-get update && sudo apt-get install -y zsh; fi
fi
[ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "==> Running Rake to create symlinks..."
cd "$DOTFILES_DIR"
if command -v rake &> /dev/null; then rake; else
    if [[ "$OS_TYPE" == "Darwin" ]]; then brew install ruby; else sudo apt-get install -y rake; fi
    rake
fi

# 4. Environment Specific Setup
if [[ -f ~/.work.sh ]]; then
    IS_WORK="y"
    echo "==> Detected existing work configuration."
else
    read -p "Is this a WORK machine? (y/N): " IS_WORK
fi

if [[ "$IS_WORK" =~ ^[Yy]$ ]]; then
    echo "==> Configuring Work Environment..."
    if [[ -f ~/.work.sh ]]; then source ~/.work.sh; fi
    read -p "Work 1Password account ID [${OP_ACCOUNT}] : " INPUT_OP_ACCOUNT
    OP_ACCOUNT=${INPUT_OP_ACCOUNT:-$OP_ACCOUNT}
    
    eval $(op signin --account "${OP_ACCOUNT}")
    op inject -fi "$DOTFILES_DIR/.secrets.work.sh" -o ~/.secrets.work.sh && cat ~/.secrets.work.sh
    
    # Save cache and ensure work aliases are sourced
    echo "export OP_ACCOUNT=\"${OP_ACCOUNT}\"" > ~/.work.sh
    echo "[[ -f ~/.aliases.work ]] && source ~/.aliases.work" >> ~/.work.sh
    
    echo "    Injecting work git config..."
    op inject -fi "$DOTFILES_DIR/.gitconfig.work.tmpl" -o ~/.gitconfig.work
else
    echo "==> Configuring Personal Environment..."
    echo "    Injecting personal git config..."
    op inject -fi "$DOTFILES_DIR/.gitconfig.personal.tmpl" -o ~/.gitconfig.personal
    
    echo "    Injecting personal secrets..."
    op inject -fi "$DOTFILES_DIR/.secrets.sh" -o ~/.secrets.sh && cat ~/.secrets.sh
    touch ~/.personal_machine
fi

# 5. Final SSH Permission Check
echo "==> Finalizing SSH permissions..."
mkdir -p ~/.ssh && chmod 700 ~/.ssh
if ls ~/.ssh/* >/dev/null 2>&1; then chmod 600 ~/.ssh/*; fi
if ls ~/.ssh/*.pub >/dev/null 2>&1; then chmod 644 ~/.ssh/*.pub; fi

# 6. Install Homebrew Packages
if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "==> Installing Baseline Homebrew packages..."
    brew bundle -v
    
    if [[ -f ~/.personal_machine ]]; then
        echo "==> Installing Personal 'Play' packages (including MAS)..."
        brew bundle --file=Brewfile.personal -v
    else
        echo "==> Installing Work packages..."
        brew bundle --file=Brewfile.work -v
    fi
fi

echo ""
echo "################################################################################"
echo "  🎉 Bootstrap completed successfully!"
echo "################################################################################"
echo ""
echo "Please restart your shell or run 'source ~/.zshrc' to apply changes."
echo ""