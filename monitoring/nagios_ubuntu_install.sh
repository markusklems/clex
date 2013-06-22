#!/bin/bash
USER=${1:-root}
NAGIOS_HOST_IP=${2:-217.160.108.3}
# http://askubuntu.com/questions/145518/how-do-i-install-nagios
sudo apt-get install -y nagios3
# you can reset the password like this:
# sudo htpasswd -c /etc/nagios3/htpasswd.users nagiosadmin
# setup remote monitoring for the cluster
sudo apt-get -y install nagios3 nagios-nrpe-plugin
# pssh into the node servers and install the agents
sudo parallel-ssh -h ../hosts.txt -l $USER -o /tmp/nagios-install 'sudo apt-get -y install nagios-nrpe-server; sudo sed -i.bak -r -e \'s/allowed_hosts=127.0.0.1/allowed_hosts=$NAGIOS_HOST_IP/g\' /etc/nagios/nrpe.cfg; sudo /etc/init.d/nagios-nrpe-server restart'