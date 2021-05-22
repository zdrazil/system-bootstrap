#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - CLI

echo "Starting bootstrapping"

sudo apt update

sudo apt install git
bash ./dotfiles.sh
bash ./package-managers.sh

echo "Installing packages..."
xargs sudo apt-get install < "$HOME/.config/packages/ubuntu-packages"

echo "Installing GUI packages..."
xargs sudo apt-get install < "$HOME/.config/packages/ubuntu-packages"

echo "Cleaning up..."
sudo apt-get clean

echo "Bootstrapping complete"
