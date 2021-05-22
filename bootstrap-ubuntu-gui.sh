#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - GUI

echo "Starting bootstrapping"

bash ./bootstrap-ubuntu-cli.sh

echo "Installing GUI packages..."
xargs sudo apt-get install < "$HOME/.config/packages/ubuntu-gui-packages"
xargs sudo snap install < "$HOME/.config/packages/snap-packages"

echo "Bootstrapping complete"
