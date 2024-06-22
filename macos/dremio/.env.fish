set --export XDG_CACHE_HOME "$HOME/.cache"
set --export XDG_CONFIG_HOME "$HOME/.config"
set --export XDG_DATA_HOME "$HOME/.local/share"
set --export XDG_STATE_HOME "$HOME/.local/state"

set --export ASDF_CONCURRENCY 12
set --export ASDF_DATA_DIR "$XDG_CACHE_HOME/asdf"
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
set --export FZF_DEFAULT_COMMAND "fd --hidden --threads 3 --type f"
set --export FZF_DEFAULT_OPTS "--ansi --border=rounded --cycle " \
	"--height=100% --layout=reverse --tabstop=4 --tiebreak=chunk,length,begin"
set --export FZF_ALT_C_COMMAND "fd --hidden --threads 3 --type d"
set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --export GPG_TTY (tty)
set --export HOMEBREW_NO_AUTO_UPDATE 1
set --export HOMEBREW_NO_INSTALL_CLEANUP 1
set --export LESSCHARSET UTF-8
set --export MANPAGER "env IS_PAGER=yes nvim -n -i NONE +Man!"
set --export NVIM_PAGER "env IS_PAGER=yes nvim -n -i NONE -R"

test -z "$HOMEBREW_PREFIX" &&
	type -q /opt/homebrew/bin/brew &&
	set --export HOMEBREW_PREFIX "/opt/homebrew"

test -n "$HOMEBREW_PREFIX" &&
test -s "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" &&
	source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"

# Homebrew on Apple Silicon uses a new location /opt/homebrew/{bin,sbin}
# which by default is not in the $PATH so they must be manually added.
fish_add_path --path "$HOMEBREW_PREFIX/opt/python@3.11/libexec/bin"
fish_add_path --path "$HOMEBREW_PREFIX/opt/libpq/bin"
fish_add_path --path "$HOMEBREW_PREFIX/sbin"
fish_add_path --path "$HOMEBREW_PREFIX/bin"

fish_add_path --path --append "$HOME"/.docker/bin
fish_add_path --path --append "$HOME"/.local/bin

if [ (type -q python3) ]
	set python3_bin (python3 -c "import site; print(site.USER_BASE + '/bin')")
	fish_add_path --path --append $python3_bin
end

test -d /usr/libexec/java_home &&
	set --export JAVA_HOME "/usr/libexec/java_home"

if status --is-login
	set NOFILE (sysctl -n kern.maxfilesperproc)
	set NOPROC (sysctl -n kern.maxproc)
	ulimit -n "$NOFILE"
	ulimit -u "$NOPROC"
end