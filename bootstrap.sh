#!/bin/bash
set -e

# Detect OS
OS_TYPE="$(uname)"

install_1password() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install --cask 1password 1password-cli
    elif [[ "$OS_TYPE" == "Linux" ]]; then
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

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

read -p "Email (leave empty to skip secrets) : " EMAIL

if [[ ! -z "${EMAIL}" ]]; then
    # my secrets
    eval $(op signin --account my)
    op inject -i .secrets.sh -o ~/.secrets.sh

    git config --global user.email "$EMAIL"
fi

read -p "Work email (leave empty to skip) : " WORK_EMAIL

if [[ ! -z "${WORK_EMAIL}" ]]; then
    read -p "Work 1Password account ID : " WORK_OP_ACCOUNT
    # Work 1password account
    eval $(op signin --account "${WORK_OP_ACCOUNT}")
    op document get .work.sh > ~/.work.sh 

    # Persist the account ID for future op signin calls (e.g. in aliases)
    echo "export WORK_OP_ACCOUNT=\"${WORK_OP_ACCOUNT}\"" >> ~/.work.sh

    ln -sf "$PWD/.gitconfig.work" ~/.gitconfig.work
fi

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# ZSH Installation
if ! command -v zsh &> /dev/null; then
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        brew install zsh
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y zsh
    fi
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone this repo if not already here (though we are likely running from it)
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone git@github.com:kirel/dotfiles.git "$DOTFILES_DIR"
fi

# Symlinking via Rake
cd "$DOTFILES_DIR"
if command -v rake &> /dev/null; then
    rake
else
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
    brew bundle -v
    if [ ! -f ~/.work.sh ]; then
        brew bundle --file=Brewfile.mas -v
    fi
else
    # On Linux, brew bundle might still work if Homebrew is installed, 
    # but we might want to skip casks or use a different Brewfile
    if command -v brew &> /dev/null; then
        brew bundle -v || true
    fi
fi

cd -
echo "Setup complete! Please restart your shell."