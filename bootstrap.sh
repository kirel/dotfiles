mkdir ~/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/homebrew

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

# Other apps
# brew list -1 --formula | gsed 's/\(.*\)/  \1 \\/' | pbcopy
brew install \
  bat \
  curl \
  dvc \
  fd \
  ffmpeg \
  fzf \
  gh \
  git \
  git-delta \
  git-crypt \
  git-lfs \
  gnu-sed \
  htop \
  hub \
  jq \
  mariadb-connector-c \
  ncdu \
  pipenv \
  prettyping \
  pyenv \
  r \
  rbenv \
  ripgrep \
  ruby-build \
  tmux \
  tree \
  wget \
  xsv \
  xz \
  z \
  zsh

# brew list -1 --cask | gsed 's/\(.*\)/  \1 \\/' | pbcopy
brew install -f --cask \
  adoptopenjdk \
  alfred \
  appzapper \
  dash \
  discord \
  docker \
  fantastical \
  homebrew/cask-fonts/font-fira-code \
  homebrew/cask-fonts/font-fira-mono-for-powerline \
  google-cloud-sdk \
  google-drive-file-stream \
  gpg-suite \
  istat-menus \
  iterm2 \
  keyboard-cleaner \
  latexit \
  launchbar \
  microsoft-auto-update \
  microsoft-edge \
  microsoft-office \
  ngrok \
  notion \
  nvidia-geforce-now \
  qlcolorcode \
  qlimagesize \
  qlmarkdown \
  qlstephen \
  qlvideo \
  quicklook-json \
  quicklookase \
  rectangle \
  rescuetime \
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
