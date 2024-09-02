#!/bin/bash

echo "Updating and upgrading packages..."
sudo apt update -qq && sudo apt upgrade -y -qq

echo "Installing required packages..."
sudo apt install -y -qq software-properties-common curl apt-transport-https ca-certificates gnupg wget tar unzip certbot

#echo "Installing Docker..."
#display_tech_fact
#curl -sSL https://get.docker.com/ | CHANNEL=stable bash >/dev/null 2>&1

echo "Installing Fastfetch..."
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch >/dev/null 2>&1
sudo apt update -qq && sudo apt upgrade -y -qq && sudo apt install -y -qq fastfetch

echo "Cleaning up packages..."
sudo apt autoremove -y -qq
sudo apt clean -y -qq

sudo apt update -qq

echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y >/dev/null 2>&1

echo "Cloning your bash files repository..."
git clone https://github.com/Kustys/my-bash-files.git

echo "Setting up bash configuration files..."
rm -f ~/.bashrc ~/.bash_aliases
ln -s ~/my-bash-files/.bashrc ~/.bashrc
ln -s ~/my-bash-files/.bash_aliases ~/.bash_aliases

echo "Setting up Starship configuration..."
mkdir -p ~/.config
rm -f ~/.config/starship.toml
ln -s ~/my-bash-files/starship.toml ~/.config/starship.toml

echo "Setup complete!"
echo "Symbolic links for bash files have been created in your home directory."
echo "Symbolic link for starship configuration has been created in ~/.config/starship.toml"
echo "The files are now linked to ~/my-bash-files repository."
echo "Restarting bash session..."

# Restart bash session
exec bash
echo "Enjoy your new setup :)"
