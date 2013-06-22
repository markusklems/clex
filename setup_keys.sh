#!/bin/bash
USER=root
echo "~/.ssh/id_rsa_cassandra


" | ssh-keygen -t rsa
while read h; do
  echo "Copy public key to $h"
  cat ~/.ssh/id_rsa_cassandra.pub | ssh "$USER@$h" "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
done < hosts.txt