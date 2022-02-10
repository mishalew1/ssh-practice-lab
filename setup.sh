#!/bin/bash

# Global Immutable variables
BOX_1=web-server
USER_1=homer
PASS_1=simpson

run_container_1() {
    docker run -d \
		--name="$BOX_1" \
		-e PUID=1000 \
		-e PGID=1000 \
		-e TZ=America/Toronto \
		-e USER_NAME="$USER_1" \
		-e USER_PASSWORD="$PASS_1" \
		-p 2222:2222 \
		-v "$HOME"/ssh-practice-lab/config:/config \
		--restart unless-stopped \
		lscr.io/linuxserver/openssh-server
}

print_box_IP() {
	box_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$BOX_1")
	echo "$BOX_1 IP: $box_ip"
	echo "User: $USER_1" 
	echo "Pass: $PASS_1"
}

main() {
    #run_container_1
	print_box_IP
}
main
