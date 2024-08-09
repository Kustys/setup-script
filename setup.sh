#!/bin/bash

# Array of tech facts
tech_facts=(
    "The first computer programmer was a woman named Ada Lovelace."
    "The first computer bug was an actual real-life bug - a moth trapped in a Harvard Mark II computer."
    "The first electronic computer ENIAC weighed more than 27 tons and took up 1800 square feet."
    "The first hard disk drive was created in 1956 and could only store 5MB of data."
    "The Apollo 11 mission used a computer with less processing power than a modern smartphone."
    "The first tweet was sent on March 21, 2006, by Jack Dorsey."
    "The most popular programming language, JavaScript, was created in just 10 days."
    "The first website is still online: http://info.cern.ch/"
    "The term 'bug' in computer science was coined by Grace Hopper in 1947."
    "Linux, one of the most popular operating systems, was created by Linus Torvalds in 1991."
)

# Function to display a random tech fact
display_tech_fact() {
    echo "Did you know? ${tech_facts[$RANDOM % ${#tech_facts[@]}]}"
}

echo "Updating and upgrading packages..."
display_tech_fact
sudo apt update -qq && sudo apt upgrade -y -qq

echo "Installing required packages..."
sudo apt install -y -qq software-properties-common curl apt-transport-https ca-certificates gnupg wget git php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip redis-server

echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer >/dev/null 2>&1

echo "Adding PHP repository..."
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php >/dev/null 2>&1

#echo "Installing Docker..."
#display_tech_fact
#curl -sSL https://get.docker.com/ | CHANNEL=stable bash >/dev/null 2>&1

echo "Installing Fastfetch..."
display_tech_fact
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch >/dev/null 2>&1
sudo apt update -qq && sudo apt upgrade -y -qq && sudo apt install -y -qq fastfetch

echo "Cleaning up packages..."
sudo apt autoremove -y -qq
sudo apt clean -y -qq

echo "Installing GitHub CLI..."
display_tech_fact
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -qq
sudo apt install -y -qq gh

echo "Installing Starship prompt..."
display_tech_fact
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y >/dev/null 2>&1

echo "Preparing for GitHub CLI login..."
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

AUTH_OUTPUT=$(gh auth login --web -h github.com -s repo,read:org -p https)
AUTH_URL=$(echo "$AUTH_OUTPUT" | grep -oP 'https://github\.com/login/device\S+')
CODE=$(echo "$AUTH_OUTPUT" | grep -oP '(?<=code: )[A-Z0-9-]+')
echo "Open this URL in your browser: $AUTH_URL"
echo "Your one-time code is: $CODE"
echo "Press Enter after you've completed the authentication in your browser."
read

if gh auth status &>/dev/null; then
    echo "GitHub CLI login successful!"
else
    echo "GitHub CLI login failed. Please try running the script again."
    exit 1
fi

echo "Cloning your bash files repository..."
display_tech_fact
gh repo clone kustys/my-bash-files ~/my-bash-files >/dev/null 2>&1

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
