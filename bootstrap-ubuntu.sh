#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine

echo "Starting bootstrapping"

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list


REPOSITORIES=(
	'ppa:ubuntu-desktop/ubuntu-make'
	'ppa:linrunner/tlp'
	'ppa:papirus/papirus'
)

for repo in ${REPOSITORIES}; do
	sudo add-apt-repository ${repo}
done

# Update package database
sudo apt update

PACKAGES=(
	bash
	bash-completion
	zsh
	snapd
	ubuntu-make
	ack
	autojump
	arc-theme
	cmake
	coreutils
	curl
	dos2unix
	exuberant-ctags
	fasd
	findutils
	fish
	g++
	gcc
	git
	golang-go
	grep
	haskell-stack
	highlight
	htop
	make
	moreutils
	mpv
	ncdu
	nodejs
	p7zip-full
	p7zip-rar
	papirus-icon-theme
	pwgen
	python3
	ranger
	sed
	shellcheck
	speedtest-cli
	silversearcher-ag
	tig
	tlp 
	tlp-rdw 
	trash-cli
	tree
	unrar
	vim
	wakeonlan
	wget
	zplug
)

echo "Installing packages..."
sudo apt install "${PACKAGES[@]}"


GUI_PACKAGES=(
	baobab
	calibre
	code
	curl
	default-jre
	emacs
	filezilla
	firefox
	google-chrome-stable
	chromium-browser
	handbrake
	kdiff3
	keepassxc
	libreoffice
	meld
	mpv
	nautilus-dropbox
	picard
	steam
	sublime-text
	thunderbird
	transmission
	trimage
	vim-gnome
	virtualbox
	vlc
	zeal	
)

echo "Installing gui apps..."
sudo apt install "${GUI_PACKAGES[@]}"

echo "Cleaning up..."
sudo apt-get cleanup

sudo snap install webstorm --classic
sudo snap install pycharm-community --classic
sudo snap install intellij-idea-community --classic

SNAP_APPS=(
	spotify
)

for snaprepo in ${SNAP_APPS}; do
	sudo snap install ${snaprepo}
done

umake android
umake web firefox-dev

echo "Installing nix and packages..."
bash <(curl https://nixos.org/nix/install)

NIX_PACKAGES=(
	ripgrep
	fd
	tldr
	shfmt
)	

nix-env -i "${NIX_PACKAGES[@]}"

echo "Installing manual apps..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

echo "Installing global npm packages..."
NPM_PACKAGES=(
	eslint
	flow-bin
	prettier
	ramda-suggest
	stylelint
	stylelint-order
	svgo
	yarn
)
sudo npm install -g "${NPM_PACKAGES[@]}"

echo "Configuring Ubuntu..."
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}"


echo "Download dot files..."

git clone --bare git@bitbucket.org:zdrazil/my-preferences.git "$HOME/.cfg"

function config() {
	/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}
config checkout
exit_status=$?

if [ $exit_status = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	mkdir -p "$HOME/.config-backup"
	config checkout 2>&1 | grep -E "\\s+\\." | awk '{print $1}' | xargs -I{} mv {} "$HOME/.config-backup/"{}
	config checkout
fi
config config status.showUntrackedFiles no

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/packages/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/packages/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/packages/zsh-completions

echo "Bootstrapping complete"
