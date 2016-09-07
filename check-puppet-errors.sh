#!/bin/bash
set -eu

do_ssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet heat-admin@"  # noqa

nova list 2>&1|grep -v SubjectAltNameWarning
for i in $(nova list 2>&1|awk '/ctlplane/ {print $12}'); do
    eval $i
    echo -n "** ${ctlplane} "
    if [ -z $(${do_ssh}${ctlplane} hostname) ]; then
        echo "Cannot reach host $ctlplane"
        continue
    else
        echo "up and running"
    fi

    ${do_ssh}${ctlplane} "
        [ -d /var/lib/heat-config/deployed ] || exit 0
        for f in \$(sudo find /var/lib/heat-config/deployed -name '*.notify.json'); do  # noqa
            if [ \$(sudo jq .deploy_status_code \$f) -ne 0 ]; then
                sudo jq -r .deploy_stderr \$f
                sudo jq -r .deploy_stdout \$f
            fi
        done
    "
done
