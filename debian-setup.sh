#!/bin/bash

apt install sudo # Don't come at me, I cba to go through all the setup and remove sudo lol

sudo apt update -qq && sudo apt upgrade -y 

sudo apt install software-properties-common curl apt-transport-https ca-certificates gnupg wget git tar unzip -y 

#curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer >/dev/null 2>&1

#LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php >/dev/null 2>&1

#display_tech_fact
#curl -sSL https://get.docker.com/ | CHANNEL=stable bash >/dev/null 2>&1

wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.21.1/fastfetch-linux-amd64.deb
dpkg -i fastfetch-linux-amd64.deb

sudo apt autoremove -y -qq
sudo apt clean -y -qq

curl -sS https://starship.rs/install.sh | sudo sh -s -- -y >/dev/null 2>&1

git clone https://github.com/Kustys/my-bash-files

rm -f ~/.bashrc ~/.bash_aliases
ln -s ~/my-bash-files/.bashrc ~/.bashrc
ln -s ~/my-bash-files/.bash_aliases ~/.bash_aliases

mkdir -p ~/.config
rm -f ~/.config/starship.toml
ln -s ~/my-bash-files/starship.toml ~/.config/starship.toml

# Restart bash session
exec bash
