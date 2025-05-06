Notes:

    - Docker container maps to host directories "/etc/dhcp/" and "/var/lib/dhcp/"
    - Requires two files: "dhcpd.conf" and "dhcpd.leases"
    - "dhcpd.conf" must be copied to "/etc/dhcp/" on the host (example dhcpd.conf included)
    - "dhcpd.leases" is created automatically by the "run.sh" script
    
Instructions:

    1. Copy all files to the OM (via SCP, USB, etc)
    2. Bash "import.sh" to import the docker image to the OM
    3. Bash "run.sh" to build and start the container

Usage:

    import.sh - import docker image from tar file
    run.sh - Build and start the container (you can run this each time instead of stop.sh or start.sh)
    stop.sh - stop the container
    start.sh - restart the container
    leases.sh - checks the current lease database (use to verify leases are being given out)
