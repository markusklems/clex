#!/bin/bash

HOME="/home/`whoami`"
CBTOOL_HOME="$HOME/cbtool"

sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum update
sudo yum install -q git make gcc python-setuptools python-devel python-daemon python-twisted-web python-webob python-beaker nc screen ganglia-gmond R ganglia-gmond-python libvirt-python net-snmp-python ntp
sudo easy_install setuptools-git
sudo easy_install redis pymongo boto setuptools-git python-novaclient
(cd $HOME; git clone git://github.com/markusklems/cbtool.git)
(cd $CBTOOL_HOME; ./configure)
# install dependencies
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/ibmcb/bootstrap.git)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/ibmcb/d3.git)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/openstack/python-novaclient.git;cd python-novaclient; sudo python setup.py install)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/apache/libcloud.git;cd libcloud; sudo python setup.py install)
(cd "$CBTOOL_HOME/3rd_party"; wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.2.tgz; tar -zxf mongodb-linux-*.tgz; cd mongodb-linux-*; sudo cp bin/* /usr/bin)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/ibmcb/monitor-core.git)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/openstack/python-novaclient.git;cd python-novaclient; sudo python setup.py install)
(cd "$CBTOOL_HOME/3rd_party"; wget http://pypureomapi.googlecode.com/files/pypureomapi-0.3.tar.gz; tar -xzvf pypureomapi-0.3.tar.gz; cd pypureomapi-0.3; sudo python setup.py install)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/ibmcb/redis.git; cd redis; git checkout 2.6; make; sudo make install)
(cd "$CBTOOL_HOME/3rd_party"; git clone https://github.com/ibmcb/Bootstrap-Wizard.git)