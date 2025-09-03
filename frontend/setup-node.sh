#!/bin/bash
set -e

# Install system dependencies
sudo apt-get update
sudo apt-get install -y curl

# Install Node.js using nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || (
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
)

# Install Node.js
nvm install 20
nvm use 20

# Go to frontend directory
cd /home/runner/work/personas-v2/personas-v2/frontend

# Install dependencies
echo "Installing dependencies..."
npm ci --prefer-offline --no-audit --no-fund

# Verify installation
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"
