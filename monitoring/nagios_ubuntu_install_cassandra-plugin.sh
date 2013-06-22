#!/bin/bash
# setup remote monitoring for the cluster
sudo apt-get -y install nagios3 nagios-nrpe-plugin
# pssh into the node servers and install the agents
sudo parallel-ssh -h $HOSTS_FILE -l $USER -o /tmp/nagios-install "sudo apt-get -y install nagios-nrpe-server; sudo sed -i.bak -r -e 's/allowed_hosts=127.0.0.1/allowed_hosts=$NAGIOS_HOST_IP/g' /etc/nagios/nrpe.cfg; sudo /etc/init.d/nagios-nrpe-server restart"

# setup the nagios server conf
N=11
while read h; do
	echo "define host{
	        use                     generic-host            ; Name of host template to use
	        host_name               machine$N
	        alias                   Cassandra $N
	        address                 $h
	        }
define service{
        use                             generic-service         ; Name of service template to use
        host_name                       machine$N
        service_description             Disk Space
        check_command                   check_nrpe_1arg!check_hda1
        }" | sudo tee -a /etc/nagios3/conf.d/cassandra.cfg
N=`expr $N + 1`
done < hosts.txt
# check if things are OK
sudo /usr/sbin/nagios3 -v /etc/nagios3/nagios.cfg

# install nagios-cassandra
fetch http://downloads.sourceforge.net/project/nagioscheckjmx/nagioscheckjmx/1.0/check_jmx.tar.gz
tar -xvfz check_jmx.tar.gz 
mv check_jmx /usr/lib/nagios/plugins/


sudo /etc/init.d/nagios3 restart