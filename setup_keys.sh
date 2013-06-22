#!/bin/bash
USER=root
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_cassandra
while read h; do
  echo "Copy public key to $h"
  cat ~/.ssh/id_rsa_cassandra.pub | ssh "$USER@$h" "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
done < hosts.txt