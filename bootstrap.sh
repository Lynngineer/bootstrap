#!/bin/bash

# **************************************************************************************** #
# **************************************** PUBLIC **************************************** #
# **************************************************************************************** #
#           WARNING: This file & the upcoming host-specific playbook are PUBLIC.           #
# **************************************************************************************** #
# **************************************** PUBLIC **************************************** #
# **************************************************************************************** #

# usage:
# 	wget https://raw.githubusercontent.com/lynngineer/bootstrap/master/bootstrap.sh
# 	wget -qO- https://raw.githubusercontent.com/lynngineer/bootstrap/master/bootstrap.sh | bash
# assumptions:
# 	Already have /home/user or similar admin, not root.

# Bootstrap-Generic:
#  - Req: bash, developed on xubuntu 18.04.2
#  - Creates a working directory.
#  - Installs ansible & configures inventory as localhost.
#  - Prep for next bootstrap file (private).

# Not root
if [ "$EUID" -eq 0 ]; then
    echo "Not root; not yet..."
    exit 1
fi

echo "###############################################################"
echo "######## A directory for bootstrap artifacts"
echo "###############################################################"
WORK_DIR=$HOME/bootstrap
if [ ! -d "$WORK_DIR" ]; then
	echo -e "#### Creating: $WORK_DIR for public repo files\n"
	mkdir $WORK_DIR
	while [ ! -d "$WORK_DIR" ]; do sleep 1 ;done
	if [ ! -d "$WORK_DIR" ]; then
		echo -e "#### Check on: $WORK_DIR - Still not found, getting ridiculous\n"
		exit $?
	fi
fi
cd $WORK_DIR
pwd
ls -la

echo "###############################################################"
echo "######## Installs (relatively quietly)"
echo "###############################################################"
sudo apt-get install software-properties-common -y -q
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -qq 		# Need after the add repo
sudo apt-get install ansible -y  -q
sudo apt-get install vim
sudo apt-get install neofetch

echo "###############################################################"
echo "######## Sanity deets"
echo "###############################################################"
HOST=$(hostnamectl --static)
echo $HOST
python --version
ansible --version

echo "###############################################################"
echo "######## Configure Local Ansible inventory and configuration for localhost"
echo "###############################################################"
if [ -e ansible.hosts ]; then
    sudo cp ansible.hosts "ansible.hosts.`date --iso`"
fi
echo -e "localhost ansible_connection=local"  | sudo tee ansible.hosts
if [ -e ansible.cfg ]; then
    sudo cp ansible.cfg "ansible.cfg.`date --iso`"
fi
echo -e "[defaults]\ninventory = ansible.hosts" | sudo tee ansible.cfg
# cat /etc/ansible/hosts
ls -la

echo "###############################################################"
echo "######## Get public bootstrap playbook"
echo "###############################################################"
PLAYBOOK=bootstrap-git.yml
wget -qO- https://raw.githubusercontent.com/lynngineer/bootstrap/master/$PLAYBOOK --output-document=$WORK_DIR/$PLAYBOOK

echo "###############################################################"
echo "######## Downloaded $WORK_DIR/$PLAYBOOK"
echo "######## Run with:"
echo "######## ansible-playbook $PLAYBOOK "
echo "###############################################################"
echo "#####################  fin  ###################################"

# read -p "Press [Enter] key to run playbook "
# ansible-playbook $PLAYBOOK -i /etc/ansible/hosts


# **************************************************************************************** #
# **************************************** PUBLIC **************************************** #
# **************************************************************************************** #
#           WARNING: This file & the upcoming playbook are PUBLIC.                         #
# **************************************************************************************** #
# **************************************** PUBLIC **************************************** #
# **************************************************************************************** #
