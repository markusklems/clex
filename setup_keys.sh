#!/bin/bash
USER=root
KEY_NAME=~/.ssh/id_rsa_cassandra
ssh-keygen -t rsa -N "" -f $KEY_NAME
while read h; do
  echo "Copy public key to $h"
  cat "$KEY_NAME.pub" | ssh "$USER@$h" "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
 echo "Host $h
    IdentityFile $KEY_NAME" | sudo tee -a ~/.ssh/config
done < hosts.txt