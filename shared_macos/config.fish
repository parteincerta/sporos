# ================= #
# ENVIRONMENT SETUP #
# ================= #

set --export XDG_CACHE_HOME "$HOME/.cache"
set --export XDG_CONFIG_HOME "$HOME/.config"
set --export XDG_DATA_HOME "$HOME/.local/share"
set --export XDG_STATE_HOME "$HOME/.local/state"

set --export BUN_RUNTIME_TRANSPILER_CACHE_PATH "$XDG_CACHE_HOME/bun/cache/transpiler"
set --export CODE "$HOME/Developer"
set --export DOCUMENTS "$HOME/Documents"
set --export DOWNLOADS "$HOME/Downloads"
set --export GRADLE_USER_HOME "$XDG_CACHE_HOME/gradle"
set --export ICLOUD "$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
set --export LF_BOOKMARKS_PATH "$XDG_CONFIG_HOME/lf/bookmarks"
set --export NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set --export VOLUMES "/Volumes"
set --export YARN_CACHE_FOLDER "$XDG_CACHE_HOME/yarn"

if [ -z "$HOMEBREW_PREFIX" ]
    set --local _arch (uname -m)
    if [ "$_arch" = "arm64" ]
        type -ft /opt/homebrew/bin/brew &>/dev/null &&
            set --export HOMEBREW_PREFIX "/opt/homebrew"
    else if [ "$_arch" = "x86_64" ]
        type -ft /usr/local/bin/brew &>/dev/null &&
            set --export HOMEBREW_PREFIX "/usr/local"
    end
end

[ -n "$HOMEBREW_PREFIX" ] &&
    set --export HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar" &&
    set --export HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"

[ -n "$HOMEBREW_PREFIX" ] &&
! string match -q "*$HOMEBREW_PREFIX/share/info:*" "$INFOPATH"  &&
begin
    [ -z "$INFOPATH" ] &&
        set --export INFOPATH "$HOMEBREW_PREFIX/share/info" ||
        set --export INFOPATH "$HOMEBREW_PREFIX/share/info:$INFOPATH"
end

! string match -q "*/usr/share/man:*" "$MANPATH"  &&
begin
    [ -z "$MANPATH" ] &&
        set --export MANPATH "/usr/share/man" ||
        set --export MANPATH "/usr/share/man:$MANPATH"
end

[ -n "$HOMEBREW_PREFIX" ] &&
! string match -q "*$HOMEBREW_PREFIX/share/man:*" "$MANPATH"  &&
begin
    [ -z "$MANPATH" ] &&
        set --export MANPATH "$HOMEBREW_PREFIX/share/man" ||
        set --export MANPATH "$HOMEBREW_PREFIX/share/man:$MANPATH"
end

fish_add_path --path "$HOMEBREW_PREFIX/opt/libpq/bin"
fish_add_path --path "$HOMEBREW_PREFIX/sbin"
fish_add_path --path "$HOMEBREW_PREFIX/bin"
fish_add_path --path --append "$HOME/.docker/bin"
fish_add_path --path --append "$HOME/.local/bin"

! set -q MISE_SHELL &&
type -ft mise &>/dev/null &&
    mise activate --shims fish | source

# ============== #
# USER FUNCTIONS #
# ============== #

function gpg_dec_file --description "Decrypt password-encrypted file."
    set --local src "$1"
    set --local dst "$2"
    if [ -s "$src" ]
        [ -z "$dst" ] && gpg --decrypt "$src" 2>/dev/null | pager
        [ -n "$dst" ] && gpg --symmetric "$src" > "$dst"
    end
end

function gpg_enc_file --description "Encrypt a file with a password."
    set --local src "$1"
    set --local dst "$2"
    if [ -s "$src" ]
        [ -z "$dst" ] && gpg --symmetric "$src"
        [ -n "$dst" ] && gpg --symmetric "$src" "$dst"
    end
end

