#!/bin/bash

echo

docker exec dhcp cat /var/lib/dhcp/dhcpd.leases
