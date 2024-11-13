# My dotfiles and setup

    sh ./bootstrap.sh

or

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/kirel/dotfiles/master/bootstrap.sh)"

## Update

    brew bundle dump -f

## Cleanup

    brew bundle cleanup
    !! --force

## Ansible

    pipx run --spec ansible -- ansible-playbook -K ansible/enable_touchid_sudo.yaml

## Update secrets

Edit `secrets.sh` then

    op inject -fi secrets.sh -o ~/.secrets.sh && cat ~/.secrets.sh

## Desperate measures

    cat Brewfile | grep ^cask | sed -e 's/cask "//g' | sed -e 's/"//g' | xargs brew install --cask -f