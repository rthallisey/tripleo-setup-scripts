#/bin/bash

sudo virsh destroy instack
sudo virsh destroy baremetalbrbm_0
sudo virsh destroy baremetalbrbm_1
sudo virsh destroy baremetalbrbm_2
sudo virsh destroy baremetalbrbm_3
sudo virsh undefine instack
sudo virsh undefine baremetalbrbm_0
sudo virsh undefine baremetalbrbm_1
sudo virsh undefine baremetalbrbm_2
sudo virsh undefine baremetalbrbm_3

#export NODE_DIST=centos7
#export DIB_LOCAL_IMAGE=CentOS-7-x86_64-GenericCloud-1508.qcow2
export NODE_DIST=rhel7
export DIB_LOCAL_IMAGE=rhel-guest-image-7.2-20151102.0.x86_64.qcow2
export NODE_COUNT=4
export NODE_CPU=4
export NODE_MEM=16384

instack-virt-setup

INSTACK_IP=`grep $(tripleo get-vm-mac instack) /var/lib/libvirt/dnsmasq/default.leases | awk '{print $3;}' | head -n 1`

sleep 5
echo "Waiting for VM to start..."

scp $DIB_LOCAL_IMAGE root@${INSTACK_IP}:/home/stack
scp undercloud-setup.sh root@${INSTACK_IP}:/home/stack
scp overcloud-containers-setup.sh root@${INSTACK_IP}:/home/stack
scp net-single-nic-with-vlans.yaml root@${INSTACK_IP}:/home/stack
scp  setup-undercloud-route.sh root@${INSTACK_IP}:/home/stack
