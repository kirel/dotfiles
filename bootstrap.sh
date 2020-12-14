sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install --cask \
    1password \
    1password-cli

# my secrets
eval $(op signin my)
op get document .secrets.sh > ~/.secrets.sh # op edit document .secrets.sh ~/.secrets.sh
op get document id_rsa_private.pub > ~/.ssh/id_rsa_private.pub # op edit document id_rsa_private.pub ~/.ssh/id_rsa_private.pub
op get document id_rsa_private > ~/.ssh/id_rsa_private # op edit document id_rsa_private ~/.ssh/id_rsa_private

# Billie 1password account
eval $(op signin billie_team)
op get document .billie.sh > ~/.billie.sh # op edit document .billie.sh ~/.billie.sh
op get document id_rsa.pub > ~/.ssh/id_rsa.pub # op edit document id_rsa.pub ~/.ssh/id_rsa.pub
op get document id_rsa > ~/.ssh/id_rsa # op edit document id_rsa ~/.ssh/id_rsa

# This repo
brew install zsh
git clone git@github.com:kirel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && rake && cd -

# Other apps
brew install the_silver_searcher prettyping ncdu htop curl fzf gh hub git git-crypt git-lfs jq pipenv pyenv rbenv tree tmux wget xsv z
brew install --cask \
    appzapper \
    atom \ 
    betterzip \
    cyberduck \
    dash \
    docker \
    font-consolas-for-powerline \
    font-droid-sans-mono-for-powerline \
    font-fira-code \
    font-ibm-plex \
    font-menlo-for-powerline \
    font-roboto-condensed \
    google-chrome \
    google-cloud-sdk \
    google-drive-file-stream \
    gpg-suite \
    iterm2 \
    java \
    keyboard-cleaner \
    latexit \
    launchbar \
    mactex-no-gui \
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
