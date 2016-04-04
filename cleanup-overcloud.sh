#!/bin/bash

instances=$(nova list | awk {'print $2'} | grep  .[0-9]* | grep -v ID)

for instance in "${instances[@]}"; do
    nova delete $instance
done

ctlplaneid=$(neutron net-list | grep ctlplane | awk '{ print $6}')
neutronports=(`neutron port-list | grep -v $ctlplaneid | awk {'print $2'} | grep  .[0-9]* | grep -v id`)
neutronnets=(`neutron net-list | grep -v ctlplane | awk {'print $2'} | grep  .[0-9]* | grep -v id`)

for neutronport in "${neutronports[@]}"; do
    neutron port-delete $neutronport
done

for neutronnet in "${neutronnets[@]}"; do
    neutron net-delete $neutronnet
done

heat stack-abandon overcloud
