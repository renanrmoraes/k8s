#!/bin/bash

echo -n "Root password:"
read -s password

for i in $(ansible -i "{{ ansible_inventory_sources }}" --list-hosts all | grep k);do sshpass -p $password ssh-copy-id $i ;done
