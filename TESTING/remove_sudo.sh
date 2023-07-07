#!/bin/bash
export USER_NAME=$(id -un 1000)

# Remove default user from sudo group
sudo deluser $USER_NAME sudo

# sudo rm -f /etc/sudoers.d/90-cloud-init-users

sudo sed -n -i "/"$USER_NAME" ALL=(ALL) NOPASSWD:ALL/d" /etc/sudoers.d/90-cloud-init-users
