# ssh-practice-lab
Mini lab to learn how SSH works

This lab spins up 6 docker containers we can SSH into

## Instructions
1) Install docker
2) Run containers via script
3) Practice SSH into the containers
4) Customize SSH config file

### Installing docker
Simply run the script like so:
```
sh install_docker.sh
```

### Setting up the containers
Run the script which will spin up 6 containers
```
sh setup_containers.sh
```
    
### Practice SSH 
Once containers are setup connect to them with the following syntax:
```
ssh USER@HOST -p 2222
ssh rachel@172.17.0.2 -p 2222
```

Test the port is open with netcat
```
nc -zv 172.17.0.2 2222
```

### Edit the config file
The config file should be located or created at $HOME/.ssh/config
Permissions should be set to 600 so that other users cannot see what servers you can access
    chmod 600 $HOME/.ssh/config

It uses the following syntax:
```
Host easy_name
    HostName 172.17.0.2  
    User rachel  
    port 2222  
    IdentityFile ~/.ssh/id_ed25519  
```

This allows us to configure 100's of servers and not have to remember all the IP's, ports and different SSH keys.
We can then log in like so:
```
ssh easy_name 
```
