#/bin/bash

INSTACK_IP=`grep $(tripleo get-vm-mac instack) /var/lib/libvirt/dnsmasq/default.leases | awk '{print $3;}' | head -n 1`
echo $INSTACK_IP
ssh root@$INSTACK_IP
