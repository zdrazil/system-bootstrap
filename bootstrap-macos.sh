#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine

echo "Starting bootstrapping"

bash ./dotfiles.sh
bash ./package-managers.sh
bash ./macos-configuration.sh

echo "Bootstrapping complete"
