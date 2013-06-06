#!/bin/bash
mytopology=${1:-cassandra-topology1.properties}

if [ -f /etc/cassandra/cassandra.yaml ]; then
  config_file="/etc/cassandra/cassandra.yaml"
fi
if [ -f /etc/cassandra/conf/cassandra.yaml ]; then
  config_file="/etc/cassandra/conf/cassandra.yaml"
fi
sed -i -e "s|endpoint_snitch: SimpleSnitch|endpoint_snitch: PropertyFileSnitch|" $config_file

topology_file="/etc/cassandra/cassandra-topology.properties"
if [ -f /etc/cassandra/conf/cassandra-topology.properties ]; then
  topology_file="/etc/cassandra/conf/cassandra-topology.properties"
  sudo rm "$topology_file"
fi
sudo cp "/home/clex/cassandra/$mytopology" "$topology_file"

sleep 5

sudo cassandra service restart