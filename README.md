# My dotfiles and setup

    sh ./bootstrap.sh

or

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/kirel/dotfiles/master/bootstrap.sh)"

## Update

    rake dump

## Install Personal / MAS Apps

    brew bundle --file=Brewfile.personal

## Cleanup

    brew bundle cleanup
    !! --force

## Ansible

    uv ansible-playbook -K ansible/enable_touchid_sudo.yaml

## Update secrets

Edit `secrets.sh` then

    update_secrets

## Desperate measures

    cat Brewfile | grep ^cask | sed -e 's/cask "//g' | sed -e 's/"//g' | xargs brew install --cask -f