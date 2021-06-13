#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - CLI

echo "Starting bootstrapping"

sudo apt update

sudo apt install git curl xclip vim-gtk3 nodejs npm
bash ./dotfiles.sh
echo "Installing packages..."
sudo apt-get install "$(cat "$HOME/.config/packages/ubuntu-packages")"

bash ./package-managers.sh

echo "Cleaning up..."
sudo apt-get clean

echo "Bootstrapping complete"
