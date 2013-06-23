#!/bin/sh -ex
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sleep 1
# Remove openjdk.
sudo apt-get purge -y openjdk-6-jre-lib
sudo apt-get purge -y openjdk-7-jre openjdk-7-jre-lib
sudo apt-get autoremove -y
sudo apt-get update -y
sleep 1

# Install Oracle Java 1.7.
JDK=jdk-7u25
target_java_dir='/opt/java/64'
sudo mkdir -p $target_java_dir
url="https://s3-eu-west-1.amazonaws.com/avoidcrappyoraclelicensethatpreventssystemautomation/$JDK-linux-x64.tar.gz"
tmpdir=`sudo mktemp -d`
sudo wget --no-check-certificate "$url" --output-document="$tmpdir/`basename $url`"
sudo chmod 777 $tmpdir
(cd $tmpdir; sudo sh `basename $url` -noregister)
sudo mkdir -p `dirname $target_java_dir`
(cd $tmpdir; sudo rm *tar.gz; sudo mv jdk* $target_java_dir)
sudo rm -rf $tmpdir
# Setup java alternatives.
update-alternatives --install /usr/bin/java java "$target_java_dir/$JDK/bin/java" 17000
update-alternatives --set java "$target_java_dir/$JDK/bin/java"

# Try to set JAVA_HOME in a number of commonly used locations
export JAVA_HOME="$target_java_dir/$JDK"
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