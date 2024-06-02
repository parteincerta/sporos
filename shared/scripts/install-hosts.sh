# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"

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

hostname="${1:-${HOSTNAME%.*}}"
ver="3.14.74"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${ver}/hosts"
system="$(uname -s)"

if [ "$system" = "Darwin" ]; then

	echo "-> Downloading StevenBlack's hosts v$ver ..."
	curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
		-L -sS -H "Accept:application/vnd.github.v3.raw" "$url" \
		-o "$TMPDIR"/hosts

	echo "-> Applying additions ..."
	# ------------------------------

	echo -e "\n# START --- General additions" >>"$TMPDIR/hosts"
	shared_address_list=$(jq -r ".shared | keys[]" "$this_script_rel_path/../install-hosts-additions.json")
	for addr in ${shared_address_list[*]}; do
		shared_names_list=$(jq -r ".shared[\"$addr\"][]" "$this_script_rel_path/../install-hosts-additions.json")
		for name in ${shared_names_list[*]}; do
			entry=$(eval echo "$name $addr")
			echo -e "$entry" >>"$TMPDIR/hosts"
		done
	done
	echo -e "# END --- General additions" >>"$TMPDIR/hosts"

	if [ -n "$1" ]; then
		echo -e "\n# START --- Specific additions for $1" >>"$TMPDIR/hosts"
		specific_address_list=$(jq -r ".specific.$1 // {} | keys[]" "$this_script_rel_path/../install-hosts-additions.json")
		for addr in ${specific_address_list[*]}; do
			specific_names_list=$(jq -r ".specific.$1[\"$addr\"][]" "$this_script_rel_path/../install-hosts-additions.json")
			for name in ${specific_names_list[*]}; do
				entry=$(eval echo "$name $addr")
				echo -e "$entry" >>"$TMPDIR/hosts"
			done
		done
		echo -e "# END --- Specific additions for $1" >>"$TMPDIR/hosts"
	fi

	echo "-> Applying exclusions ..."
	# -------------------------------

	shared_address_list=$(jq -r '.shared | join(" ")' "$this_script_rel_path/../install-hosts-exclusions.json")
	for name in ${shared_address_list[*]}; do
		sed -i -r "/^$name/s//#&/g" "$TMPDIR/hosts"
	done

	if [ -n "$1" ]; then
		specific_address_list=$(jq -r ".specific.$1 // [] | join(\" \")" "$this_script_rel_path/../install-hosts-exclusions.json")
		for name in ${specific_address_list[*]}; do
			sed -i -r "/^$name/s//#&/g" "$TMPDIR/hosts"
		done
	fi

	echo "-> Setting new /private/etc/hosts ..."
	sudo mv "$TMPDIR"/hosts /private/etc/hosts

elif [ "$system" = "Linux" ]; then
	#TODO
	:
fi