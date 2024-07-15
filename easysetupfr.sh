#!/bin/bash

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y
sudo apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
sudo apt install wget -y
sudo apt install curl -y
sudo apt install git -y
sudo apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server
yes | curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
yes | curl -sSL https://get.docker.com/ | CHANNEL=stable bash

# Add fastfetch repository and install with automatic yes
yes | sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update && sudo apt upgrade -y && sudo apt install fastfetch -y

sudo apt auto-remove -y
sudo apt clean -y

# Download and install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# Install Starship
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y

# Login to GitHub CLI
echo "Now we'll log you into GitHub CLI using a device code."
echo "Please follow these steps:"
echo "1. You'll see a URL and a device code below."
echo "2. Copy the URL and open it in a browser on your local machine (not on the VPS)."
echo "3. Enter the device code on that GitHub page in your browser."
echo "4. Grant the necessary permissions."
echo "5. Return here and press Enter once you've completed the authentication in your browser."
echo ""
echo "Press Enter to start the login process."
read

# Start the login process
AUTH_OUTPUT=$(gh auth login --web -h github.com -s repo,read:org -p https)

# Extract URL and code from AUTH_OUTPUT
AUTH_URL=$(echo "$AUTH_OUTPUT" | grep -oP 'https://github\.com/login/device\S+')
CODE=$(echo "$AUTH_OUTPUT" | grep -oP '(?<=code: )[A-Z0-9-]+')

echo "Open this URL in your browser: $AUTH_URL"
echo "Your one-time code is: $CODE"
echo "Press Enter after you've completed the authentication in your browser."
read

# Check if login was successful
if gh auth status &>/dev/null; then
    echo "GitHub CLI login successful!"
else
    echo "GitHub CLI login failed. Please try running the script again."
    exit 1
fi
#!/bin/bash

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y
sudo apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
sudo apt install wget -y
sudo apt install curl -y
sudo apt install git -y
sudo apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server
yes | curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
yes | curl -sSL https://get.docker.com/ | CHANNEL=stable bash

# Add fastfetch repository and install with automatic yes
yes | sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update && sudo apt upgrade -y && sudo apt install fastfetch -y

sudo apt auto-remove -y
sudo apt clean -y

# Download and install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# Install Starship
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y

# Login to GitHub CLI
echo "Now we'll log you into GitHub CLI using a device code."
echo "Please follow these steps:"
echo "1. You'll see a URL and a device code below."
echo "2. Copy the URL and open it in a browser on your local machine (not on the VPS)."
echo "3. Enter the device code on that GitHub page in your browser."
echo "4. Grant the necessary permissions."
echo "5. Return here and press Enter once you've completed the authentication in your browser."
echo ""
echo "Press Enter to start the login process."
read

# Start the login process
AUTH_OUTPUT=$(gh auth login --web -h github.com -s repo,read:org -p https)

# Extract URL and code from AUTH_OUTPUT
AUTH_URL=$(echo "$AUTH_OUTPUT" | grep -oP 'https://github\.com/login/device\S+')
CODE=$(echo "$AUTH_OUTPUT" | grep -oP '(?<=code: )[A-Z0-9-]+')

echo "Open this URL in your browser: $AUTH_URL"
echo "Your one-time code is: $CODE"
echo "Press Enter after you've completed the authentication in your browser."
read

# Check if login was successful
if gh auth status &>/dev/null; then
    echo "GitHub CLI login successful!"
else
    echo "GitHub CLI login failed. Please try running the script again."
    exit 1
fi
# Clone the my-bash-files repository
gh repo clone kustys/my-bash-files ~/my-bash-files

# Remove old bash configuration files
rm -f ~/.bashrc ~/.bash_aliases

# Create symbolic links for bash files
ln -s ~/my-bash-files/.bashrc ~/.bashrc
ln -s ~/my-bash-files/.bash_aliases ~/.bash_aliases

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Remove old starship.toml if it exists
rm -f ~/.config/starship.toml

# Create symbolic link for starship.toml
ln -s ~/my-bash-files/starship.toml ~/.config/starship.toml

echo "Symbolic links for bash files have been created in your home directory."
echo "Symbolic link for starship configuration has been created in ~/.config/starship.toml"
echo "The files are now linked to ~/my-bash-files repository."
echo "Restarting bash session..."

# Restart bash session
exec bash
echo "Enjoy :)"
