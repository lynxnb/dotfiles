#!/bin/sh
# Configuration script for setting up the distros I use

# Cool marker tags
STEP="\e[7m STEP \e[0m"
INFO="\e[40m INFO \e[0m"
WARN="\e[33m\e[7m WARN \e[0m"

OS=""
ID=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    ID=$ID
fi

kernel=$(uname -r | tr '[:upper:]' '[:lower:]')
if [[ $kernel == *"microsoft"* ]]; then
    WSL=" (WSL)"
fi

echo "Configuring $OS$WSL"

# Install packages and other distro-specific stuff
printf "$STEP Installing dependencies\n"
case $ID in
    ubuntu)
        sudo apt update
        sudo apt install -y zsh htop
        ;;
    debian)
        sudo apt update
        sudo apt install -y zsh htop
        ;;
    alpine)
        # Avoid asking root passwords multiple times
        sucmds="apk update"
        sucmds="$sucmds && apk add zsh sudo git make gcc musl-dev htop"
        # Configure sudo
        sucmds="$sucmds && printf \"$STEP Setting up sudo\n\""
        sucmds="$sucmds && echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel"
        sucmds="$sucmds && adduser $USER wheel"
        su -c "$sucmds"
        ;;
    *)
        echo "Unsupported OS."
        exit 1
        ;;
esac

# Setup gitconfig
printf "$STEP Copying gitconfig\n"
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig

# Use vscode if available
if ! [ -x "$(command -v code)" ]; then
    printf "$WARN VSCode is not installed, install manually\n"
fi

# Configure zsh
printf "$STEP Copying zsh configuration\n"
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

# Install oh-my-posh
printf "$STEP Installing oh-my-posh\n"
mkdir ~/.cache
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Install oh-my-posh theme
OHMYPOSH_THEME="zash"
printf "$STEP Installing oh-my-posh theme: '$OHMYPOSH_THEME'\n"
mkdir ~/.poshthemes
ln -s ~/.dotfiles/oh-my-posh/$OHMYPOSH_THEME.json ~/.poshthemes/$OHMYPOSH_THEME.json

# Install zsh-autosuggestions
printf "$STEP Installing zsh-autosuggestions\n"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Set zsh as default shell
printf "$STEP Setting zsh as the default shell\n"
chsh -s /bin/zsh

echo "Done."
