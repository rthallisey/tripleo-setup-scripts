#/bin/bash

if [[ -n $1 ]]; then
    sudo curl -o /etc/yum.repos.d/delorean-$1.repo https://trunk.rdoproject.org/centos7-$1/current/delorean.repo
    sudo curl -o /etc/yum.repos.d/delorean-deps-$1.repo http://trunk.rdoproject.org/centos7-$1/delorean-deps.repo

    sudo sed -i 's/\[delorean\]/\[delorean-current\]/' /etc/yum.repos.d/delorean-$1.repo
    sudo /bin/bash -c "cat <<EOF>>/etc/yum.repos.d/delorean-$1.repo

includepkgs=diskimage-builder,instack,instack-undercloud,os-apply-config,os-cloud-config,os-collect-config,os-net-config,os-refresh-config,python-tripleoclient,tripleo-common,openstack-tripleo-heat-templates,openstack-tripleo-image-elements,openstack-tripleo,openstack-tripleo-puppet-elements,openstack-puppet-modules
EOF"


    sudo yum -y install yum-plugin-priorities
    sudo yum install -y python-tripleoclient

    openstack undercloud install
    source stackrc

    export USE_DELOREAN_TRUNK=1
    export DELOREAN_TRUNK_REPO="http://trunk.rdoproject.org/centos7-$1/current/"
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
