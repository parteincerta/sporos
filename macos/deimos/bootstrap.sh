#!/bin/bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"
shared_dir_macos="$(cd $this_script_abs_path/../../shared_macos >/dev/null && pwd)"

set -e
source "$shared_dir/scripts/helper.sh"
trap trap_error ERR
pushd "$this_script_abs_path" >/dev/null
trap "popd >/dev/null" EXIT


source .env.sh || true
bootstrap_mark_file="$XDG_CACHE_HOME/.bootstrapped"
if [ -s "$bootstrap_mark_file" ]; then
	log_warning ">>> This system was previously bootstrapped."
	log_warning ">>> To restart the process: \$ rm $bootstrap_mark_file"
	exit 1
fi

if [ "deimos" != "$system_hostname" ]; then
	log_warning ">>> This bootstrap script belongs to another host: deimos".
	log_warning ">>> The current host is: $system_hostname"
	exit 1
fi

log_info "\t >>> Installing dotfiles"
/bin/bash configure.sh


log_info "\t >>> Configuring the Desktop and keyboard"
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.30
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Doesn't work on macOS Sonoma
# defaults write com.apple.Safari DebugDisableTabHoverPreview 1

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSWindowShouldDragOnGesture -bool true

if [ -z "$(command -v brew)" ]; then
	log_info "\t >>> Installing Homebrew"
	homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
	/bin/bash -c "$(curl --fail --location --silent --show-error $homebrew_url)"
fi


log_info "\t >>> Installing Homebrew apps"
homebrew_cli=(
	7zip aria2 asdf bat bash bash-completion@2 bear bzip2 coreutils eza fd
	findutils fish font-jetbrains-mono-nerd-font fzf gettext gh git-delta gnupg
	gsed jq lf libpq miniserve mkcert moreutils neovim oha pbzip2 pigz rclone
	ripgrep tokei xz zstd
)
brew install ${homebrew_cli[*]}


log_info "\t >>> Installing Homebrew casks"
compass="mongodb-compass-isolated-edition"
microsoft=(microsoft-{excel,powerpoint,remote-desktop,word})
homebrew_casks=(
	alt-tab araxis-merge basictex betterdisplay brave-browser bruno chatgpt
	$compass docker fork iina kitty mac-mouse-fix ${microsoft[*]} numi obs
	signal tableplus transmission visual-studio-code whatsapp
)
brew install --cask ${homebrew_casks[*]}


log_info "\t >>> Sourcing environment variables and re-installing dotfiles"
source .env.sh
/bin/bash configure.sh
bat cache --build

log_info "\t >>> Setting up the host file"
source "$shared_dir/scripts/install-hosts.sh" deimos


log_info "\t >>> Installing PIP packages"
pip3 install --user wheel
pip3 install --user pynvim


log_info "\t >>> Installing ASDF packages"
asdf_plugins=("bun:1*" "golang:" "nodejs:18*" "zig:")

for item in ${asdf_plugins[*]}
do
	plugin_name="${item%%:*}"
	plugin_target="${item##*:}"
	plugin_version="${plugin_target%%\**}"
	plugin_is_global="${plugin_target: -1}"

	if [ -z "$(asdf list | grep $plugin_name)" ]; then
		asdf plugin-add "$plugin_name"
	fi

	[ -n "$plugin_name" ] &&
	[ -n "$plugin_version" ] &&
		asdf install "$plugin_name" "latest:$plugin_version" || true

	[ -n "$plugin_name" ] &&
	[ -n "$plugin_version" ] &&
	[ -n "$plugin_is_global" ] &&
		asdf global "$plugin_name" "latest:$plugin_version" || true
done


log_info "\t >>> Installing MongoDB Shell and Tools"
source "$shared_dir/scripts/install-mongo-utils.sh" shell
source "$shared_dir/scripts/install-mongo-utils.sh" tools


log_info "\t >>> Installing Neovim plugins"
nvim --headless -c "Lazy! install" -c qall


log_info "\t >>> Installing VSCode plugins"
source "$shared_dir/scripts/install-plugins-vscode.sh"


log_info "\t >>> Ignoring Focusrite Scarlett Solo automount"
echo "UUID=DC798778-543D-396B-A11F-2EC42F3500F9 none msdos ro,noauto" |
	sudo tee -a /etc/fstab >/dev/null


if [ -z "$(grep "$HOMEBREW_PREFIX/bin/bash" /etc/shells)" ]; then
	log_info "\t >>> Setting Homebrew's bash as the default shell"
	echo "$HOMEBREW_PREFIX/bin/bash" | sudo tee -a /etc/shells
	chsh -s "$HOMEBREW_PREFIX/bin/bash" "$(whoami)"
fi


echo "ok" > "$bootstrap_mark_file"
log_success "\t >>> Finished!"