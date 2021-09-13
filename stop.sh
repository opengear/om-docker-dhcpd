#!/bin/bash
# Script to stop the dhcp container

echo
echo Stopping container...
echo
sudo docker stop dhcp
echo
sudo docker ps -a
echo