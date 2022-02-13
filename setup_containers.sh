#!/bin/bash

# Global Immutable variables
BOXES=(rachel_box monica_box phoebe_box joey_box chandler_box ross_box)
USERS=(rachel monica phoebe joey chandler ross)
PASSWORDS=(green geller buffay tribbiani bing geller)
PORTS=(2223 2224 2225 2226 2227 2228)

# ANSI Colors 
GREEN="\033[0;32m" 
RESTORE="\033[0m" 


run_containers() {
    for i in "${!BOXES[@]}"; do
	docker run -d \
		--name="${BOXES[i]}" \
		-e PUID=1000 \
		-e PGID=1000 \
		-e TZ=America/Toronto \
		-e PASSWORD_ACCESS=true \
		-e USER_PASSWORD="${PASSWORDS[i]}" \
		-e USER_NAME="${USERS[i]}" \
		-p "${PORTS[i]}":2222 \
		-v "$HOME"/ssh-practice-lab/config/config-${USERS[i]}:/config \
		-v "$HOME"/ssh-practice-lab/motd:/etc/motd \
		--restart unless-stopped \
		lscr.io/linuxserver/openssh-server
	done
	local i
}

#		--hostname="${BOXES[i]}" \


list_containers() {
    docker container ls -a
}


print_box_IP() {
	for box in "${BOXES[@]}"; do
	    box_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$box")
		box_ports=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$box")
		box_name=$(docker inspect -f '{{.Name}}' "$box" | cut -c2-)
	    box_pass=$(docker inspect $box | awk -F = '/USER_PASSWORD/ { print $2 }' | sed 's/",//')
	    box_user=$(docker inspect $box | awk -F = '/USER_NAME/ { print $2 }' | sed 's/",//')
	    echo -e "${GREEN}$box: $box_ip ${RESTORE}"
        echo -e "Port: $box_ports"
		echo -e "User: $box_user"
		echo -e "Pass: $box_pass"
	done
	local box
}
# box_name=$(docker inspect -f '{{.Name}}' $(docker ps --format "{{.Names}}" | grep _box) | cut -c2-)

print_syntax() {
	echo -e "${GREEN}Syntax: 'ssh USER@IP -p PORT_NUMBER'${RESTORE}"
	echo -e "${GREEN}Example: 'ssh Rachel@IP -p 2224'${RESTORE}"
}


main() {
#	run_containers
	list_containers
	print_box_IP
	print_syntax
}
main
