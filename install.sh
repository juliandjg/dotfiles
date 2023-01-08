#!/usr/bin/env bash

sudo apt update -y && sudo apt full-upgrade -y

sudo apt-get install -y \
    zsh zoxide exa unzip zip bat \
    ca-certificates curl gnupg lsb-release

# Fix batcat -> bat
sudo ln -s /usr/bin/batcat /usr/local/bin/bat

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo source $HOME/.dotfiles/.zshrc >> ~/.zshrc

# Starship
curl -sS https://starship.rs/install.sh | sh
echo source $HOME/.dotfiles/starship.toml >> ~/.config/starship.toml

# SDKMan
curl -s "https://get.sdkman.io" | bash

# FNM - node manager
curl -fsSL https://fnm.vercel.app/install | bash

#Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo apt autoremove -y

# Change to ZSH
sudo chsh -s /usr/bin/zsh

zsh
