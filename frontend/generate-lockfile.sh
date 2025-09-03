#!/bin/bash
set -e

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Copy package.json to the temporary directory
cp package.json "$TEMP_DIR/"

# Run npm install in a Node.js container to generate package-lock.json
echo "Generating package-lock.json..."
docker run --rm -v "${TEMP_DIR}:/app" -w /app node:20-alpine sh -c "npm install --package-lock-only --no-audit --no-fund"

# Copy the generated package-lock.json back to the project
cp "$TEMP_DIR/package-lock.json" .

# Clean up
rm -rf "$TEMP_DIR"

echo "package-lock.json has been generated successfully!"
