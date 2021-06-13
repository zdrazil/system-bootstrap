#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - GUI

echo "Starting bootstrapping"

bash ./bootstrap-ubuntu-cli.sh

echo "Installing GUI packages..."
sudo apt-get install $(cat "$HOME/.config/packages/ubuntu-gui-packages" | sed '/^#/d')
snap install $(cat "$HOME/.config/packages/snap-packages" | sed '/^#/d')

echo "Bootstrapping complete"
