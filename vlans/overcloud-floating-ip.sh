PRIVATEIP=$(nova list | grep test1 | awk -F"default-net=" '{print $2}' | awk '{print $1}')
PORT=$(neutron port-list | grep $PRIVATEIP | cut -d'|' -f2)
FLOATINGIP=$(neutron floatingip-create ext-net --port-id "${PORT//[[:space:]]/}" | awk '$2=="floating_ip_address" {print $4}')
SECGROUPID=$(nova secgroup-list | grep default | cut -d ' ' -f2)
neutron security-group-rule-create $SECGROUPID --protocol icmp \
    --direction ingress --port-range-min 8 || true
neutron security-group-rule-create $SECGROUPID --protocol tcp \
    --direction ingress --port-range-min 22 --port-range-max 22 || true
