#/bin/bash

git clone https://git.openstack.org/openstack/tripleo-common

export DIB_INSTALLTYPE_puppet_modules=source
export DELOREAN_REPO_URL=http://trunk.rdoproject.org/centos7/current/

./tripleo-common/scripts/tripleo.sh --repo-setup --undercloud --overcloud-images --register-nodes --introspect-nodes

# Bug with introspecting nodes
#sudo rm -f /var/lib/ironic-inspector/inspector.sqlite
#sudo -u ironic-inspector ironic-inspector-dbsync --config-file /etc/ironic-inspector/inspector.conf upgrade

./overcloud-containers-setup.sh
