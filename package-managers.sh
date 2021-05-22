#!/usr/bin/env bash

echo "Download plugins and package managers..."

echo "Vim plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"

echo "fisher"
curl -sL https://git.io/fisher | source && fisher update 

echo "tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "zgen"
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

echo "Homebrew"
if [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew packages"
    brew bundle --verbose --file "$HOME/.config/packages/Brewfile"
    brew bundle --verbose --file "$HOME/.config/packages/BrewCaskFile" 
fi

echo "Nix"
if [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi
echo "Nix packages"
nix-env -i -f "$HOME/.config/packages/nix-packages.nix"


