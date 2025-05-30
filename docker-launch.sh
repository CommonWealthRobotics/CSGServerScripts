#!/bin/bash

# CSG Server Docker Runner Script
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

echo "Starting CSG Server..."
echo "Script directory: $SCRIPT_DIR"

# Check if user is in docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding user $USER to docker group..."
    sudo usermod -aG docker $USER
    echo "User added to docker group. You may need to log out and back in for changes to take effect."
    echo "Alternatively, you can run: newgrp docker"
    echo "Continuing with current session..."
fi

# Check if docker service is running
if ! systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found in current directory"
    exit 1
fi

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo "Error: Dockerfile not found in current directory"
    exit 1
fi

# Stop and remove any existing containers and images
echo "Cleaning up existing containers and images..."
docker-compose down --remove-orphans || true
docker container prune -f || true

# Remove the specific image if it exists
docker rmi csgserverscripts_bowler-studio:latest || true

# Build and run the container with no cache
echo "Building and starting CSG Server container (clean build)..."
docker-compose up --build --force-recreate

echo "CSG Server has stopped."
