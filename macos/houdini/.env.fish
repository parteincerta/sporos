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

set homebrew_bin /usr/local/bin
set homebrew_sbin /usr/local/sbin
set homebrew_pg_bin /usr/local/opt/libpq/bin
contains $homebrew_bin $PATH || set --append PATH $homebrew_bin
contains $homebrew_sbin $PATH || set --append PATH $homebrew_sbin
contains $homebrew_pg_bin $PATH || set --append PATH $homebrew_pg_bin

contains "$HOME"/.docker/bin $PATH || set --append PATH "$HOME"/.docker/bin
contains "$HOME"/.local/bin $PATH || set --append PATH "$HOME"/.local/bin

string match -e 'Python*bin' "$PATH" >/dev/null ||
begin
	type -q python3 &&
	set --append PATH (python3 -c "import site; print(site.USER_BASE + '/bin')")
end

test -z "$HOMEBREW_PREFIX" &&
	type -q brew &&
	set --export HOMEBREW_PREFIX (brew --prefix)

test -s "$HOMEBREW_PREFIX"/opt/asdf/libexec/asdf.sh &&
	source "$HOMEBREW_PREFIX"/opt/asdf/libexec/asdf.fish