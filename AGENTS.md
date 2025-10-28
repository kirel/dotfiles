# Project Overview

This repository contains personal dotfiles for setting up and configuring a macOS development environment. It automates the installation of applications, command-line tools, and shell configurations. The setup is primarily managed through a bootstrap script, Homebrew for package management, and Rake for symlinking configuration files.

## Key Technologies

*   **Shell:** Zsh, configured with Oh My Zsh and Starship prompt.
*   **Package Manager:** Homebrew (using a `Brewfile`).
*   **Automation:** Bash scripts, Rake.
*   **Configuration:** A collection of `.symlink` files that are linked to the home directory.
*   **Secrets Management:** 1Password CLI is used to inject secrets into the environment.

# Building and Running

The primary way to set up the environment is by running the `bootstrap.sh` script. This script will:

1.  Install 1Password and its CLI tool.
2.  Prompt for user information to configure Git and fetch secrets from 1Password.
3.  Set up SSH keys.
4.  Install Zsh and Oh My Zsh.
5.  Clone this dotfiles repository to `~/.dotfiles`.
6.  Run `rake` to create symlinks for all the configuration files.
7.  Run `brew bundle` to install all the packages, casks, and VS Code extensions listed in the `Brewfile`.

## Commands

*   **Initial Setup:**
    ```bash
    sh ./bootstrap.sh
    ```

*   **Update Brewfile:** To update the `Brewfile` with currently installed packages:
    ```bash
    brew bundle dump -f
    ```

*   **Cleanup Unlisted Brew Packages:** To remove any packages not listed in the `Brewfile`:
    ```bash
    brew bundle cleanup --force
    ```

*   **Run Ansible Playbook:** To run the included Ansible playbook for enabling Touch ID for `sudo`:
    ```bash
    pipx run --spec ansible -- ansible-playbook -K ansible/enable_touchid_sudo.yaml
    ```

# Development Conventions

*   **Symlinking:** Configuration files in this repository have a `.symlink` extension. The `Rakefile` contains a task that creates symbolic links from this repository to the corresponding dotfile in the user's home directory (e.g., `.zshrc.symlink` -> `~/.zshrc`).
*   **Package Management:** The `Brewfile` is the single source of truth for all Homebrew-managed software, including command-line tools, GUI applications (casks), Mac App Store apps (`mas`), and VS Code extensions (`vscode`).
*   **Secrets:** Secrets are not stored in the repository. They are managed in 1Password and sourced into the shell environment by the `bootstrap.sh` script, creating files like `~/.secrets.sh`.
*   **Modularity:** Shell configuration is broken down into multiple files. The main entry point is `.zshrc.symlink`, which sources other files like `.aliases.symlink` and the secret files.
