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


xcode_cli_tools_path="$(xcode-select --print-path)"
if [ $? ]; then
	log_info "\t >>> XCode CLI Tools available at: $xcode_cli_tools_path"
else
	log_error "\t >>> XCode CLI Tools not available."
	log_error "\t >>> To install them: \$ xcode-select --install"
	exit 1
fi


source .env.sh || true
bootstrap_mark_file="$XDG_CACHE_HOME/.bootstrapped"
if [ -s "$bootstrap_mark_file" ]; then
	log_warning ">>> This system was previously bootstrapped."
	log_warning ">>> To restart the process: \$ rm $bootstrap_mark_file"
	exit 1
fi

if [ "phobos" != "$system_hostname" ]; then
	log_warning ">>> This bootstrap script belongs to another host: phobos".
	log_warning ">>> The current host is: $system_hostname"
	exit 1
fi

log_info "\t >>> Setting up the host file"
/bin/bash configure.sh


log_info "\t >>> Configuring the Desktop and keyboard"
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.30
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# defaults write com.apple.Safari DebugDisableTabHoverPreview 1
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSWindowShouldDragOnGesture -bool true
killall Dock


log_info "\t >>> Installing Apple Rosetta"
/usr/sbin/softwareupdate --install-rosetta --agree-to-license


if [ -z "$(command -v brew)" ]; then
	log_info "\t >>> Installing Homebrew"
	homebrew_url="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
	/bin/bash -c "$(curl --fail --location --silent --show-error $homebrew_url)"
fi


log_info "\t >>> Installing Homebrew apps"
homebrew_cli=(
	7zip aria2 asdf bat bash bash-completion@2 bear bzip2 coreutils eza fd
	findutils fish font-jetbrains-mono-nerd-font fzf gettext git-delta gnupg
	gsed jq lf libpq miniserve mkcert moreutils neovim oha pbzip2 pigz rclone
	ripgrep tokei xz zstd
)
brew install ${homebrew_cli[*]}


# `jdtls` has two dependencies: `openjdk` and `python@3.12`.
# `openjdk` will be handled by ASDF. `python@3.12` will be installed next.
# Hence the usage of --ignore-dependencies.
brew install --ignore-dependencies gradle jdtls maven

# Java's LSP needs Homebrew's Python (see `brew info jdtls`) but we don't so
# lets unlink it after installation.
brew install python@3.12
brew unlink python@3.12


log_info "\t >>> Installing Homebrew casks"
compass="mongodb-compass-isolated-edition"
microsoft=(microsoft-{excel,powerpoint,remote-desktop,word})
homebrew_casks=(
	alt-tab araxis-merge basictex betterdisplay brave-browser bruno chatgpt
	$compass docker fork iina kitty mac-mouse-fix ${microsoft[*]} numi obs
	signal tableplus transmission visual-studio-code whatsapp zoom
)
brew install --cask ${homebrew_casks[*]}


log_info "\t >>> Sourcing environment variables and re-installing dotfiles"
source .env.sh
/bin/bash configure.sh
bat cache --build

log_info "\t >>> Setting up the hosts file"
source "$shared_dir/scripts/install-hosts.sh" phobos


log_info "\t >>> Installing PIP packages"
pip3 install --user wheel
pip3 install --user pynvim


log_info "\t >>> Installing ASDF packages"
asdf plugin-add bun
asdf install bun latest:1
asdf global bun latest:1

asdf plugin-add
asdf install java latest:graalvm-community-21
asdf install java latest:temurin-21
asdf global java latest:temurin-21

asdf plugin-add nodejs
# Workaround to build Node.js v14 on Apple Silicon.
# https://github.com/nodejs/node/issues/52230#issuecomment-2148778308
CPPFLAGS='-Wno-enum-constexpr-conversion' asdf install nodejs latest:14
asdf install nodejs latest:18
asdf global nodejs latest:18


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