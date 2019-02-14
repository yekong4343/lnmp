#!/bin/sh

. $(pwd)/include.sh

yum install -y expect expect-devel

files=()
files=(${files[@]} "https://downloads.mariadb.com/infinidb/infinidb-ent-4.6.0-1.x86_64.rpm.tar.gz")
libs=$( download files[@] )

cd $DOWNLOAD

files=()
files=(${files[@]} "infinidb-libs-4.6.0-1.x86_64.rpm")
files=(${files[@]} "infinidb-platform-4.6.0-1.x86_64.rpm")
files=(${files[@]} "infinidb-mysql-4.6.0-1.x86_64.rpm")
files=(${files[@]} "infinidb-storage-engine-4.6.0-1.x86_64.rpm")
files=(${files[@]} "infinidb-enterprise-4.6.0-1.x86_64.rpm")

for file in ${files[@]}; do
	rpm -ivh $file
done

cat <<EOD >> /root/.bashrc
alias infinidb='service infinidb'
EOD

export LD_LIBRARY_PATH=$PREFIX/java/jre/lib/amd64/server
/usr/local/Calpont/bin/setenv-hdfs-20

ln -s /usr/local/Calpont/ /infinidb
