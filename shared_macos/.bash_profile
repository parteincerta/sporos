# vim:ft=bash

this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
source "$this_script_abs_path"/.env.sh

# NOTE: Don't replace the white spaces at the start of the lines
# The play a role the the format of the prompt.
PS1="\[$(tput setaf 5)\]\A\[$(tput sgr0)\]\
 \w$([ -n "$LF_LEVEL" ] && echo " lf:$LF_LEVEL")\
 \[$(tput setaf 6)\]>\[$(tput sgr0)\] "

export CLICOLOR=1
export HISTSIZE=32768
export HISTFILESIZE=32768
export HISTCONTROL=ignoreboth:ereasedups
export HISTIGNORE="?:??:???:????:?????"
export HISTTIMEFORMAT="%F %T "

# Based on https://github.com/mrzool/bash-sensible
# ------------------------------------------------
if [[ $- == *i* ]]; then
	shopt -s checkwinsize
	PROMPT_DIRTRIM=3
	bind Space:magic-space
	shopt -s globstar 2>/dev/null
	shopt -s nocaseglob
	bind "set blink-matching-paren on"
	bind "set colored-completion-prefix on"
	bind "set colored-stats on"
	bind "set completion-ignore-case on"
	bind "set completion-map-case on"
	bind "set editing-mode vi"
	bind "set keymap vi"
	bind "set mark-symlinked-directories on"
	bind "set show-all-if-ambiguous on"
	bind "set show-mode-in-prompt on"
	bind "set visible-stats on"
	bind "set vi-cmd-mode-string $(tput setaf 4)cmd $(tput sgr0)"
	bind "set vi-ins-mode-string"
	shopt -s histappend
	shopt -s cmdhist
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
	bind -m vi-insert '"\C-k": clear-display'
	bind -m vi-insert '"\C-l": clear-screen'
	bind -m vi-insert '"\C-p": history-search-backward'
	bind -m vi-insert '"\C-n": history-search-forward'
	bind '"\e[C": forward-char'
	bind '"\e[D": backward-char'
	shopt -s autocd 2>/dev/null
	shopt -s direxpand 2>/dev/null
	shopt -s dirspell 2>/dev/null
	shopt -s cdspell 2>/dev/null
	CDPATH="."
	shopt -s cdable_vars
fi


ads="/Applications/'Azure Data Studio.app'/Contents/Resources/app/bin/code"
ads_data_dir="$XDG_CACHE_HOME/ads/data/"
ads_extensions_dir="$XDG_CACHE_HOME/ads/extensions/"
vsc_data_dir="$XDG_CACHE_HOME/code/data/"
vsc_extensions_dir="$XDG_CACHE_HOME/code/extensions/"

alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ads="$ads --user-data-dir $ads_data_dir --extensions-dir $ads_extensions_dir"
alias beep="tput bel"
alias brewi="brew info"
alias brewo="brew outdated"
alias brewog="brew outdated --greedy"
alias brews="brew search"
alias brewu="brew update --verbose"
alias code="code --user-data-dir $vsc_data_dir --extensions-dir $vsc_extensions_dir"
alias compose="docker compose"
alias gita="git add"
alias gitaa="git add --all"
alias gitaac="git add --all && git commit -v"
alias gitau="git add -u"
alias gitauc="git add -u && git commit -v"
alias gitb="git branch"
alias gitc="git commit -v"
alias gitcfddx="git clean -fddx"
alias gitco="git checkout"
alias gitd="git diff"
alias gitds="git diff --staged"
alias gitf="git fetch"
alias gitfp="git fetch --prune"
alias gitl="git log"
alias gitlo="git log --oneline"
alias gitm="git merge"
alias gitma="git merge --abort"
alias gitp="git pull"
alias gitpb="git pull origin \$(git rev-parse --abbrev-ref HEAD)"
alias gitpr="git pull --rebase"
alias gits="git status"
alias gitss="git status -s"
alias gitst="git stash"
alias gitstp="git stash pop"
alias gitui-noskip="git update-index --no-skip-worktree"
alias gitui-skip="git update-index --skip-worktree"
alias gitui-skip-list="git ls-files -v | grep ^S"
alias gitwa="git worktree add"
alias gitwl="git worktree list"
alias gitwr="git worktree remove"
alias l="eza -1"
alias la="eza -1a"
alias lar="eza -1aR"
alias less="$NVIM_PAGER"
alias lh="eza -1ad .??*"
alias ll="eza -lhS --icons"
alias lla="eza -ahlS --icons"
alias llar="eza -ahlRS --icons"
alias llat="eza -ahlS --icons --total-size"
alias llh="eza -adhlS --icons .??*"
alias llr="eza -lhRS --icons"
alias llt="eza -lhS --icons --total-size"
alias lr="eza -1R"
alias ls="eza"
alias lsa="eza -ah"
alias n="nvim"
alias nn="nvim -n -u NONE -i NONE"
alias npma="npm audit"
alias npmci="npm ci"
alias npmcip="npm ci --production"
alias npmi="npm install"
alias npmo="npm outdated"
alias npmog="npm outdated -g"
alias npmr="npm run"
alias npmrb="npm run build"
alias npmrd="npm run dev"
alias npmrs="npm run start"
alias npms="npm search"
alias q="exit"
alias tar="COPYFILE_DISABLE=1 tar"

