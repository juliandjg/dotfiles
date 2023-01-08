source ~/.zsh-snap/install.zsh

znap eval starship 'starship init zsh --print-full-init'
znap prompt


export PATH=$HOME/bin:/usr/local/bin:$PATH

znap eval zeoxide'zoxide init zsh'

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/git
znap source zsh-users/zeoxide
znap source zsh-users/docker-compose
znap source zsh-users/zsh-syntax-highlighting

znap source ~/.dotfiles/.aliases

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# fnm
export PATH="/home/$USER/.local/share/fnm:$PATH"
eval "`fnm env`"
# fnm end

# Load Angular CLI autocompletion.
# source <(ng completion script)
