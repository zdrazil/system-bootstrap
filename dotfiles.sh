#!/usr/bin/env bash

git clone --bare git@github.com:zdrazil/my-preferences.git "$HOME/.cfg" --recurse-submodules

cd "$HOME"
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

