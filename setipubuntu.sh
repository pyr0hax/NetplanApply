#!/bin/bash

list_netplan_configs() {
    echo "Available netplan configurations:"
    ls /etc/netplan/*.yaml 2>/dev/null || echo "No netplan configurations found."
}

select_netplan_config() {
    list_netplan_configs
    read -p "Enter the name of the configuration file you want to edit (e.g., 01-netcfg.yaml): " config_file
    config_path="/etc/netplan/$config_file"
    if [ -f "$config_path" ]; then
        echo "Editing $config_path"
    else
        echo "Error: Configuration file not found."
        exit 1
    fi
}

read -p "Do you want to use DHCP or Static IP? (dhcp/static): " ip_type

if [[ "$ip_type" == "dhcp" ]]; then
    config="dhcp4: yes"
else
    read -p "Enter IP address and subnet mask (e.g., 192.168.1.222/24): " ip_subnet
    read -p "Enter gateway address: " gateway
    read -p "Enter DNS servers (comma-separated): " dns_servers

    config="dhcp4: no\n    addresses: [$ip_subnet]\n    gateway4: $gateway\n    nameservers:\n      addresses: [$dns_servers]"
fi

select_netplan_config

cat <<EOF | sudo tee "$config_path"
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      $config
EOF

sudo netplan apply
