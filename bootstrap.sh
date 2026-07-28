#!bin/usr/env bash
#!bin/bash
export DOTFILE_DIR=${HOME}/.dotfiles

# conditionals for custom use and testing
export INSTALL_KEYBOARD=true

# -------------------------------
# install packages
# -------------------------------
# Brewfile
# brew bundle --file ~/.dotfiles/Brewfile
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt install -y $(cat ${DOTFILE_DIR}/bin/linux_deps.txt) > /dev/null 
    sudo apt -y update && -y sudo apt upgrade > /dev/null
    sudo apt -y autoremove > /dev/null
fi

#keyboard install 
if [[ "$INSTALL_KEYBOARD" == "true" ]];then
    cd ${DOTFILE_DIR}
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # needs kanata setup
        bash ${DOTFILE_DIR}/kanata/scripts/linux-config-kanata.sh
        mkdir -p ~/.config/systemd/user/
        ln -sf ${DOTFILE_DIR}/kanata/kanata.service ~/.config/systemd/user/kanata.service
        systemctl --user daemon-reload
        systemctl --user enable kanata.service
        systemctl --user start kanata.service
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask karabiner-elements
        #sh ./scripts/kanata/macos-kanata-install.sh 
        #echo "auth required to set launchctl settings:"
        #sudo sh ./scripts/kanata/macos-kanata-config.sh
        #echo "\n----------\nKanata Setup!\nrequires manual configuration in settings panel"
        #echo "instructions:\nhttps://github.com/jtroo/kanata/discussions/1537#:~:text=Set%20macOS%20to%20use%20the%20virtual%20keyboard"
        #echo "----------\n" 
    fi
fi  

# -------------------------------
# setup dirs and symbolic links
# -------------------------------
mkdir -p ~/.config
mkdir -p ~/.config/alacritty
ln -sf ${DOTFILE_DIR}/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
ln -sf ${DOTFILE_DIR}/tmux/.tmux.conf ~/.tmux.conf
ln -sf ${DOTFILE_DIR}/git/.gitconfig ~/.gitconfig
ln -sf ${DOTFILE_DIR}/vim ~/.vim
ln -sf ${DOTFILE_DIR}/vimrc ~/.vimrc

#(OS specific)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    mkdir -p ~/.config/kanata
    ln -sf ${DOTFILE_DIR}/kanata/kanata.kbd ~/.config/kanata/config.kbd
    echo "----\nKanata set up with config file"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "----\ninstalled vim plugin manager\n----"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    ln -sf ${DOTFILE_DIR}/karabiner/assets/complex_modifications/capslock.json ~/.config/karabiner/assets/complex_modifications/custom-capslock.json
    echo "----\nkarabiner is setup make sure to refresh and config\n----"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "----\ninstalled vim plugin manager\n----"
fi

#firefox profile config
firefox_profile=''
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	firefox_profile="$(ls -d ~/snap/firefox/common/.mozilla/firefox/*.default | head -n1)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	firefox_profile="$(ls -d ~/Library/Application\ Support/Firefox/Profiles/*.default-release | head -n1)"
fi

mkdir -p "$firefox_profile/chrome"
ln -sf ~/.dotfiles/firefox/userChrome.css "$firefox_profile/chrome/userChrome.css"
echo "----\nfirefox css downloaded"
echo "in firefox: search 'about:config'"
echo "head to: toolkit.legacyUserProfileCustomizations.stylesheets"
echo "and set the value to true\n----"

# setup additional static cli configs
git config --global core.exludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global

# -------------------------------
# cleanup any leftover files
# -------------------------------
