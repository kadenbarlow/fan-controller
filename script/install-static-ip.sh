#!/bin/bash

echo "\nPlease enter the static ip that you want to use, e.g. 192.168.0.80"
read static_ip
echo "Please enter the router's ip address, e.g. 192.168.0.1"
read router_ip

# Add required settings to the dhcpcd config
echo "interface wlan0" >> /etc/dhcpcd.conf
echo "static ip_address=$static_ip/24" >> /etc/dhcpcd.conf
echo "static routers=$router_ip" >> /etc/dhcpcd.conf
echo "static domain_name_servers=$router_ip" >> /etc/dhcpcd.conf

# Make sure dhcpcd service is running
service dhcpcd start
systemctl enable dhcpcd
