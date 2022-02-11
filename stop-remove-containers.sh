#!/bin/bash

BOXES=(coffee-shop restaurant massage-spa famous-actor IT-procurement museum)

stop_containers() {
    for i in "${BOXES[@]}"; do
	    docker stop $i
	done
}


kill_containers() {
    for i in "${BOXES[@]}"; do
	    docker exec $i kill 1
	done
}


remove_containers() {
    for i in "${BOXES[@]}"; do
	    docker rm $i
	done
}


main() {
	remove_containers
    stop_containers
	kill_containers
	remove_containers
}
main
