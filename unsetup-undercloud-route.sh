sudo ovs-vsctl del-port br-ctlplane vlan10
sudo iptables -t nat -D BOOTSTACK_MASQ -s 192.0.3.0/24 ! -d 192.0.3.0/24 -j MASQUERADE
