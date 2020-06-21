#!/usr/bin/env bash
#
# Bootstrap script for setting up a new Ubuntu machine - GUI

echo "Starting bootstrapping"

echo "Adding package sources"

echo "Adding packages sources and installing software"

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
	arc-theme
	calibre
	chromium-browser
	default-jre
	emacs
	filezilla
	firefox
	google-chrome-stable
	handbrake
	kdiff3
	libreoffice
	meld
	mpv
	papirus-icon-theme
	steam
	sublime-text
	thunderbird
	transmission
	ubuntu-make
	virtualbox
	virtualbox-extension-pack
	vlc
	yacreader
	zeal	
)

echo "Installing gui apps..."
sudo apt install "${PACKAGES[@]}"

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

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

echo "Bootstrapping complete"
