#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

# Check for required packages
if ! is_installed nginx || ! is_installed certbot || ! is_installed python3-certbot-nginx; then
    echo "Installing required packages..."
    apt-get update
    apt-get install -y nginx certbot python3-certbot-nginx
fi

# Prompt for domain name
read -p "Enter your domain name: " domain

# Prompt for backend port
read -p "Enter the port your backend is running on (default is 8080): " port
port=${port:-8080}

# Create Nginx configuration file
config_file="/etc/nginx/sites-available/$domain"
if [ -f "$config_file" ]; then
    read -p "Configuration for $domain already exists. Overwrite? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Exiting without making changes."
        exit 0
    fi
fi

cat > "$config_file" <<EOL
server {
    listen 80;
    listen [::]:80;
    server_name $domain;

    location / {
        proxy_pass http://localhost:$port;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Create symbolic link to sites-enabled
ln -sf "$config_file" "/etc/nginx/sites-enabled/"

# Remove default Nginx configuration if it exists
if [ -f "/etc/nginx/sites-enabled/default" ]; then
    rm "/etc/nginx/sites-enabled/default"
fi

# Test Nginx configuration
nginx -t

if [ $? -eq 0 ]; then
    # Obtain SSL certificate using Certbot
    if certbot --nginx -d "$domain" --non-interactive --agree-tos --email webmaster@"$domain" --redirect; then
        echo "SSL certificate obtained and Nginx configured successfully."
    else
        echo "Failed to obtain SSL certificate. Please check your domain and Certbot configuration."
        exit 1
    fi

    # Reload Nginx to apply all changes
    systemctl reload nginx

    echo "Configuration complete! Your site should now be accessible at https://$domain"
    echo "The backend is configured to proxy requests to localhost:$port"
else
    echo "Nginx configuration test failed. Please check your configuration."
    exit 1
fi
