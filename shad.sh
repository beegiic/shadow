#!/bin/bash

# Update and upgrade
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Shadowsocks-Rust via Snap
echo "📦 Installing Shadowsocks-Rust..."
sudo snap install shadowsocks-rust

# Create config directory
echo "📁 Creating config directory..."
sudo mkdir -p /var/snap/shadowsocks-rust/common/etc/shadowsocks-rust/

# Generate random password
PASSWORD=$(openssl rand -base64 16)

# Create config file
CONFIG_PATH="/var/snap/shadowsocks-rust/common/etc/shadowsocks-rust/config.json"
echo "📝 Writing config to $CONFIG_PATH..."
sudo bash -c "cat > $CONFIG_PATH" <<EOF
{
  "server": "0.0.0.0",
  "server_port": 8211,
  "password": "$PASSWORD",
  "timeout": 300,
  "method": "chacha20-ietf-poly1305"
}
EOF

# Restart and enable Shadowsocks server
echo "🚀 Starting Shadowsocks server..."
sudo systemctl restart snap.shadowsocks-rust.ssserver-daemon.service
sudo systemctl enable snap.shadowsocks-rust.ssserver-daemon.service

# Ensure curl is installed
echo "🔍 Checking if curl is installed..."
if ! command -v curl &> /dev/null; then
    echo "📥 curl not found. Installing..."
    sudo apt install curl -y
fi

# Get public IP
IP=$(curl -s ifconfig.me)

# Show connection info
echo ""
echo "✅ Shadowsocks Server Installed and Running!"
echo "🔑 Connection Details:"
echo "----------------------------------------"
echo "Server IP   : $IP"
echo "Port        : 8211"
echo "Password    : $PASSWORD"
echo "Encryption  : chacha20-ietf-poly1305"
echo "----------------------------------------"
