#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
	echo "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update
brew bundle --global

brew cleanup

echo "Installing global npm packages..."
NPM_PACKAGES=(
	eslint
	flow-bin
	prettier
	ramda-suggest
	stylelint
	stylelint-order
	svgo
	yarn
)
npm install -g "${NPM_PACKAGES[@]}"

echo "Configuring OSX..."

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable sound effects when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0

# Use a dark menu bar / dock
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Allow fast user switching (icon style, in the menu bar)
defaults write NSGlobalDomain userMenuExtraStyle -int 2

# Show the Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Don't show Siri in the menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# New Finder windows points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Use previous scope as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCsp"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Enable scroll gesture (with modifier) to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Allow tap to click for Apple trackpad devices
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool false

# Set hiding effect to scale
defaults write com.apple.Dock mineffect scale

# Set time to show date and day of the week
defaults write com.apple.menuextra.clock "DateFormat" "EEE MMM d  h:mm"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Set up Terminal
defaults write com.apple.Terminal Shell "/usr/local/bin/fish"

# Spectacle.app
# Set up my preferred keyboard shortcuts
cp -r init/spectacle.json ~/Library/Application\ Support/Spectacle/Shortcuts.json 2>/dev/null

echo "Download dot files..."
bash ./dotfiles.sh

echo "Download plugins and plugin managers..."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/packages/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/packages/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/packages/zsh-completions

echo "Bootstrapping complete"
