#!/bin/bash

for node in `ironic node-list --fields uuid | tail -n +4 | head -n -1 | cut -d ' ' -f 2`; do
    ironic node-update $node remove instance_uuid
done

sudo systemctl restart opentack-ironic-conductor
sudo systemctl restart opentack-nova-compute
