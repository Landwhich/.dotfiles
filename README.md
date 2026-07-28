## Install System Dependencies for Dotfile Cloning
These are the tools required to clone the system
```bash
#linux has git installed
#for macos:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install Homebrew
brew install git
#windows users won't like my dotfiles
```

## Clone The Repo
```bash
git clone git@github.com:Landwhich/.dotfiles.git # ssh if setup

git clone https://github.com/Landwhich/.dotfiles.git # https if needed
```
```bash
brew bundle --file ~/.dotfiles/Brewfile # install my brew packages
```

## Run boostrap.sh Script
```bash 
sh ./bootstrap.sh
```

### Extra Baloney:"
- finalize firefox styling by going to `about:config` and setting `toolkit.legacyUserProfileCustomizations.stylesheet` to `true 
```bash
#maintain brewfile:
brew bundle dump --force --describe --no-vscode
```
