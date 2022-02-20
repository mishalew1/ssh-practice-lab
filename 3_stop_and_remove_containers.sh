#!/bin/bash

BOXES=(rachel_box monica_box phoebe_box joey_box chandler_box ross_box)

start_message(){
	echo "Shutting down containers, please wait: .."
}

stop_containers() {
    for i in "${BOXES[@]}"; do
	    docker stop $i 2>/dev/null
	done
}


kill_containers() {
    for i in "${BOXES[@]}"; do
	    docker exec $i kill 1 2>/dev/null
	done
}


remove_containers() {
    for i in "${BOXES[@]}"; do
	    docker rm $i 2>/dev/null
	done
}


reset_config_dir() {
    sudo rm -r "$HOME"/ssh-practice-lab/config/ 2>/dev/null
}


main() {
	start_message
    remove_containers
    stop_containers
	kill_containers
	remove_containers
	reset_config_dir
}
main
