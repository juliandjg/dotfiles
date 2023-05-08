[[ -f ~/.zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.zsh-snap

zstyle ':znap:*' repos-dir ~/.zsh-snap/repos
source ~/.zsh-snap/znap.zsh

znap eval starship 'starship init zsh --print-full-init'
znap prompt

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.dotfiles"

export HISTFILE=~/.zsh_history
export HISTSIZE=12000
export SAVEHIST=10000

source $ZSH/.aliases

# Load plugins
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source marlonrichert/zsh-autocomplete

# zoxide
znap eval zoxide "zoxide init zsh"
# zoxide end

# fnm
export PATH="/home/$USER/.local/share/fnm:$PATH"
znap eval fnm "fnm env"
# fnm end

# pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Load Angular CLI autocompletion.
# source <(ng completion script)

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
