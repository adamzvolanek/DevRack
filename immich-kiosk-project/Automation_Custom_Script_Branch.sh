#!/bin/bash

# Variables
immich_api_key=""
immich_url=""
album_id=""

# Create /opt/kiosk directory
mkdir -p /home/dietpi/immichkiosk

# Download pre-configured config.yaml
wget https://raw.githubusercontent.com/adamzvolanek/DevRack/refs/heads/immichframe2/immich-kiosk-project/config.yaml -O /home/dietpi/immichkiosk/config.yaml

# Download and extract immich-kiosk
wget https://github.com/damongolding/immich-kiosk/releases/download/v0.25.0/immich-kiosk_Linux_arm64.tar.gz -O /home/dietpi/immichkiosk/immich-kiosk_Linux_arm64.tar.gz
tar -zxvf /home/dietpi/immichkiosk/immich-kiosk_Linux_arm64.tar.gz -C /home/dietpi/immichkiosk/

# Update the keys in the config file
sed -i "s|immich_api_key:.*|immich_api_key: \"$immich_api_key\"|" /home/dietpi/immichkiosk/config.yaml
sed -i "s|immich_url:.*|immich_url: \"$immich_url\"|" /home/dietpi/immichkiosk/config.yaml
sed -i '/^albums:/!b;n;s|.*|  - "'"$album_id"'"|' /home/dietpi/immichkiosk/config.yaml

# Create systemd service file
wget https://raw.githubusercontent.com/adamzvolanek/DevRack/refs/heads/immichframe2/immich-kiosk-project/immich-kiosk.service -O /etc/systemd/system/immich-kiosk.service

# Reload systemd, enable
systemctl daemon-reload
systemctl enable immich-kiosk.service
systemctl start immich-kiosk.service

# Fix Memory warning in chromium with updated resolution
wget https://raw.githubusercontent.com/adamzvolanek/DevRack/refs/heads/immichframe2/immich-kiosk-project/chromium-autostart.sh -O /var/lib/dietpi/dietpi-software/installed/chromium-autostart.sh

echo "Installation and setup complete!"
