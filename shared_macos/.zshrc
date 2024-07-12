PROMPT="%F{green}%D{%a %H:%M:%S} ·%f "

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

function zvm_after_init() {
    zinit light zsh-users/zsh-completions
    autoload -Uz compinit
    compinit

    whence fzf &>/dev/null && source <(fzf --zsh)
}

if [ -s "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh" ]; then
    source "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh"
    zinit load jeffreytse/zsh-vi-mode

    zinit light zsh-users/zsh-autosuggestions

    zinit ice wait"!0" lucid
    zinit light zsh-users/zsh-syntax-highlighting
fi
