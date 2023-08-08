#!/bin/bash

# Check if the script is run with sudo
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Prompt for username and password
read -p "Choose a username for the new user: " USERNAME
read -s -p "Enter a password for the new user: " PASSWORD
echo

# Fetch the public IP and save it to a variable
PUBLIC_IP=$(curl -s https://api.ipify.org)

# Create a new user with the provided username and password
useradd -m -G www-data "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Add the new user to the sudo group
usermod -aG sudo "$USERNAME"

# Install Docker and Docker Compose
apt update
apt install -y docker.io
systemctl start docker
systemctl enable docker
systemctl enable docker.service

# Install Docker Compose
curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Download and extract the ZIP file using curl
apt install -y unzip

# Clear out old stuff
# rm -rf /home/$USERNAME
# mkdir -p /home/$USERNAME

# Switch to the user's home directory
cd /home/$USERNAME && wait

# Download the code from GitHub as a ZIP
mkdir -p tmp
curl -LJ -o tmp/master.zip https://github.com/ikmolbo/Simple-PHP-Server/archive/refs/heads/master.zip
unzip tmp/master.zip -d ./tmp
rm tmp/master.zip
mv -f ./tmp/Simple-PHP-Server-master/* .
rm -rf ./tmp

# Clean up
rm /home/$USERNAME/install.sh

# Set permissions
chown -R $USERNAME:www-data /home/$USERNAME
wait
 
# Build the Docker image for the app
cd ./app  # Assuming the Dockerfile is in this directory
sudo -u $USERNAME docker build -t app .

# Build and run the Docker Compose setup
cd ..  # Assuming the docker-compose.yml is in this directory
sudo -u $USERNAME docker-compose up -d
sudo -u $USERNAME docker-compose ps

# Print username and password
echo "Your username is $USERNAME"
echo "Your password is $PASSWORD"
echo "Your public IP is http://$PUBLIC_IP"

echo "Setup completed successfully."
