ZSH_ADDONS_DIR="$HOME/.zsh-addons"

clone_if_not_exists() {
    local repo_url=$1
    local dest_dir=$2
    if [ ! -d "$dest_dir" ]; then
        git clone --depth 1 "$repo_url" "$dest_dir"
    fi
}

update_repos() {
    echo "Updating all repositories in $ZSH_ADDONS_DIR..."
    for repo in "$ZSH_ADDONS_DIR"/*; do
        if [ -d "$repo/.git" ]; then
            echo "Updating $repo..."
            (cd "$repo" && git pull --rebase --autostash)
        fi
    done
    echo "All repositories updated."
}

mkdir -p "$ZSH_ADDONS_DIR"

# plugins
clone_if_not_exists "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_ADDONS_DIR/zsh-syntax-highlighting"
clone_if_not_exists "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_ADDONS_DIR/zsh-autosuggestions"
clone_if_not_exists "https://github.com/zsh-users/zsh-completions.git" "$ZSH_ADDONS_DIR/zsh-completions"
# clone_if_not_exists "https://github.com/marlonrichert/zsh-autocomplete.git" "$ZSH_ADDONS_DIR/zsh-autocomplete"
clone_if_not_exists "https://github.com/Aloxaf/fzf-tab.git" "$ZSH_ADDONS_DIR/fzf-tab"
# end plugins

# source plugins
source "$ZSH_ADDONS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH_ADDONS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_ADDONS_DIR/zsh-completions/zsh-completions.plugin.zsh"
# source "$ZSH_ADDONS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$ZSH_ADDONS_DIR/fzf-tab/fzf-tab.zsh"
# source plugins end

# Set up fzf-tab & completion style
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# disable sort
zstyle ':completion:*:git-*:*' sort false
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Set fzf-preview for specific commands first
zstyle ':fzf-tab:complete:cd:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
zstyle ':fzf-tab:complete:z:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
zstyle ':fzf-tab:complete:zoxide:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
zstyle ':fzf-tab:complete:cat:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
zstyle ':fzf-tab:complete:bat:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
zstyle ':fzf-tab:complete:nano:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'
# git
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word | delta'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git show --color=always $word | delta'
# zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f "$realpath" ] && git diff --color=always $word | delta || git log --color=always $word | delta'

# miscellaneous
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
# Set fzf-preview for all other completions
zstyle ':fzf-tab:complete:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || ([ -f "$realpath" ] && bat --style=plain --color=always "$realpath")'

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-min-height 100
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Initialize Starship prompt
eval "$(starship init zsh --print-full-init)"

export PATH=$HOME/bin:/usr/local/bin:$PATH

export HISTFILE=~/.zsh_history
export HISTSIZE=12000
export SAVEHIST=10000
setopt sharehistory
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

source ~/.aliases

# zoxide
eval "$(zoxide init zsh)"
# zoxide end

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(fnm completions --shell zsh)"
# fnm end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Load Angular CLI autocompletion.
# source <(ng completion script)

# Load Docker CLI autocompletion.
# eval "$(docker completion zsh)"

if grep -q "microsoft" /proc/version >/dev/null 2>&1; then
    if service docker status 2>&1 | grep -q "is not running"; then
        wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
            --exec /usr/sbin/service docker start >/dev/null 2>&1
    fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

source ~/.asdf/plugins/golang/set-env.zsh
# asdf end

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
