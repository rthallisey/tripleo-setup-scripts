#!/bin/bash

swift delete --all
mistral environment-delete overcloud

for workbook in $(mistral workbook-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workbook-delete $workbook
done
for workflow in $(mistral workflow-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workflow-delete $workflow
done

sudo mistral-db-manage populate
sleep 2
sudo systemctl restart openstack-mistral-engine
sudo systemctl restart openstack-mistral-executor
sudo systemctl restart openstack-mistral-api
sleep 2

for workbook in $(ls /usr/share/openstack-tripleo-common/workbooks/*); do
    mistral workbook-create $workbook
done
