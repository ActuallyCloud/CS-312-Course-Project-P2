#!/bin/bash

echo "This script will set up a minecraft server for you automatically on a deployed AWS server."
echo "This script assumes this server has not been interacted with at all other than Terraform deployment."

echo "Updating packages... (may take a while)"
apt update > /dev/null
apt upgrade -y > /dev/null

echo "Installing Java... (may take a while)"
apt install openjdk-17-jdk -y > /dev/null

echo "Setting up directory for MC server..."
mkdir minecraft && cd minecraft
wget https://api.papermc.io/v2/projects/paper/versions/1.18.2/builds/388/downloads/paper-1.18.2-388.jar
mv paper-1.18.2-388.jar paper.jar
echo 'eula=true' > eula.txt

echo "Creating a systemd service for the Minecraft server..."
cd ../..
cd /etc/systemd/system
echo "[Unit]
Description=Minecraft Server

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/minecraft
Restart=on-failure
RestartSec=10s
ExecStart=java -Xmx1536M -Xms1536M -jar paper.jar

[Install]
WantedBy=multi-user.target" > mcserver.service

echo "Starting the Minecraft server..."
systemctl daemon-reload
systemctl start mcserver
systemctl enable mcserver

echo "Current server status..."
systemctl status mcserver