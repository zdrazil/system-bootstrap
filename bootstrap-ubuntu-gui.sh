#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - GUI

echo "Starting bootstrapping"

echo "Adding packages sources and installing software"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

REPOSITORIES=(
	'ppa:ubuntu-desktop/ubuntu-make'
	'ppa:linrunner/tlp'
)

for repo in ${REPOSITORIES}; do
	sudo add-apt-repository ${repo}
done

# Update package database
sudo apt update

echo "Installing gui apps..."
xargs sudo apt-get install < "$HOME/.config/packages/ubuntu-gui-packages"

echo "Cleaning up..."
sudo apt-get cleanup

sudo snap install --classic code
# sudo snap install webstorm --classic
# sudo snap install pycharm-community --classic
# sudo snap install intellij-idea-community --classic

SNAP_APPS=(
	zotero-snap
	spotify
)

for snaprepo in ${SNAP_APPS}; do
	sudo snap install ${snaprepo}
done

# umake android
umake web firefox-dev --lang en-US

echo "Bootstrapping complete"
