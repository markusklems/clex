#!/bin/bash

SSH_CONF="/home/`whoami`/.ssh/config"

sudo touch $SSH_CONF
sudo chown `whoami` "/home/`whoami`/.ssh/config"
echo "StrictHostKeyChecking=no" | tee -a $SSH_CONF
echo "UserKnownHostsFile=/dev/null" | tee -a $SSH_CONF