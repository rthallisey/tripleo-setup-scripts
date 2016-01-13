source overcloudrc
neutron net-create ext-net --router:external \
--provider:physical_network datacentre \
--provider:network_type vlan \
--provider:segmentation_id 10
neutron subnet-create ext-net 192.0.3.0/24 --name ext-net-subnet --allocation-pool start=192.0.3.140,end=192.0.3.240 --disable-dhcp --gateway 192.0.3.251
neutron net-create default-net --shared 
# Make sure allocation pool range below does not overlap with any ip's already allocated from the tenant network in the undercloud
neutron subnet-create default-net 172.16.0.0/24 --name default-net-subnet  --allocation-pool start=172.16.0.10,end=172.16.0.250
neutron router-create default-router
neutron router-interface-add default-router default-net-subnet
neutron router-gateway-set default-router ext-net 
neutron router-port-list default-router
# Ping router IP
ping -c 3 192.0.3.140
neutron l3-agent-list-hosting-router default-router
