#!/bin/bash

echo "Creating a systemd service for the Minecraft server..."
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