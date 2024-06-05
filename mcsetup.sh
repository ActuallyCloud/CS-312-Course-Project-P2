#!/bin/bash

echo "This script will set up a minecraft server for you automatically on a deployed AWS server."
echo "This script assumes this server has not been interacted with at all other than Terraform deployment."

echo "Updating packages..."
apt update && apt upgrade -y

echo "Installing Java..."
apt install openjdk-17-jdk -y
