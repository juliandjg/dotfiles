#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get full-upgrade -y

sudo apt-get install -y language-pack-en
sudo update-locale

sudo apt-get install -y \
  zsh zoxide eza unzip zip bat \
  ca-certificates curl gnupg lsb-release \
  git-delta

# Fix batcat -> bat
sudo ln -s /usr/bin/batcat /usr/local/bin/bat

# Settings ZSH
ln $HOME/.dotfiles/.zshrc ~/.zshrc

# Settings aliases
ln $HOME/.dotfiles/.aliases ~/.aliases

# LazyDocker
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz lazydocker
sudo mv lazydocker /usr/local/bin

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo mv lazygit /usr/local/bin

# Asdf
ASDF_VERSION=$(curl -s "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo asdf.tar.gz "https://github.com//asdf-vm/asdf/releases/latest/download/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz"
tar xf asdf.tar.gz asdf
sudo mv asdf /usr/local/bin

# Asdf plugins
asdf plugin add nodejs
asdf plugin add golang

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config
ln $HOME/.dotfiles/starship.toml ~/.config/starship.toml

# SDKMan
curl -s "https://get.sdkman.io" | bash

# FNM - node manager
curl -fsSL https://fnm.vercel.app/install | bash

# PNPM
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo usermod -aG docker $USER

# Change to ZSH
chsh -s /usr/bin/zsh

zsh
