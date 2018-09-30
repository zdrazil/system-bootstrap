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

PACKAGES=(
	bash
	bash-completion
	zsh
	zsh-completions
	ack
	autojump
	cmake
	ctags
	coreutils
	dos2unix
	fasd
	fd
	findutils
	fish
	fzf
	git
	gnu-sed
	grep
	haskell-stack
	highlight
	htop
	httpie
	jq
	moreutils
	mpv
	ncdu
	node
	p7zip
	pwgen
	python
	python3
	ranger
	readline
	ripgrep
	shellcheck
	shfmt
	speedtest-cli
	the_silver_searcher
	tig
	tldr
	tokei
	trash
	tree
	unrar
	'vim --with-gettext --with-lua --with-tcl'
	wakeonlan
	wget
	youtube-dl
	zplug
)

echo "Installing packages..."
brew install "${PACKAGES[@]}"

echo "Cleaning up..."
brew cleanup

CASKS=(
	air-video-server-hd
	alfred
	android-file-transfer
	appcleaner
	applepi-baker
	bbedit
	bettertouchtool
	calibre
	caskroom/versions/firefox-developer-edition
	catch
	dash
	db-browser-for-sqlite
	disk-inventory-x
	dropbox
	emacs
	filebot
	filezilla
	firefox
	flux
	freac
	get-lyrical
	gog-galaxy
	google-backup-and-sync
	google-chrome
	grandperspective
	handbrake
	imageoptim
	iina
	inkscape
	intellij-idea-ce
	iterm2
	java
	jubler
	karabiner-elements
	kdiff3
	keka
	keepassxc
	keycastr
	libreoffice
	lyricfier
	macvim
	music-manager
	musicbrainz-picard
	nightowl
	namebench
	openrefine
	origin
	playonmac
	plex-media-server
	poedit
	pycharm-ce
	rstudio
	scummvm
	shifty
	skim
	skype
	slack
	sourcetree
	spectacle
	spotify
	steam
	subler
	sublime-text
	subsmarine
	textual
	thunderbird
	toggl
	transmission
	usb-overdrive
	veracrypt
	virtualbox
	visual-studio-code
	vlc
	vmware-fusion
	wakeonlan
	webstorm
	yacreader
)

echo "Installing cask apps..."
brew cask install "${CASKS[@]}"

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
defaults write com.apple.Terminal Shell "/usr/local/bin/zsh"

# Spectacle.app
# Set up my preferred keyboard shortcuts
cp -r init/spectacle.json ~/Library/Application\ Support/Spectacle/Shortcuts.json 2>/dev/null

# Transmission
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Library/Application Support/Incomplete Torrents"
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Torrents"
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.trasmission BlocklistAutoUpdate -bool true
defaults write org.m0k.transmission DownloadLimit -int 1500
defaults write org.m0k.transmission UploadLimit -int 0
defaults write org.m0k.transmission SpeedLimitUploadLimit -int 0
defaults write org.m0k.transmission SpeedLimitDownloadLimit -int 700
defaults write org.m0k.transmission EncryptionPrefer -bool true

echo "Download dot files..."

git clone --bare git@bitbucket.org:zdrazil/my-preferences.git "$HOME/.cfg"

function config() {
	/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}
config checkout
exit_status=$?

if [ $exit_status = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	mkdir -p "$HOME/.config-backup"
	config checkout 2>&1 | grep -E "\\s+\\." | awk '{print $1}' | xargs -I{} mv {} "$HOME/.config-backup/"{}
fi
config checkout
config config status.showUntrackedFiles no

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/packages/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/packages/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/packages/zsh-completions

echo "Bootstrapping complete"
