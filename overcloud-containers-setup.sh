#/bin/bash

git clone https://github.com/openstack/tripleo-heat-templates.git

pushd ~/tripleo-heat-templates
git config --global user.email "rhallise@redhat.com"
git config --global user.name "Ryan Hallisey"

popd

wget https://download.fedoraproject.org/pub/alt/atomic/stable/Cloud-Images/x86_64/Images/Fedora-Cloud-Atomic-23-20160420.x86_64.qcow2
source stackrc
glance image-create --name atomic-image --file Fedora-Cloud-Atomic-23-20160405.x86_64.qcow2 --disk-format qcow2 --container-format bare
neutron subnet-update `neutron subnet-list | grep start | cut -d'|' -f 2 | sed 's/ //'` --dns-nameserver 192.168.122.1

# cirros image
wget download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
#glance image-create --name cirros --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare

echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network.yaml --libvirt-type=qemu"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e tripleo-heat-templates/environments/network-isolation.yaml -e  tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network-isolation.yaml --libvirt-type=qemu"
