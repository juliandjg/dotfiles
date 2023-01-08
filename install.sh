#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get full-upgrade -y

sudo apt-get install -y \
    zsh zoxide exa unzip zip bat zgen \
    ca-certificates curl gnupg lsb-release

# Fix batcat -> bat
sudo ln -s /usr/bin/batcat /usr/local/bin/bat

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cat $HOME/.dotfiles/.zshrc > ~/.zshrc
cat $HOME/.dotfiles/.aliases > ~/.oh-my-zsh/.aliases
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install


# Starship
curl -sS https://starship.rs/install.sh | sh
sudo mkdir -p ~/.config
cat $HOME/.dotfiles/starship.toml | sudo tee -a ~/.config/starship.toml

# SDKMan
curl -s "https://get.sdkman.io" | bash

# FNM - node manager
curl -fsSL https://fnm.vercel.app/install | bash

# PNPM
curl -fsSL https://get.pnpm.io/install.sh | sh -

#Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Change to ZSH
sudo chsh -s /usr/bin/zsh

zsh
