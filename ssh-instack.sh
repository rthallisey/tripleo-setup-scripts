#/bin/bash

INSTACK_IP=`arp -an | grep 192 | cut -d " " -f 2 | tr -d '(' | tr -d ')'`
echo $INSTACK_IP
ssh root@$INSTACK_IP
