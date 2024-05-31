# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"

source "$shared_dir"/helper.sh

trap_error () {
	local exit_code=$?
	local failed_cmd="$BASH_COMMAND"
	local failed_line_nr="$BASH_LINENO"
	echo ">>> Failed the execution of $this_script on line $failed_line_nr."
	echo ">>> Command '$failed_cmd' failed with exit code $exit_code."
}

set -e
trap trap_error ERR

force_disable_brave () {
	[ ! -d "/Applications/Brave Browser.app" ] && return 0

	echo ">>> Disabling Brave's automatic updates ..."

	local updater_path=$(join_strings \
		"/Applications/Brave Browser.app/Contents/Frameworks/"\
		"Brave Browser Framework.framework/Versions/Current/"\
		"/Frameworks/Sparkle.framework/Versions/A/Resources"
	)
	$(
		cd "$updater_path" &&
		[ -d "Autoupdate.app" ] &&
		mv Autoupdate.app DisableAutoupdate.app ||
		true
	)
}

force_disable_chrome () {
	[ ! -d "$HOME"/Library/Google/GoogleSoftwareUpdate ] && return 0

	echo ">>> Disabling Google Chrome's automatic updates ..."
	sudo chown nobody:nobody "$HOME"/Library/Google/GoogleSoftwareUpdate
	sudo chmod 000 "$HOME"/Library/Google/GoogleSoftwareUpdate
}

force_disable_brave
force_disable_chrome
echo ">>> Done!"