function mkcd --description "Create a directory if it doesn't exist and cd into it."
    if [ -n "$argv[1]" ]
        mkdir -p "$argv[1]" && cd "$argv[1]"
    else
        echo "Usage: mkcd <dir>"
    end
end

function secrm --description "Remove files in a secure manner using GNU shred."
    bash --login -c "secrm $argv"
end

# Adapted from https://stackoverflow.com/a/44811468
# Sanite a string to produce a valid file name
function sanitize --description ""
    set --local s $argv[1]
    set --local s (echo "$s" | sed 's/[^[:alnum:]]\./-/g')
    set --local s (echo "$s" | sed -E 's/-+/-/g')
    set --local s (string trim --char=- -- "$s")
    echo "$s"
end

# ============================= #
# INTERACTIVE ENVIRONMENT SETUP #
# ============================= #
! status --is-interactive && return 0

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

set fish_greeting
set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_hide_untrackedfiles 1
set __fish_git_prompt_showupstream "informative"
set __fish_git_prompt_char_upstream_ahead "↑"
set __fish_git_prompt_char_upstream_behind "↓"
set __fish_git_prompt_char_upstream_prefix ""
set __fish_git_prompt_char_cleanstate "#"
set __fish_git_prompt_char_conflictedstate "!"
set __fish_git_prompt_char_dirtystate "~"
set __fish_git_prompt_char_stagedstate "+"
set __fish_git_prompt_char_untrackedfiles "?"
set __fish_git_prompt_color_branch magenta
set __fish_git_prompt_color_dirtystate blue
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_untrackedfiles $fish_color_normal
set __fish_git_prompt_color_cleanstate green
set __fish_git_prompt_show_informative_status 1
set fish_handle_reflow 0
set fish_color_command blue --bold
set fish_color_error brred --bold
set fish_escape_delay_ms 30

function fish_mode_prompt;
end

function prompt_cwd
    set_color green
    echo -n (prompt_pwd)
    set_color $fish_color_normal
end

function prompt_sh_level
    if [ "$SHLVL" -gt "1" ]
        set_color black --background white
        echo -n " $(math $SHLVL - 1) "
        set_color $fish_color_normal
        echo -n " "
    end
end

function prompt_vi_mode
    if [ "$fish_bind_mode" = "default" ]
        set_color --background red
        set_color black
        echo -n " C "
        set_color normal
        [ $SHLVL -eq 1 ] && echo -n " "
    else if [ "$fish_bind_mode" = "visual" ]
        set_color --background yellow
        set_color black
        echo -n " V "
        set_color normal
        [ $SHLVL -eq 1 ] && echo -n " "
    end
end

function fish_prompt
    echo -n "$(prompt_vi_mode)$(prompt_sh_level)$(prompt_cwd) · "
end

function fish_right_prompt
    echo -n "$(__fish_git_prompt) $(date '+%a %T')"
end

if type -ft fzf &>/dev/null
    fzf --fish | source
end

function brew --description "Homebrew hook to handle specific commands"
    set --local homebrew (type -fp brew)
    if [ $argv[1] = "install" ] || [ $argv[1] = "upgrade" ]
        echo "Homebrew's install and upgrade commands should be executed in Bash (Apple Terminal)."
        echo "To force-execute them in Fish start the command with: $homebrew"
    else
        $homebrew $argv
    end
end

function clear_screen --description "Clear the screen and move the previous content to the scrollback buffer."
    printf "\e[H\e[2J"
end

function clear_screen_and_scrollback_buffer --description "Clear the screen and purge the scrollback buffer."
    clear_screen
    printf '\e[3J'
end

function e --description "Start lf in the current directory or in the given one."
    lf "$argv[1]"
    if [ -f "$TMPDIR/lfcd" ]
        set --local dir (cat "$TMPDIR/lfcd")
        [ -d "$dir" ] && cd "$dir"
        rm -rf "$TMPDIR/lfcd"
    end
