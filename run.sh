#!/bin/bash
# Script builds the docker image, runs the containers, and starts the dhcpd service on the container

# Check for an existing dhcp container and image
checkExisting(){

    if sudo docker ps -a | grep dhcp > /dev/null; then
	    echo
        echo "Found existing dhcp container and image. Removing..."
        echo "This may take up to 30 seconds..."
        echo
        if [ "$( docker container inspect -f '{{.State.Status}}' dhcp )" == "running" ]; then
            sudo docker stop dhcp
        else
            :
        fi
        sudo docker rm dhcp
	sudo docker rmi opengear:dhcpd
	echo "Done!"
    else
	echo
        echo "No existing dhcp containers found."
        echo
    fi

}


# Check and make necessary files and directories
makeFiles(){

    leaseDir=/var/lib/dhcp
    leaseFile=/var/lib/dhcp/dhcpd.leases
    if [ ! -d "$leaseDir" ]; then
        echo
        echo "Creating /var/lib/dhcp"
        echo
        sudo mkdir /var/lib/dhcp
    fi

    if [ ! -f "$leaseFile" ]; then
        echo
        echo "Creating /var/lib/dhcp/dhcpd.leases"
        echo
        sudo touch /var/lib/dhcp/dhcpd.leases
    fi

    # Check if dhcpd.conf exists
    dhcpConf=/etc/dhcp/dhcpd.conf
    if [ ! -f "$dhcpConf" ]; then
        echo
        echo "Script stopped!"
        echo "Cannot find file /etc/dhcp/dhcpd.conf. Copy your dhcpd.conf to /etc/dhcp and re-run install.sh" >&2
        echo 
        exit 1
    fi

}

# Build dhcpd docker image from Dockerfile
dockerBuild(){

    if sudo docker images -a | grep dhcpd > /dev/null; then
        echo
        echo "Building opengear:dhcpd Docker image..."
        echo
        sudo docker build -t opengear:dhcpd .
        echo 
        sleep 2
    else
        echo "Docker image opengear:dhcpd not found."
        echo
        echo "Run import.sh to import docker image."
        echo
        echo "Exiting..."
        echo
        exit 1
    fi

}

# Create the dhcp docker container
dockerRun(){

    echo
    echo "Creating dhcp Docker container..."
    echo
    sudo docker run \
        --name dhcp \
        -itd \
        --net host \
        -v /etc/dhcp:/etc/dhcp \
        -v /var/lib/dhcp:/var/lib/dhcp \
        opengear:dhcpd \
        /bin/sh
    
    echo
    sleep 2

}

# Start the dhcp docker container
containerStart(){

    echo
    echo "Starting dhcp Docker container..."
    echo
    sudo docker start dhcp
    sleep 2
    echo

}

# Start the dhcpd service in the dhcp Docker container
dhcpStart(){

    echo
    echo "Starting the dhcpd service in the dhcp Docker container..."
    echo
    sudo docker exec dhcp dhcpd
    echo
    sleep 2
    echo
    echo "Checking if dhcp container is running..."    
    if sudo docker ps -a | grep dhcp > /dev/null; then
	    echo
        echo "Container running!!!"
        echo
    else
        echo
        echo "Container is not running. Trying to start..."
        sudo docker start dhcp
    fi
    sleep 2
    echo "Checking if dhcpd service is running in the container..."
    if sudo docker exec dhcp ps -a | grep dhcpd > /dev/null; then
	    echo
        docker exec dhcp ps -a | grep dhcpd
        echo
	    echo "dhcpd service running in the container!"
	    echo
    else
	    echo "dhcpd not running in container..."
	    echo "trying to start..."
	    sudo docker exec dhcp dhcpd
        echo
    fi

}

# Execute functions
checkExisting
makeFiles
dockerBuild
dockerRun
containerStart
dhcpStart