mkdir -p $HOME/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/homebrew

$HOME/homebrew/bin/brew install --cask \
    1password \
    1password-cli

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

read -p "Email : " EMAIL

if [[ ! -z "${EMAIL}" ]]; then
    op signin my $EMAIL

    # my secrets
    eval $(op signin my)
    op get document .secrets.sh > ~/.secrets.sh # op edit document .secrets.sh ~/.secrets.sh
    op get document id_rsa_private.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa_private.pub ~/.ssh/id_rsa_private.pub
    op get document id_rsa_private > ~/.ssh/id_rsa # op edit document id_rsa_private ~/.ssh/id_rsa_private

    git config --global user.email $EMAIL
fi

read -p "Billie email : " BILLIE_EMAIL

if [[ ! -z "${BILLIE_EMAIL}" ]]; then
    op signin my $BILLIE_EMAIL

    # Billie 1password account
    eval $(op signin billie_team)
    op get document .billie.sh > ~/.billie.sh # op edit document .billie.sh ~/.billie.sh
    op get document id_rsa.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa.pub ~/.ssh/id_rsa.pub

    git config --global user.email $BILLIE_EMAIL
fi

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# This repo
[ ! -d "~/.dotfiles" ] && git clone git@github.com:kirel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && rake && cd -

brew bundle


