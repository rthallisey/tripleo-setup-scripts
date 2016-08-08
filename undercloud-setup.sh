#/bin/bash

if [[ -n $1 ]]; then
    sudo curl -o /etc/yum.repos.d/delorean.repo http://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-$1/delorean.repo
    sudo curl -o /etc/yum.repos.d/delorean-deps.repo http://trunk.rdoproject.org/centos7/delorean-deps.repo

    sudo yum -y install yum-plugin-priorities
    sudo yum install -y python-tripleoclient

    openstack undercloud install
    source stackrc

    export USE_DELOREAN_TRUNK=1
    export DELOREAN_TRUNK_REPO="http://trunk.rdoproject.org/centos7/current/"
    export DELOREAN_REPO_FILE="delorean.repo"

    openstack overcloud image build --all
    openstack overcloud image upload

    openstack baremetal import instackenv.json --json
    openstack baremetal configure boot
    openstack baremetal introspection bulk start
else
    git clone https://github.com/openstack-infra/tripleo-ci

    export DIB_INSTALLTYPE_puppet_modules=source
    export DELOREAN_REPO_URL=http://trunk.rdoproject.org/centos7/current/
    ./tripleo-ci/scripts/tripleo.sh --repo-setup --undercloud --overcloud-images --register-nodes --introspect-nodes
fi

./overcloud-containers-setup.sh
