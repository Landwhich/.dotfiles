# install brewfile packages

# Typically not needed
# brew bundle --file ~/.dotfiles/Brewfile

# setup dir and symbolic links

mkdir -p ~/.config/alacritty
ln -sf ~/.dotfiles/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig

firefox_profile=''

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	firefox_profile="$(ls -d ~/.mozilla/firefox/*.default-release | head -n1)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	firefox_profile="$(ls -d ~/Library/Application\ Support/Firefox/Profiles/*.default-release | head -n1)"
	mkdir -p ~/.config/karabiner/assets/complex_modifications
	ln -sf ~/.dotfiles/karabiner/assets/complex_modifications/capslock.json ~/.config/karabiner/assets/complex_modifications
fi

mkdir -p "$firefox_profile/chrome"
ln -sf ~/.dotfiles/firefox/userChrome.css "$firefox_profile/chrome/userChrome.css"

# setup additional static cli configs

git config --global core.exludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global

