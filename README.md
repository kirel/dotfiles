# My dotfiles and setup

    sh ./bootstrap.sh

or

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/kirel/dotfiles/master/bootstrap.sh)"

## Update

    brew bundle dump -f

## Cleanup

    brew bundle cleanup
    !! --force

## Desperate measures

    cat Brewfile | grep ^cask | sed -e 's/cask "//g' | sed -e 's/"//g' | xargs brew install --cask -f