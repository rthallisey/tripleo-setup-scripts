#/bin/bash

mac=$(sudo virsh dumpxml instack |
  xmllint --xpath //interface'[1]/mac/@address' - |
  sed 's/.*="\([^"]*\)"/\1/'
  )
INSTACK_IP=`arp -an | grep $mac | cut -d " " -f 2 | tr -d '(' | tr -d ')'`
echo $INSTACK_IP
ssh root@$INSTACK_IP
