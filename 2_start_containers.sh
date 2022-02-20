#!/bin/bash

# Lists & Variables 
BOXES=(rachel_box monica_box phoebe_box joey_box chandler_box ross_box)
USERS=(rachel monica phoebe joey chandler ross)
PASSWORDS=(green geller buffay tribbiani bing geller)
PORTS=(2223 3456 4567 2890 22 4444)

# ANSI Colors 
GREEN="\033[0;32m" 
RESTORE="\033[0m" 


run_containers() {
    for i in "${!BOXES[@]}"; do
	docker run -d \
		--name="${BOXES[i]}" \
		--hostname="${BOXES[i]}" \
		-e PUID=1000 \
		-e PGID=1000 \
		-e TZ=America/Toronto \
		-e PASSWORD_ACCESS=true \
		-e SUDO_ACCESS=false \
		-e PUBLIC_KEY="$HOME"/ssh-practice-lab/keys/id_rsa.pub \
		-e USER_PASSWORD="${PASSWORDS[i]}" \
		-e USER_NAME="${USERS[i]}" \
		-p "${PORTS[i]}":2222 \
		-v "$HOME"/ssh-practice-lab/config/config-${USERS[i]}:/config \
		-v "$HOME"/ssh-practice-lab/motd:/etc/motd \
		--restart unless-stopped \
		lscr.io/linuxserver/openssh-server 2>/dev/null
	done
	local i
}



list_containers() {
    docker container ls -a
}


print_box_info() {
	for box in "${BOXES[@]}"; do
	    box_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$box")
		box_ports=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$box")
		box_name=$(docker inspect -f '{{.Name}}' "$box" | cut -c2-)
	    box_pass=$(docker inspect $box | awk -F = '/USER_PASSWORD/ { print $2 }' | sed 's/",//')
	    box_user=$(docker inspect $box | awk -F = '/USER_NAME/ { print $2 }' | sed 's/",//')
	    echo -e "${GREEN}$box:${RESTORE}"
        echo -e "User: $box_user, Pass: $box_pass, IP: $box_ip, Port:$box_ports\n"
	done
	local box
}


print_syntax() {
	echo -e "${GREEN}Syntax: ${RESTORE}'ssh user@ip_addr -p port_num"
	echo -e "${GREEN}Example:${RESTORE} 'ssh rachel@172.17.0.2 -p 2222'\n"
}


test_connection(){
	echo -e "${GREEN}Testing connections: ${RESTORE}"
	for box in "${BOXES[@]}"; do
	    box_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$box")
		netcat -zvw2 "$box_ip" 2222
	done
	local box
}


main() {
	run_containers
	list_containers
	print_box_info
	print_syntax
	test_connection
}
main
