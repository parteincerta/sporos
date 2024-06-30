export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ASDF_CONCURRENCY=12
export ASDF_DATA_DIR="$XDG_CACHE_HOME/asdf"
export BUN_RUNTIME_TRANSPILER_CACHE_PATH="$XDG_CACHE_HOME/bun/cache/transpiler"
export CODE="$HOME/Developer"
export DOCUMENTS="$HOME/Documents"
export DOWNLOADS="$HOME/Downloads"
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
export LF_BOOKMARKS_PATH="$XDG_CONFIG_HOME/lf/bookmarks"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export VOLUMES="/Volumes"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"

export BAT_THEME="tokyonight-moon"
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND="fd --hidden --threads 3 --type f"
export FZF_DEFAULT_OPTS="--ansi --border=rounded --cycle --height=100%
 --layout=reverse --tabstop=4 --tiebreak=chunk,length,begin"
export FZF_ALT_C_COMMAND="fd --hidden --threads 3 --type d"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export GPG_TTY=$(tty)
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export LESSCHARSET="UTF-8"
export MANPAGER="env IS_PAGER=yes nvim -n -i NONE +Man!"
export NVIM_PAGER="env IS_PAGER=yes nvim -n -i NONE -R"

[ -z "$HOMEBREW_PREFIX" ] &&
	command -v /opt/homebrew/bin/brew &>/dev/null &&
	export HOMEBREW_PREFIX="/opt/homebrew" || true

[ -n "$HOMEBREW_PREFIX" ] &&
[ -s "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ] &&
	source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" || true

# Homebrew on Apple Silicon uses a new location /opt/homebrew/{bin,sbin}
# which by default is not in the $PATH so they must be manually added.
homebrew_bin="$HOMEBREW_PREFIX/bin"
homebrew_sbin="$HOMEBREW_PREFIX/sbin"
homebrew_pg_bin="$HOMEBREW_PREFIX/opt/libpq/bin"

[ -d $homebrew_pg_bin ] &&
[[ ! "$PATH" =~ $homebrew_pg_bin ]] &&
	export PATH="$homebrew_pg_bin:$PATH" || true

[ -d $homebrew_sbin ] &&
[[ ! "$PATH" =~ $homebrew_sbin ]] &&
	export PATH="$homebrew_sbin:$PATH" || true

[ -d $homebrew_bin ] &&
[[ ! "$PATH" =~ $homebrew_bin ]] &&
	export PATH="$homebrew_bin:$PATH" || true

[ -d "$HOME/.docker/bin" ] &&
[[ ! "$PATH" =~ $HOME/.docker/bin ]] &&
	export PATH="$PATH:$HOME/.docker/bin" || true

[ -d "$HOME/.local/bin" ] &&
[[ ! "$PATH" =~ $HOME/.local/bin ]] &&
	export PATH="$PATH:$HOME/.local/bin" || true

if shopt -q login_shell; then
	command -v asdf &>/dev/null &&
		PYTHON3="$(asdf which python3 2>/dev/null)" || true

	[ -z "$PYTHON3" ] &&
		PYTHON3="/usr/bin/python3" || true

	PYTHON3_BIN_PATH="$($PYTHON3 -c "import site; print(site.USER_BASE + '/bin')")"
	[ -d "$$PYTHON3_BIN_PATH" ] &&
	[[ ! "$PATH" =~ $PYTHON3_BIN_PATH ]] &&
		export PATH="$PATH:$PYTHON3_BIN_PATH" || true

	[ -z "$JAVA_HOME" ] && command -v asdf &>/dev/null &&
		JAVA_HOME="$(asdf which java 2>/dev/null)/../.." &&
		[ -d "$JAVA_HOME" ] &&
		export JAVA_HOME="$(realpath $JAVA_HOME)"
fi