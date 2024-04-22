#!/bin/bash
read -p "Do you want to use DHCP or Static IP? (dhcp/static): " ip_type
config=""
if [[ "$ip_type" == "dhcp" ]]; then
    config="dhcp4: true"
elif [[ "$ip_type" == "static" ]]; then
    read -p "Enter IP address and subnet mask (e.g., 172.26.137.116/20): " ip_subnet
    read -p "Enter gateway address (e.g., 172.26.128.1): " gateway
    read -p "Enter DNS servers (comma-separated): " dns_servers
    config=$(cat <<EOF
dhcp4: false
addresses:
  - $ip_subnet
routes:
  - to: 0.0.0.0/0
    via: $gateway
nameservers:
  addresses: [$dns_servers]
EOF
    )
else
    echo "Invalid option. Please choose either dhcp or static."
    exit 1
fi
echo "Available netplan configurations:"
ls /etc/netplan/*.yaml 2>/dev/null || echo "No netplan configurations found."

read -p "Enter the name of the configuration file you want to edit (e.g., 01-netcfg.yaml): " config_file
config_path="/etc/netplan/$config_file"

if [ -f "$config_path" ]; then
    echo "Editing $config_path"
else
    echo "Error: Configuration file not found."
    exit 1
fi
cat <<EOF | sudo tee "$config_path"
network:
  version: 2
  ethernets:
    eth0:
      $config
EOF

sudo netplan apply
