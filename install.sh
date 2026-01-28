#!/bin/bash

# Exit on error
set -e

echo "Starting installation..."

# Update package list and install basic dependencies
sudo apt-get update
sudo apt-get install -y curl git

# Install Docker using official script (works for Ubuntu, Debian, etc.)
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
else
    echo "Docker is already installed."
fi

# Ensure Docker is started and enabled
sudo systemctl enable --now docker

# Docker Compose is usually included in modern Docker installations via the get.docker.com script
# but we can check if it's available as 'docker compose'
if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose plugin..."
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
fi

# Handle Portspoof repository
if [ ! -d "Portspoof" ]; then
    echo "Cloning Portspoof repository..."
    git clone https://github.com/drk1wi/Portspoof.git
else
    echo "Portspoof directory already exists."
fi

# Try to run the project
echo "Starting the project with Docker Compose..."
sudo docker compose up --build -d

echo "Installation and startup complete!"
