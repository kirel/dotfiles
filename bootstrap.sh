
set -x

brew install -f --cask \
    1password \
    1password-cli

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

read -p "Email : " EMAIL

if [[ ! -z "${EMAIL}" ]]; then
    # my secrets
    eval $(op signin --account my)
    op document get id_rsa_private.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa_private.pub ~/.ssh/id_rsa_private.pub
    op document get id_rsa_private > ~/.ssh/id_rsa # op edit document id_rsa_private ~/.ssh/id_rsa_private
    op inject -i .secrets.sh -o ~/.secrets.sh

    git config --global user.email $EMAIL
fi

read -p "Billie email : " BILLIE_EMAIL

if [[ ! -z "${BILLIE_EMAIL}" ]]; then
    # Billie 1password account
    eval $(op signin --account billie_team)
    op document get .billie.sh > ~/.billie.sh # op edit document .billie.sh ~/.billie.sh
    op document get id_rsa.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa.pub ~/.ssh/id_rsa.pub
    op document get id_rsa > ~/.ssh/id_rsa # op edit document id_rsa ~/.ssh/id_rsa

    ln -sf $PWD/.gitconfig.billie ~/.gitconfig.billie
fi

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# This repo
[ ! -d "~/.dotfiles" ] && git clone git@github.com:kirel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && rake && brew bundle -v && cd -


