#!/bin/bash

echo "This script will set up a minecraft server for you automatically on a deployed AWS server."
echo "This script assumes this server has not been interacted with at all other than Terraform deployment."

echo "Updating packages..."
apt update && apt upgrade -y

echo "Installing Java..."
apt install openjdk-17-jdk -y

echo "Creating a new user for the Minecraft server and switching to it..."
useradd -r -m -U -d /Minecraft -s /bin/bash minecraft
sudo su - minecraft

echo "Downloading the Minecraft server jar..."
wget https://api.papermc.io/v2/projects/paper/versions/1.18.2/builds/388/downloads/paper-1.18.2-388.jar
mv paper-1.18.2-388.jar paper.jar
echo "eula=true" > eula.txt

echo "Creating a systemd service for the Minecraft server..."
exit
cd /etc/systemd/system
echo "[Unit]
Description=Minecraft Server

[Service]
User=minecraft
WorkingDirectory=/Minecraft
Restart=on-failure
RestartSec=10s
ExecStart=java -Xmx2G -Xms2G -jar paper.jar

[Install]
WantedBy=multi-user.target" > mcserver.service

echo "Starting the Minecraft server..."
systemctl daemon-reload
systemctl start mcserver
systemctl enable mcserver

echo "Current server status..."
systemctl status mcserver