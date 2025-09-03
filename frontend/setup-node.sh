#!/bin/bash
set -e

# Install system dependencies
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl

# Install Node.js using nvm
echo "Setting up NVM..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || (
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
)

# Install Node.js
echo "Installing Node.js 20..."
nvm install 20
nvm use 20

# Go to frontend directory
cd /home/runner/work/personas-v2/personas-v2/frontend

# Generate package-lock.json if it doesn't exist
if [ ! -f "package-lock.json" ]; then
  echo "Generating package-lock.json..."
  npm install --package-lock-only --no-audit --no-fund
fi

# Install dependencies
echo "Installing dependencies..."
npm ci --prefer-offline --no-audit --no-fund

# Verify installation
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"