end

function pager --description "Pager-like implementation using neovim"
    set --function target "-"
    if [ -n "$argv[1]" ]
        set --function target "$argv[1]"
    end

    nvim -n -u NONE -i NONE -R \
        -c "map q :q<CR>" \
        -c "set laststatus=0" -c "set number" \
        -c "syntax on" "$target"
end

function purge --description "Purge temporary data from some programs."
    if [ "$argv[1]" = "fish" ]
        echo 'yes' | history clear &>/dev/null

    else if [ "$argv[1]" = "clipboard" ]
        pbcopy < /dev/null

    else if [ "$argv[1]" = "nvim" ]
        for file in "$XDG_DATA_HOME"/nvim/shada/*.shada
            rm -f "$file"
        end
        for file in "$XDG_STATE_HOME"/nvim/shada/*.shada
            rm -f "$file"
        end

        [ -d "$XDG_STATE_HOME"/nvim/undo/ ] &&
        [ -n "$(lsa "$XDG_STATE_HOME"/nvim/undo/)" ] &&
            rm -rf "$XDG_STATE_HOME"/nvim/undo/*

    else if [ "$argv[1]" = "bash" ]
        bash -i -c "purge $argv"
    else
        echo "Usage purge bash|clipboard|fish|nvim."
    end
end

function test_underline_styles --description "Prints underline text in several styles."
    echo -e "\x1b[4:0m4:0 none\x1b[0m \x1b[4:1m4:1 straight\x1b[0m " \
        "\x1b[4:2m4:2 double\x1b[0m \x1b[4:3m4:3 curly" \
        "\x1b[0m \x1b[4:4m4:4 dotted\x1b[0m \x1b[4:5m4:5 dashed\x1b[0m"
end

function test_underline_colors --description "Prints text with colored underlines"
    echo -e "\x1b[4;58:5:203mred underline (256)" \
        "\x1b[0m \x1b[4;58:2:0:255:0:0mred underline (true color)\x1b[0m"
end

abbr -a -- - 'cd -'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias beep="tput bel"
alias brewi="brew info"
alias brewo="brew outdated"
alias brewog="brew outdated --greedy"
alias brews="brew search"
alias brewu="brew update --verbose"
alias code="code --user-data-dir $XDG_CACHE_HOME/code/data --extensions-dir $XDG_CACHE_HOME/code/extensions"
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
alias gitfa="git fetch --all"
alias gitfap="git fetch --all --prune"
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
alias whicha="which -a"

fish_vi_key_bindings
bind --mode default \cf accept-autosuggestion
bind --mode insert \cf accept-autosuggestion
bind --mode visual \cf accept-autosuggestion
bind --mode default \cy accept-autosuggestion execute
bind --mode insert \cy accept-autosuggestion execute
bind --mode visual \cy accept-autosuggestion execute
# NOTE: \ck and \cl and currently being handled in Kitty because they don't
# produce the expected result when applied through Fish. Both work fine in Apple
# Terminal but in Kitty.
bind --mode default \ck 'clear_screen_and_scrollback_buffer; commandline -f repaint'
bind --mode insert \ck 'clear_screen_and_scrollback_buffer; commandline -f repaint'
bind --mode visual \ck 'clear_screen_and_scrollback_buffer; commandline -f repaint'
bind --mode default \cl 'clear_screen; commandline -f repaint'
bind --mode insert \cl 'clear_screen; commandline -f repaint'
bind --mode visual \cl 'clear_screen; commandline -f repaint'
bind --mode default --key nul edit_command_buffer
bind --mode insert --key nul edit_command_buffer
bind --mode visual --key nul edit_command_buffer

if type -q fzf-cd-widget &>/dev/null
    bind --mode default \ce fzf-cd-widget
    bind --mode insert \ce fzf-cd-widget
    bind --mode visual \ce fzf-cd-widget
end
