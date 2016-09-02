#!/bin/bash

if [[ -z $1 ]]; then
    echo "Enter a node you want to ssh to."
    echo "For example: ./ssh-overcloud.sh compute-0"
    exit 1
fi

rm ~/.ssh/known_hosts > /dev/null

VM_IP=$(nova list | grep $1 | cut -d '|' -f 7 | cut -d '=' -f 2)
echo $VM_IP

ssh -oStrictHostKeyChecking=no heat-admin@$VM_IP
