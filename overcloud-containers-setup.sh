#/bin/bash

git clone https://github.com/openstack/tripleo-heat-templates.git

pushd ~/tripleo-heat-templates
git config --global user.email "rhallise@redhat.com"
git config --global user.name "Ryan Hallisey"

# Controller
#git fetch https://review.openstack.org/openstack/tripleo-heat-templates refs/changes/95/227295/2 && git cherry-pick FETCH_HEAD
popd

#sudo systemctl mask lvm2-lvmetad.service
#sudo systemctl mask lvm2-lvmetad.socket

wget https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22-20150521.x86_64.qcow2
source stackrc
glance image-create --name atomic-image --file Fedora-Cloud-Atomic-22-20150521.x86_64.qcow2 --disk-format qcow2 --container-format bare

# cirros image
wget download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network.yaml --libvirt-type=qemu"
echo "START CMD: openstack overcloud deploy --templates=tripleo-heat-templates -e tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e tripleo-heat-templates/environments/network-isolation.yaml -e  /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml -e tripleo-heat-templates/environments/docker-network-isolation.yaml --libvirt-type=qemu"
