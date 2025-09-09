#!/usr/bin/env bash
set -e

echo "Installing dependencies: curl, docker, docker-compose..."
sudo apt-get update
sudo apt-get install -y curl

if ! command -v docker &>/dev/null; then
  echo "Docker not found. Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "${USER}"
else
  echo "Docker is already installed: $(docker -v)"
fi

if ! command -v docker-compose &>/dev/null; then
  echo "docker-compose not found. Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "docker-compose version: $(docker-compose --version)"
else
  echo "docker-compose is already installed: $(docker-compose --version)"
fi

echo "Setting up Filestash directory..."
mkdir -p filestash
cd filestash

echo "Downloading the latest docker-compose.yml..."
curl -O https://downloads.filestash.app/latest/docker-compose.yml

echo "Starting Filestash with Docker Compose..."
docker-compose up -d

echo
echo "✅ Filestash should now be running."
echo "Visit http://<your_server_ip_or_domain>:8334 to configure the admin password and storage backends."
