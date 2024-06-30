set --export XDG_CACHE_HOME "$HOME/.cache"
set --export XDG_CONFIG_HOME "$HOME/.config"
set --export XDG_DATA_HOME "$HOME/.local/share"
set --export XDG_STATE_HOME "$HOME/.local/state"

set --export ASDF_CONCURRENCY 2
set --export ASDF_DATA_DIR "$XDG_CACHE_HOME/asdf"
set --export BUN_RUNTIME_TRANSPILER_CACHE_PATH "$XDG_CACHE_HOME/bun/cache/transpiler"
set --export CODE "$HOME/Developer"
set --export DOCUMENTS "$HOME/Documents"
set --export DOWNLOADS "$HOME/Downloads"
set --export ICLOUD "$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
set --export LF_BOOKMARKS_PATH "$XDG_CONFIG_HOME/lf/bookmarks"
set --export NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set --export VOLUMES "/Volumes"
set --export YARN_CACHE_FOLDER "$XDG_CACHE_HOME/yarn"

set --export BAT_THEME "tokyonight-moon"
set --export EDITOR "nvim"
set --export FZF_DEFAULT_COMMAND "fd --hidden --threads 2 --type f"
set --export FZF_DEFAULT_OPTS "--ansi --border=rounded --cycle " \
	"--height=100% --layout=reverse --tabstop=4 --tiebreak=chunk,length,begin"
set --export FZF_ALT_C_COMMAND "fd --hidden --threads 2 --type d"
set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --export GPG_TTY (tty)
set --export HOMEBREW_NO_AUTO_UPDATE 1
set --export HOMEBREW_NO_INSTALL_CLEANUP 1
set --export LESSCHARSET UTF-8
set --export MANPAGER "env IS_PAGER=yes nvim -n -i NONE +Man!"
set --export NVIM_PAGER "env IS_PAGER=yes nvim -n -i NONE -R"

test -z "$HOMEBREW_PREFIX" &&
	type -q /usr/local/bin/brew &&
	set --export HOMEBREW_PREFIX "/usr/local"

test -n "$HOMEBREW_PREFIX" &&
test -s "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" &&
	source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"

# Homebrew on Apple Silicon uses a new location /opt/homebrew/{bin,sbin}
# which by default is not in the $PATH so they must be manually added.
fish_add_path --path "$HOMEBREW_PREFIX/opt/libpq/bin"
fish_add_path --path "$HOMEBREW_PREFIX/sbin"
fish_add_path --path "$HOMEBREW_PREFIX/bin"

fish_add_path --path --append "$HOME"/.docker/bin
fish_add_path --path --append "$HOME"/.local/bin

if status --is-login
	type -q asdf &&
		set PYTHON3 (asdf which python3 2>/dev/null)

	[ -z "$PYTHON3" ] &&
		set PYTHON3 "/usr/bin/python3"

	set PYTHON3_BIN_PATH ($PYTHON3 -c "import site; print(site.USER_BASE + '/bin')")
	fish_add_path --path --append "$PYTHON3_BIN_PATH"

	[ -z "$JAVA_HOME" ] && type -q asdf &&
		set JAVA_HOME (asdf which java)/../.. &&
		[ -d "$JAVA_HOME" ] &&
		set --export JAVA_HOME (realpath $JAVA_HOME)
end