[ -r "$HOMEBREW_PREFIX"/etc/profile.d/bash_completion.sh ] &&
	source "$HOMEBREW_PREFIX"/etc/profile.d/bash_completion.sh

if [ -r "$HOMEBREW_PREFIX"/opt/fzf/shell/key-bindings.bash ]; then
	eval "$(fzf --bash)"
	[[ $- == *i* ]] &&
		bind -m vi-insert -x '"\C-e": "__fzf_cd__;"'
fi

[[ $- == *i* ]] &&
	source "$HOMEBREW_PREFIX"/opt/fzf/shell/completion.bash


# (re)Apply specific environment settings on demand.
ambient () {
	local category="$1"
	local command="$2"
	local args="${@:3}"

	if [ "$category" = "kbd" ]; then
		if [ "$command" = "remap" ]; then

			[ "${args[0]}" = "apple.mbp15" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0x0263, "VendorID": 0x05AC }' \
					--set \
					'{ "UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					}]}' >/dev/null &&
				echo "ambient: Apple's keyboard map successfully applied."

			[ "${args[0]}" = "apple.mbp16" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0x0000, "VendorID": 0x0000 }' \
					--set \
					'{ "UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					}]}' >/dev/null &&
				echo "ambient: Apple's keyboard map successfully applied."

			[ "${args[0]}" = "apple-magic" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0x029C, "VendorID": 0x004C }' \
					--set \
					'{ "UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					}]}' >/dev/null &&
				echo "ambient: Apple's keyboard map successfully applied."

			[ "${args[0]}" = "ozone" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0xA096, "VendorID": 0x04D9 }' \
					--set \
					'{"UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000064,
						"HIDKeyboardModifierMappingDst": 0x700000035
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000035,
						"HIDKeyboardModifierMappingDst": 0x700000031
					},{
						"HIDKeyboardModifierMappingSrc": 0x70000002F,
						"HIDKeyboardModifierMappingDst": 0x70000002E
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000034,
						"HIDKeyboardModifierMappingDst": 0x70000002F
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000031,
						"HIDKeyboardModifierMappingDst": 0x700000034
					}]}' >/dev/null &&
				echo "ambient: Ozone's keyboard map successfully applied."

			[ "${args[0]}" = "ducky" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0x0123, "VendorID": 0x0416 }' \
					--set \
					'{"UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000064,
						"HIDKeyboardModifierMappingDst": 0x700000035
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000035,
						"HIDKeyboardModifierMappingDst": 0x700000031
					},{
						"HIDKeyboardModifierMappingSrc": 0x70000002F,
						"HIDKeyboardModifierMappingDst": 0x70000002E
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000034,
						"HIDKeyboardModifierMappingDst": 0x70000002F
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000031,
						"HIDKeyboardModifierMappingDst": 0x700000034
					}]}' >/dev/null &&
				echo "ambient: Ducky's keyboard map successfully applied."

			[ "${args[0]}" = "varmilo" ] &&
				/usr/bin/hidutil property \
					--matching \
					'{ "ProductID": 0x024F, "VendorID": 0x05AC }' \
					--set \
					'{"UserKeyMapping":[{
						"HIDKeyboardModifierMappingSrc": 0x700000039,
						"HIDKeyboardModifierMappingDst": 0x700000029
					},{
						"HIDKeyboardModifierMappingSrc": 0x7000000E2,
						"HIDKeyboardModifierMappingDst": 0x7000000E3
					},{
						"HIDKeyboardModifierMappingSrc": 0x7000000E3,
						"HIDKeyboardModifierMappingDst": 0x7000000E2
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000064,
						"HIDKeyboardModifierMappingDst": 0x700000035
					},{
						"HIDKeyboardModifierMappingSrc": 0x700000035,
						"HIDKeyboardModifierMappingDst": 0x700000064
					}]}' >/dev/null &&
				echo "ambient: Varmilo's keyboard map successfully applied."

			[ "${args[0]}" = "clear" ] &&
				/usr/bin/hidutil property \
					--set '{ "UserKeyMapping":[]}' >/dev/null &&
					echo "ambient: Keyboard maps successfully cleared."
		else
			echo "Usage:"
			echo "> ambient kbd remap apple"
			echo "> ambient kbd remap ozone"
			echo "> ambient kbd remap varmilo"
		fi
	else
		echo "Usage: ambient <category> <command> <args>..."
	fi
}

# Copy a file or directory into the clipboard.
clipit () {
	if [ -f "$1" ] || [ -d "$1" ]; then
		osascript -e{'on run{a}','set the clipboard to posix file a',end} \
		"$(greadlink -f -- "$1")"
	fi
}

# Start lf in the current directory or in the given one.
e () {
	BASH_ENV="$HOME/.bash_profile" lf "$1"
	if [ -f "$TMPDIR"/lfcd ]; then
		local dir=$(cat "$TMPDIR"/lfcd)
		[ -d "$dir" ] && cd "$dir"
		rm -rf "$TMPDIR"/lfcd
	fi
}

