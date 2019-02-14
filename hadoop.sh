#!/bin/sh

. $(pwd)/include.sh

. $(pwd)/java.sh

wget http://archive.cloudera.com/cdh5/one-click-install/redhat/5/x86_64/cloudera-cdh-4-0.x86_64.rpm
yum -y --nogpgcheck localinstall cloudera-cdh-4-0.x86_64.rpm
rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
#rpm --import http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/RPM-GPG-KEY-cloudera
#wget http://archive-primary.cloudera.com/cdh4/redhat/6/x86_64/cdh/cdh4-repository-1-0.noarch.rpm
#yum localinstall cdh4-repository-1-0.noarch.rpm
#http://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin

useradd hdfs

for p in hadoop hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-namenode hadoop-0.20-mapreduce-jobtracker hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-mapreduce hadoop-client hadoop-libhdfs; do
	yum clean all; yum install -y $p
done

mkdir /hdfs /hdfs_data
chown hdfs:hadoop /hdfs
chown hdfs:hadoop /hdfs_data

#su hdfs -c "hadoop namenode -format"

cat <<EOD >> /root/.bashrc
alias srv_namenode='service hadoop-hdfs-namenode'
alias srv_datanode='service hadoop-hdfs-datanode'
EOD

cat <<EOD >> /etc/profile

alias hdfscmd='hdfs dfs'
EOD

rsync $PWD_9377/conf/hadoop/*.xml /etc/hadoop/conf/

#127.0.0.1	sdnx.9377.com