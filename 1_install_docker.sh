#!/bin/bash

# Global variables
readonly LOCATION=/tmp/get-docker.sh

# functions

check_exists() {
	command -v docker 2>/dev/null && echo "Docker already installed. Exiting." || echo "Docker not installed, proceeding:"
	exit_code="$?"
}


download_convenience_script() {
    curl -fsSL https://get.docker.com -o "$LOCATION"
}


run_convenience_script() {
    sudo sh "$LOCATION"
}

setup_docker() {
    systemctl enable --now docker
	groupadd docker 2>/dev/null
	usermod -aG docker $(logname)
	newgrp docker
}


main() {
	check_exists
	
	if [ $exit_code -ne 0 ]; then 
		download_convenience_script
	    run_convenience_script
	    setup_docker
	fi

}
main
