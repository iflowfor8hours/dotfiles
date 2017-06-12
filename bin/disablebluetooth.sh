#!/bin/bash

sudo -i

# systemctl list-dependencies multi-user.target 

systemctl disable bluetooth.service
systemctl disable isc-dhcp-server.service
systemctl disable isc-dhcp-server6.service
systemctl disable openvpn.service
systemctl disable postgresql.service
systemctl disable transmission-daemon.service
systemctl disable whoopsie.service
systemctl disable ModemManager.service
systemctl disable bluetooth.target
rfkill block bluetooth
rfkill block wwan
