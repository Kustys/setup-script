#!/bin/bash

echo "Updating and upgrading packages..."
sudo apt update -qq && sudo apt upgrade -y -qq

echo "Installing required packages..."
sudo apt install -y -qq software-properties-common curl apt-transport-https ca-certificates gnupg wget git php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip redis-server certbot

echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer >/dev/null 2>&1

echo "Adding PHP repository..."
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php >/dev/null 2>&1

#echo "Installing Docker..."
#display_tech_fact
#curl -sSL https://get.docker.com/ | CHANNEL=stable bash >/dev/null 2>&1

echo "Installing Fastfetch..."
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch >/dev/null 2>&1
sudo apt update -qq && sudo apt upgrade -y -qq && sudo apt install -y -qq fastfetch

echo "Cleaning up packages..."
sudo apt autoremove -y -qq
sudo apt clean -y -qq

echo "Installing GitHub CLI..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -qq
sudo apt install -y -qq gh

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
