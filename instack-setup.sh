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

export DIB_EPEL_MIRROR=http://dl.fedoraproject.org/pub/epel
export NODE_DIST=centos7
export DIB_LOCAL_IMAGE=CentOS-7-x86_64-GenericCloud-1606.qcow2
#export NODE_DIST=rhel7
#export DIB_LOCAL_IMAGE=rhel-guest-image-7.2-20151102.0.x86_64.qcow2
export NODE_COUNT=4
export NODE_CPU=4
export NODE_MEM=6144

export UNDERCLOUD_NODE_MEM=8192

if [[ -z `rpm -qa instack-undercloud` ]]; then
    echo "instack-undercloud is not installed!"
    echo "Follow the tripleo docs to setup the delorean repos: http://tripleo.org/environments/environments.html#virtual-environment"
else
    instack-virt-setup
fi

mac=$(sudo virsh dumpxml instack |
  xmllint --xpath //interface'[1]/mac/@address' - |
  sed 's/.*="\([^"]*\)"/\1/'
  )
INSTACK_IP=`arp -an | grep $mac | cut -d " " -f 2 | tr -d '(' | tr -d ')'`

sleep 5
echo "Waiting for VM to start..."

SCRIPT_DIR=~/tripleo-setup-scripts

copy_to_stack=( undercloud-setup.sh
overcloud-setup.sh
net-single-nic-with-vlans.yaml
setup-undercloud-route.sh
cleanup-ironic.sh
cleanup-overcloud.sh
check-puppet-errors.sh
ssh-overcloud.sh
mistral-update.sh )

for script in "${copy_to_stack[@]}"; do
    while true; do
	scp $SCRIPT_DIR/$script root@${INSTACK_IP}:/home/stack
	myResult=$?
	if [ $myResult -eq 0 ]; then
            echo "SUCCESS"
            break
	else
            echo "FAILED copy."
            echo "Retrying..."
            sleep 1
	fi
    done
done

scp .emacs root@${INSTACK_IP}:/home/stack/.emacs
scp .emacs root@${INSTACK_IP}:/root/.emacs
