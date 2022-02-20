#!/bin/bash

# Global immutable variables
readonly KEY_DIR="$HOME"/ssh-practice-lab/keys/

# Functions
create_rsa_key() {
	echo "Creating public keys:"
	ssh-keygen -t rsa -b 4096 -C "email@example.com" -f "$KEY_DIR"/id_rsa
}


display_key() {
	ls -lAh "$KEY_DIR"
    echo ""
	cat "$KEY_DIR"/id_rsa.pub
}

main(){
	create_rsa_key
	display_key
}
main
