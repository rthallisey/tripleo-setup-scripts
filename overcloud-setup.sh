#/bin/bash

git clone https://github.com/openstack/tripleo-heat-templates.git
git clone https://github.com/openstack/tripleo-common

if [[ $1 = "containers" ]]; then
    pushd ~/tripleo-heat-templates
    git config --global user.email "rhallise@redhat.com"
    git config --global user.name "Ryan Hallisey"
    popd

    wget https://mirrors.rit.edu/fedora/alt/atomic/stable/CloudImages/x86_64/images/Fedora-Atomic-24-20160809.0.x86_64.qcow2
    source stackrc
    glance image-create --name atomic-image --file Fedora-Atomic-24-20160809.0.x86_64.qcow2 --disk-format qcow2 --container-format bare

    # cirros image
    wget download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
    #glance image-create --name cirros --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare
fi

neutron subnet-update `neutron subnet-list | grep start | cut -d'|' -f 2 | sed 's/ //'` --dns-nameserver 192.168.122.1

pushd ~/tripleo-heat-templates
git config --global user.email "rhallise@redhat.com"
git config --global user.name "Ryan Hallisey"
popd

echo "CONTAINERS"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network.yaml --libvirt-type=qemu"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e tripleo-heat-templates/environments/network-isolation.yaml -e  tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network-isolation.yaml --libvirt-type=qemu"

echo "HA/NET-ISO NON_CONTAINERS"
echo "START CMD: openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/overcloud-resource-registry-puppet.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml --control-scale 3 --compute-scale 1 --libvirt-type qemu --ntp-server '0.fedora.pool.ntp.org'"
echo "START CMD: openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/overcloud-resource-registry-puppet.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml --control-scale 3 --compute-scale 1 --libvirt-type qemu -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml --ntp-server '0.fedora.pool.ntp.org'"

echo "HA/NET-ISO NON_CONTAINERS USING THT repo"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/overcloud-resource-registry-puppet.yaml -e tripleo-heat-templates/environments/puppet-pacemaker.yaml --control-scale 3 --compute-scale 1 --libvirt-type qemu --ntp-server '0.fedora.pool.ntp.org'"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/overcloud-resource-registry-puppet.yaml -e tripleo-heat-templates/environments/puppet-pacemaker.yaml --control-scale 3 --compute-scale 1 --libvirt-type qemu -e tripleo-heat-templates/environments/network-isolation.yaml -e tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e tripleo-heat-templates/environments/network-environment.yaml --ntp-server '0.fedora.pool.ntp.org'"
