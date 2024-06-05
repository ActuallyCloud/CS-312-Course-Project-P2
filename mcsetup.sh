#!/bin/bash

echo "This script will set up a minecraft server for you automatically on a deployed AWS server."
echo "This script assumes this server has not been interacted with at all other than Terraform deployment."

echo "Updating packages... (may take a while)"
apt update > /dev/null
apt upgrade -y > /dev/null

echo "Installing Java... (may take a while)"
apt install openjdk-17-jdk -y > /dev/null

echo "Creating a new user for the Minecraft server..."
useradd -r -m -U -d /Minecraft -s /bin/bash minecraft