# Decrypt password-encrypted file.
gpg_dec_file () {
	local src="$1"
	local dst="$2"
	if [ -s "$src" ]; then
		[ -z "$dst" ] && gpg --decrypt "$src" 2>/dev/null | pager
		[ -n "$dst" ] && gpg --symmetric "$src" > "$dst"
	fi
}

# Encrypt a file with a password.
gpg_enc_file () {
	local src="$1"
	local dst="$2"
	if [ -s "$src" ]; then
		[ -z "$dst" ] && gpg --symmetric "$src"
		[ -n "$dst" ] && gpg --symmetric "$src" "$dst"
	fi
}

# Create a directory if it doesn't exist and cd into it.
mkcd () {
	if [ -n "$1" ]; then
		mkdir -p "$1" && cd "$1"
	else
		echo "Usage: mkcd <dir>"
	fi
}

# Create and edit text notes in iCloud
notes () {
	if [ -n "$1" ]; then
		local path="$(dirname $1)"
		local file="$(basename $1)"
		mkdir -p "${ICLOUD}/${path}"
		if [ -n "$file" ]; then
			local file="$(sanitize $file)"
			touch "${ICLOUD}/${path}/$file"
			env IS_NOTES=yes nvim -n "${ICLOUD}/${path}/$file" -c "cd %:h"
		else
			env IS_NOTES=yes nvim -n "${ICLOUD}/${path}/"  -c "cd %:h"
		fi
	elif [ -z "$1" ]; then
		e "$ICLOUD"
	fi
}

# Pager-like implementation using neovim
pager () {
	local target="-"
	[ -n "$1" ] && target="$1"

	nvim -n -u NONE -i NONE -R \
		-c "map q :q<CR>" \
		-c "set laststatus=0" -c "set number" \
		-c "syntax on" "$target"
}

# Purge temporary data from some programs.
purge () {
	if [ "$1" == "bash" ]; then
		history -c
		[ -f "$HOME/.bash_history" ] && secrm "$HOME/.bash_history"

	elif [ "$1" == "clipboard" ]; then
		pbcopy < /dev/null

	elif [ "$1" == "nvim" ]; then
		for file in "$XDG_DATA_HOME"/nvim/shada/*.shada; do
			rm -f "$file"
		done
		for file in "$XDG_STATE_HOME"/nvim/shada/*.shada; do
			rm -f "$file"
		done

		[ -d "$XDG_STATE_HOME"/nvim/undo/ ] &&
		[ -n "$(lsa "$XDG_STATE_HOME"/nvim/undo/)" ] &&
			rm -rf "$XDG_STATE_HOME"/nvim/undo/*

	else echo "Usage purge bash|clipboard|nvim."
	fi
}

push_route () {
	target="$1"

	# NOTES
	# 1. To only add specific hosts instead of an address range:
	#	sudo route add -host 192.168.123.124 -interface ppp0

	if [ "$target" = "icnew" ]; then
		sudo route add -net 192.168.123.0/24 -interface ppp0

		if [ $? -eq 0 ]; then
			read -p "Hit <Enter> to pop route (a password might be requested) ..."
			sudo route delete -net 192.168.123.0/24 -interface ppp0
		fi
		return
	else
		echo "push_route icnew"
	fi
}

# Taken from https://stackoverflow.com/a/44811468
# Sanite a string to produce a valid file name.
sanitize () {
	local s="$1"
	s="${s//[^[:alnum:]\.]/-}"
	s="${s//+(-)/-}"
	s="${s/#-}"
	s="${s/%-}"
	echo "$s"
	# ... or convert to lowercase
	# echo "${s,,}"
}

# Remove files in a secure manner using GNU shred.
secrm () {
	if [ $# -eq 0 ]; then
		echo "Usage: secrm <file>|<dir>"
		return 1
	fi

	for i in "$@"; do

		local item="$i"
		if [ -f "$item" ]; then
			chmod u+w "$item" &&
			shred --iterations=1 --random-source=/dev/urandom -u --zero "$item" &&
			echo "shred $item"

		elif [ -h "$item" ]; then
			rm "$item" >/dev/null &&
			echo "rm $item"

		elif [ -d "$item" ]; then
			chmod u+wx "$item"
			pushd "$item" >/dev/null
				secrm $(eza -ah --color=never "../$item")
				local res=$?
			popd >/dev/null
			[ $res -eq 0 ] &&
				rmdir "$item" &&
				echo "rmdir $item/"
		fi
	done
}

test_underline_styles () {
	echo -e "\x1b[4:0m4:0 none\x1b[0m \x1b[4:1m4:1 straight\x1b[0m " \
		"\x1b[4:2m4:2 double\x1b[0m \x1b[4:3m4:3 curly" \
		"\x1b[0m \x1b[4:4m4:4 dotted\x1b[0m \x1b[4:5m4:5 dashed\x1b[0m"
}

test_underline_colors () {
	echo -e "\x1b[4;58:5:203mred underline (256)" \
		"\x1b[0m \x1b[4;58:2:0:255:0:0mred underline (true color)\x1b[0m"
}