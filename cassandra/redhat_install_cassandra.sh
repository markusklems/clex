#!/bin/sh -ex

# Install Oracle Java 1.6.
sudo wget --no-check-certificate https://s3-eu-west-1.amazonaws.com/avoidcrappyoraclelicensethatpreventssystemautomation/jdk-6u45-linux-x64.bin
sudo chmod a+x jdk-*
sudo ./jdk-*
sudo rm jdk-*.bin
sudo mkdir /usr/java
sudo mv jdk1.6.0_45 /usr/java/jdk1.6.0_45

# update alternatives
sudo alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_45/bin/java 17000
sudo alternatives --set java /usr/java/jdk1.6.0_45/bin/java	

# Try to set JAVA_HOME in a number of commonly used locations
export JAVA_HOME="$target_java_dir/jdk1.6.0_45"
if [ -f /etc/profile ]; then
  echo export JAVA_HOME=$JAVA_HOME >> /etc/profile
fi
if [ -f /etc/bashrc ]; then
  echo export JAVA_HOME=$JAVA_HOME >> /etc/bashrc
fi
if [ -f ~root/.bashrc ]; then
  echo export JAVA_HOME=$JAVA_HOME >> ~root/.bashrc
fi
if [ -f /etc/skel/.bashrc ]; then
  echo export JAVA_HOME=$JAVA_HOME >> /etc/skel/.bashrc
fi

# Install JNA
sudo yum install -y jna
	
# recommended by datastax
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm

# install cassandra
echo "[datastax]
name= DataStax Repo for Apache Cassandra
baseurl=http://rpm.datastax.com/community
enabled=1
gpgcheck=0" | sudo tee -a /etc/yum.repos.d/datastax.repo

sudo yum update
sudo yum install -y dsc12
