#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - CLI

echo "Starting bootstrapping"

echo "Adding package sources and installing software"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Update package database
sudo apt update

PACKAGES_MAKE=(
	cmake
	g++
	gcc
	make
	tlp 
	tlp-rdw 
)

PACKAGES=(
	ack
	bash
	bash-completion
	coreutils
	curl
	dos2unix
	gnupg2
	findutils
	fish
	grep
	moreutils
	nodejs
	p7zip-full
	p7zip-rar
	pwgen
	sed
	snapd
	trash-cli
	tree
	unrar
	vim
	wakeonlan
	wget
	xclip
	zplug
	zsh
)

PACKAGES_SERVER=(
	fail2ban
)

echo "Installing packages..."
sudo apt install "${PACKAGES[@]}"
sudo apt install "${PACKAGES_MAKE[@]}"
sudo apt install "${PACKAGES_SERVER[@]}"

echo "Cleaning up..."
sudo apt-get clean

# Server
systemctl start fail2ban
systemctl enable fail2ban

echo "Installing Nix"
curl -L https://nixos.org/nix/install | sh

echo "Changing shell to fish..."

command -v fish | sudo tee -a /etc/shells
sudo chsh -s "$(command -v fish)" "${USER}"

echo "Download dot files..."

bash ./dotfiles.sh

echo "Installing nix packages"
nix-env -i -f .nix-packages.nix

echo "Download plugins and plugin managers..."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/packages/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/packages/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/packages/zsh-completions

echo "Bootstrapping complete"
