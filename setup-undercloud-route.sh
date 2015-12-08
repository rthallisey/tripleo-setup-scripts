#!/bin/bash

sudo ovs-vsctl add-port br-ctlplane vlan10 tag=10 -- set interface vlan10 type=internal;
sudo ip l set dev vlan10 up; sudo ip addr add 192.0.3.251/24 dev vlan10;
sudo iptables -A BOOTSTACK_MASQ -s 192.0.3.0/24 ! -d 192.0.3.0/24 -j MASQUERADE -t nat

# NETWORK ISOLATION
# Add to environments/net-single-nic-with-vlans.yaml
# openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e tripleo-heat-templates/environments/network-isolation.yaml -e tripleo-heat-templates/environments/docker-rdo.yaml
# ControlPlaneSubnetCidr: "24"
# ControlPlaneDefaultRoute: "192.0.2.1"
# EC2MetadataIp: "192.0.2.1"
# ExternalInterfaceDefaultRoute: "192.0.3.251"
# ExternalNetCidr: "192.0.3.1/24"
# ExternalAllocationPools: [{'start': '192.0.3.30', 'end': '192.0.3.100'}]
