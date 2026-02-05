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
3.  Prompt for optional work information (email and 1Password account ID) to set up a work-specific environment.
4.  Set up SSH keys.
5.  Install Zsh and Oh My Zsh.
6.  Clone this dotfiles repository to `~/.dotfiles`.
7.  Run `rake` to create symlinks for all the configuration files.
8.  Run `brew bundle` to install all the packages, casks, and VS Code extensions listed in the `Brewfile`.
9.  Install personal Mac App Store apps via `Brewfile.mas` (automatically skipped if a work environment is detected).

## Commands

*   **Initial Setup:**
    ```bash
    sh ./bootstrap.sh
    ```

*   **Install MAS Apps:** To manually install personal Mac App Store apps:
    ```bash
    brew bundle --file=Brewfile.mas
    ```

*   **Update Brewfile:** To update both `Brewfile` and `Brewfile.mas` with currently installed packages:
    ```bash
    rake dump
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
*   **Package Management:** The `Brewfile` is the primary source of truth for command-line tools, GUI applications (casks), and VS Code extensions (`vscode`). Mac App Store apps (`mas`) are managed separately in `Brewfile.mas` to allow skipping them in environments where the App Store is restricted.
*   **Secrets:** Secrets are not stored in the repository. They are managed in 1Password and sourced into the shell environment by the `bootstrap.sh` script, creating files like `~/.secrets.sh` and `~/.work.sh`.
*   **Modularity:** Shell configuration is broken down into multiple files. The main entry point is `.zshrc.symlink`, which sources other files like `.aliases.symlink`, secret files, and work-specific overrides.
