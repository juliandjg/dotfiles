#!/usr/bin/env bash

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Package installation
if [[ "$OS" == "linux" ]]; then
    sudo apt-get update -y
    sudo apt-get full-upgrade -y
    sudo apt-get install -y language-pack-en
    sudo update-locale
    sudo apt-get install -y \
      zsh zoxide eza unzip zip bat \
      ca-certificates curl gnupg lsb-release \
      git-delta
    # Fix batcat -> bat
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
elif [[ "$OS" == "macos" ]]; then
    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo >> ~/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi

    brew update
    brew upgrade
    brew install \
      zsh zoxide eza unzip zip bat \
      curl gnupg \
      git-delta \
      docker docker-compose colima

    # Start colima
    ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock
    colima start --cpu 4 --memory 8 --disk 20 --vm-type vz --runtime docker --save-config
fi

# Settings ZSH
ln -sf $HOME/.dotfiles/.zshrc ~/.zshrc

# Settings aliases
ln -sf $HOME/.dotfiles/.aliases ~/.aliases

# LazyDocker
if [[ "$OS" == "linux" ]]; then
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_linux_x86_64.tar.gz"
    tar xf lazydocker.tar.gz lazydocker
    sudo mv lazydocker /usr/local/bin
    rm lazydocker.tar.gz
elif [[ "$OS" == "macos" ]]; then
    brew install lazydocker
fi

# LazyGit
if [[ "$OS" == "linux" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo mv lazygit /usr/local/bin
    rm lazygit.tar.gz
elif [[ "$OS" == "macos" ]]; then
    brew install lazygit
fi

# Asdf
if [[ "$OS" == "linux" ]]; then
    ASDF_VERSION=$(curl -s "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo asdf.tar.gz "https://github.com/asdf-vm/asdf/releases/latest/download/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz"
    tar xf asdf.tar.gz asdf
    sudo mv asdf /usr/local/bin
    rm asdf.tar.gz
elif [[ "$OS" == "macos" ]]; then
    brew install asdf
fi

# Asdf plugins
asdf plugin add nodejs
asdf plugin add golang

# Fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config
ln -sf $HOME/.dotfiles/starship.toml ~/.config/starship.toml

# SDKMan
curl -s "https://get.sdkman.io" | bash

# FNM - node manager
curl -fsSL https://fnm.vercel.app/install | bash

# PNPM
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Docker
if [[ "$OS" == "linux" ]]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo usermod -aG docker $USER
fi

# Change to ZSH
if [[ "$OS" == "linux" ]]; then
    chsh -s /usr/bin/zsh
fi

zsh
