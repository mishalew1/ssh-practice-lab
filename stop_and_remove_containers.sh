#!/bin/bash

BOXES=(rachel_box monica_box phoebe_box joey_box chandler_box ross_box)

stop_containers() {
    for i in "${BOXES[@]}"; do
	    docker stop $i
	done
}


kill_containers() {
    for i in "${BOXES[@]}"; do
	    docker exec $i kill 1 2>/dev/null
	done
}


remove_containers() {
    for i in "${BOXES[@]}"; do
	    docker rm $i
	done
}


main() {
	#remove_containers
    stop_containers
	kill_containers
	remove_containers
}
main
