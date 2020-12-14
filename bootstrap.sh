sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask \
    1password \
    1password-cli

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

read -p "Email : " EMAIL
op signin my $EMAIL

# my secrets
eval $(op signin my)
op get document .secrets.sh > ~/.secrets.sh # op edit document .secrets.sh ~/.secrets.sh
op get document id_rsa_private.pub > ~/.ssh/id_rsa_private.pub # op edit document id_rsa_private.pub ~/.ssh/id_rsa_private.pub
op get document id_rsa_private > ~/.ssh/id_rsa_private # op edit document id_rsa_private ~/.ssh/id_rsa_private

read -p "Billie email : " BILLIE_EMAIL
op signin my $BILLIE_EMAIL

# Billie 1password account
eval $(op signin billie_team)
op get document .billie.sh > ~/.billie.sh # op edit document .billie.sh ~/.billie.sh
op get document id_rsa.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa.pub ~/.ssh/id_rsa.pub
op get document id_rsa > ~/.ssh/id_rsa # op edit document id_rsa ~/.ssh/id_rsa

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# This repo
brew install zsh
git clone git@github.com:kirel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && rake && cd -

# Other apps
brew install the_silver_searcher autoenv bat prettyping ncdu htop curl fzf gh hub git git-crypt git-lfs jq pipenv pyenv rbenv tree tmux wget xsv z
brew install \
    appzapper \
    homebrew/cask/dash \
    homebrew/cask/docker \
    google-cloud-sdk \
    google-drive-file-stream \
    gpg-suite \
    iterm2 \
    openjdk \
    keyboard-cleaner \
    latexit \
    launchbar \
    ngrok \
    qlcolorcode \
    qlimagesize \
    qlmarkdown \
    qlstephen \
    qlvideo \
    quicklook-json \
    quicklookase \
    r \
    rectangle \
    rowanj-gitx \
    rstudio \
    skype \
    slack \
    suspicious-package \
    tableplus \
    telegram \
    the-unarchiver \
    tunnelblick \
    vagrant \
    virtualbox \
    virtualbox-extension-pack \
    visual-studio-code \
    webpquicklook
