# vim:ft=bash

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ASDF_CONCURRENCY=2
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
export FZF_DEFAULT_COMMAND="fd --hidden --threads 2 --type f"
export FZF_DEFAULT_OPTS="--ansi --border=rounded --cycle --height=100%
 --layout=reverse --tabstop=4 --tiebreak=chunk,length,begin"
export FZF_ALT_C_COMMAND="fd --hidden --threads 2 --type d"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export GPG_TTY=$(tty)
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export LESSCHARSET="UTF-8"
export MANPAGER="env IS_PAGER=yes nvim -n -i NONE +Man!"
export NVIM_PAGER="env IS_PAGER=yes nvim -n -i NONE -R"

homebrew_bin=/opt/homebrew/bin
homebrew_sbin=/opt/homebrew/sbin
homebrew_pg_bin=/opt/homebrew/opt/libpq/bin
[[ ! "$PATH" =~ $homebrew_bin ]] &&
	export PATH="$PATH:$homebrew_bin" || true

[[ ! "$PATH" =~ $homebrew_sbin ]] &&
	export PATH="$PATH:homebrew_sbin" || true

[[ ! "$PATH" =~ $homebrew_pg_bin ]] &&
	export PATH="$PATH:$homebrew_pg_bin" || true

[[ ! "$PATH" =~ $HOME/.docker/bin ]] &&
	export PATH="$PATH:$HOME/.docker/bin" || true

[[ ! "$PATH" =~ $HOME/.local/bin ]] &&
	export PATH="$PATH:$HOME/.local/bin" || true

[[ ! "$PATH" =~ Python ]] &&
	command -v python3 &>/dev/null &&
	export PATH="$PATH:$(python3 -c "import site; print(site.USER_BASE + '/bin')")" || true

[ -z "$HOMEBREW_PREFIX" ] &&
	command -v brew &>/dev/null &&
	export HOMEBREW_PREFIX="$(brew --prefix)" || true

[ -s "$HOMEBREW_PREFIX"/opt/asdf/libexec/asdf.sh ] &&
	source "$HOMEBREW_PREFIX"/opt/asdf/libexec/asdf.sh || true