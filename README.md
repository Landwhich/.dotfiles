## Install system dependencies
These are the tools required to clone the system
### MacOS:
```bash
xcode-select install
```

## Clone .dotfiles repo
```bash
git clone git@github.com:Landwhich/.dotfiles.git # ssh if setup
git clone https://github.com/Landwhich/.dotfiles.git # https if needed
```

## Run boostrap.sh script
```bash 
sh ./bootstrap.sh
```

## Additional steps
Further Steps to take in finalizing the system
### Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install Homebrew
brew bundle --file ~/.dotfiles/Brewfile # install commonly used brew packages
```