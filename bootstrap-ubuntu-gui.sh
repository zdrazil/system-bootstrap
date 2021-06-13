#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - GUI

echo "Starting bootstrapping"

bash ./bootstrap-ubuntu-cli.sh

echo "Installing GUI packages..."
sudo apt-get install "$(cat "$HOME/.config/packages/ubuntu-gui-packages")"
snap install "$(cat "$HOME/.config/packages/snap-packages")"

echo "Bootstrapping complete"
