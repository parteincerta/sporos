source "$(dirname $(status --current-filename))"/.env.fish

set fish_greeting
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""
set -g __fish_git_prompt_char_cleanstate "#"
set -g __fish_git_prompt_char_conflictedstate "!"
set -g __fish_git_prompt_char_dirtystate "~"
set -g __fish_git_prompt_char_stagedstate "+"
set -g __fish_git_prompt_char_untrackedfiles "?"
set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green
set -g __fish_git_prompt_show_informative_status 1
set -g fish_handle_reflow 0
set -g fish_color_command blue --bold
set -g fish_color_cwd black --background green
set -g fish_color_lf black --background blue
set -g fish_color_error brred --bold
set -U ENABLE_GIT_PROMPT 1

function fish_mode_prompt
	switch $fish_bind_mode
	case default
		set_color --background red
		set_color black
		echo ' C '
		set_color normal
		#echo ' '
	case insert
		echo ''
	case replace_one
		set_color --background green
		set_color black
		echo ' R '
		set_color normal
		#echo ' '
	case visual
		set_color --background yellow
		set_color black
		echo ' S '
		set_color normal
		#echo ' '
	case '*'
		set_color --background blue
		set_color black
		echo ' ? '
		set_color normal
		#echo ' '
	end
end

function fish_prompt
	if test "$ENABLE_GIT_PROMPT" = 1
		printf '%s %s %s%s%s%s%s ' (set_color $fish_color_cwd) (prompt_pwd) \
			(set_color $fish_color_lf) ([ -n "$LF_LEVEL" ] && echo " $LF_LEVEL ") (set_color $fish_color_normal) \
			(set_color $fish_color_normal) (__fish_git_prompt)
	else
		printf '%s %s %s%s%s ' (set_color $fish_color_cwd) (prompt_pwd) \
			(set_color $fish_color_lf) ([ -n "$LF_LEVEL" ] && echo " $LF_LEVEL ") (set_color $fish_color_normal)
	end
end

function fish_right_prompt
	printf '%s%s%s' (date '+%T')
end

fish_vi_key_bindings
bind --mode default \cf accept-autosuggestion
bind --mode insert \cf accept-autosuggestion
bind --mode default \cy accept-autosuggestion execute
bind --mode insert \cy accept-autosuggestion execute
bind --mode default \ck 'printf "\033c"; commandline -f repaint'
bind --mode insert \ck 'printf "\033c"; commandline -f repaint'

if test -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish"
	fzf --fish | source
	if type -q fzf_key_bindings
		fzf_key_bindings
	end
	bind --mode default \ce fzf-cd-widget
	bind --mode insert \ce fzf-cd-widget
end

set --local ads "/Applications/'Azure Data Studio.app'/Contents/Resources/app/bin/code"
set --local ads_data_dir "$XDG_CACHE_HOME/ads/data/"
set --local ads_extensions_dir "$XDG_CACHE_HOME/ads/extensions/"
set --local vsc_data_dir "$XDG_CACHE_HOME/code/data/"
set --local vsc_extensions_dir "$XDG_CACHE_HOME/code/extensions/"

abbr -a -- - 'cd -'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ads="$ads --user-data-dir $ads_data_dir --extensions-dir $ads_extensions_dir"
alias beep="tput bel"
alias brewi="brew info"
alias brewo="brew outdated"
alias brewog="brew outdated --greedy"
alias brews="brew search"
alias brewu="brew update --verbose"
alias code="code --user-data-dir $vsc_data_dir --extensions-dir $vsc_extensions_dir"
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
alias gitfp="git fetch --prune"
alias gitl="git log"
alias gitlo="git log --oneline"
alias gitm="git merge"
alias gitma="git merge --abort"
alias gitp="git pull"
alias gitpb="git pull origin (git rev-parse --abbrev-ref HEAD)"
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
alias tar="env COPYFILE_DISABLE=1 tar"

function ambient --description "(re)Apply specific environment settings on demand."
	bash -l -c "ambient $argv"
end

function clipit --description "Copy a file or directory into the clipboard."
	bash -l -c "clipit $argv"
end

function e --description "Start lf in the current directory or in the given one."
	BASH_ENV="$HOME/.bash_profile" lf "$argv[1]"
	if [ -f "$TMPDIR"/lfcd ]
		set --local dir (cat "$TMPDIR"/lfcd)
		[ -d "$dir" ] && cd "$dir"
		rm -rf "$TMPDIR"/lfcd
	end
end

function gpg_dec_file --description "Decrypt password-encrypted file."
	bash -l -c "dec_file $argv"
end

function gpg_enc_file --description "Encrypt a file with a password."
	bash -l -c "enc_file $argv"
end

function mkcd --description "Create a directory if it doesn't exist and cd into it."
	if [ -n "$argv[1]" ]
		mkdir -p "$argv[1]" && cd "$argv[1]"
	else
		echo "Usage: mkcd <dir>"
	end
end

function notes --description "Create and edit text notes in iCloud."
	if [ -n "$argv[1]" ]
		set --local path (dirname $argv[1])
		set --local file (basename $argv[1])
		mkdir -p "$ICLOUD/$path"
		if [ -n "$file" ]
			set --local file (sanitize $file)
			touch "$ICLOUD/$path/$file"
			env IS_NOTES=yes nvim -n "$ICLOUD/$path/$file" -c "cd %:h"
		else
			env IS_NOTES=yes nvim -n "$ICLOUD/$path/"  -c "cd %:h"
		end
	else
		e "$ICLOUD"
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

# Adapted from https://stackoverflow.com/a/44811468
# Sanite a string to produce a valid file name
function sanitize --description ""
	set --local s $argv[1]
	set --local s (echo "$s" | sed 's/[^[:alnum:]]\./-/g')
	set --local s (echo "$s" | sed -E 's/-+/-/g')
	set --local s $(string trim --char=- -- "$s")
	echo "$s"
end

function secrm --description "Remove files in a secure manner using GNU shred."
	bash -l -c "secrm $argv"
end

function push_route --description ""

	set --local target $argv[1]

	# NOTES
	# 1. To only add specific hosts instead of an address range:
	#	sudo route add -host 192.168.123.124 -interface ppp0

	if [ "$target" = "icnew" ]
		sudo route add -net 192.168.123.0/24 -interface ppp0

		if [ $status -eq 0 ]
			read --prompt-str "Hit <Enter> to pop route (a password might be requested) ..."
			sudo route delete -net 192.168.123.0/24 -interface ppp0
		end
		return
	else
		echo "push_route icnew <push|pop>"
	end
end

function test_underline_styles --description "Prints underline text in several styles."
	bash -l -c "test_underline_styles"
end

function test_underline_colors --description "Prints text with colored underlines"
	bash -l -c "test_underline_colors"
end