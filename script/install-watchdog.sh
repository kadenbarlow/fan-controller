#!/bin/bash
# RUN this script with sudo

echo 'dtparam=watchdog=on' >> /boot/config.txt

apt-get update
apt-get install watchdog

echo 'watchdog-device = /dev/watchdog' >> /etc/watchdog.conf
echo 'watchdog-timeout = 15' >> /etc/watchdog.conf
echo 'max-load-1 = 24' >> /etc/watchdog.conf
echo 'interface = wlan0' >> /etc/watchdog.conf

systemctl enable watchdog
systemctl start watchdog
systemctl status watchdog
reboot
