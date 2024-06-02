# vim:ft=bash

this_script="$(basename ${BASH_SOURCE[0]})"

trap_error () {
	local exit_code=$?
	local failed_cmd="$BASH_COMMAND"
	local failed_line_nr="$BASH_LINENO"
	echo ">>> Failed the execution of $this_script on line $failed_line_nr."
	echo ">>> Command '$failed_cmd' failed with exit code $exit_code."
}

trap_exit () {
	rm -rf "$TMPDIR"/mongodb*
	rm -rf "$TMPDIR"/mongosh*
}

set -e
trap trap_error ERR
trap trap_exit EXIT

arch="$(uname -m)"
system="$(uname -s)"

if [ "$1" == "shell" ]; then
	rm -rf "$TMPDIR"/mongosh*

	version="2.2.6"

	if [ "$system" = "Darwin" ]; then
		[ "$arch" = "x86_64" ] && arch="x64" || true
		url="https://downloads.mongodb.com/compass/mongosh-${version}-darwin-${arch}.zip"

		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "$TMPDIR"mongosh.zip

		echo "-> Extracting "$TMPDIR"mongosh.zip ..."
		unzip "$TMPDIR"/mongosh.zip -d "$TMPDIR" >/dev/null

		echo "-> Installing in "$HOME"/.local/bin/ ..."
		rm -rf "$HOME"/.local/bin/mongosh
		mv "$TMPDIR"/"mongosh-${version}-darwin-${arch}"/bin/mongosh \
			"$HOME"/.local/bin/

		echo "Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi

elif [ "$1" == "tools" ]; then
	rm -rf "$TMPDIR"/mongodb*

	version="100.9.4"

	if [ "$system" = "Darwin" ]; then
		url="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-${arch}-${version}.zip"
		echo "-> Downloading $url ..."
		curl --fail --connect-timeout 13 --retry 5 --retry-delay 2 \
			--progress-bar -L -S "$url" -o "$TMPDIR"mongodb-tools.zip

		echo "-> Extracting "$TMPDIR"mongodb-tools.zip ..."
		unzip "$TMPDIR"/mongodb-tools.zip -d "$TMPDIR" >/dev/null

		echo "-> Installing in "$HOME"/.local/bin/ ..."
		rm -rf "$HOME"/.local/bin/mongo{dump,export,import,restore,stat,top}
		mv "$TMPDIR"/"mongodb-database-tools-macos-${arch}-${version}"/bin/mongo* \
			"$HOME"/.local/bin/

		echo "Finished."

	elif [ "$system" = "Linux" ]; then
		# TODO
		:
	fi
fi