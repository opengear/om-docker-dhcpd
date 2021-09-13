#!/bin/bash
# Docker dhcpd container startup script

echo
echo Starting container...
echo

# Start the dhcp container
sudo docker start dhcp

# Create the the dhcpd.leases file in the container
# docker exec dhcp touch /var/lib/dhcp/dhcpd.leases

# Start the dhcpd service within the dhcp container
echo
sudo docker exec dhcp dhcpd

# Verify service dhcpd is running in the dhcp container
echo
sudo docker exec dhcp ps -a
echo
sudo docker ps -a
echo
echo bash leases.sh to check dhcp client leases
echo