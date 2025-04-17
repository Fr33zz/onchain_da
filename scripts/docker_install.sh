#!/bin/bash

set -e

USER_TO_ADD=${1:-$SUDO_USER}

echo "📦 Updating system packages..."
apt update && apt upgrade -y

echo "🔐 Installing prerequisites..."
apt install -y ca-certificates curl gnupg lsb-release

echo "🔑 Adding Docker’s official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "📦 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🐳 Installing Docker Engine + Docker Compose plugin..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Enabling and starting Docker..."
systemctl enable docker
systemctl start docker

# Optional: Add non-root user to docker group
if [ -n "$USER_TO_ADD" ]; then
  echo "👤 Adding user '$USER_TO_ADD' to docker group..."
  usermod -aG docker "$USER_TO_ADD"
  echo "⚠️  You must log out and log back in (or run 'newgrp docker') for group changes to take effect."
fi

echo "🎉 Docker installed successfully!"
docker --version

echo 'opening the port to connection'
ufw allow 5432/tcp #docker
ufw allow 3000/tcp #metabase
ufw reload