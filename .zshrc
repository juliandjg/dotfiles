ZSH_THEME="agnoster"
plugins=(git zoxide docker-compose)

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# Reload theme
source $ZSH/oh-my-zsh.sh

source $ZSH/.aliases


# Load plugins
source /usr/share/zgen/zgen.zsh
zgen load zsh-users/zsh-syntax-highlighting
zgen load zsh-users/zsh-autosuggestions
zgen load zsh-users/zsh-completions
zgen load marlonrichert/zsh-autocomplete

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# fnm
export PATH="/home/$USER/.local/share/fnm:$PATH"
eval "`fnm env`"
# fnm end

# pnpm
export PNPM_HOME="/home/julian/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Load Angular CLI autocompletion.
# source <(ng completion script)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
