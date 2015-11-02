#/bin/bash

git clone https://git.openstack.org/openstack/tripleo-common

./tripleo-common/scripts/tripleo.sh --repo-setup --undercloud --overcloud-images --register-nodes

# Bug with introspecting nodes
sudo rm -f /var/lib/ironic-inspector/inspector.sqlite
sudo -u ironic-inspector ironic-inspector-dbsync --config-file /etc/ironic-inspector/inspector.conf upgrade

./tripleo-common/scripts/tripleo.sh --introspect-nodes --flavors

./overcloud-containers-setup.sh
