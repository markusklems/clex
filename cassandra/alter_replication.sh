#!/bin/bash
strategy=${1:-alter_replication1}
cqlsh -f "/home/clex/cassandra/$strategy"