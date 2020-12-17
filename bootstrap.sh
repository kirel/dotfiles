/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo chgrp -R admin $(brew --prefix)/*
sudo chmod -R g+w $(brew --prefix)/*

brew install --cask \
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
fi

read -p "Billie email : " BILLIE_EMAIL

if [[ ! -z "${BILLIE_EMAIL}" ]]; then
    op signin my $BILLIE_EMAIL

    # Billie 1password account
    eval $(op signin billie_team)
    op get document .billie.sh > ~/.billie.sh # op edit document .billie.sh ~/.billie.sh
    op get document id_rsa.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa.pub ~/.ssh/id_rsa.pub
    op get document id_rsa > ~/.ssh/id_rsa # op edit document id_rsa ~/.ssh/id_rsa
else

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# This repo
git clone git@github.com:kirel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && rake && cd -

# Other apps
# brew list -1 --formula | gsed 's/\(.*\)/  \1 \\/' | pbcopy
brew install \
    bat \
    curl \
    fzf \
    gh \
    git \
    git-crypt \
    git-lfs \
    gnu-sed \
    htop \
    hub \
    jq \
    mariadb-connector-c \
    ncdu \
    openjdk \
    pipenv \
    prettyping \
    pyenv \
    r \
    rbenv \
    ruby-build \
    subversion \
    the_silver_searcher \
    tmux \
    tree \
    wget \
    xsv \
    z

# brew list -1 --cask | gsed 's/\(.*\)/  \1 \\/' | pbcopy
brew install --cask \
  1password \
  1password-cli \
  appzapper \
  dash \
  discord \
  docker \
  fantastical \
  font-fira-mono-for-powerline \
  google-cloud-sdk \
  google-drive-file-stream \
  gpg-suite \
  iterm2 \
  keyboard-cleaner \
  latexit \
  launchbar \
  microsoft-auto-update \
  microsoft-edge \
  microsoft-office \
  ngrok \
  nvidia-geforce-now \
  qlcolorcode \
  qlimagesize \
  qlmarkdown \
  qlstephen \
  qlvideo \
  quicklook-json \
  quicklookase \
  rectangle \
  rowanj-gitx \
  rstudio \
  shadow \
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
  webpquicklook \
  whatsapp \
  zoom
