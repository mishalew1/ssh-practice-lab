#!/bin/bash

# Global Immutable variables
BOXES=(coffee-shop restaurant massage-spa famous-actor IT-procurement museum)
USERS=(Rachel Monica Phoebe Joey Chandler Ross)
PASSWORDS=(Green Geller Buffay Tribbiani Bing Geller)
PORTS=(2224 2225 2226 2227 2228 2229)

# ANSI Colors 
GREEN="\033[0;32m" 
RESTORE="\033[0m" 

run_containers_test() {
    for i in "${!BOXES[@]}"; do
        echo "${BOXES[i]} ${BOXES[i]} ${USERS[i]} ${PASSWORDS[i]} ${PORTS[i]}:2222"   \ 
	done
	local i
}

run_containers() {
    for i in "${!BOXES[@]}"; do
	docker run -d \
		--name="${BOXES[i]}" \
		--hostname="${BOXES[i]}" \
		-e PUID=1000 \
		-e PGID=1000 \
		-e TZ=America/Toronto \
		-e PASSWORD_ACCESS=true \
		-e USER_PASSWORD="${PASSWORDS[i]}" \
		-e USER_NAME="${USERS[i]}" \
		-p "${PORTS[i]}":2222 \
		-v "$HOME"/ssh-practice-lab/config:/config \
		-v "$HOME"/ssh-practice-lab/motd:/etc/motd \
		--restart unless-stopped \
		lscr.io/linuxserver/openssh-server
	done
	local i
}


list_containers() {
    docker container ls -a
}


print_box_IP() {
	for i in "${!BOXES[@]}"; do
	    box_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${BOXES[i]}")
	    echo -e "${GREEN}${BOXES[i]}: $box_ip ${RESTORE}"
        echo -e "Port: ${PORTS[i]}"
		echo -e "User: ${USERS[i]}"
		echo -e "Pass: ${PASSWORDS[i]}"
	done
	local i
}


print_syntax() {
	echo -e "${GREEN}Syntax: 'ssh USER@IP -p PORT_NUMBER'${RESTORE}"
	echo -e "${GREEN}Example: 'ssh Rachel@IP -p 2224'${RESTORE}"
}


main() {
	#run_containers_test
	run_containers
	list_containers
	print_box_IP
	print_syntax
}
main
