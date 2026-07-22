## Install System Dependencies for Installing
These are the tools required to clone the system
```bash
#linux has git installed
#for macos:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install Homebrew
brew install git
#windows users won't like my dotfiles
```

## Clone The repo
```bash
git clone git@github.com:Landwhich/.dotfiles.git # ssh if setup
git clone https://github.com/Landwhich/.dotfiles.git # https if needed

brew bundle --file ~/.dotfiles/Brewfile # install my brew packages
```

## Run boostrap.sh script
```bash 
sh ./bootstrap.sh
```

## Additional steps
Further Steps to take in finalizing the system
### Maintain the repo (note to self):
```bash
brew bundle dump --force --describe --no-vscode
```
