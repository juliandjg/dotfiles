[[ -f ~/.zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.zsh-snap

zstyle ':znap:*' repos-dir ~/.zsh-snap/repos
zstyle ':znap:*:*' git-maintenance off

# Set fzf-tab & completion style
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
zstyle ':fzf-tab:complete:*' fzf-preview '[ -d "$realpath" ] && exa -1 --color=always "$realpath" || bat --style=plain --color=always "$realpath"'

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-min-height 100
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

source ~/.zsh-snap/znap.zsh

znap eval starship 'starship init zsh --print-full-init'
znap prompt

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

# Load plugins
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
# znap source marlonrichert/zsh-autocomplete
znap source Aloxaf/fzf-tab


# zoxide
znap eval zoxide "zoxide init zsh"
# zoxide end

# fnm
export PATH="/home/julian/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(fnm completions --shell zsh)"
# fnm end

# pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Load Angular CLI autocompletion.
#source <(ng completion script)

# Load Docker CLI autocompletion.
#znap eval docker_completion "docker completion zsh"

if grep -q "microsoft" /proc/version >/dev/null 2>&1; then
    if service docker status 2>&1 | grep -q "is not running"; then
        wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
            --exec /usr/sbin/service docker start >/dev/null 2>&1
    fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
