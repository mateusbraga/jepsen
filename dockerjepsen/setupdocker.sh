#!/bin/bash

NODES="n1 n2 n3 n4 n5"

echo "Deleting nodes:"
docker rm -f $NODES

HOSTS_IPS=""
for NODE in $NODES
do
    docker run -d --cap-add=NET_ADMIN --name $NODE projectads/jepsen
    NODE_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $NODE`
    HOSTS_NODE_LINE="$NODE_IP $NODE"

    # update host machine /etc/hosts
    ./etchosts.sh update $NODE $NODE_IP

    # append to HOSTS_LINES
    HOSTS_LINES="$HOSTS_LINES\n$HOSTS_NODE_LINE"

    #sed -i'.sedbackup' -e '/'"$NODE"'$/s=^[0-9\.]*='"$NODE_IP"'=' /etc/hosts
    echo "Started $NODE with IP $NODE_IP"
done

echo "Configuring containers /etc/hosts files"
for NODE in $NODES
do
	sshpass -p "root" ssh  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$NODE "echo -e \"$HOSTS_LINES\" >> /etc/hosts"
done

ssh-keyscan -t rsa n1 >> ~/.ssh/known_hosts
ssh-keyscan -t rsa n2 >> ~/.ssh/known_hosts
ssh-keyscan -t rsa n3 >> ~/.ssh/known_hosts
ssh-keyscan -t rsa n4 >> ~/.ssh/known_hosts
ssh-keyscan -t rsa n5 >> ~/.ssh/known_hosts
