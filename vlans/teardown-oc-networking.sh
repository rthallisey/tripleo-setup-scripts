# this reverses overcloud-networking.sh
source overcloudrc
neutron router-gateway-clear default-router
neutron router-interface-delete default-router default-net-subnet
neutron router-delete default-router

neutron net-delete ext-net
neutron net-delete default-net

neutron port-list
