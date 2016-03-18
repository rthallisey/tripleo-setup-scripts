#/bin/bash

git clone https://github.com/openstack-infra/tripleo-ci

export DIB_INSTALLTYPE_puppet_modules=source
export DELOREAN_REPO_URL=http://trunk.rdoproject.org/centos7/current/

./tripleo-ci/scripts/tripleo.sh --repo-setup --undercloud --overcloud-images --register-nodes --introspect-nodes

./overcloud-containers-setup.sh
