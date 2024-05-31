# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"

trap_error () {
	local exit_code=$?
	local failed_cmd="$BASH_COMMAND"
	local failed_line_nr="$BASH_LINENO"
	echo ">>> Failed the execution of $this_script on line $failed_line_nr."
	echo ">>> Command '$failed_cmd' failed with exit code $exit_code."
}

trap_exit () {
	rm -rf "$TMPDIR"/hosts
}

set -e
trap trap_error ERR
trap trap_exit EXIT

vsc_data_dir="$XDG_CACHE_HOME/code/data/"
vsc_extensions_dir="$XDG_CACHE_HOME/code/extensions/"
[ "$1" = "--extensions-list" ] &&
	vsc_extensions_list=$(cat "${this_script_abs_path}/${2}") ||
	vsc_extensions_list=$(cat "$this_script_abs_path"/extensions.vscode.txt)

for extension in $vsc_extensions_list
do
	extension_author=${extension##*.}
	extension_name=${extension##*.}
	echo -e "\t-> Installing $extension_name"
	code \
		--user-data-dir "$vsc_data_dir" \
		--extensions-dir "$vsc_extensions_dir" \
		--install-extension "$extension" \
		--force &>/dev/null
done